module ExprCompilation(compileExpr, compileAssign) where

import Utils
import Errors

-- [compileExpr] wylicza wartość wyrażenia i dodaje instrukcje wrzucające wynik 
-- na stos
compileExpr :: Expr -> M Type
compileExpr expr = case expr of
    EVar ass -> retAss ass
    ELitInt i -> pushIfInt i
    ELitTrue -> do { pushInstr ["push dword 1"];
                     return Bool }
    ELitFalse -> do { pushInstr ["push dword 0"];
                      return Bool }
    EString s -> do { id <- saveStr s;
                      pushInstr (allocStr (length s + 1) id);
                      return Str }
    Neg expr -> do { t <- compileExpr expr;
                     if t /= Int
                     then nTypErr "negation" t
                     else do { pushInstr ["pop eax",
                                          "neg eax",
                                          "push eax"];
                                return t } }
    Not expr -> do { t <- compileExpr expr;
                     if t /= Bool
                     then nTypErr "! operator" t
                     else do { pushInstr ["pop eax",
                                          "mov edx, 1",
                                          "xor eax, edx",
                                          "push eax"];
                                return t } }
    EMul expr1 op expr2 -> mul op expr1 expr2
    EAdd expr1 op expr2 -> add op expr1 expr2
    ERel expr1 op expr2 -> do { t1 <- compileExpr expr1;
                                t2 <- compileExpr expr2;
                                rel op t1 t2 }
    EAnd expr1 expr2 -> lazyCompileExpr (Not expr1) "push dword 0" expr2
    EOr expr1 expr2 -> lazyCompileExpr expr1 "push dword 1" expr2
    ECast t -> case t of
                  Clas t1 -> do { pushInstr ["push dword 0"];
                                  return t }
                  _ -> projTypErr t
    ENew newExpr -> compileNewExpr newExpr

--------------------------- ZMIENNA --------------------------------------------
retAss :: Assign -> M Type
retAss ass = do { (a, t) <- compileAssign ass;
                  case t of
                    A -> do { pushInstr ["pop eax",
                                          "mov edx, [eax]",
                                          "push edx"];
                               return (typOfA a) }
                    NA -> do { return (typOfA a) } }

---------------------- WYWOŁANIE FUNKCJI ---------------------------------------
pushExprs :: Ident -> [Expr] -> Vars -> M ()
pushExprs _ [] [] = do { return () }
pushExprs id [] _ = funArgErr id "few"
pushExprs id _ [] = funArgErr id "many"
pushExprs id (expr:exprs) (var:vars) = 
  do { t <- compileExpr expr;
       if t == typOf var
       then do { pushExprs id exprs vars }
       else argTypeErr t (typOf var) id }

pop :: Int -> M ()
pop i = do { pushInstr ["add esp, " ++ show (i * 4)] }

------------------------ DZIAŁANIA ---------------------------------------------
operOn :: Type -> Expr -> Expr -> (String -> M ()) -> M Type
operOn t expr1 expr2 instrFun = 
  do { t1 <- compileExpr expr1;
       t2 <- compileExpr expr2;
       if ((t1 == t) && (t2 == t))
       then do { pushInstr ["pop ecx", -- kolejność odwrotna od pushowania
                            "pop eax"];
                 instrFun "ecx";
                 return t }
       else expTypeErr t1 t2 t }

twoRegOper :: String -> String -> M ()
twoRegOper instr reg = do { pushInstr [instr ++ " eax, " ++ reg,
                                       "push eax"] }

------------------------ MNOŻENIE, DZIELENIE, MOD ------------------------------
mul :: MulOp -> Expr -> Expr -> M Type
mul op expr1 expr2 = case op of
  Times -> operOn Int expr1 expr2 (twoRegOper "imul")
  Div -> operOn Int expr1 expr2 divOper
  Mod -> operOn Int expr1 expr2 modOper

divOper :: String -> M ()
divOper reg = do { pushInstr ["cdq",
                              "idiv " ++ reg,
                              "push eax"] }
modOper :: String -> M ()
modOper reg = do { pushInstr ["cdq",
                              "idiv " ++ reg,
                              "push edx"] }

--------------------- DODAWANIE, ODEJMOWANIE -----------------------------------
add :: AddOp -> Expr -> Expr -> M Type
add op expr1 expr2 = case op of
  Plus -> plusOperOn expr1 expr2
  Minus -> operOn Int expr1 expr2 (twoRegOper "sub")

