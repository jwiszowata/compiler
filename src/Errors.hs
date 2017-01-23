module Errors where

import DataAndTypes

pushErr :: String -> M ()
pushErr s = StOut (\fs st v p l so i e -> 
  ((), fs, st, v, p, l, so, i, if e /= "" then e else s, []))

-------------------------- GLOBAL ----------------------------------------------
mainFunErr :: [String]
mainFunErr = ["There is no proper main function!"]

dubFunNameErr :: [String]
dubFunNameErr = ["There are two functions (classes) with the same name or" ++
                 " basic type was used as a struct name!"]

funTypeErr :: Fun -> Type -> M ()
funTypeErr f t = pushErr (show (typOF f) ++ " function " ++ toStr (idOF f) ++ 
												" has type " ++ show t ++ "!")

interiorErr :: M ()
interiorErr = pushErr ("There is no start position on stack!")

voidArgErr :: [String]
voidArgErr = ["There is a Void argument(attribute) in one of the functions(class)!"]
-------------------------- STATEMENTS ------------------------------------------
retErr :: M StmtType
retErr = do { pushErr ("One block return value and the other one not!"); 
              defaultST }

blockTypeErr :: Type -> Type -> M StmtType
blockTypeErr t1 t2 = do { pushErr ("One block returns " ++ show t1 ++ 
                                   " value and the other one returns " ++ 
                                   show t2 ++ " value!");
                          defaultST }

condErr :: Type -> String -> M StmtType
condErr t sName = do { pushErr (sName ++ " condition is type " ++ 
                              show t ++ " instead of Bool!");
                       defaultST }

notAssErr :: Attr -> M StmtType
notAssErr (t, id, _) = do { pushErr ("Try of assigment to not assignable structure " 
                                 ++ toStr id ++ " of type " ++ show t ++ "!");
                         defaultST }

assErr :: Type -> Type -> Ident -> M StmtType
assErr t1 t2 id = do { pushErr ("Try of assigment " ++ show t1 ++ 
                          " expression to " ++ show t2 ++ 
                          " variable (array element) " ++ toStr id ++ "!");
                       defaultST }

initDeclErr :: Type -> Type -> Ident -> M ()
initDeclErr t t1 id = pushErr ("Type of expresion (" ++ show t1 ++ 
                     ") is different than type " ++ show t ++ " of variable " ++ 
                     toStr id ++ "!")

dubVar :: Ident -> M ()
dubVar id = pushErr ("There already exists variable " ++ toStr id ++ "!")

decIncErr :: Type -> M ()
decIncErr t = pushErr ("Only Ints can be decrimented and " ++
                    "incrimented, not " ++ show t ++ "!")

whileLoopedErr :: M StmtType
whileLoopedErr = do { pushErr ("While is looped!");
                      defaultST }

retVoidErr :: M StmtType
retVoidErr = do { pushErr ("Return returns void expresion!");
                  defaultST }

declVoidErr :: M ()
declVoidErr = pushErr ("Try of declaration of Void variable!")

difRetTypeErr :: Type -> Type -> M StmtType
difRetTypeErr t t1 = do { pushErr ("One function cannot return two values with " ++ 
                            "different types (" ++ show t ++ " and " ++ show t1 ++ ")!");
                          defaultST }

forTypeErr :: Type -> Type -> M StmtType
forTypeErr t t1 = do { pushErr ("Variable of type " ++ show t ++ 
                            " tries to iterate on " ++ show t1 ++ " array!");
                       defaultST }

forNotArrVarErr :: M AssType
forNotArrVarErr = do { pushErr ("For used to expression which is not an array!");
                       defaultAT }

------------------ EXPRESIONS --------------------------------------------------
noVarErr :: Ident -> M Type
noVarErr id = do { pushErr ("There is no variable " ++ toStr id ++ " declared!");
                   defaultT }

noFunErr :: Ident -> M Type
noFunErr id = do { pushErr ("There is no " ++ toStr id ++ " function!");
                   defaultT }

