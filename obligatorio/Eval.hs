module Eval (eval) where

import AwkiSA
import Memoria

eval :: [Memoria] -> Expr -> ([Memoria], Valor)
eval m (Lit v) = (m, v)
eval m (Var s) = (m, Str (getValor s m))


-- *Eval> eval [("1", "Pepito")] (Lit 1)
-- ([("1","Pepito")],1)
-- *Eval> eval [("1", "Pepito")] (Var "1")
-- ([("1","Pepito")],Pepito)
-- *Eval>