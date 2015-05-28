module Eval (eval) where

import AwkiSA
import Data.Map (Map)
import qualified Data.Map as Map
import Data.Maybe 

eval :: Map String String -> Expr -> (Map String String, Valor)

-- DEFINIMOS LA EVALUACION DE LAS EXPESIONES ATOMICAS ------------------------------------------------------------------------
eval m (Lit v) = (m, v)

eval m (Var s) = (m, Str (toString (Map.lookup s m)))

-- DEFINIMOS LAS EXPRESIONES DE LAS OPERACIONES DOS PARAMETROS ---------------------------------------------------------------
eval m (Op2 Add a b) = (m, (snd (eval m a)) + (snd (eval m b))) -- FUNCIONA PORQUE Valor implementa Num

eval m (Op2 Sub a b) = (m, (snd (eval m a)) - (snd (eval m b))) -- FUNCIONA PORQUE Valor implementa Num

eval m (Op2 Mul a b) = (m, (snd (eval m a)) * (snd (eval m b))) -- FUNCIONA PORQUE Valor implementa Num

eval m (Op2 Div a b) 
	| (toInt (snd (eval m b))) /= 0 = (m, Num (div  (toInt (snd (eval m a))) (toInt (snd (eval m b)))))
	| otherwise = (Map.insert "errorFlag" "ERROR: DIVISION POR 0" m, (Num 0))
	
eval m (Op2 Mod a b) 
	| (toInt (snd (eval m b))) /= 0 = (m, Num (mod  (toInt (snd (eval m a))) (toInt (snd (eval m b)))))
	| otherwise = (Map.insert "errorFlag" "ERROR: DIVISION POR 0" m, (Num 0))

-- VER ALGUN EJEMPLO COMO HIZO EL RESTO CON EL TEMA DE LAS COMPARACIONES, QUE DEVUELVEN?
eval m (Op2 Lt a b) 
	| (snd (eval m a)) < (snd (eval m b)) = (m, Num 1)
	| otherwise = (m, Num 0)
	
eval m (Op2 Gt a b) 
	| (snd (eval m a)) > (snd (eval m b)) = (m, Num 1)
	| otherwise = (m, Num 0)
	
eval m (Op2 Le a b)
	| (snd (eval m a)) <= (snd (eval m b)) = (m, Num 1)
	| otherwise = (m, Num 0)
	
eval m (Op2 Ge a b) 
	| (snd (eval m a)) >= (snd (eval m b)) = (m, Num 1)
	| otherwise = (m, Num 0)

eval m (Op2 Ne a b) 
	| (snd (eval m a)) /= (snd (eval m b)) = (m, Num 1)
	| otherwise = (m, Num 0)

eval m (Op2 Equal a b) 
	| (snd (eval m a)) == (snd (eval m b)) = (m, Num 1)
	| otherwise = (m, Num 0)

eval m (Op2 And a b)
	| (toBool (snd (eval m a))) && (toBool (snd (eval m b))) = (m, Num 1)
	| otherwise = (m, Num 0)

eval m (Op2 Or a b)
	| (toBool (snd (eval m a))) || (toBool (snd (eval m b))) = (m, Num 1)
	| otherwise = (m, Num 0)
	
eval m (Op2 Concat a b) = (m,  Str (concat [show (snd (eval m a)), show (snd (eval m b))]))

-- DEFINIMOS LAS EXPRESIONES DE LAS OPERACIONES UN PARAMETRO -----------------------------------------------------------------
eval m (Op1 Plus a) = (m, snd (eval m a)) -- VER ACA ??????????????????????????????????????????????????????????????????????????????????????????????????

eval m (Op1 Minus a) = (m, ((snd (eval m a)) * (-1)))

eval m (Op1 Not a) 
	| toBool (snd (eval m a)) == False = (m, Num 1)
	| otherwise = (m, Num 0)	
-- eval [("$1", "10")] (Op1 Not (Op2 Gt (Var "$1") (Lit (Num 1))))
-- eval [("$1", "10")] (Op1 Not (Op2 Lt (Var "$1") (Lit (Num 1))))

-- DEFINIMOS LAS ASIGNACIONES DE VARIABLES -----------------------------------------------------------------------------------
eval m (Assign s a) = (Map.insert s (show (snd (eval m a))) m, snd (eval m a))

-- DEFINIMOS LAS ACUMULACIONES -----------------------------------------------------------------------------------------------
eval m (Accum b s a) = ((Map.insert s (show (snd (eval m (Op2 b (Var s) a)))) m), (snd (eval m (Op2 b (Var s) a))))
-- eval [("$1", "10")] (Accum Add "$1" (Lit (Num 1))) // Deberia Guardar 11 y devolver 11

-- DEFINIMOS LAS PP ----------------------------------------------------------------------------------------------------------
eval m (PP True True s) = (Map.insert s (show (snd (eval m (Op2 Add (Var s) (Lit 1))))) m, snd (eval m (Op2 Add (Var s) (Lit 1))))
eval m (PP False True s) =  (Map.insert s (show (snd (eval m (Op2 Add (Var s) (Lit 1))))) m, snd (eval m (Var s)))
eval m (PP True False s) = (Map.insert s (show (snd (eval m (Op2 Add (Var s) (Lit (-1)))))) m, snd (eval m (Op2 Add (Var s) (Lit (-1)))))
eval m (PP False False s) =  (Map.insert s (show (snd (eval m (Op2 Add (Var s) (Lit (-1)))))) m, snd (eval m (Var s)))
-- eval [("$1", "10")] (PP False False "$1") // Deberia guardar 9 y devolver 10


	
-- PRUEBAS ...............................................................
-- eval [("1", "Pepito")] (Op2 Equal (Lit (Str "")) (Lit ( Str ""))) 
-- eval [("1", "Pepito")] (Op2 Equal (Var "1") (Lit ( Str "Pepito")))

-- *Eval> eval [("1", "Pepito")] (Lit 1) // ([("1","Pepito")],1)
-- *Eval> eval [("1", "Pepito")] (Var "1") // ([("1","Pepito")],Pepito)


toString :: Maybe a -> String
toString Nothing s = ""
toString Just s = s



