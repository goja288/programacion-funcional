module Eval (eval) where

import AwkiSA
import Data.Map (Map)
import qualified Data.Map as Map
import Data.Maybe 

eval :: Map String String -> Expr -> (Map String String, Valor)

-- DEFINIMOS LA EVALUACION DE LAS EXPESIONES ATOMICAS ------------------------------------------------------------------------
eval m (Lit v) 
	| evalError m  == True = (m, (Num 0))
	| otherwise = (m, v)

eval m (Var s)
	| evalError m  == True = (m, (Num 0))
	| otherwise = (m, Str (toString (Map.lookup s m)))

-- DEFINIMOS LAS EXPRESIONES DE LAS OPERACIONES DOS PARAMETROS ---------------------------------------------------------------
eval m (Op2 Add a b)
	| evalError m  == True = (m, (Num 0))
	| otherwise = (m, (snd (eval m a)) + (snd (eval m b))) -- FUNCIONA PORQUE Valor implementa Num

eval m (Op2 Sub a b) 
	| evalError m  == True = (m, (Num 0)) 
	| otherwise = (m, (snd (eval m a)) - (snd (eval m b))) -- FUNCIONA PORQUE Valor implementa Num

eval m (Op2 Mul a b) 
	| evalError m  == True = (m, (Num 0))
	| otherwise = (m, (snd (eval m a)) * (snd (eval m b))) -- FUNCIONA PORQUE Valor implementa Num

eval m (Op2 Div a b) 
	| evalError m  == True = (m, (Num 0))
	| (toInt (snd (eval m b))) /= 0 = (m, Num (div  (toInt (snd (eval m a))) (toInt (snd (eval m b)))))
	| otherwise = (Map.insert "errorFlag" "ERROR: DIVISION POR 0" m, (Num 0))
	
eval m (Op2 Mod a b)
	| evalError m  == True = (m, (Num 0))
	| (toInt (snd (eval m b))) /= 0 = (m, Num (mod  (toInt (snd (eval m a))) (toInt (snd (eval m b)))))
	| otherwise = (Map.insert "errorFlag" "ERROR: DIVISION POR 0" m, (Num 0))

-- VER ALGUN EJEMPLO COMO HIZO EL RESTO CON EL TEMA DE LAS COMPARACIONES, QUE DEVUELVEN?
eval m (Op2 Lt a b) 
	| evalError m  == True = (m, (Num 0))
	| (snd (eval m a)) < (snd (eval m b)) = (m, Num 1)
	| otherwise = (m, Num 0)
	
eval m (Op2 Gt a b) 
	| evalError m  == True = (m, (Num 0))
	| (snd (eval m a)) > (snd (eval m b)) = (m, Num 1)
	| otherwise = (m, Num 0)
	
eval m (Op2 Le a b)
	| evalError m  == True = (m, (Num 0))
	| (snd (eval m a)) <= (snd (eval m b)) = (m, Num 1)
	| otherwise = (m, Num 0)
	
eval m (Op2 Ge a b) 
	| evalError m  == True = (m, (Num 0))
	| (snd (eval m a)) >= (snd (eval m b)) = (m, Num 1)
	| otherwise = (m, Num 0)

eval m (Op2 Ne a b) 
	| evalError m  == True = (m, (Num 0))
	| (snd (eval m a)) /= (snd (eval m b)) = (m, Num 1)
	| otherwise = (m, Num 0)

eval m (Op2 Equal a b) 
	| evalError m  == True = (m, (Num 0))
	| (snd (eval m a)) == (snd (eval m b)) = (m, Num 1)
	| otherwise = (m, Num 0)

eval m (Op2 And a b)
	| evalError m  == True = (m, (Num 0))
	| (toBool (snd (eval m a))) && (toBool (snd (eval m b))) = (m, Num 1)
	| otherwise = (m, Num 0)

eval m (Op2 Or a b)
	| evalError m  == True = (m, (Num 0))
	| (toBool (snd (eval m a))) || (toBool (snd (eval m b))) = (m, Num 1)
	| otherwise = (m, Num 0)
	
