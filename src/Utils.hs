module Utils(module DataAndTypes,
             pushArgs, pushAtts, getAttr, getSts, getStSize,
             pushErr, pushInstr, createLabel, getFuns, saveStr,
             getVars, getFunction, getFun, setVars, getVar, pushVar, isDeclaredVar,
             labeledInstr, concatStringsStr, allocStr, pushIfInt) where

import DataAndTypes
import Errors

pushFun :: Fun -> M ()
pushFun f = StOut (\fs st v p l so i e -> ((), f:fs, st, v, p, l, so, i, e, []))

pushInstr :: [String] -> M ()
pushInstr s = StOut (\f st v p l so i e -> ((), f, st, v, p, l, so, i, e, s))

pushVar :: Type -> Ident -> M Pos
pushVar t id = 
  let var = (t, id, EmptyPos)
  in StOut (\f st (v, vd) p l so i e -> 
  (p, f, st, ((setPos var p):v, (setPos var p):vd), nextPos p, l, so, i + 1, e, []))

getPos :: Ident -> M Pos
getPos id = StOut (\f st (v, vd) p l so i e -> (getPosition id v, f, st, (v, vd), p, l, so, i, e, []))

getVari :: Ident -> M Var
getVari id = StOut (\f st (v, vd) p l so i e -> (getVariable id v, f, st, (v, vd), p, l, so, i, e, []))


isDeclaredVar :: Ident -> M Bool
isDeclaredVar id = StOut (\f st (v, vd) p l so i e -> 
  (getPosition id vd /= EmptyPos, f, st, (v, vd), p, l, so, i, e, []))

createLabel :: M String
createLabel = StOut (\f st v p (nr, id) so i e -> 
  ("." ++ toStr id ++ show nr, f, st, v, p, (nr + 1, id), so, i, e, []))

getFuns :: M Funs
getFuns = StOut (\f st v p l so i e -> (f, f, st, v, p, l, so, i, e, []))

getSts :: M Structs
getSts = StOut (\f st v p l so i e -> (st, f, st, v, p, l, so, i, e, []))

getStrObjs :: M StrObjs
getStrObjs = StOut (\f st v p l so i e -> (so, f, st, v, p, l, so, i, e, []))

getFun :: Ident -> M Fun
getFun id = StOut (\f st v p l so i e -> (getFunction id f, f, st, v, p, l, so, i, e, []))


getVars :: M (Vars, Vars)
getVars = StOut (\f st v p l so i e -> (v, f, st, v, p, l, so, i, e, []))

setVars :: (Vars, Vars) -> M ()
setVars vars = StOut (\f st v p l so i e -> ((), f, st, vars, p, l, so, i, e, []))

getLastStrObj :: M StrObj
getLastStrObj = StOut (\f st v p l (s:so) i e -> (s, f, st, v, p, l, s:so, i, e, []))

pushStrObj :: StrObj -> M ()
pushStrObj s = StOut (\f st v p l so i e -> ((), f, st, v, p, l, s:so, i, e, []))

isEmptyStrObjs :: M Bool
isEmptyStrObjs = StOut (\f st v p l s i e -> (isEmpty s, f, st, v, p, l, s, i, e, []))

getAttrib :: Ident -> Ident -> M (Attr, Int)
getAttrib idA idS = StOut (\f st v p l s i e -> 
  (getAttri idA idS st, f, st, v, p, l, s, i, e, []))

findSt :: Ident -> M Struct
findSt idS = StOut (\f st v p l s i e -> (findStFrom idS st, f, st, v, p, l, s, i, e, []))
--------------------------------------------------------------------------------

findStFrom :: Ident -> Structs -> Struct
findStFrom _ [] = (Clas (Ident ""), [])
findStFrom idS (st:sts)
  | idS == idOfS st = st
  | otherwise = findStFrom idS sts

getAttri :: Ident -> Ident -> Structs -> (Attr, Int)
getAttri idA idS ((Clas id, ats):sts)
  | idS == id = getAttribute idA ats 0
  | otherwise = getAttri idA idS sts

getAttribute :: Ident -> Attrs -> Int -> (Attr, Int)
getAttribute _ [] _ = ((Void, Ident ""), -1)
getAttribute idA (at:ats) n
  | idA == idOfA at = (at, n)
  | otherwise = getAttribute idA ats (n+1)



setPos :: Var -> Pos -> Var
setPos (t, id, _) p = (t, id, p)

nextPos :: Pos -> Pos
nextPos EmptyPos = EmptyPos
nextPos (Pos i) = Pos (i - 4)

nextUpPos :: Pos -> Pos
nextUpPos EmptyPos = EmptyPos
nextUpPos (Pos p) = Pos (p + 4)

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