plusOperOn :: Expr -> Expr -> M Type
plusOperOn expr1 expr2 = 
  do { t1 <- compileExpr expr1;
       t2 <- compileExpr expr2;
       case (t1, t2) of 
       (Int, Int) -> do { pushInstr ["pop ecx", -- kolejność odwrotna od pushowania
                                     "pop eax"];
                          twoRegOper "add" "ecx";        
                          return Int }
       (Str, Str) -> do { pushInstr ["pop ecx", -- kolejność odwrotna od pushowania
                                     "pop eax"];
                          concatOper "ecx"; 
                          return Str }
       (_, _) -> plusErr t1 t2 }

concatOper :: String -> M () -- dostane dwa wskazniki na stercie
concatOper reg = do { pushInstr (concatStringsStr reg) }

-------------------------- RELACJE ---------------------------------------------
rel :: RelOp -> Type -> Type -> M Type
rel op = case op of
  LTH -> relOperInt "jl"
  LE -> relOperInt "jle"
  GTH -> relOperInt "jg"
  GE -> relOperInt "jge"
  EQU -> relOperEq "je"
  NE -> relOperEq "jne"

relOperInt :: String -> Type -> Type -> M Type
relOperInt = relOper (\x y -> x == Int && y == Int) "Int"

relOperEq :: String -> Type -> Type -> M Type
relOperEq = relOper (\x y -> x == y) "each other"

relOper :: (Type -> Type -> Bool) -> String -> String -> Type -> Type -> M Type
relOper cmpExprTypes msg instr t1 t2 = 
  do { if cmpExprTypes t1 t2
       then compareInstr instr
       else relExpTypesErr t1 t2 msg }

-- [compareInstr] porównuje dwa wyrażenia, które są na stosie zgodnie ze 
-- wskazaną instrukcją, ostateczny wynik wrzuca na stos
compareInstr :: String -> M Type
compareInstr instr = do { labeledInstr trueFun Empty falseFun Empty instr;
                          return Bool }

trueFun :: Stmt -> M StmtType
trueFun _ = do { compileExpr ELitTrue;
                 defaultST }

falseFun :: Stmt -> M StmtType
falseFun _ = do { compileExpr ELitFalse;
                  defaultST }

------------------- AND, OR - LENIWE -------------------------------------------
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
                 else andOrErr t2 "second" }
       else andOrErr t "first"}

--------------------------------------------------------------------------------

compileNewExpr :: New -> M Type
compileNewExpr newExpr = case newExpr of
  NewArr t expr -> do { t1 <- compileExpr expr;
                        if t1 == Int
                        then do { pushInstr ["pop eax",
                                             "push eax",     -- size
                                             "inc eax",
                                             "mov edx, dword 4",
                                             "imul edx",
                                             "push eax",     -- (size + 1) * 4, size
                                             "push eax",     -- (size + 1) * 4, (size + 1) * 4, size
                                             "call malloc",
                                             "add esp, 4",   -- (size + 1) * 4, size
                                             "push dword 0", -- 0, (size + 1) * 4, size
                                             "push eax",     -- x*, 0, (size + 1) * 4, size
                                             "call memset",
                                             "add esp, 12",  -- size
                                             "pop edx",
                                             "mov [eax], edx",
                                             "push eax"];
                                  return (Array t) }
                        else notIntArrSizeErr t1 }
  NewSt t -> do { case t of 
                  Clas id -> do { size <- getStSize id;
                                  pushInstr ["mov eax, " ++ show size,
                                             "mov edx, 4",
                                             "imul edx",
                                             "push eax",
                                             "push eax",
                                             "call malloc",
                                             "add esp, 4",
                                             "push dword 0", -- 0, size * 4
                                             "push eax",     -- x*, 0, size * 4
                                             "call memset",
                                             "add esp, 12",
                                             "push eax"];
                                  return (Clas id) }
                  _ -> newNotClasErr }

--------------------------------------------------------------------------------
-- [compileAssign] kompiluje wyrażenia, na które może zostać coś przypisane,
-- wrzuca na stos wskaźnik, pod którym można zapisać wybraną wartość, te 
-- wyrażenia to >> zmienna << lub >> tablica[expr] <<
-- zwraca typ wyrażenia i jego nazwę
-- jeżeli wyrażenie jest [A]ssignable na stosie jest wskaźnik
-- jeżeli wyrażenie jest [N]ot [A]ssignable na stosie jest wynik
compileAssign :: Assign -> M AssType
compileAssign (AList []) = emptyAssignErr
compileAssign (AList (a:as)) = do { ass <- compileAssignable a;
                                    compileNextAssignable as ass }
compileAssign (ANewDot newExpr as) = 
  do { t <- compileNewExpr newExpr;
       compileNextAssignable as ((t, defaultI, EmptyPos), NA) }
