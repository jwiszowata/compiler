module Compiler(compileProgram) where

import Utils
import Errors
import DefaultFunctions
import ExprCompilation
import Optimize

-------------------- KOMPILACJA PROGRAMU ---------------------------------------
-- [compileProgram] bierze Program i zwraca listę instrukcji nasmowych w postaci
-- Stringów
compileProgram :: Program -> [String]
compileProgram (Program topDefs) =
    let pos = Pos (-4)
        startLabel = (0, Ident "")
        funs = pushDefaultFuns
        (mthDefs, defFuns, defSts, bMain, bOther, bVoid) = pushDefinitions topDefs funs [] False []
        (soF, _, _, _, _, _, _, _, errorMsgF, programF) = 
          unStOut (compileDefs topDefs []) defFuns defSts ([], []) pos startLabel [] 0 "" --- trzeba zwrócić i przekazać dalej
        (soM, _, _, _, _, _, _, _, errorMsgM, programM) = 
          unStOut (compileMthDefs mthDefs soF) defFuns defSts ([], []) pos startLabel soF 0 ""
    in case (bMain, bOther, bVoid, errorMsgF /= "", errorMsgM /= "") of
       (False, _, _, _, _) -> mainFunErr
       (_, True, _, _, _) -> dubFunNameErr
       (_, _, True, _, _) -> voidArgErr
       (_, _, _, True, _) -> [errorMsgF]
       (_, _, _, _, True) -> [errorMsgM]
       _ -> optimize $ pushDefaults soM ++ programF ++ programM


pushDefinitions :: [TopDef] -> Funs -> Structs -> Bool -> MthTypes -> 
                                  (MthTypes, Funs, Structs, Bool, Bool, Bool)
pushDefinitions [] fs sts bM fd = (fd, fs, sts, bM, False, False)
pushDefinitions (def:defs) fs sts bM fd = 
  let (fd1, fs1, sts1, bM1, bO1, bV1) = pushDefinition def fs sts bM fd
  in if bO1 || bV1
     then (fd1, fs1, sts1, bM1, bO1, bV1)
     else pushDefinitions defs fs1 sts1 bM1 fd1

pushDefinition :: TopDef -> Funs -> Structs -> Bool -> MthTypes -> 
                                     (MthTypes, Funs, Structs, Bool, Bool, Bool)
pushDefinition def funs sts b funDefs = case def of 
  FnDef funDef -> pushFunDefinition funDef funs sts b funDefs
  StDef t atts -> let (ats, aFun, isVoid) = pushAtts atts [] t
                      st = (t, ats)
                      fd = aFun ++ funDefs
                  in case t of
                    Clas t1 -> (fd, funs, st:sts, b, isDefinedSt t sts, isVoid)
                    _ -> (funDefs, funs, sts, b, True, False) -- korzysta z leniwości

pushFunDefinition :: FunDef -> Funs -> Structs -> Bool -> MthTypes -> 
                                     (MthTypes, Funs, Structs, Bool, Bool, Bool)
pushFunDefinition (FunDef t id args (Block stmts)) funs sts b funDefs =
  let (v, isVoid) = pushArgs args
      fun = (t, id, v)
  in (funDefs, fun:funs, sts, b || (isMainFun fun), isDefinedFun id funs, isVoid)

isMainFun :: Fun -> Bool
isMainFun fun = let typ = typOF fun == Int
                    id = idOF fun == Ident "main"
                    arg = argOF fun == []
                in typ && id && arg

isDefinedFun :: Ident -> Funs -> Bool
isDefinedFun _ [] = False
isDefinedFun ident (fun:funs) = (idOF fun == ident) || (isDefinedFun ident funs)

isDefinedSt :: Type -> Structs -> Bool
isDefinedSt _ [] = False
isDefinedSt t (st:sts) = (typOfS st == t) || (isDefinedSt t sts)

pushAtts :: Atts -> MthTypes -> Type -> (Attrs, MthTypes, Bool)
pushAtts = pushAttributes ([], []) (StPos 0)

