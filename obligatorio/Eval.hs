module Eval (eval) where

import AwkiSA
import Data.Map (Map)
import qualified Data.Map as Map
import Data.Maybe 

-- Este modulo tiene como funcionalidad la evaluacion de una expresion.


eval :: Map String String -> Expr -> (Map String String, Valor)

-- DEFINIMOS LA EVALUACION DE LAS EXPESIONES ATOMICAS ------------------------------------------------------------------------
eval m (Lit v) 
	| evalError m  == True = (m, (Num 0))
	| otherwise = (m, v)

eval m (Var s)
	| evalError m  == True = (m, (Num 0))
	| otherwise = (m, Str (toString (Map.lookup s m))) ----- VER ????????????????????????????????????????????????????????????????????????

-- DEFINIMOS LAS EXPRESIONES DE LAS OPERACIONES DOS PARAMETROS ---------------------------------------------------------------
eval m (Op2 Add a b)
	| evalError m  == True = (m, (Num 0))
	| evalError (fst (eval m a)) == True = eval m a
	| evalError (fst (eval (fst (eval m a)) b)) == True = eval (fst (eval m a)) b
	| otherwise = 
		let 
		dupla1 = eval m a
		dupla2 = eval (fst dupla1) b
		in (fst dupla2, (snd dupla1) + (snd dupla2))

eval m (Op2 Sub a b) 
	| evalError m  == True = (m, (Num 0)) 
	| evalError (fst (eval m a)) == True = eval m a
	| evalError (fst (eval (fst (eval m a)) b)) == True = eval (fst (eval m a)) b
	| otherwise = 
		let 
		dupla1 = eval m a
		dupla2 = eval (fst dupla1) b
		in (fst dupla2, (snd dupla1) - (snd dupla2))

eval m (Op2 Mul a b) 
	| evalError m  == True = (m, (Num 0))
	| evalError (fst (eval m a)) == True = eval m a
	| evalError (fst (eval (fst (eval m a)) b)) == True = eval (fst (eval m a)) b
	| otherwise = 
		let 
		dupla1 = eval m a
		dupla2 = eval (fst dupla1) b
		in (fst dupla2, (snd dupla1) * (snd dupla2))

eval m (Op2 Div a b)
	| evalError m  == True = (m, (Num 0))
	| evalError (fst (eval m a)) == True = eval m a
	| evalError (fst (eval (fst (eval m a)) b)) == True = eval (fst (eval m a)) b
	| (toInt (snd (eval m b))) /= 0 = 
		let 
		dupla1 = eval m a
		dupla2 = eval (fst dupla1) b
		in (fst dupla2, Num (div  (toInt (snd dupla1)) (toInt (snd dupla2))))
	| otherwise = 
		let 
		dupla1 = eval m a
		dupla2 = eval (fst dupla1) b
		in (Map.insert "-1" "Error: Division por 0\n" (fst dupla2), (Num 0))
	
eval m (Op2 Mod a b)
	| evalError m  == True = (m, (Num 0))
	| evalError (fst (eval m a)) == True = eval m a
	| evalError (fst (eval (fst (eval m a)) b)) == True = eval (fst (eval m a)) b	
	| (toInt (snd (eval m b))) /= 0 = 
		let 
		dupla1 = eval m a
		dupla2 = eval (fst dupla1) b
		in if (toBool (snd (eval (fst dupla2) (Op2 Lt (Lit (snd dupla2)) (Lit 0))))) then
		  		(fst dupla2, Num (mod  (toInt (snd dupla1)) (-1 * (toInt (snd dupla2)))))
		  	else
		  		(fst dupla2, Num (mod  (toInt (snd dupla1)) (toInt (snd dupla2))))
	| otherwise = 
		let 
		dupla1 = eval m a
		dupla2 = eval (fst dupla1) b
		in (Map.insert "-1" "Error: Division por 0\n" (fst dupla2), (Num 0))

