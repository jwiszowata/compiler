module Compiler(compileProgram) where

import Utils
import DefaultFunctions

-------------------- KOMPILACJA PROGRAMU ---------------------------------------
-- [compileProgram] bierze Program i zwraca listę instrukcji nasmowych w postaci
-- Stringów
compileProgram :: Program -> [String]
compileProgram (Program topDefs) =
    let pos = Pos (-4)
        startLabel = (0, Ident "")
        funs = pushDefaultFuns
        (defFuns, bMain, bOther) = pushDefinedFuns topDefs funs False
        (strings, _, _, _, _, _, _, errorMsg, program) = 
          unStOut (compileDefs topDefs []) defFuns ([], []) pos startLabel [] 0 ""
    in if not bMain
       then ["There is no proper main function!"]
       else if bOther
            then ["There are two function with the same name!"]
            else if errorMsg /= ""
                 then [errorMsg]
                 else pushDefaults strings ++ program


pushDefinedFuns :: [TopDef] -> Funs -> Bool -> (Funs, Bool, Bool)
pushDefinedFuns [] fs bM = (fs, bM, False)
pushDefinedFuns (def:defs) fs bM = 
  let (fs1, bM1, bO1) = pushDefinedFun def fs bM
  in if bO1
     then (fs1, bM1, bO1)
     else pushDefinedFuns defs fs1 bM1

pushDefinedFun :: TopDef -> Funs -> Bool -> (Funs, Bool, Bool)
pushDefinedFun (FnDef typ ident args (Block stmts)) funs b =
  let v = pushArgs args
      fun = (typ, ident, v)
  in (fun:funs, b || (isMainFun fun), isDefinedFun ident funs)

isMainFun :: Fun -> Bool
isMainFun fun = let typ = typOF fun == Int
                    id = idOF fun == Ident "main"
                    arg = argOF fun == []
                in typ && id && arg

isDefinedFun :: Ident -> Funs -> Bool
isDefinedFun _ [] = False
isDefinedFun ident (fun:funs) = (idOF fun == ident) || (isDefinedFun ident funs)

---------------- KOMPILACJA DEFINICJI FUNKCJI ----------------------------------
-- [compileDefs] bierze listę definicji funkcji, oraz początkowy stan listy 
-- "statycznych" Stringów i generuje kod nasmowy dla każdej z funkcji; zwraca 
-- ostateczny stan listy "statycznych" stringów ze wszystkich zdefiniowanych 
-- funkcji
compileDefs :: [TopDef] -> StrObjs -> M StrObjs
compileDefs [] so = do { return so }
compileDefs (def:defs) so = do { fs <- getFuns;
                                 so1 <- compileDef def fs so;
                                 compileDefs defs so1 }

compileDef :: TopDef -> Funs -> StrObjs -> M StrObjs
compileDef (FnDef typ ident args (Block stmts)) funs so =
  let pos = Pos (-4)
      f = getFunction ident funs
      args = argOF f
      (_, _, _, _, _, strings, varsNr, errorMsg, definition) = 
        unStOut (compileFun f stmts) funs (args, args) pos (0, ident) so 0 ""
      str = (addPreamble ident varsNr) $ addEpilogue definition
  in do { if errorMsg /= ""
          then do { pushErr errorMsg;
                    return strings }
          else do { pushInstr str;
                    return strings } }

addPreamble :: Ident -> Int -> [String] -> [String]
addPreamble ident i str = [toStr ident ++ ":", 
                           "push ebp", 
                           "mov ebp, esp",
                           "sub esp, " ++ show (i * 4)] ++ str

addEpilogue :: [String] -> [String]
addEpilogue str = str ++ ["leave", "ret"]

------------ KOMPILACJA FUNKCJI ------------------------------------------------
-- [compileFun] generowane są nasmowe instrukcje dla kolejnych instrukcji z 
-- ciała funkcji, na koniec sprawdzana jest zgodność uzyskanego typu z typem 
-- kompilowanej funkcji
compileFun :: Fun -> [Stmt] -> M ()
compileFun f stmts = 
  do { (t, _) <- compileStmts stmts (typOF f);
       if t == typOF f
       then return ()
       else pushErr (show (typOF f) ++ " function " ++ 
        toStr (idOF f) ++ " has type " ++ show t ++ "!") }

