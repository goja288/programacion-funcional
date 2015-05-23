module RunAwki(runAwki) where

import AwkiSA

runAwki :: AwkiProg -> String -> String
runAwki _ =  unlines .  map ("prueba" ++)  . lines
