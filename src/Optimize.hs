module Optimize(optimize) where

optimize :: [String] -> [String]
optimize [] = []
optimize s = optPushPop s []

optPushPop :: [String] -> [String] -> [String]
optPushPop [] res = reverse res
optPushPop (s1:[]) res = optPushPop [] (s1:res)
optPushPop (s:(s1:ss)) res = 
  let sw = words s
      sw1 = words s1
  in case (length sw, length sw1) of
    (2, 2) -> let (swf:[sws]) = sw
                  (sw1f:[sw1s]) = sw1
              in case (swf, sw1f) of
                  ("push",  "pop") -> if sws == sw1s
                                      then optPushPop ss res
                                      else optPushPop ss (("mov " ++ sw1s ++ ", " ++ sws):res)
                  _ -> optPushPop (s1:ss) (s:res)
    (3, 2) -> let (swf:(sws:[swt])) = sw
                  (sw1f:[sw1s]) = sw1
              in case (swf, sws, sw1f) of
                   ("push", "dword", "pop") -> optPushPop ss (("mov " ++ sw1s ++ ", dword " ++ swt):res)
                   _ -> optPushPop (s1:ss) (s:res)
    (2, 1) -> let (swf:[sws]) = sw
                  [sw1f] = sw1
                  label = removeLast sw1f []
              in if swf == "jmp" && label == sws
                 then optPushPop ss (s1:res)
                 else optPushPop (s1:ss) (s:res)
    _ -> optPushPop (s1:ss) (s:res)

removeLast :: String -> String -> String
removeLast [] res = reverse res
removeLast (s:[]) res = reverse res
removeLast (s:ss) res = removeLast ss (s:res)