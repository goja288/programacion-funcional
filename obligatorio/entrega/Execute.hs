module Execute (execute) where

import AwkiSA
import Data.Map (Map)
import qualified Data.Map as Map
import Data.Maybe 
import Eval

-- La funcion de este modulo es ejecutar un statement con cierta memoria y devolver la memoria eventualemnte
-- modificada y la salida acumulada.

execute :: Map String Valor -> Statement -> String -> (Map String Valor, String)

-- Empty
execute m Empty s = (m, s)

-- Simple Expr
execute m (Simple a) s
	| evalError m  == True = (m, s)
	| evalExit m  == True = (m, s)
	| otherwise = let dupla = eval m a
				in if (evalError (fst dupla)) then 
						(fst dupla, s ++ (show ((fst dupla) Map.! "-1")))
					else
						((fst dupla), s)



-- Print [Expr]
execute m (Print l) s
	| evalError m  == True = (m, s)
	| evalExit m  == True = (m, s)
	| otherwise = let hayError = execute' m (Print l) ""
				in if ((snd hayError) /= "") then
						((fst hayError), s ++ (snd hayError))
					else
						execute'' m (Print l) s



-- Exit
execute m Exit s = let memoria = Map.insert "-2" (Str "Exit") m
				in (memoria, s)



-- Sequence [Statement]
execute m (Sequence l) s
	| evalError m  == True = (m, s)
	| evalExit m  == True = (m, s)
	| length l > 1 = let dupla = execute m (head l) (s)
					in if ((evalError (fst dupla)) || (evalExit (fst dupla))) then
							dupla
						else
							execute (fst dupla) (Sequence (tail l)) (snd dupla)
	| otherwise = execute m (head l) (s)


-- If Expr Statement Statment
execute m (If a st1 st2) s
	| evalError m  == True = (m, s)
	| evalExit m  == True = (m, s)
	| evalError (fst (eval m a)) == True = let dupla = eval m a
										in (fst dupla, s ++ (show ((fst dupla) Map.! "-1")))
	| otherwise = let 
				dupla = eval m a
				in if (((toBool (snd dupla))) == True) then 
						execute (fst dupla) st1	s
					else
						execute (fst dupla) st2 s


-- For Expr Expr Expr Statment
execute m (For a1 a2 a3 st) s
	| evalError m  == True = (m, s) 
	| evalExit m  == True = (m, s)
	| otherwise = let 
				dupla1 = eval m a1
				in if (evalError (fst dupla1)) then
							(fst dupla1, s ++ (show ((fst dupla1) Map.! "-1")))
						else
							execute''' (fst dupla1) a2 a3 st s


-- While Expr Statment
execute m (While a st) s
	| evalError m  == True = (m, s) 
	| evalExit m  == True = (m, s)
	| otherwise = let 
				dupla = eval m a
				in if (evalError (fst dupla)) then
						(fst dupla, s ++ (show ((fst dupla) Map.! "-1")))
					else
						if (toBool (snd dupla)) then
							let 
							result = execute (fst dupla) st s
							in if (evalError (fst result)) then
									result
								else
									if (evalExit (fst result)) then
										result
									else
										execute (fst result) (While a st) (snd result)
						else
							(fst dupla, s)



execute m (DoWhile st a) s
	| evalError m  == True = (m, s) 
	| evalExit m  == True = (m, s)
	| otherwise = let dupla = execute m st s
				in if((evalError (fst dupla))|| (evalExit (fst dupla))) then
						dupla
					else
						let 
						result = eval (fst dupla) a
						in if(evalError (fst result)) then
								(fst result, (snd dupla) ++ (show ((fst result) Map.! "-1")))
							else
								if (toBool (snd result)) then
									execute (fst result) (DoWhile st a) (snd dupla)	
								else 
									(fst result, snd dupla)


--------------------------------------------------------------------------------------------------
-- FUNCIONES AUXILIARES
--------------------------------------------------------------------------------------------------

toString :: Maybe String -> String
toString maybeValue = case maybeValue of
  Just value -> value
  Nothing    -> ""


  
evalError :: Map String Valor -> Bool
evalError m = Map.member "-1" m

evalExit :: Map String Valor -> Bool
evalExit m = Map.member "-2" m 



-- Averigua si se va a dar error al ejecutar la secuencia de expresiones.
execute' :: Map String Valor -> Statement -> String -> (Map String Valor, String)
execute' m (Print l) s
	| s /= "" = (m, s)
	| length l > 1 = let dupla = (eval m (head l))
					in if ((evalError (fst dupla)) == True) then
					 	((fst dupla), (show ((fst dupla) Map.! "-1")))
					else
						execute' (fst dupla) (Print (tail l)) s
	| otherwise = let dupla = (eval m (head l))
				in if ((evalError (fst dupla)) == True) then
						((fst dupla), (show ((fst dupla) Map.! "-1")))
					else 
						((fst dupla), "")


-- Toma una memoria, una lista de expresiones a imprimir y agrega su salida a la salida acumulada
-- PRECONDICION: No puede existir error en la ejecucion de ninguna de las expresiones.s
execute''  :: Map String Valor -> Statement -> String -> (Map String Valor, String)
execute'' m (Print l) s
	| evalError m  == True = (m, s)
	| length l > 1 = let dupla = (eval m (head l)) 
					in execute'' (fst dupla) (Print (tail l)) (s ++ (show (snd dupla)) ++ "\t")  
	| otherwise = let dupla = (eval m (head l)) 
				in (fst dupla, s ++ (show (snd dupla)) ++ "\n")


execute''' :: Map String Valor -> Expr -> Expr -> Statement -> String -> (Map String Valor, String)
execute''' m a2 a3 st s
	| evalError m  == True = (m, s) 
	| otherwise = let dupla1 = eval m a2
				in if (evalError (fst dupla1)) then
						(fst dupla1, s ++ (show ((fst dupla1) Map.! "-1")))
					else
					  	if ((toBool (snd dupla1)) == True) then
					  		let 
					  		body = execute (fst dupla1) st s
					  		inc = eval (fst body) a3
					  		in if (evalError (fst body)) then
					  				body
					  			else
					  				if (evalError (fst inc)) then
					  					(fst inc, (snd body) ++ (show ((fst inc) Map.! "-1")))
					  				else
					  					if (evalExit (fst inc)) then
					  						(fst inc, snd body)
					  					else
					  						execute''' (fst inc) a2 a3 st (snd body)
					  	else
					  		(fst dupla1, s)