funArgErr :: Ident -> String -> M ()
funArgErr id amount = pushErr ("Too " ++ amount ++ " arguments is given to" ++ 
	" called function " ++ toStr id ++ "!")

argTypeErr :: Type -> Type -> Ident -> M ()
argTypeErr argT varT id = pushErr ("Wrong type (" ++ show argT ++ 
        ") of argument of called function " ++ toStr id ++ ". Should be " ++ 
       show varT ++ "!")

plusErr :: Type -> Type -> M Type
plusErr t1 t2 = do { pushErr ("Operator '+': Type of first expr is " ++ 
											show t1 ++ ", type of second one is " ++ show t2 ++ "!"); 
                     defaultT }

expTypeErr :: Type -> Type -> Type -> M Type
expTypeErr t1 t2 t = do { pushErr ("Type of first expr (" ++ show t1 ++ 
                                   ") or type of second one (" ++ show t2 ++ 
                                   ") is different than " ++ show t ++ "!");
                 					defaultT }

relExpTypesErr :: Type -> Type -> String -> M Type
relExpTypesErr t1 t2 msg = do { pushErr ("Type of first expr is " ++ show t1 ++ 
                                    " and type of second one is " ++ show t2 ++ 
                                    ". They are different from " ++ msg ++ "!");
                                defaultT }

andOrErr :: Type -> String -> M Type
andOrErr t which = do { pushErr ("Type of " ++ which ++ " expr in and/or (" ++ 
																 show t ++ ") is different than Bool!");
                        defaultT }

tooBigNrErr :: Integer -> M ()
tooBigNrErr i = pushErr ("Number " ++ show i ++ " is too big!")

nTypErr :: String -> Type -> M Type
nTypErr str t = do { pushErr ("Try of usage " ++ str ++ " to " ++ show t ++ 
                              " expresion!");
								     defaultT }

notIntArrSizeErr :: Type -> M Type
notIntArrSizeErr t = do { pushErr ("Size of created array must be of type " ++ 
                                   "Int instead of " ++ show t ++ "!");
                          defaultT }

noAttrErr :: Ident -> Ident -> M Type
noAttrErr idA idS = do { pushErr ("There is no attribute " ++ toStr idA ++ 
                                     " in structure " ++ toStr idS ++ "!");
                         defaultT }

projTypErr :: Type -> M Type
projTypErr t = do { pushErr ("There is a try of cast of null to " ++ show t ++ "!");
                    defaultT }

newNotClasErr :: M Type
newNotClasErr = do { pushErr ("Wrong usage of 'new' operator!");
                     defaultT }

------------------------------- ASSIGNMENTS ------------------------------------
notArrVarErr :: Ident -> M AssType
notArrVarErr id = do { pushErr ("Variable " ++ toStr id ++ " is not an array!");
                       defaultAT }

notIntExprArrErr :: Ident -> Type -> M AssType
notIntExprArrErr id t = do { pushErr ("Argument of " ++ toStr id ++ 
                              "[] is of type " ++ show t ++ " instead of Int!");
                             defaultAT }

noAssAttrErr :: Type -> Ident -> Ident -> M AssType
noAssAttrErr t idA idV = do { pushErr ("There is no assignable attribute " ++ 
                                  toStr idA ++ " in " ++ show t ++ " variable " ++ 
                                  toStr idV ++ "!");
                              defaultAT }

noSt :: Ident -> M Int
noSt idS = do { pushErr ("There is no struct " ++ toStr idS ++ " declared!");
                return (-1) }

emptyAssignErr :: M AssType
emptyAssignErr = do { pushErr ("Try of assigment to empty expression!");
                      defaultAT }

dotUsageErr :: M AssType
dotUsageErr = do { pushErr ("Wrong usage of operator '.'!");
                   defaultAT }

arrOpErr :: Type -> M AssType
arrOpErr t = do { pushErr ("array operator [] used to " ++ show t ++ " expression!");
                  defaultAT }