compileStmts :: [Stmt] -> Type -> M StmtType
compileStmts [] = do { defaultST }
compileStmts (stmt:stmts)
  | stmts == [] = compileStmt stmt
  | otherwise = do { (t, r) <- compileStmt stmt;
                     if r == R
                     then return (t, R)
                     else compileStmts stmts }

------------------ KOMPILACJA INSTRUKCJI ---------------------------------------
-- [compileStmt] generowane są nasmowe instrukcje dla poszczególnych typów Stmt,
-- zwracany jest typ jaki został wyliczony dla danej instrkcji i informacja czy 
-- wystąpiła instrukcja "return"
compileStmt :: Type -> Stmt -> M StmtType
compileStmt ftype stmt = case stmt of
    Empty -> do { defaultST }

    BStmt (Block stmts) -> do { (vars, dvars) <- getVars;
                                setVars (vars, []);
                                (t, r) <- compileStmts stmts;
                                setVars (vars, dvars);
                                return (t, r) }

    Decl t items -> do { declareItems t items;
                         defaultST }

    Ass id expr -> do { (typ, ident, p) <- getVar id;
                        t <- compileExpr expr;
                        if t == typ
                        then do { pushInstr ["pop eax",
                                             "mov " ++ show p ++ ", eax"];
                                  defaultST }
                        else do { pushErr ("Try of assigment " ++ show t ++ 
                                     " expression to " ++ show typ ++ 
                                     " variable " ++ toStr id ++ "!");
                                  defaultST } }

    Incr id -> do { changeOne id "inc";
                    defaultST }

    Decr id -> do { changeOne id "dec";
                    defaultST }

    Ret expr -> do { t <- compileExpr expr;
                     pushInstr ["pop eax",
                                "leave",
                                "ret"];
                     return (t, R) }

    VRet -> do { pushInstr ["leave",
                            "ret"];
                 return (Void, R) }

    Cond expr stmt -> do { stypes <- ifTypeCheck expr stmt Empty;
                           ifRetST stypes }

    CondElse expr stmt1 stmt2 -> do { stypes <- ifTypeCheck expr stmt1 stmt2;
                                      ifElseRetST stypes }

    While expr stmt -> do { l1 <- createLabel;
                            pushInstr [l1 ++ ":"];
                            t <- compileExpr expr;
                            if t == Bool
                            then do { l2 <- createLabel;
                                      pushInstr ["pop eax",
                                                "mov edx, dword 0",
                                                "cmp edx, eax",
                                                "je " ++ l2];
                                      (t1, r1) <- compileStmt stmt;
                                      pushInstr ["jmp " ++ l1,
                                                l2 ++ ":"];
                                      return (t1, r1) }
                            else do { pushErr ("If condition is type " ++ 
                              (show t) ++ " instead of Bool!");
                            defaultST } }

    SExp expr -> do { compileExpr expr;
                      pushInstr ["pop eax"];
                      defaultST }

------------- DEKLARACJE ZMIENNYCH ---------------------------------------------

declareItems :: Type -> [Item] -> M ()
declareItems _ [] = do { return () }
declareItems t (item:items) = do { declareItem t item;
                                   declareItems t items }

declareItem :: Type -> Item -> M ()
declareItem t item = case item of
  NoInit id -> let valToEax = "mov eax, " ++ emptyVal t
               in declare id t valToEax
  Init id expr -> do { t1 <- compileExpr expr;
                       if t1 == t
                       then declare id t "pop eax"
                       else pushErr ("Type of expresion (" ++ show t1 ++ 
                         ") is different than type of variable " ++ 
                         toStr id ++ "!") }