pushAttributes:: Attrs -> Pos -> Atts -> MthTypes -> Type -> (Attrs, MthTypes, Bool)
pushAttributes (ats, mths) _ [] fd _ = ((reverse ats, mths), fd, False)
pushAttributes (ats, mths) pos (att:atts) fd t = case att of 
  Att typ id -> let attr = (typ, id, pos)
                in if typ == Void
                   then (([], []), [], True)
                   else pushAttributes (attr:ats, mths) (nextPos pos) atts fd t
  Meth (FunDef typ id args block) -> 
    let (v, isVoid) = pushArgs ((Arg t (Ident "")):args)
        mthName = makeMthName id t
        mth = (typ, mthName, v)
        f = (FunDef typ mthName args block, t)
    in pushAttributes (ats, mth:mths) pos atts (f:fd) t


---------------- KOMPILACJA DEFINICJI FUNKCJI ----------------------------------
-- [compileDefs] bierze listę definicji, oraz początkowy stan listy 
-- "statycznych" Stringów i generuje kod nasmowy dla każdej z funkcji; zwraca 
-- ostateczny stan listy "statycznych" stringów ze wszystkich zdefiniowanych 
-- funkcji
compileDefs :: [TopDef] -> StrObjs -> M StrObjs
compileDefs [] so = do { return so }
compileDefs (def:defs) so = do { fs <- getFuns;
                                 sts <- getSts;
                                 so1 <- compileDef def fs sts so;
                                 compileDefs defs so1 }

compileDef :: TopDef -> Funs -> Structs -> StrObjs -> M StrObjs
compileDef (FnDef (FunDef typ ident args (Block stmts))) funs sts so =
  let pos = Pos (-4)
      f = getFunction ident funs
      args = argOF f
      (_, _, _, _, _, _, strings, varsNr, errorMsg, definition) = 
        unStOut (compileFun f stmts) funs sts (args, args) pos (0, ident) so 0 ""
      str = (addPreamble ident varsNr) $ addEpilogue ident definition
  in do { if errorMsg /= ""
          then do { pushErr errorMsg;
                    return strings }
          else do { pushInstr str;
                    return strings } }
compileDef (StDef t ats) _ _ so = do { return so }

addPreamble :: Ident -> Int -> [String] -> [String]
addPreamble ident i str = [toStr ident ++ ":", 
                           "push ebp", 
                           "mov ebp, esp",
                           "sub esp, " ++ show (i * 4),
                           "push ebx"] ++ str

addEpilogue :: Ident -> [String] -> [String]
addEpilogue ident str = str ++ ["." ++ toStr ident ++ ".:",
                                "pop ebx", 
                                "leave", 
                                "ret"]

---------------- KOMPILACJA DEFINICJI METOD ------------------------------------
-- [compileMthDefs] bierze listę definicji metod, początkowy stan listy 
-- "statycznych" Stringów oraz strukture w której są te metody i generuje kod 
-- nasmowy dla każdej z funkcji; zwraca 
-- ostateczny stan listy "statycznych" stringów ze wszystkich zdefiniowanych 
-- funkcji
compileMthDefs :: MthTypes -> StrObjs -> M StrObjs
compileMthDefs [] so = do { return so }
compileMthDefs (def:defs) so = do { fs <- getFuns;
                                    sts <- getSts;
                                    so1 <- compileMthDef def fs sts so;
                                    compileMthDefs defs so1 }

compileMthDef :: MthType -> Funs -> Structs -> StrObjs -> M StrObjs
compileMthDef ((FunDef typ ident args (Block stmts)), Clas stId) funs sts so =
  let pos = Pos (-4)
      st = findStFrom stId sts
      f = getMthFrom ident st
      atts = atOfS st
      args = argOF f
      (_, _, _, _, _, _, strings, varsNr, errorMsg, definition) = 
        unStOut (compileFun f stmts) funs sts (atts ++ args, args) pos (0, ident) so 0 ""
      str = (addPreamble ident varsNr) $ addEpilogue ident definition
  in do { if errorMsg /= ""
          then do { pushErr errorMsg;
                    return strings }
          else do { pushInstr str;
                    return strings } }

------------ KOMPILACJA FUNKCJI ------------------------------------------------
-- [compileFun] generowane są nasmowe instrukcje dla kolejnych instrukcji z 
-- ciała funkcji, na koniec sprawdzana jest zgodność uzyskanego typu z typem 
-- kompilowanej funkcji
compileFun :: Fun -> [Stmt] -> M ()
compileFun f stmts = 
  do { (t, _) <- compileStmts stmts;
       if t == typOF f
       then return ()
       else funTypeErr f t }

