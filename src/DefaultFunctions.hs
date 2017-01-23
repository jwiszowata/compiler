module DefaultFunctions(pushDefaults, pushDefaultFuns) where

import AbsLatte
import DataAndTypes
import Utils

pushDefaults :: StrObjs -> [String]
pushDefaults so = pushPreamble ++ (addStrings so []) ++ printIntStr ++ 
                  printStringStr ++ errorStr ++ readIntStr ++ readStringStr

pushPreamble :: [String]
pushPreamble = ["global main",
                "extern printf, malloc, strcpy, strncat, strlen, scanf, exit, memset",
                "section .data",
                "msgInt: db \"%d\", 10, 0",
                "msgStr: db \"%s\", 10, 0",
                "msgErr: db \"runtime error\", 10, 0",
                "msgReadInt: db \"%d\", 0",
                "msgReadStr: db \"%s\", 0",
                "emptyStr: db \"\", 0"]
                

addStrings :: StrObjs -> [String] -> [String]
addStrings [] str = str ++ ["section .text"]
addStrings (so:sos) str = addStrings sos (addString so str)

addString :: StrObj -> [String] -> [String]
addString (s, i) str = ("str" ++ show i ++ ": db \"" ++ showStr s ++ "\", 0"):str

showStr :: String -> String
showStr s = reverse (showStri s "")

showStri :: String -> String -> String
showStri [] res = res
showStri (s:ss) res
  | '\"' == s = let r = "\",\'\"\',\""
                in showStri ss (r ++ res)
  | '\n' == s = let r = "\",01 ,\""
                in showStri ss (r ++ res)
  | '\'' == s = let r = "\",\"\'\",\""
                in showStri ss (r ++ res)
  | otherwise = showStri ss (s:res)

printIntStr :: [String]
printIntStr = ["printInt:",
               "push ebp", 
               "mov ebp, esp",
               "mov eax, [ebp + 8]",
               "push eax",
               "push msgInt",
               "call printf",
               "add esp, 8",
               "leave",
               "ret"]

printStringStr :: [String]
printStringStr = ["printString:",
               "push ebp", 
               "mov ebp, esp",
               "mov eax, [ebp + 8]",
               "push eax",
               "push msgStr",
               "call printf",
               "add esp, 8",
               "leave",
               "ret"]

errorStr :: [String]
errorStr = ["error:",
            "push ebp",
            "mov ebp, esp",
            "push msgErr",
            "call printf",
            "add esp, 4",
            "push dword -1",
            "call exit",
            "add esp, 4",
            "leave",
            "ret"];

readIntStr :: [String]
readIntStr = ["readInt:",
              "push ebp",
              "mov ebp, esp",
              "push dword 4",
              "call malloc",
              "add esp, 4",
              "push eax",
              "push eax",
              "push msgReadInt",
              "call scanf",
              "add esp, 8",
              "pop eax",
              "mov edx, [eax]",
              "mov eax, edx",
              "leave",
              "ret"]

readStringStr :: [String]
readStringStr = ["readString:",
                 "push ebp",
                 "mov ebp, esp",
                 "push dword 256",
                 "call malloc",
                 "add esp, 4",
                 "push eax",
                 "push eax",
                 "push msgReadStr",
                 "call scanf",
                 "add esp, 8",
                 "pop eax",
                 "leave",
                 "ret"]
                 
pushDefaultFuns :: Funs
pushDefaultFuns = let arg1 = (Int, Ident "arg1", EmptyPos)
                      f1 = (Void, Ident "printInt", [arg1])
                      arg2 = (Str, Ident "arg2", EmptyPos)
                      f2 = (Void, Ident "printString", [arg2])
                      f3 = (Void, Ident "error", [])
                      f4 = (Int, Ident "readInt", [])
                      f5 = (Str, Ident "readString", [])
                  in [f1, f2, f3, f4, f5]