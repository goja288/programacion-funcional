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
	| otherwise = let dupla = eval m a
				in if (evalError (fst dupla)) then 
						(fst dupla, s ++ ((fst dupla) Map.! "-1"))
					else
						((fst dupla), show (snd dupla))



-- Print [Expr]
-- Test1: execute (Map.fromList [("1","10"), ("2","20")]) (Print [(Lit 1), (Op2 Mod (Lit 2) (Var "2")), (Lit 3)]) ""
--   OUT> (fromList [("1","10"),("2","20")],"1\t2\t3\n")
-- Test2: execute (Map.fromList [("1","10"), ("2","20")]) (Print [(Lit 1), (Op2 Mul (Lit 2) (Var "2")), (Lit 3)]) ""
--   out> (fromList [("1","10"),("2","20")],"1\t40\t3\n") 
-- Test3: *Execute Data.Map> execute (Map.fromList [("1","10"), ("2","20"), ("3", "0")]) (Print [(Lit 1), (Op2 Mod (Lit 2) (Var "3")), (Lit 3)]) ""
--   OUT> (fromList [("1","10"),("2","20"),("3","0")],"awk: cmd. line:1: (FILENAME=- FNR=1) fatal: division by zero attempted\n")
execute m (Print l) s
	| evalError m  == True = (m, s)
	| otherwise = let hayError = execute' m (Print l) ""
				in if ((snd hayError) /= "") then
						(m, s ++ (snd hayError))
					else
						execute'' m (Print l) s



-- Exit
execute m Exit s = let memoria = Map.insert "-2" "Exit" m
				in (memoria, s)



-- Sequence [Statement]
-- Test1: execute (Map.fromList [("1","10"), ("2","20"), ("3", "0")]) (Sequence [(Print [(Lit 1), (Op2 Mod (Lit 2) (Var "3")), (Lit 3)]), (Simple (PP True True "1"))]) ""
--   OUT> (fromList [("1","11"),("2","20"),("3","0")],"awk: cmd. line:1: (FILENAME=- FNR=1) fatal: division by zero attempted\n")
-- Test2: execute (Map.fromList [("1","10"), ("2","20"), ("3", "0")]) (Sequence [(Print [(Lit 1), (Op2 Mul (Lit 2) (Var "3")), (Lit 3)]), (Simple (PP True True "1"))]) ""
--   OUT> (fromList [("1","11"),("2","20"),("3","0")],"1\t0\t3\n")
execute m (Sequence l) s
	| evalError m  == True = (m, s)
	| length l > 1 = let dupla = execute m (head l) s
					in if ((evalError (fst dupla)) || (evalExit (fst dupla))) then -- VER ACA QUE PASA CON EL Exit.
							dupla
						else
							execute (fst dupla) (Sequence (tail l)) (snd dupla)
	| otherwise = execute m (head l) s


-- If Expr Statement Statment
-- Test1: putStrLn (snd (execute (Map.fromList [("1","10"), ("2","20")]) (If (Var "1") (Print [(Lit 1), (Op2 Mod (Lit 2) (Var "2")), (Lit 3)]) (Print (Var "2"))) ""))
--   OUT> 1       2       3
execute m (If a st1 st2) s
	| evalError m  == True = (m, s)
	| evalError (fst (eval m a)) == True = let dupla = eval m a
										in (fst dupla, s ++ ((fst dupla) Map.! "-1"))
	| otherwise = let dupla = eval m a
				in if (toBool (snd dupla)) then 
						execute (fst dupla) st1	s
					else
						execute (fst dupla) st2 s


-- For Expr Expr Expr Statment
-- execute m (For a1 a2 a3 Statment) s
--	| evalError m  == True = (m, s) 
--	| otherwise = let dupla1 = eval m a1
--					  dupla2 = if (evalError (fst dupla1)) then
--					  				(m, s ++ ((fst dupla) Map.! "-1"))



























--------------------------------------------------------------------------------------------------
-- FUNCIONES AUXILIARES
--------------------------------------------------------------------------------------------------

toString :: Maybe String -> String
toString maybeValue = case maybeValue of
  Just value -> value
  Nothing    -> ""


  
evalError :: Map String String -> Bool
evalError m = Map.member "-1" m

evalExit :: Map String String -> Bool
evalExit m = Map.member "-2" m 



-- Averigua si se va a dar error al ejecutar la secuencia de expresiones.
-- Test1: execute' (Map.fromList [("1","10")]) (Print [(Lit 1), (Lit 2), (Lit 3)]) ""
--   OUT> (fromList [("1","10")], "")
-- Test2: execute' (Map.fromList [("1","10")]) (Print [(Lit 1), (Op2 Mod (Lit 2) (Lit 0)), (Lit 3)]) ""
--   OUT> (fromList [("-1","awk: cmd. line:1: (FILENAME=- FNR=1) fatal: division by zero attempted\n"),("1","10")],"awk: cmd. line:1: (FILENAME=- FNR=1) fatal: division by zero attempted\n")
-- Test3: execute' (Map.fromList [("1","10"), ("2","20")]) (Print [(Lit 1), (Op2 Mod (Lit 2) (Var "2")), (Lit 3)]) ""
--   OUT> (fromList [("1","10"),("2","20")],"")
execute' :: Map String String -> Statement -> String -> (Map String String, String)
execute' m (Print l) s
	| s /= "" = (m, s)
	| length l > 1 = let dupla = (eval m (head l))
					in if ((evalError (fst dupla)) == True) then
					 	((fst dupla), (fst dupla) Map.! "-1")
					else
						execute' (fst dupla) (Print (tail l)) s
	| otherwise = let dupla = (eval m (head l))
				in if ((evalError (fst dupla)) == True) then
						((fst dupla), (fst dupla) Map.! "-1'")
					else 
						((fst dupla), "")


-- Toma una memoria, una lista de expresiones a imprimir y agrega su salida a la salida acumulada
-- PRECONDICION: No puede existir error en la ejecucion de ninguna de las expresiones.
-- Test1: 
execute''  :: Map String String -> Statement -> String -> (Map String String, String)
execute'' m (Print l) s
	| evalError m  == True = (m, s)
	| length l > 1 = let dupla = (eval m (head l)) 
					in execute'' (fst dupla) (Print (tail l)) (s ++ (show (snd dupla)) ++ "\t")  
	| otherwise = let dupla = (eval m (head l)) 
				in (fst dupla, s ++ (show (snd dupla)) ++ "\n")


-- execute''' :: Map String String -> Expr -> Expr -> Statment -> String -> (Map String String, String)
-- execute' m a2 a3 st s
--	| evalError m  == True = (m, s) 
--	| otherwise = let dupla1 = eval m a2
--					  dupla2 = if (evalError (fst dupla1)) then
--					  				(m, s ++ ((fst dupla) Map.! "-1"))