declare :: Ident -> Type -> String -> M ()
declare id t valToEax = 
  do { is <- isDeclaredVar id;
       if is 
       then pushErr ("There already exists variable " ++ toStr id ++ "!")
       else do { pos <- pushVar t id;
                 if pos == EmptyPos
                 then pushErr ("There is no start position on stack!")
                 else do { pushInstr [ valToEax, 
                                      "mov " ++ show pos ++ ", eax"] } } }

emptyVal :: Type -> String 
emptyVal Str = show ""
emptyVal _ = show 0

--------------------- INKREMENTACJA I DEKRYMENTACJA ----------------------------

changeOne :: Ident -> String -> M ()
changeOne id instr = 
  do { var <- getVar id;
       if typOf var == Int
       then do { pushInstr ["mov eax, " ++ show (posOf var),
                            instr ++ " eax",
                            "mov " ++ show (posOf var) ++ ", eax"] }
       else do { pushErr ("Only Ints can be decrimented and " ++
                    "incrimented, not " ++ show (typOf var) ++ "!") } }

------------------------------ IF ELSE -----------------------------------------

ifTypeCheck :: Expr -> Stmt -> Stmt -> M StmtType
ifTypeCheck expr stmt1 stmt2 = case expr of
       ELitFalse -> compileStmt stmt2
       ELitTrue -> compileStmt stmt1
       _ -> do { t <- compileExpr expr;
                 if t == Bool
                 then do { compileExpr ELitTrue;
                           labeledInstr compileStmt stmt1 compileStmt stmt2 "je" }
                 else do { pushErr ("Condition in 'if' statement is type " ++ 
                                 show t ++ " instead of Bool!");
                           defaultST } }

labeledInstr1 :: (Stmt -> M StmtType) -> Stmt-> Stmt -> String -> M (StmtType, StmtType)
labeledInstr1 cfun stmt1 stmt2 instr = do { l1 <- createLabel;
                                           l2 <- createLabel;
                                           pushInstr ["pop edx",
                                                      "pop eax",
                                                      "cmp eax, edx",
                                                      instr ++ " " ++ l1];
                                           st2 <- cfun stmt2;
                                           pushInstr ["jmp " ++ l2,
                                                      l1 ++ ":" ];
                                           st1 <- cfun stmt1;
                                           pushInstr [l2 ++ ":"];
                                           return (st1, st2) }

retProperType :: (StmtType, StmtType) -> M StmtType
retProperType ((t1, r1), (t2, r2)) = case (t1, t2) of
  (Void, Void) -> if r1 == r2
                  then return (Void, r1)
                  else defaultST

labeledInstr :: (Stmt -> M StmtType) -> Stmt-> (Stmt -> M StmtType) -> Stmt -> String -> M StmtType
labeledInstr cfun1 stmt1 cfun2 stmt2 instr = 
  do { l1 <- createLabel;
       l2 <- createLabel;
       pushInstr ["pop edx",
                  "pop eax",
                  "cmp eax, edx",
                  instr ++ " " ++ l1];
       (t2, r2) <- cfun2 stmt2;
       pushInstr ["jmp " ++ l2,
                  l1 ++ ":" ];
       (t1, r1) <- cfun1 stmt1;
       pushInstr [l2 ++ ":"];
       case (t1, t2) of
       (Void, _) -> do { if r1 == r2
                         then return (t2, r2)
                         else retErr }
       (_, Void) -> do { if r1 == r2
                         then return (t1, r1)
                         else do { if stmt2 == Empty 
                                   then return (Void, NR)
                                   else retErr } }
       (_, _) -> do { if t1 == t2
                      then do { if r1 == r2
                                then return (t1, r1)
                                else retErr }
                      else do { pushErr ("Different types of blocks: " ++ 
                                  show t1 ++ " and " ++ show t2 ++ "!"); 
                                return (Void, R) } } }

retErr :: M StmtType
retErr = do { pushErr ("One block return value and the other one not!"); 
              return (Void, R) }