compileStmts :: [Stmt] -> M StmtType
compileStmts [] = do { defaultST }
compileStmts (stmt:stmts) = 
  do { (t, r) <- compileStmt stmt;
       case r of
       R -> do { (t1, r1) <- compileStmts stmts;
                 case r1 of
                 NR -> return (t, r)
                 _ -> if t1 == t
                      then return (t, r)
                      else difRetTypeErr t t1 }
       PR -> do { (t1, r1) <- compileStmts stmts;
                  case (t1, r1) of
                  (_, R) -> if t1 == t 
                            then return (t, R)
                            else blockTypeErr t t1
                  (Void, NR) -> if t == Void
                                then return (t1, r1)
                                else blockTypeErr t t1
                  _ -> retErr }
       NR -> compileStmts stmts }

------------------ KOMPILACJA INSTRUKCJI ---------------------------------------
-- [compileStmt] generowane są nasmowe instrukcje dla poszczególnych typów Stmt,
-- zwracany jest typ jaki został wyliczony dla danej instrkcji i informacja czy 
-- wystąpiła instrukcja "return"
compileStmt :: Stmt -> M StmtType
compileStmt stmt = case stmt of
    Empty -> do { defaultST }
    BStmt (Block stmts) -> do { (vars, dvars) <- getVars;
                                setVars (vars, []);
                                (t, r) <- compileStmts stmts;
                                setVars (vars, dvars);
                                return (t, r) }
    Decl t items -> do { declareItems t items;
                         defaultST }
    Ass ass expr -> do { (a, at) <- compileAssign ass;
                         if at == NA 
                         then notAssErr a
                         else do { t1 <- compileExpr expr;
                                   if typOfA a == t1
                                   then do { pushInstr ["pop eax", -- expr
                                                        "pop edx", -- adress
                                                        "mov [edx], eax"];
                                            defaultST }
                                   else assErr (typOfA a) t1 (idOfA a) } }
    Incr ass -> do { changeOne ass "inc";
                    defaultST }
    Decr ass -> do { changeOne ass "dec";
                    defaultST }
    Ret expr -> do { t <- compileExpr expr;
                     if t /= Void
                     then do { l <- endLabel;
                               pushInstr ["pop eax",
                                          "jmp " ++ l];
                               return (t, R) }
                     else retVoidErr }
    VRet -> do { l <- endLabel;
                 pushInstr ["jmp " ++ l];
                 return (Void, R) }
    Cond expr stmt -> ifTypeCheck expr stmt Empty ifRetST
    CondElse expr stmt1 stmt2 -> ifTypeCheck expr stmt1 stmt2 ifElseRetST
    While expr stmt -> do { l1 <- createLabel;
                            pushInstr [l1 ++ ":"];
                            case expr of
                            ELitFalse -> defaultST
                            ELitTrue -> do { (t1, r1) <- while stmt l1;
                                             if r1 /= R
                                             then whileLoopedErr
                                             else return (t1, r1) }
                            _ -> do { t <- compileExpr expr;
                                      if t == Bool
                                      then while stmt l1
                                      else condErr t "While" } }
    SExp expr -> do { compileExpr expr;
                      pushInstr ["pop eax"];
                      defaultST }
    For t vId expr stmt -> do { t1 <- compileExpr expr;
                               case t1 of
                                Array t2 -> do { if t == t2
                                                 then compileFor vId t stmt
                                                 else forTypeErr t t2 }
                                _ -> do { forNotArrVarErr;
                                          defaultST } }

------------- DEKLARACJE ZMIENNYCH ---------------------------------------------
declareItems :: Type -> [Item] -> M ()
declareItems _ [] = do { return () }
declareItems t (item:items) = do { if t == Void
                                   then declVoidErr
                                   else do { declareItem t item;
                                             declareItems t items } }

declareItem :: Type -> Item -> M ()
declareItem t item = case item of
  NoInit id -> let valToEax = "mov eax, " ++ emptyVal t
               in declare id t valToEax
  Init id expr -> do { t1 <- compileExpr expr;
                       if t1 == t
                       then declare id t "pop eax"
                       else initDeclErr t1 t id }

