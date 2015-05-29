module Execute (execute) where

import AwkiSA
import Data.Map (Map)
import qualified Data.Map as Map
import Data.Maybe 
import Eval

-- La funcion de este modulo es ejecutar un statement con cierta memoria y devolver la memoria eventualemnte
-- modificada y la salida acumulada.

execute :: Map String String -> Statement -> String -> (Map String String, String)

-- Empty
execute m Empty s
	| evalError m  == True = (m, s)
	| otherwise = (m, s)

-- Simple Expr
execute m (Simple a) s
	| evalError m  == True = (m, s)
	| otherwise = (fst (eval m a), s)

-- Print [Expr]
execute m (Print l) s
	| evalError m  == True = (m, s)
	| length l > 1 = execute (fst (eval m (head l))) (Print (tail l)) (s ++ (show (snd (eval m (head l)))) ++ "\t")  
	| otherwise = (fst (eval m (head l)), s ++ (show (snd (eval m (head l)))) ++ "\n")  
	-- EL PRINT SI HAY UN ERRROR EN UNA DE LAS EXPRESIONES NO DEBE IMPRIMIR NINGUNA.
				  
				  

	
	
	


	
toString :: Maybe String -> String
toString maybeValue = case maybeValue of
  Just value -> value
  Nothing    -> ""
  
evalError :: Map String String -> Bool
evalError m = Map.member "errorFlag" m 