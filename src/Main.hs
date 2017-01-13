module Main where
  
import LexLatte
import ParLatte
import AbsLatte
import Compiler
import ErrM
import System.Environment
import System.IO
import System.FilePath.Posix
import System.Cmd

main = do
  args <- getArgs
  case args of 
    (filename : _) -> do
      handle <- openFile filename ReadMode
      s <- hGetContents handle
      doInterpret filename $ pProgram $ myLexer s
    _ -> do
      error "No file name was given!"
  
doInterpret f (Ok e) = 
  let sfp = filePath f "asm"
      ofp = filePath f "o"
      fp = dropExtension f
      dir = directory f
      name = takeBaseName f
      str = compileProgram e
  in do { if length str == 1
          then do { hPutStrLn stderr "ERROR";
                    hPutStrLn stderr $ unlines str;
                    return () }
          else do { writeFile sfp $ unlines str;
                    system("nasm -f elf32 " ++ sfp ++ " -o " ++ ofp);
                    system("gcc -m32 -o " ++ fp ++ " " ++ ofp);
                    --system("ld -o " ++ fp ++ " " ++ ofp ++ 
                    --" -melf_i386 /home/students/inf/PUBLIC/MRJP/lib32/crt?.o" ++ 
                    --" -L /home/students/inf/PUBLIC/MRJP/lib32 --library c");
                    hPutStrLn stderr "OK";
                    return () } }
                                
doInterpret f (Bad s) = hPutStrLn stderr s

filePath filename e = (dropExtension filename) <.> e

directory filename = takeDirectory filename
