module RunAwki(runAwki) where

import AwkiSA
import Memoria

import Data.Map (Map)
import qualified Data.Map as Map



runAwki :: AwkiProg -> String -> String
runAwki awkiprog entrada = do


	-- INICIALIZACION
	let m = Map.fromList [("NR",show 0)]
	let lineas = lines entrada


	-- FIN INICIALIZACION
	let m1 = runAwkiIter awkiprog (lineas !! 0) m

	-- ORDENAR EL AWKIPROG (poner los begins y ends en orden)
	
	-- Para cada linea de la entrada ejecutar lo que sigue


		-- FALTA UN LOOP POR LINEA 
		-- cargarVariablesAutomaticas  entrada (Map.fromList [("g","j")])

	-- imprimirMap m1

	let p1 = AwkiProg [(END,Empty),(BEGIN,Empty),(BEGIN,Empty),(BEGIN,Empty),(Pat (Lit (Num 1)),Empty)]
	let p2 = ordenarAwkiProg p1
	
	let pepe = length (awkiProgToList p2)

	--let abu = BEGIN == BEGIN
	--show abu
	-- "asdasdasd"
	show pepe


--	entrada (putStrLn "awkiprog")



	-- AwkiProg.Patron
		-- if (typeOf(AwkiProg.Patron p) ==  Expr) {
			-- bool b = eval p m
			-- if (b == true && noError) { 
				-- ejecuta el statement 
			-- }
		-- }
		-- else (typeOf(AwkiProg.Patron p) ==  BEGIN) {
		-- 	VER
		-- }
		-- else (typeOf(AwkiProg.Patron p) ==  END) {
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
runAwkiIter :: AwkiProg -> String -> Map String String -> Map String String
runAwkiIter awp str m = Map.insert "$1" "esto es una var" m 
	-- print varAutomaticas3

	



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

imprimirMap :: Map String String -> String
imprimirMap m = foldl1 (++) (map (++"\n") (map juntarDupla (Map.toList m)))

--imprimirABORRAR :: AwkiProg -> String
--imprimirABORRAR (AwkiProg xs) = foldl1 (++) (map juntarDupla2 (xs))

 
--juntarDupla :: (String, String) -> String
-- juntarDupla (a,b) = a ++ "\t" ++b

juntarDupla :: (String, String) -> String
juntarDupla (a,b) = a ++ "\t" ++b


--- VA A RECIBIR UN AWIKIPROG Y DEVUELVE UN AWIKIPROGORDENADO
-- Con los BEGIN AL PRINCIPIO Y 
ordenarAwkiProg :: AwkiProg -> AwkiProg 
--ordenarAwkiProg :: AwkiProg -> [(Patron,Statement)]
ordenarAwkiProg xs = AwkiProg (( (filter f' (awkiProgToList xs))) ++ ( (filter f'' (awkiProgToList xs))) ++ ( (filter f''' (awkiProgToList xs))))

f' :: (Patron,Statement) -> Bool
f' (a,b) = (a == BEGIN)

f'' :: (Patron,Statement) -> Bool
f'' (a,b) = (a /= BEGIN && a /= END)

f''' :: (Patron,Statement) -> Bool
f''' (a,b) = (a == END)

--ordenarAwkiProg (AwkiProg []) = (AwkiProg [])
--ordenarAwkiProg (AwkiProg ((x,y):xs)) 
--	| x == BEGIN = ()(AwkiProg [])
--ordenarAwkiProg (AwkiProg 

-- concat filter las que tienen begin + filter las que no tienen end + filter las que tienen end


awkiProgToList :: AwkiProg -> [(Patron,Statement)]
awkiProgToList (AwkiProg xs ) = xs


patronEq :: Patron -> Patron -> Bool
patronEq BEGIN BEGIN = True
patronEq END END = True
patronEq _ _ = False


instance Eq Patron where
  a == b = patronEq a b
