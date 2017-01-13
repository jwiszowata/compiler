module Utils(module DataAndTypes, module AbsLatte,
             M, unStOut,
             pushArgs, pushErr, pushInstr, createLabel, getFuns, saveStr, defaultST,
             getVars, getFunction, getFun, setVars, getVar, pushVar, isDeclaredVar,
             toStr, 
             typOf, posOf, 
             typOF, argOF, idOF) where

import DataAndTypes
import AbsLatte

--------------------------------------------------------------------------------

-- State and Output monad
-- Fun          = wszystkie funkcje
-- (Vars, Vars) = (zmienne widoczne, zmienne zadleklarowane w tym bloku)
-- Pos          = następna pozycja dla zmiennej
-- Label        = następna wolna labelka
-- StrObjs      = wszystkie stringi statyczne
-- Int          = liczba wszystkich zmiennych użytych w funkcji
-- String       = informacja o błędach

newtype M a = StOut (Funs -> (Vars, Vars) -> Pos -> Label -> StrObjs -> Int -> String ->
  (a, Funs, (Vars, Vars), Pos, Label, StrObjs, Int, String, [String]))

instance Monad M where
  return x = StOut (\f v p l s i e -> (x, f, v, p, l, s, i, e, []))
  g1 >>= g2 = StOut (\f v p l s i e -> 
    let (x1, f1, v1, p1, l1, so1, i1, e1, s1) = (unStOut g1) f v p l s i e
        (x2, f2, v2, p2, l2, so2, i2, e2, s2) = unStOut (g2 x1) f1 v1 p1 l1 so1 i1 e1
    in (x2, f2, v2, p2, l2, so2, i2, e2, s1 ++ s2) ) 

unStOut (StOut f) = f

--------------------------------------------------------------------------------
pushErr :: String -> M ()
pushErr s = StOut (\fs v p l so i e -> 
  ((), fs, v, p, l, so, i, if e /= "" then e else s, []))

pushFun :: Fun -> M ()
pushFun f = StOut (\fs v p l so i e -> ((), f:fs, v, p, l, so, i, e, []))

pushInstr :: [String] -> M ()
pushInstr s = StOut (\f v p l so i e -> ((), f, v, p, l, so, i, e, s))

pushVar :: Type -> Ident -> M Pos
pushVar t id = 
  let var = (t, id, EmptyPos)
  in StOut (\f (v, vd) p l so i e -> 
  (p, f, ((setPos var p):v, (setPos var p):vd), nextPos p, l, so, i + 1, e, []))

setPos :: Var -> Pos -> Var
setPos (t, id, _) p = (t, id, p)

nextPos :: Pos -> Pos
nextPos EmptyPos = EmptyPos
nextPos (Pos i) = Pos (i - 4)

nextUpPos :: Pos -> Pos
nextUpPos EmptyPos = EmptyPos
nextUpPos (Pos p) = Pos (p + 4)

getPos :: Ident -> M Pos
getPos id = StOut (\f (v, vd) p l so i e -> (getPosition id v, f, (v, vd), p, l, so, i, e, []))

getVari :: Ident -> M Var
getVari id = StOut (\f (v, vd) p l so i e -> (getVariable id v, f, (v, vd), p, l, so, i, e, []))

getVariable :: Ident -> Vars -> Var
getVariable ident [] = (Int, Ident "", EmptyPos)
getVariable ident (var:vars) 
  | ident == idOf var = var
  | otherwise = getVariable ident vars

getPosition :: Ident -> Vars -> Pos
getPosition _ [] = EmptyPos
getPosition ident (var:vars)
  | ident == idOf var = posOf var
  | otherwise = getPosition ident vars

isDeclaredVar :: Ident -> M Bool
isDeclaredVar id = StOut (\f (v, vd) p l so i e -> 
  (getPosition id vd /= EmptyPos, f, (v, vd), p, l, so, i, e, []))

createLabel :: M String
createLabel = StOut (\f v p (nr, id) so i e -> 
  ("." ++ toStr id ++ show nr, f, v, p, (nr + 1, id), so, i, e, []))

getFuns :: M Funs
getFuns = StOut (\f v p l so i e -> (f, f, v, p, l, so, i, e, []))

getStrObjs :: M StrObjs
getStrObjs = StOut (\f v p l so i e -> (so, f, v, p, l, so, i, e, []))

getFun :: Ident -> M Fun
getFun id = StOut (\f v p l so i e -> (getFunction id f, f, v, p, l, so, i, e, []))

getFunction :: Ident -> Funs -> Fun
getFunction id [] = (Int, Ident "", [])
getFunction id ((t, ident, args):fs)
  | id == ident = (t, ident, args)
  | otherwise = getFunction id fs

getVars :: M (Vars, Vars)
getVars = StOut (\f v p l so i e -> (v, f, v, p, l, so, i, e, []))

setVars :: (Vars, Vars) -> M ()
setVars vars = StOut (\f v p l so i e -> ((), f, vars, p, l, so, i, e, []))

getLastStrObj :: M StrObj
getLastStrObj = StOut (\f v p l (s:so) i e -> (s, f, v, p, l, s:so, i, e, []))

pushStrObj :: StrObj -> M ()
pushStrObj s = StOut (\f v p l so i e -> ((), f, v, p, l, s:so, i, e, []))

nextNr :: StrObj -> Int
nextNr (_, i) = i + 1

saveStr :: String -> M String
saveStr s = do { b <- isEmptyStrObjs;
                 if b
                 then do { pushStrObj (s, 0);
                           return "str0" }
                 else do { so <- getLastStrObj;
                           pushStrObj (s, nextNr so);
                           return ("str" ++ show (nextNr so)) } }

getVar :: Ident -> M Var
getVar id = do { var <- getVari id;
                 if posOf var == EmptyPos
                 then do { pushErr ("There is no " ++ toStr id ++ 
                                    " variable declared!");
                            return var }
                 else do { return var } }

defaultST :: M StmtType
defaultST = do { return (Void, NR) }

isEmptyStrObjs :: M Bool
isEmptyStrObjs = StOut (\f v p l s i e -> (isEmpty s, f, v, p, l, s, i, e, []))

isEmpty :: StrObjs -> Bool
isEmpty [] = True
isEmpty _ = False

typOf :: Var -> Type
typOf (typ, _, _) = typ

idOf :: Var -> Ident
idOf (_, id, _) = id

posOf :: Var -> Pos
posOf (_, _, pos) = pos

typOF :: Fun -> Type
typOF (typ, _, _) = typ

idOF :: Fun -> Ident
idOF (_, id, _) = id

argOF :: Fun -> Vars
argOF (_, _, args) = args

toStr :: Ident -> String
toStr (Ident id) = id

pushArgs :: [Arg] -> Vars
pushArgs args = pushArguments args (Pos 8) []
  
pushArguments :: [Arg] -> Pos -> Vars -> Vars
pushArguments [] _ vars = reverse vars
pushArguments ((Arg typ id):args) pos vars = 
  let var = (typ, id, pos)
  in pushArguments args (nextUpPos pos) (var:vars)
  
  