--------------------------------------------------------------------------------
pushExprs :: Ident -> [Expr] -> Vars -> M ()
pushExprs _ [] [] = do { return () }
pushExprs id [] _ = pushErr ("Too few arguments is given to called function " ++ toStr id ++ "!")
pushExprs id _ [] = pushErr ("Too many arguments is given to called function " ++ toStr id ++ "!")
pushExprs id (expr:exprs) (var:vars) = 
  do { t <- compileExpr expr;
       if t == typOf var
       then do { pushExprs id exprs vars }
       else pushErr ("Wrong type (" ++ show t ++ 
        ") of argument of called function " ++ toStr id ++ ". Should be " ++ 
       show (typOf var) ++ "!") }

popExprs :: Int -> M ()
popExprs i = do { pushInstr ["add esp, " ++ show (i * 4)] }

compileExpr :: Expr -> M Type
compileExpr expr = case expr of
    EVar id -> retVar id
    ELitInt i -> do { pushInstr ["push dword " ++ show i];
                      return Int }
    ELitTrue -> do { pushInstr ["push dword 1"];
                     return Bool }
    ELitFalse -> do { pushInstr ["push dword 0"];
                      return Bool }
    EApp id exprs -> do { (typ, fid, args) <- getFun id;
                          if fid /= id
                          then do { pushErr ("There is no " ++ toStr id ++ " function!");
                                    return Void }
                          else do { pushExprs fid (reverse exprs) (reverse args);
                                    pushInstr ["call " ++ toStr fid];
                                    popExprs (length exprs);
                                    pushInstr ["push eax"];
                                    return typ } }
    EString s -> do { id <- saveStr s;
                      pushInstr ["push dword " ++ show (length s + 1),
                                "call malloc",
                                "add esp, 4",
                                "push eax", -- zwracany adres, zostanie na koniec na stosie
                                "push " ++ id,
                                "push eax",
                                "call strcpy", -- wkopiowywanie stringa
                                "add esp, 8"];
                      return Str }
    Neg expr -> do { t <- compileExpr expr;
                     pushInstr ["pop eax",
                               "neg eax",
                               "push eax"];
                     return t }
    Not expr -> do { t <- compileExpr expr;
                     pushInstr ["pop eax",
                               "mov edx, 1",
                               "xor eax, edx",
                               "push eax"];
                     return t }
    EMul expr1 op expr2 -> mul op expr1 expr2
    EAdd expr1 op expr2 -> add op expr1 expr2
    ERel expr1 op expr2 -> do { t1 <- compileExpr expr1;
                                t2 <- compileExpr expr2;
                                (t, r) <- rel op t1 t2;
                                return t }
    EAnd expr1 expr2 -> lazyCompileExpr (Not expr1) "push dword 0" expr2
    EOr expr1 expr2 -> lazyCompileExpr expr1 "push dword 1" expr2

retVar :: Ident -> M Type
retVar id = do { (typ, _, pos) <- getVar id;
                 if pos == EmptyPos
                 then do { pushErr ("There is no variable " ++ toStr id ++ "declared!");
                           return Void }
                 else do { pushInstr ["mov eax, " ++ show pos,
                                     "push eax"];
                           return typ } }

mul :: MulOp -> Expr -> Expr -> M Type
mul op expr1 expr2 = case op of
  Times -> operOn Int expr1 expr2 (addOper "imul")
  Div -> operOn Int expr1 expr2 divOper
  Mod -> operOn Int expr1 expr2 modOper

add :: AddOp -> Expr -> Expr -> M Type
add op expr1 expr2 = case op of
  Plus -> plusOperOn expr1 expr2
  Minus -> operOn Int expr1 expr2 (addOper "sub")

operOn :: Type -> Expr -> Expr -> (String -> M ()) -> M Type
operOn t expr1 expr2 instrFun = 
  do { t1 <- compileExpr expr1;
       t2 <- compileExpr expr2;
       if ((t1 == t) && (t2 == t))
       then do { pushInstr ["pop ecx", -- kolejność odwrotna od pushowania
                           "pop eax"];
                 instrFun "ecx";
                 return t }
       else do { pushErr ("Type of first expr (" ++ show t1 ++ 
                          ") or type of second one (" ++ show t2 ++ ") is different than " ++ 
                          show t ++ "!");
                 return t } }

