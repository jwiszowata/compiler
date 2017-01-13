module DataAndTypes where

import AbsLatte

data Pos = Pos Integer | EmptyPos deriving (Eq)

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

data RTyp = R | NR deriving (Eq)

type StmtType = (Type, RTyp)