-- VER ALGUN EJEMPLO COMO HIZO EL RESTO CON EL TEMA DE LAS COMPARACIONES, QUE DEVUELVEN?
eval m (Op2 Lt a b) 
	| evalError m  == True = (m, (Num 0))
	| evalError (fst (eval m a)) == True = eval m a
	| evalError (fst (eval (fst (eval m a)) b)) == True = eval (fst (eval m a)) b
	| (snd (eval m a)) < (snd (eval (fst (eval m a)) b)) = 
		let 
		dupla1 = eval m a
		dupla2 = eval (fst dupla1) b
		in (fst dupla2, Num 1)
	| otherwise =
		let 
		dupla1 = eval m a
		dupla2 = eval (fst dupla1) b
		in (fst dupla2, Num 0)
	
eval m (Op2 Gt a b) 
	| evalError m  == True = (m, (Num 0))
	| evalError (fst (eval m a)) == True = eval m a
	| evalError (fst (eval (fst (eval m a)) b)) == True = eval (fst (eval (fst (eval m a)) a)) b
	| (snd (eval m a)) > (snd (eval (fst (eval m a)) b)) = 
		let 
		dupla1 = eval m a
		dupla2 = eval (fst dupla1) b
		in (fst dupla2, Num 1)
	| otherwise =
		let 
		dupla1 = eval m a
		dupla2 = eval (fst dupla1) b
		in (fst dupla2, Num 0)
	
eval m (Op2 Le a b)
	| evalError m  == True = (m, (Num 0))
	| evalError (fst (eval m a)) == True = eval m a
	| evalError (fst (eval (fst (eval m a)) b)) == True = eval (fst (eval (fst (eval m a)) a)) b
	| (snd (eval m a)) <= (snd (eval (fst (eval m a)) b)) = 
		let 
		dupla1 = eval m a
		dupla2 = eval (fst dupla1) b
		in (fst dupla2, Num 1)
	| otherwise =
		let 
		dupla1 = eval m a
		dupla2 = eval (fst dupla1) b
		in (fst dupla2, Num 0)
	
eval m (Op2 Ge a b) 
	| evalError m  == True = (m, (Num 0))
	| evalError (fst (eval m a)) == True = eval m a
	| evalError (fst (eval (fst (eval m a)) b)) == True = eval (fst (eval (fst (eval m a)) a)) b
	| (snd (eval m a)) >= (snd (eval (fst (eval m a)) b)) = 
		let 
		dupla1 = eval m a
		dupla2 = eval (fst dupla1) b
		in (fst dupla2, Num 1)
	| otherwise =
		let 
		dupla1 = eval m a
		dupla2 = eval (fst dupla1) b
		in (fst dupla2, Num 0)

eval m (Op2 Ne a b) 
	| evalError m  == True = (m, (Num 0))
	| evalError (fst (eval m a)) == True = eval m a
	| evalError (fst (eval (fst (eval m a)) b)) == True = eval (fst (eval m a)) b
	| (snd (eval m a)) /= (snd (eval (fst (eval m a)) b)) = 
		let 
		dupla1 = eval m a
		dupla2 = eval (fst dupla1) b
		in (fst dupla2, Num 1)
	| otherwise =
		let 
		dupla1 = eval m a
		dupla2 = eval (fst dupla1) b
		in (fst dupla2, Num 0)

eval m (Op2 Equal a b) 
	| evalError m  == True = (m, (Num 0))
	| evalError (fst (eval m a)) == True = eval m a
	| evalError (fst (eval (fst (eval m a)) b)) == True = eval (fst (eval m a)) b
	| (snd (eval m a)) == (snd (eval (fst (eval m a)) b)) = 
		let 
		dupla1 = eval m a
		dupla2 = eval (fst dupla1) b
		in (fst dupla2, Num 1)
	| otherwise =
		let 
		dupla1 = eval m a
		dupla2 = eval (fst dupla1) b
		in (fst dupla2, Num 0)