plusOperOn :: Expr -> Expr -> M Type
plusOperOn expr1 expr2 = 
  do { t1 <- compileExpr expr1;
       t2 <- compileExpr expr2;
       case (t1, t2) of 
       (Int, Int) -> do { pushInstr ["pop ecx", -- kolejność odwrotna od pushowania
                                    "pop eax"];
                          addOper "add" "ecx";        
                          return Int }
       (Str, Str) -> do { pushInstr ["pop ecx", -- kolejność odwrotna od pushowania
                                    "pop eax"];
                          concatOper "ecx"; 
                          return Str }
       (_, _) -> do { pushErr ("Operator '+': Type of first expr is " ++ show t1 ++ 
                        ", type of second one is " ++ show t2 ++ "!"); 
                      return Void } }

lazyCompileExpr :: Expr -> String -> Expr -> M Type
lazyCompileExpr expr1 instr expr2 = 
  do { t <- compileExpr expr1;
       if t == Bool
       then do { pushInstr ["push dword 1"];
                 l1 <- createLabel;
                 l2 <- createLabel;
                 pushInstr ["pop edx",
                           "pop eax",
                           "cmp eax, edx",
                           "je " ++ l1];
                 t2 <- compileExpr expr2;
                 if t2 == Bool
                 then do { pushInstr ["jmp " ++ l2,
                                     l1 ++ ":",
                                     instr,
                                     l2 ++ ":"];
                           return t2 }
                 else do { pushErr ("Type of second expr in and/or (" ++ show t ++ 
                                    ") is different than Bool!");
                           return Void } }
       else do { pushErr ("Type of first expr in and/or (" ++ show t ++ 
                          ") is different than Bool!");
                 return Void } }

addOper :: String -> String -> M ()
addOper instr reg = do { pushInstr [instr ++ " eax, " ++ reg,
                                   "push eax"] }

concatOper :: String -> M () -- dostane dwa wskazniki na stercie
concatOper reg = do { pushInstr (concatStringsStr reg) }

divOper :: String -> M ()
divOper reg = do { pushInstr ["cdq",
                             "idiv " ++ reg,
                             "push eax"] }
modOper :: String -> M ()
modOper reg = do { pushInstr ["cdq",
                             "idiv " ++ reg,
                             "push edx"] }

-------------------------- RELATIONS -------------------------------------------

rel :: RelOp -> Type -> Type -> M StmtType
rel op = case op of
  LTH -> relOperInt "jl"
  LE -> relOperInt "jle"
  GTH -> relOperInt "jg"
  GE -> relOperInt "jge"
  EQU -> relOperEq "je"
  NE -> relOperEq "jne"

relOperInt :: String -> Type -> Type -> M StmtType
relOperInt = relOper (\x y -> x == Int && y == Int) "Int"

relOperEq :: String -> Type -> Type -> M StmtType
relOperEq = relOper (\x y -> x == y) "each other"

relOper :: (Type -> Type -> Bool) -> String -> String -> Type -> Type -> M StmtType
relOper cmpExpr msg instr t1 t2 = 
  do { if cmpExpr t1 t2
       then compareInstr instr
       else do { pushErr ("Type of first expr is " ++ show t1 ++ 
                          " and type of second one is " ++ show t2 ++ 
                          ". They are different from " ++ msg ++ "!");
                 return (Void, NR) } }

compareInstr :: String -> M StmtType
compareInstr = labeledInstr trueFun Empty falseFun Empty

trueFun :: Stmt -> M StmtType
trueFun _ = do { t <- compileExpr ELitTrue;
                 return (t, NR) }

falseFun :: Stmt -> M StmtType
falseFun _ = do { t <- compileExpr ELitFalse;
                  return (t, NR) }
--------------------------------------------------------------------------------
