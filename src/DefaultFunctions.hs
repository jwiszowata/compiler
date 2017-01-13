module DefaultFunctions(pushDefaults, pushDefaultFuns, concatStringsStr) where

import AbsLatte
import DataAndTypes

pushDefaults :: StrObjs -> [String]
pushDefaults so = pushPreamble ++ (addStrings so []) ++ printIntStr ++ 
                  printStringStr ++ errorStr ++ readIntStr ++ readStringStr

pushPreamble :: [String]
pushPreamble = ["global main",
                "extern printf, malloc, strcpy, strncat, strlen, scanf, exit",
                "section .data",
                "msgInt: db \"%d\", 10, 0",
                "msgStr: db \"%s\", 10, 0",
                "msgErr: db \"runtime error\", 10, 0",
                "msgReadInt: db \"%d\", 0",
                "msgReadStr: db \"%s\", 0"]
                

addStrings :: StrObjs -> [String] -> [String]
addStrings [] str = str ++ ["section .text"]
addStrings (so:sos) str = addStrings sos (addString so str)

addString :: StrObj -> [String] -> [String]
addString (s, i) str = ("str" ++ show i ++ ": db " ++ show s ++ ", 0"):str

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
                 
pushDefaultFuns :: Funs
pushDefaultFuns = let arg1 = (Int, Ident "arg1", EmptyPos)
                      f1 = (Void, Ident "printInt", [arg1])
                      arg2 = (Str, Ident "arg2", EmptyPos)
                      f2 = (Void, Ident "printString", [arg2])
                      f3 = (Void, Ident "error", [])
                      f4 = (Int, Ident "readInt", [])
                      f5 = (Str, Ident "readString", [])
                  in [f1, f2, f3, f4, f5]