eval m (Op2 And a b)
	| evalError m  == True = (m, (Num 0))
	| evalError (fst (eval m a)) == True = eval m a
	| evalError (fst (eval (fst (eval m a)) b)) == True = eval (fst (eval m a)) b
	| (toIntMb (Str (show (snd (eval m a))))) == Nothing || (toIntMb (Str (show (snd (eval (fst (eval m a)) b))))) == Nothing =
		if ((toBool (snd (eval m a))) && (toBool (snd (eval (fst (eval m a)) b)))) then
			let 
			dupla1 = eval m a
			dupla2 = eval (fst dupla1) b
			in (fst dupla2, Num 1)
		else
			let 
			dupla1 = eval m a
			dupla2 = eval (fst dupla1) b
			in if ((toBool (snd dupla1)) == False) then
					(fst dupla1, Num 0)
				else
					(fst dupla2, Num 0)
	| (toBool (Num (toInt (snd (eval m a)))) && (toBool (Num (toInt (snd (eval (fst (eval m a)) b)))))) = 
		let 
		dupla1 = eval m a
		dupla2 = eval (fst dupla1) b
		in (fst dupla2, Num 1)
	| otherwise =
		let 
		dupla1 = eval m a
		dupla2 = eval (fst dupla1) b
		in if ((toBool (snd dupla1)) == False) then
				(fst dupla1, Num 0)
			else
				(fst dupla2, Num 0)


eval m (Op2 Or a b)
	| evalError m  == True = (m, (Num 0))
	| evalError (fst (eval m a)) == True = eval m a
	| evalError (fst (eval (fst (eval m a)) b)) == True = eval (fst (eval m a)) b	
	| (toIntMb (Str (show (snd (eval m a))))) == Nothing || (toIntMb (Str (show (snd (eval (fst (eval m a)) b))))) == Nothing =
		if ((toBool (snd (eval m a))) || (toBool (snd (eval (fst (eval m a)) b)))) then 
			let 
			dupla1 = eval m a
			dupla2 = eval (fst dupla1) b
			in if ((toBool (snd dupla1)) == True) then
					(fst dupla1, Num 1)
				else
					(fst dupla2, Num 1)
		else
			let 
			dupla1 = eval m a
			dupla2 = eval (fst dupla1) b
			in (fst dupla2, Num 0)
	| (toBool (Num (toInt (snd (eval m a)))) || (toBool (Num (toInt (snd (eval (fst (eval m a)) b)))))) = 
		let 
		dupla1 = eval m a
		dupla2 = eval (fst dupla1) b
		in if ((toBool (snd dupla1)) == True) then
				(fst dupla1, Num 1)
			else
				(fst dupla2, Num 1)
	| otherwise =
		let 
		dupla1 = eval m a
		dupla2 = eval (fst dupla1) b
		in (fst dupla2, Num 0)
	
eval m (Op2 Concat a b) 
	| evalError m  == True = (m, (Num 0))
	| evalError (fst (eval m a)) == True = eval m a
	| evalError (fst (eval m b)) == True = eval (fst (eval m a)) b	
	| otherwise = 
		let 
		dupla1 = eval m a
		dupla2 = eval (fst dupla1) b
		in (fst dupla2, Str (concat [show (snd dupla1), show (snd dupla2)]))

-- DEFINIMOS LAS EXPRESIONES DE LAS OPERACIONES UN PARAMETRO -----------------------------------------------------------------
eval m (Op1 Plus a) 
	| evalError m  == True = (m, (Num 0))
	| otherwise = eval m a

eval m (Op1 Minus a) 
	| evalError m  == True = (m, (Num 0))
	| evalError (fst (eval m a)) == True = eval m a
	| otherwise = (fst (eval m a), ((snd (eval m a)) * (-1)))

eval m (Op1 Not a)
	| evalError m  == True = (m, (Num 0))
	| evalError (fst (eval m a)) == True = eval m a
	| toBool (snd (eval m a)) == False = (fst (eval m a), Num 1)
	| otherwise = (fst (eval m a), Num 0)	
-- eval (Map.fromList [("$1", "10")]) (Op1 Not (Op2 Gt (Var "$1") (Lit (Num 1))))
-- eval (Map.fromList [("$1", "10")]) (Op1 Not (Op2 Lt (Var "$1") (Lit (Num 1))))

