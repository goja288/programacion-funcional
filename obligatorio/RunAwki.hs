module RunAwki(runAwki) where

import AwkiSA
import Memoria

import Data.Map (Map)
import qualified Data.Map as Map


runAwki :: AwkiProg -> String -> String
runAwki awkiprog entrada = do


	-- INICIALIZACION
	let m = Map.fromList [("NR",0)]
	let lineas = lines entrada


	-- FIN INICIALIZACION
	let m_aux = runAwkiIter awkiprog (lineas !! 0) m

	-- ORDENAR EL AWIKIPROG (poner los begins y ends en orden)
	
	-- Para cada linea de la entrada ejecutar lo que sigue


		-- FALTA UN LOOP POR LINEA 
		let m = cargarVariablesAutomaticas  entrada (Map.fromList [("g","j")])
		"Me descanzo cristian"  

	-- AwikiProg.Patron
		-- if (typeOf(AwikiProg.Patron p) ==  Expr) {
			-- bool b = eval p m
			-- if (b == true && noError) { 
				-- ejecuta el statement 
			-- }
		-- }
		-- else (typeOf(AwikiProg.Patron p) ==  BEGIN) {
		-- 	VER
		-- }
		-- else (typeOf(AwikiProg.Patron p) ==  END) {
			-- VER 
		-- } 


	-- ANTES DE VOLVER AL LOOP BORRO EL MAP CON CUIDADO, 
		


-- runAwki (AwkiProg [(BEGIN,Empty)]) _ = "ola no es lo mismo que Hola"
-- '{ print }'
-- runAwki ( AwkiProg [(Pat (Lit 1),Sequence [Print [Field (Lit 0)]])] ) a = a -- '{ print }'

-- runAwki _ _ = "a bu"

----
-- runAwki _ =  unlines .  map ("prueba" ++)  . lines
---

-- Devuelve la memoria con NR incrementado
runAwkiIter AwikiProg -> String -> (Map String String) -> (Map String String) 
runAwkiIter awp str m = do

	



cargarVariablesAutomaticas :: String -> Map String String -> Map String String
cargarVariablesAutomaticas str m = do

	let lineas = lines str
  	-- putStrLn "LINEAS: "
  	-- print lineas
  	let campos = map words lineas
  	--	putStrLn "CAMPOS: "
  --		print campos 

	-- Numero de linea 
  	let nr = length lineas
  	--	putStr "NR: "
  	--	print (show nr) 

  	-- Cantidad de campos que tiene la linea
  	let nf = last (map length campos)
  	-- 	putStrLn "NF: "
  	-- 	print (show nf) 
	
	
	Map.fromList [("NF",show nf),("NR",show nr)] 


	-- print "dasd"
	--print varAutomaticas2;

	--let varAutomaticas3 = Map.insert "$1" "esto es una var" (varAutomaticas2) 
	-- print varAutomaticas3


	-- Obtener valor 
	--let valor = Map.lookup "NF" varAutomaticas3

	--putStrLn $ "ESTO es el valor de NF: " ++ (show valor)
