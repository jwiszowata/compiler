module AbsLatte where

-- Haskell module generated by the BNF converter


newtype Ident = Ident String deriving (Eq,Ord,Show)
data Program =
   Program [TopDef]
  deriving (Eq,Ord,Show)

data FunDef =
   FunDef Type Ident [Arg] Block
  deriving (Eq,Ord,Show)

data TopDef =
   FnDef FunDef
 | StDef Type [Att]
  deriving (Eq,Ord,Show)

data Arg =
   Arg Type Ident
  deriving (Eq,Ord,Show)

data Att =
   Att Type Ident
 | Meth FunDef
  deriving (Eq,Ord,Show)

data New =
   NewArr Type Expr
 | NewSt Type
  deriving (Eq,Ord,Show)

data Assignable =
   AIdent Ident
 | AArr Ident Expr
 | AMeth Ident [Expr]
  deriving (Eq,Ord,Show)

data Assign =
   AList [Assignable]
 | ANewDot New [Assignable]
 | ANewArr New Expr
  deriving (Eq,Ord,Show)

data Block =
   Block [Stmt]
  deriving (Eq,Ord,Show)

data Stmt =
   Empty
 | BStmt Block
 | Decl Type [Item]
 | Ass Assign Expr
 | Incr Assign
 | Decr Assign
 | Ret Expr
 | VRet
 | Cond Expr Stmt
 | CondElse Expr Stmt Stmt
 | While Expr Stmt
 | SExp Expr
 | For Type Ident Expr Stmt
  deriving (Eq,Ord,Show)

data Item =
   NoInit Ident
 | Init Ident Expr
  deriving (Eq,Ord,Show)

data Type =
   Int
 | Str
 | Bool
 | Void
 | Array Type
 | Clas Ident
 | Fun Type [Type]
  deriving (Eq,Ord,Show)

data Expr =
   EVar Assign
 | ELitInt Integer
 | ELitTrue
 | ELitFalse
 | EString String
 | Neg Expr
 | Not Expr
 | EMul Expr MulOp Expr
 | EAdd Expr AddOp Expr
 | ERel Expr RelOp Expr
 | EAnd Expr Expr
 | EOr Expr Expr
 | ECast Type
 | ENew New
  deriving (Eq,Ord,Show)

data AddOp =
   Plus
 | Minus
  deriving (Eq,Ord,Show)

data MulOp =
   Times
 | Div
 | Mod
  deriving (Eq,Ord,Show)

data RelOp =
   LTH
 | LE
 | GTH
 | GE
 | EQU
 | NE
  deriving (Eq,Ord,Show)