-- DEFINIMOS LAS ASIGNACIONES DE VARIABLES -----------------------------------------------------------------------------------
eval m (Assign s a) 
	| evalError m  == True = (m, (Num 0))
	| evalError (fst (eval m a)) == True = eval m a
	| otherwise = let dupla = eval m a
				in if (evalError (fst dupla)) then
					dupla
				else
					(Map.insert s (show (snd dupla)) (fst dupla), snd dupla)

-- DEFINIMOS LAS ACUMULACIONES -----------------------------------------------------------------------------------------------
eval m (Accum b s a) 
	| evalError m  == True = (m, (Num 0))
	| evalError (fst (eval m a)) == True = eval m a
	| otherwise = 
		let dupla1 = eval (fst (eval m a)) (Op2 b (Var s) a)
		in (Map.insert s (show (snd (dupla1))) (fst dupla1), (snd dupla1))
-- eval (Map.fromList [("$1", "10")]) (Accum Add "$1" (Lit (Num 1))) // Deberia Guardar 11 y devolver 11

-- DEFINIMOS LAS PP ----------------------------------------------------------------------------------------------------------
eval m (PP True True s) 
	| evalError m  == True = (m, (Num 0)) 
	| otherwise = 
		let dupla1 = eval m (Op2 Add (Var s) (Lit 1))
		in (Map.insert s (show (snd dupla1)) (fst dupla1), snd dupla1)
	
eval m (PP False True s) 
	| evalError m  == True = (m, (Num 0))
	| otherwise =  
		let dupla1 = eval m (Op2 Add (Var s) (Lit 1)) 
		in (Map.insert s (show (snd dupla1)) (fst dupla1), Num (toInt (snd (eval m (Var s)))))
	
eval m (PP True False s) 
	| evalError m  == True = (m, (Num 0))
	| otherwise = 
		let dupla1 = eval m (Op2 Add (Var s) (Lit (-1)))
		in (Map.insert s (show (snd dupla1)) (fst dupla1), snd dupla1)
	
eval m (PP False False s) 
	| evalError m  == True = (m, (Num 0))
	| otherwise =
		let dupla1 = eval m (Op2 Add (Var s) (Lit (-1)))
		in (Map.insert s (show (snd dupla1)) (fst dupla1), Num (toInt (snd (eval m (Var s)))))
-- eval (Map.fromList [("$1", "10")]) (PP False False "$1") // Deberia guardar 9 y devolver 10

-- DEFINIMOS LA EXPESION "FIELD EXPR" ------------------------------------------------------------------------------------------
eval m (Field a)
	| evalError m  == True = (m, (Num 0))
	| (toBool (snd (eval (fst (eval m a)) (Op2 Lt (Lit (snd (eval m a))) (Lit (Num 0)))))) == True = (Map.insert "-1" ("Error: Variable Negativa\n") (fst (eval (fst (eval m a)) (Op2 Lt (Lit (snd (eval m a))) (Lit 0)))), Num 0)
	| otherwise = (eval (fst (eval m a)) (Var (show (snd (eval m a)))))
	
	
-- PRUEBAS ............................................................................
-- eval (Map.fromList [("1", "Pepito")]) (Op2 Equal (Lit (Str "")) (Lit ( Str ""))) 
-- eval (Map.fromList [("1", "Pepito")]) (Op2 Equal (Var "1") (Lit ( Str "Pepito")))

-- *Eval> eval (Map.fromList [("1", "Pepito")]) (Lit 1) // ([("1","Pepito")],1)
-- *Eval> eval (Map.fromList [("1", "Pepito")]) (Var "1") // ([("1","Pepito")],Pepito)


toString :: Maybe String -> String
toString maybeValue = case maybeValue of
  Just value -> value
  Nothing    -> ""
  
evalError :: Map String String -> Bool
evalError m = Map.member "-1" m 

debugImprimirMemoria :: Map String String -> String
debugImprimirMemoria memoria = "\n\t-------------\n\t" ++ (foldl1 (++) (map (++"\n") (map juntarDupla (Map.toList memoria)))) ++ "\n\t-------------\n"

juntarDupla :: (String, String) -> String
juntarDupla (a,b) = a ++ "\t" ++b