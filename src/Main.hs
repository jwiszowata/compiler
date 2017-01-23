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
import System.Exit

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
  let sfp = filePath f "s"
      ofp = filePath f "o"
      fp = dropExtension f
      dir = directory f
      name = takeBaseName f
      str = compileProgram e
  in do { if length str == 1
          then do { showError (unlines str);
                    return () }
          else do { writeFile sfp $ unlines str;
                    system("nasm -f elf32 -g \"" ++ sfp ++ "\" -o \"" ++ ofp ++ "\"");
                    system("gcc -m32 -o \"" ++ fp ++ "\" \"" ++ ofp ++ "\""); -- on my computer
                    --system("ld -o \"" ++ fp ++ "\" \"" ++ ofp ++ 
                    --"\" -melf_i386 /home/students/inf/PUBLIC/MRJP/lib32/crt?.o" ++ 
                    --" -L /home/students/inf/PUBLIC/MRJP/lib32 --library c");
                    hPutStrLn stderr "OK";
                    return () } }
                                
doInterpret f (Bad s) = showError (s ++ "\n")

showError s = do { hPutStrLn stderr "ERROR";
                   hPutStr stderr s;
                   exitFailure }

filePath filename e = (dropExtension filename) <.> e

directory filename = takeDirectory filename
