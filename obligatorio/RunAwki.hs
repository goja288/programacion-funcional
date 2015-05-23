module RunAwki(runAwki) where

import AwkiSA
import Memoria

runAwki :: AwkiProg -> String -> String
runAwki (AwkiProg [(BEGIN,Empty)]) _ = "ola no es lo mismo que Hola"
-- '{ print }'
runAwki ( AwkiProg [(Pat (Lit 1),Sequence [Print [Field (Lit 0)]])] ) a = a -- '{ print }'

runAwki _ _ = "a bu"

----
-- runAwki _ =  unlines .  map ("prueba" ++)  . lines
---