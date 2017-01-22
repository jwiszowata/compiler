module DataAndTypes(module AbsLatte, 
					M (StOut), unStOut,
					Pos (Pos, EmptyPos), 
					Var, Vars, 
					Fun, Funs, 
					Label, 
					StrObj, StrObjs, 
          Attr, Attrs,
          ATyp (A, NA),
          Struct, Structs,
					RTyp (R, NR, PR), 
					StmtType, AssType,
          typOF, idOF, argOF, 
          typOf, idOf, posOf, 
          typOfS,
          typOfA, idOfA,
          atOfS, idOfS,
          toStr, 
          defaultT, defaultST, defaultAT, defaultI) where

import AbsLatte

data Pos = Pos Int | EmptyPos deriving (Eq)

instance Show (Pos) where
    show (Pos i)
      | i >= 0 = "[ebp + " ++ show i ++ "]"
      | i < 0 = "[ebp - " ++ show (-i) ++ "]"
    show EmptyPos = ""

type Var = (Type, Ident, Pos)
type Vars = [Var]

type Fun = (Type, Ident, Vars)
type Funs = [Fun]

type Label = (Integer, Ident)

type StrObj = (String, Int)
type StrObjs = [StrObj]

-- [R]eturn | [N]ot [R]eturn | [P]artly [R]eturn
data RTyp = R | NR | PR deriving (Eq)

type StmtType = (Type, RTyp)

type Attr = (Type, Ident)
type Attrs = [Attr]
type Struct = (Type, Attrs)
type Structs = [Struct]

-- [A]ssignable | [N]ot [A]ssignable
data ATyp = A | NA deriving (Eq)
type AssType = (Attr, ATyp)


-- State and Output monad
-- Fun          = wszystkie funkcje
-- Structs        = wszystkie zadeklarowane typy/struktury
-- (Vars, Vars) = (zmienne widoczne, zmienne zadleklarowane w tym bloku)
-- Pos          = następna pozycja dla zmiennej
-- Label        = następna wolna labelka
-- StrObjs      = wszystkie stringi statyczne
-- Int          = liczba wszystkich zmiennych użytych w funkcji
-- String       = informacja o błędach

newtype M a = StOut (Funs -> Structs -> (Vars, Vars) -> Pos -> Label -> StrObjs -> Int -> String ->
  (a, Funs, Structs, (Vars, Vars), Pos, Label, StrObjs, Int, String, [String]))

instance Monad M where
  return x = StOut (\f st v p l so i e -> (x, f, st, v, p, l, so, i, e, []))
  g1 >>= g2 = StOut (\f st v p l so i e -> 
    let (x1, f1, st1, v1, p1, l1, so1, i1, e1, s1) = (unStOut g1)     f  st  v  p  l  so   i  e
        (x2, f2, st2, v2, p2, l2, so2, i2, e2, s2) =  unStOut (g2 x1) f1 st1 v1 p1 l1 so1 i1 e1
    in  (x2, f2, st2, v2, p2, l2, so2, i2, e2, s1 ++ s2) ) 

unStOut (StOut f) = f

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

typOfS :: Struct -> Type
typOfS (t, _) = t

typOfA :: Attr -> Type
typOfA (t, _) = t

idOfA :: Attr -> Ident
idOfA (_, id) = id

atOfS :: Struct -> Attrs
atOfS (_, a) = a

idOfS :: Struct -> Ident
idOfS (Clas id, _) = id

toStr :: Ident -> String
toStr (Ident id) = id

defaultST :: M StmtType
defaultST = do { return (Void, NR) }

defaultT :: M Type
defaultT = do { return Void }

defaultAT :: M AssType
defaultAT = do { return ((Void, defaultI), NA) }

defaultI :: Ident
defaultI = Ident ""