compileAssign (ANewArr newExpr expr) = 
  do { t1 <- compileNewExpr newExpr;
        case t1 of
          Array t2 -> do { t <- compileExpr expr;
                           if t == Int
                           then do { pushInstr ["pop edx", -- i
                                                "inc edx",
                                                "pop eax", -- array
                                                "lea ecx, [eax + 4 * edx]",
                                                "push ecx"];
                                     return ((t1, defaultI, EmptyPos), A) }
                           else notIntExprArrErr defaultI t }
          _ -> arrOpErr t1 }

-- wołanie bez kropki
-- Jeżeli jest A to zwraca wskaźnik na obiekt
-- Jeżeli jest NA to zwraca obiekt
compileAssignable :: Assignable -> M AssType
compileAssignable ass = case ass of
  AIdent id -> do { var <- getVar id;
                    pushInstr ["lea eax, " ++ show (posOf var),
                               "push eax"];
                    return ((typOf var, id, EmptyPos), A) }
  AArr id expr -> 
    do { t <- compileExpr expr;
         var <- getVar id;
         case typOf var of
         Array t1 -> if t == Int
                     then do { pushInstr ["pop edx", -- i
                                          "inc edx",
                                          "lea eax, " ++ show (posOf var),
                                          "mov eax, [eax]",
                                          "lea ecx, [eax + 4 * edx]",
                                          "push ecx"];
                               return ((t1, id, EmptyPos), A) }
                     else notIntExprArrErr id t
         _ -> notArrVarErr id }
  AMeth id exprs -> do { fun <- getFun id;
                         callFunction fun id exprs }

compileNextAssignable :: [Assignable] -> AssType -> M AssType
compileNextAssignable [] at = do { return at }
compileNextAssignable (a:as) ((t,_, _), atyp) = 
  let sEdx = (if atyp == A
              then objInEdx
              else inEdx)
  in case (a, t) of
  (AIdent id, Clas t1) -> do { (a, i) <- getAttr id t1;
                               pushInstr (sEdx ++ ["mov eax, dword " ++ show i,
                                                   "lea ecx, [edx + 4 * eax]",
                                                   "push ecx"]);
                               compileNextAssignable as (a, A) }
  (AIdent (Ident "length"), Array t1) -> 
    do { if as == []
         then do { pushInstr (sEdx ++ ["mov eax, [edx]",
                                       "push eax"]);
                   return ((Int, Ident "length", EmptyPos), NA) }
         else dotUsageErr }
  (AArr id expr, Clas t1) -> 
    do { (a, i) <- getAttr id t1;
          case typOfA a of 
            Array t1 -> 
                let att = (t1, defaultI, EmptyPos)
                in do { pushInstr (sEdx ++ ["mov ecx, dword " ++ show i,
                                            "mov eax, [edx + 4 * ecx]",
                                            "push eax"]);
                     t <- compileExpr expr; -- expr, array
                     if t == Int
                     then do { pushInstr ["pop edx",
                                          "pop eax",
                                          "inc edx",
                                          "lea ecx, [eax + 4 * edx]",
                                          "push ecx"];
                               compileNextAssignable as (att, A) }
                     else notIntExprArrErr id t }
            _ -> notArrVarErr id }
  (AMeth id exprs, Clas t1) ->
      let mthName = makeMthName id (Clas t1)
      in do { fun <- getMth mthName t1;
              ass <- callMethod fun mthName exprs;
              compileNextAssignable as ass }
  _ -> dotUsageErr

objInEdx :: [String]
objInEdx = ["pop ecx", "mov edx, [ecx]"]

inEdx :: [String]
inEdx = ["pop edx"]

callFunction :: Fun -> Ident -> [Expr] -> M AssType
callFunction fun fid exprs = 
  do { if idOF fun /= fid
       then do { noFunErr fid;
                 defaultAT }
       else do { pushExprs (idOF fun) (reverse exprs) (reverse (argOF fun));
                 pushInstr ["call " ++ toStr (idOF fun)];
                 pop (length exprs);
                 pushInstr ["push eax"];
                 return ((typOF fun, (idOF fun), EmptyPos), NA) } }

callMethod :: Fun -> Ident -> [Expr] -> M AssType
callMethod fun fid exprs = 
  do { if idOF fun /= fid
       then do { noFunErr fid;
                 defaultAT }
       else let arg:args = argOF fun
            in do { pushInstr ["pop ebx",
                               "mov ebx, [ebx]"];
                     pushExprs (idOF fun) (reverse exprs) (reverse args);
                     pushInstr ["push ebx",
                                "call " ++ toStr (idOF fun)];
                     pop (length (argOF fun));
                     pushInstr ["push eax"];
                     return ((typOF fun, (idOF fun), EmptyPos), NA) } }