getFunction :: Ident -> Funs -> Fun
getFunction id [] = (Int, Ident "", [])
getFunction id ((t, ident, args):fs)
  | id == ident = (t, ident, args)
  | otherwise = getFunction id fs

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
                 then do { pushErr ("There is no variable " ++ toStr id ++ " declared!");
                           return var }
                 else do { return var } }

labeledInstr :: (Stmt -> M StmtType) -> Stmt-> (Stmt -> M StmtType) -> Stmt -> 
 String -> M (StmtType, StmtType)
labeledInstr cfun1 stmt1 cfun2 stmt2 instr = 
  do { l1 <- createLabel;
       l2 <- createLabel;
       pushInstr ["pop edx",
                  "pop eax",
                  "cmp eax, edx",
                  instr ++ " " ++ l1];
       st2 <- cfun2 stmt2;
       pushInstr ["jmp " ++ l2,
                  l1 ++ ":" ];
       st1 <- cfun1 stmt1;
       pushInstr [l2 ++ ":"];
       return (st1, st2) }

isEmpty :: StrObjs -> Bool
isEmpty [] = True
isEmpty _ = False

--------------------------------------------------------------------------------
-- [pushArgs]
pushArgs :: [Arg] -> (Vars, Bool)
pushArgs args = pushArguments args (Pos 8) []

pushArguments :: [Arg] -> Pos -> Vars -> (Vars, Bool)
pushArguments [] _ vars = (reverse vars, False)
pushArguments ((Arg typ id):args) pos vars = 
  let var = (typ, id, pos)
  in if typ == Void
     then ([], True)
     else pushArguments args (nextUpPos pos) (var:vars)

--------------------------------------------------------------------------------
-- [pushAtts]
pushAtts :: [Att] -> (Attrs, Bool)
pushAtts atts = pushAttributes atts []

pushAttributes:: [Att] -> Attrs -> (Attrs, Bool)
pushAttributes [] ats = (reverse ats, False)
pushAttributes ((Att typ id):atts) ats = 
  let attr = (typ, id)
  in if typ == Void
     then ([], True)
     else pushAttributes atts (attr:ats)

--------------------------------------------------------------------------------

concatStringsStr :: String -> [String]
concatStringsStr reg = ["push eax",     -- a
                        "push " ++ reg, -- b, a
                        "push eax",     -- a, b, a
                        "call strlen",
                        "add esp, 4",   -- b, a;  eax = len a
                        "pop ecx",      -- a;     eax = len a, ecx = b
                        "push eax",     -- len a, a
                        "push ecx",     -- b, len a, a
                        "push ecx",     -- b, b, len a, a
                        "call strlen",
                        "add esp, 4",   -- b, len a, a;   eax = len b
                        "pop ecx",      -- len a, a;   eax = len b, ecx = b
                        "pop edx",      -- a;   eax = len b, ecx = b, edx = len a
                        "pop edi",       -- ; eax = len b, ecx = b, edx = len a, edi = a
                        "push eax",     -- len b
                        "push ecx",     -- b, len b
                        "push edi",     -- a, b, len b
                        "add edx, eax",
                        "inc edx",
                        "push edx",     -- len a + len b + 1, a, b, len b
                        "call malloc",
                        "add esp, 4",   -- a, b, len b;    eax = *x
                        "push eax",     -- x, a, b, len b
                        "call strcpy",
                        "add esp, 8",   -- b, len b; eax = *x
                        "push eax",     -- x, b, len b;
                        "call strncat",
                        "add esp, 12",  -- ; eax = *x
                        "push eax"]     -- *x;

allocStr :: Int -> String -> [String]
allocStr i id = ["push dword " ++ show i,
                 "call malloc",
                 "add esp, 4",
                 "push eax", -- zwracany adres, zostanie na koniec na stosie
                 "push " ++ id,
                 "push eax",
                 "call strcpy", -- wkopiowywanie stringa
                 "add esp, 8"]
  
pushIfInt :: Integer -> M Type
pushIfInt i = let ii = (fromIntegral i :: Int)
                  iI = (fromIntegral ii :: Integer)
              in do { if i == iI
                      then do { pushInstr ["push dword " ++ show i];
                                return Int } 
                      else do { tooBigNrErr i;
                                return Int } }

getAttr :: Ident -> Ident -> M (Attr, Int)
getAttr idA idS = do { (a, i) <- getAttrib idA idS;
                       if i == (-1)
                       then do { noAttrErr idA idS;
                                 return ((Void, Ident ""), -1) }
                       else return (a, i) }

getStSize :: Ident -> M Int
getStSize idS = do { st <- findSt idS;
                     return (length (atOfS st)) }