eval m (Op2 Concat a b) 
	| evalError m  == True = (m, (Num 0))
	| otherwise = (m,  Str (concat [show (snd (eval m a)), show (snd (eval m b))]))

-- DEFINIMOS LAS EXPRESIONES DE LAS OPERACIONES UN PARAMETRO -----------------------------------------------------------------
eval m (Op1 Plus a) 
	| evalError m  == True = (m, (Num 0))
	| otherwise = (m, snd (eval m a))

eval m (Op1 Minus a) 
	| evalError m  == True = (m, (Num 0))
	| otherwise = (m, ((snd (eval m a)) * (-1)))

eval m (Op1 Not a)
	| evalError m  == True = (m, (Num 0))
	| toBool (snd (eval m a)) == False = (m, Num 1)
	| otherwise = (m, Num 0)	
-- eval (Map.fromList [("$1", "10")]) (Op1 Not (Op2 Gt (Var "$1") (Lit (Num 1))))
-- eval (Map.fromList [("$1", "10")]) (Op1 Not (Op2 Lt (Var "$1") (Lit (Num 1))))

-- DEFINIMOS LAS ASIGNACIONES DE VARIABLES -----------------------------------------------------------------------------------
eval m (Assign s a) 
	| evalError m  == True = (m, (Num 0))
	| otherwise = (Map.insert s (show (snd (eval m a))) m, snd (eval m a))

-- DEFINIMOS LAS ACUMULACIONES -----------------------------------------------------------------------------------------------
eval m (Accum b s a) 
	| evalError m  == True = (m, (Num 0))
	| otherwise = ((Map.insert s (show (snd (eval m (Op2 b (Var s) a)))) m), (snd (eval m (Op2 b (Var s) a))))
-- eval (Map.fromList [("$1", "10")]) (Accum Add "$1" (Lit (Num 1))) // Deberia Guardar 11 y devolver 11

-- DEFINIMOS LAS PP ----------------------------------------------------------------------------------------------------------
eval m (PP True True s) 
	| evalError m  == True = (m, (Num 0)) 
	| otherwise = (Map.insert s (show (snd (eval m (Op2 Add (Var s) (Lit 1))))) m, snd (eval m (Op2 Add (Var s) (Lit 1))))
	
eval m (PP False True s) 
	| evalError m  == True = (m, (Num 0))
	| otherwise =  (Map.insert s (show (snd (eval m (Op2 Add (Var s) (Lit 1))))) m, snd (eval m (Var s)))
	
eval m (PP True False s) 
	| evalError m  == True = (m, (Num 0))
	| otherwise = (Map.insert s (show (snd (eval m (Op2 Add (Var s) (Lit (-1)))))) m, snd (eval m (Op2 Add (Var s) (Lit (-1)))))
	
eval m (PP False False s) 
	| evalError m  == True = (m, (Num 0))
	| otherwise =  (Map.insert s (show (snd (eval m (Op2 Add (Var s) (Lit (-1)))))) m, snd (eval m (Var s)))
-- eval (Map.fromList [("$1", "10")]) (PP False False "$1") // Deberia guardar 9 y devolver 10


	
-- PRUEBAS ...............................................................
-- eval (Map.fromList [("1", "Pepito")]) (Op2 Equal (Lit (Str "")) (Lit ( Str ""))) 
-- eval (Map.fromList [("1", "Pepito")]) (Op2 Equal (Var "1") (Lit ( Str "Pepito")))

-- *Eval> eval (Map.fromList [("1", "Pepito")]) (Lit 1) // ([("1","Pepito")],1)
-- *Eval> eval (Map.fromList [("1", "Pepito")]) (Var "1") // ([("1","Pepito")],Pepito)


toString :: Maybe String -> String
toString maybeValue = case maybeValue of
  Just value -> value
  Nothing    -> ""
  
evalError :: Map String String -> Bool
evalError m = Map.member "errorFlag" m 
