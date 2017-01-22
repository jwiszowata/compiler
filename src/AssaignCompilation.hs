module AssaignCompilation(compileAssign) where

import Utils
import Errors
import ExprCompilation

-- [compileAssignable] kompiluje wyrażenia, na które może zostać coś przypisane,
-- wrzuca na stos wskaźnik, pod którym można zapisać wybraną wartość, te 
-- wyrażenia to >> zmienna << lub >> tablica[expr] <<
-- zwraca typ wyrażenia i jego nazwę
compileAssignable :: Assignable -> M AssType
compileAssignable ass = case ass of
  AIdent id -> do { var <- getVar id;
                    pushInstr ["mov eax, " ++ show (posOf var),
                               "push eax"];
                    return ((typOf var, id), A) }
  AArr id expr -> 
    do { t <- compileExpr expr;
         var <- getVar id;
         case typOf var of
         Array t1 -> if t == Int
                     then do { pushInstr ["pop edx", -- i
                                          "inc edx",
                                          "mov eax, " ++ show (posOf var),
                                          "lea ecx, [eax + 4 * edx]",
                                          "push ecx"];
                               return ((t1, id), A) }
                     else notIntExprArrErr id t
         _ -> notArrVarErr id }

compileAssign :: Assign -> M AssType
compileAssign (AList []) = emptyAssignErr
compileAssign (AList (a:as) = do { ass <- compileAssignable a;
                                   compileNextAssignable as ass }

compileNextAssignable :: [Assignable] -> AssType -> M AssType
compileNextAssignable [] at = at
compileNextAssignable (a:as) ((t,_), _) = case (a, t) of
  (AIdent id, Clas t1) -> do { (a, i) <- getAttr id t1;
                               pushInstr ["pop edx", -- wskaźnik na struct wyżej
                                          "mov eax, dword " ++ show i,
                                          "lea ecx, [edx + 4 * eax]",
                                          "push ecx"];
                               compileNextAssignable as (a, A) }
  (AIdent "length", Array t1) -> do { if as == []
                                      then do { pushInstr ["pop eax",
                                                           "lea ecx, [eax]",
                                                           "push ecx"];
                                      return ((Int, Ident "length"), NA) }
                                      else dotUsageErr }
  (AArr id expr, Clas t1) -> do { (a, i) <- getAttr id t1;
                                  case typOfA a of 
                                    Array t1 -> do { pushInstr ["pop eax",
                                                                "mov ecx, dword " ++ show i,
                                                                "mov edx, [eax + 4 * ecx]",
                                                                "push edx"];
                                                     t <- compileExpr expr; -- expr, array
                                                     if t == Int
                                                     then do { pushInstr ["pop edx",
                                                                          "pop eax",
                                                                          "inc edx",
                                                                          "lea ecx, [eax + 4 * edx]",
                                                                          "push ecx"];
                                                               compileNextAssignable as ((t1, Ident ""), A) }
                                                     else notIntExprArrErr id t }
                                    _ -> notArrVarErr id }
  _ -> dotUsageErr