declare :: Ident -> Type -> String -> M ()
declare id t valToEax = 
  do { is <- isDeclaredVar id;
       if is 
       then dubVar id
       else do { pos <- pushVar t id;
                 if pos == EmptyPos
                 then interiorErr
                 else do { pushInstr [valToEax, 
                                      "mov " ++ show pos ++ ", eax"] } } }

emptyVal :: Type -> String 
emptyVal Str = "emptyStr"
emptyVal _ = "dword 0"

--------------------- INKREMENTACJA I DEKRYMENTACJA ----------------------------
changeOne :: Assign -> String -> M ()
changeOne ass instr = 
  do { (a, at) <- compileAssign ass;
       if typOfA a == Int
       then do { if at == A
                 then do { pushInstr ["pop eax",
                                      "mov edx, [eax]",
                                      instr ++ " edx",
                                      "mov [eax], edx"] }
                 else do { notAssErr a;
                           return () } }
       else decIncErr (typOfA a) }

------------------------------ IF ELSE -----------------------------------------
ifTypeCheck :: Expr -> Stmt -> Stmt -> ((StmtType, StmtType) -> M StmtType) -> M StmtType
ifTypeCheck expr stmt1 stmt2 retTypFun = case expr of
       ELitFalse -> compileStmt stmt2
       ELitTrue -> compileStmt stmt1
       _ -> do { t <- compileExpr expr;
                 if t == Bool
                 then do { compileExpr ELitTrue;
                           sts <- labeledInstr compileStmt stmt1 compileStmt stmt2 "je" ;
                           retTypFun sts }
                 else condErr t "If" }

ifRetST :: (StmtType, StmtType) -> M StmtType
ifRetST ((t, r), _) = case r of 
  R -> return (t, PR)
  NR -> return (t, NR)
  PR -> blockTypeErr t Void

ifElseRetST :: (StmtType, StmtType) -> M StmtType
ifElseRetST ((t1, r1), (t2, r2)) = case (r1, t1, r2, t2) of 
  (R, _, R, _) -> ifElseTypeCheck t1 t2 R
  (NR, _, NR, _) -> ifElseTypeCheck t1 t2 NR
  (NR, Void, R, Void) -> do { return (Void, R) }
  (R, Void, NR, Void) -> do { return (Void, R) }
  _ -> retErr

ifElseTypeCheck :: Type -> Type -> RTyp -> M StmtType
ifElseTypeCheck t1 t2 rt = 
  do { if t1 == t2
       then return (t1, rt)
       else blockTypeErr t1 t2 }

------------------- WHILE ------------------------------------------------------
while :: Stmt -> String -> M StmtType
while stmt l1 = do { l2 <- createLabel;
                     pushInstr ["pop eax",
                                "mov edx, dword 0",
                                "cmp edx, eax",
                                "je " ++ l2];
                     (t1, r1) <- compileStmt stmt;
                     pushInstr ["jmp " ++ l1,
                                l2 ++ ":"];
                     return (t1, r1) }

------------------- FOR --------------------------------------------------------
-- tablica jest na górze stosu
compileFor :: Ident -> Type -> Stmt -> M StmtType
compileFor vId t stmt = do { l1 <- createLabel;
                             l2 <- createLabel;
                             (vars, dvars) <- getVars;
                             setVars (vars, []);
                             pushInstr ["; start for"];
                             compileStmt (Decl t [NoInit vId]);
                             pushInstr ["push dword 0", -- 0, array
                                        l1 ++ ":",
                                        "pop edx",      -- array
                                        "inc edx",
                                        "pop eax",      -- 
                                        "mov ecx, [eax]", -- długość tablicy
                                        "push eax",     -- array
                                        "push edx",     -- licznik na przyszłą kolejkę, array
                                        "dec edx",
                                        "cmp edx, ecx",
                                        "jge " ++ l2];
                             var <- getVar vId;
                             pushInstr ["inc edx",
                                        "mov ecx, [eax + 4 * edx]",
                                        "mov " ++ show (posOf var) ++ ", ecx"];
                             (t2, r2) <- compileStmt stmt;
                             pushInstr ["jmp " ++ l1,
                                        l2 ++ ":",
                                        "pop ecx", -- zdejmujemy licznik
                                        "pop ecx"]; -- zdejmujemy array
                             setVars (vars, dvars);
                             return (t2, r2) }