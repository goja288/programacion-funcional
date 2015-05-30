module RunAwki(runAwki) where

import AwkiSA
import Memoria

import Data.Map (Map)
import qualified Data.Map as Map

import Parser
import Eval
import Execute

runAwki :: AwkiProg -> String -> String
runAwki awkiProg entrada = do

	-- Tomo la entrada y la separo por lineas
	let lineas = lines entrada

	-- Ordeno el AwkiProg (BEGIN's al ppio, END's al final y el resto en el medio)
	let awkiProgOrdenado = ordenarAwkiProg awkiProg

	-- Inicializo la memoria 
	let memoria = Map.fromList [("NR",show 0),("NF",show 0),("0"," ESTO ES LO QUE ESTA EN EL LUGAR 0")]

	-- let salida = "ESTA ES LA SALIDA \n"
    
    -- Para cada linea de la entrada {
    	-- Para cada regla (patron,accion) del programa {
        	-- if cumple patron
                -- then ejecutar accion sobre linea
		-- } 
	-- }
	let res = procesarLinea awkiProgOrdenado "#1#" lineas 0 memoria

	let a = (snd res)
	a
	

-- 
procesarLinea :: AwkiProg -> String -> [String] -> Int -> Map String String -> (Map String String,String)
procesarLinea awp salida lineas indice memoria = do
	
	if (indice < (length lineas)) then do
		
		let linea = (lineas !! indice) 
		let listaPatronAccion = awkiProgToList awp
		if (not(Map.member "-1" memoria)) then do 
			
			-- let res = aux2 memoria linea salida (Pat (Lit 1),Sequence [Print [Field (Lit 0)]]) -- TODO !!!!!!! CORREGIR ESTO PARA QUE RECORRA TODO EL PROGRAMA
			let res = recorrerPatronStatement memoria linea listaPatronAccion salida

			if (Map.member "-1" (fst res)) then do 
		--		-- ERROR
				(fst res,(snd res) ++ "#2#")
			else do
				let indiceInc = indice + 1 
				procesarLinea awp (snd res) lineas indiceInc (fst res)
				-- (memoria,salida ++ "#2.5#")
		else do
			(memoria,salida ++ "#3#")
	else do
		(memoria,salida ++ "#4#")


recorrerPatronStatement :: Map String String -> String -> [(Patron,Statement)] -> String -> (Map String String, String)
recorrerPatronStatement memoria linea awkiList salida 
	| evalError memoria  == True = (memoria, salida)
	| length awkiList > 1 = 
			let dupla =  aux2 memoria linea salida (head awkiList)
			in 
				if (evalError (fst dupla) == True) then 
					dupla
				else
					recorrerPatronStatement (fst dupla) linea (tail awkiList) (snd dupla)
	| otherwise = aux2 memoria linea salida (head awkiList)


aux2 :: Map String String -> String -> String -> (Patron,Statement) -> (Map String String,String)
aux2 memoria linea salida (BEGIN,st) = (memoria,salida ++ "#5#")
aux2 memoria linea salida (END,st) = (memoria,salida ++ "#6#")
aux2 memoria linea salida (Pat e,st) = do
	let dupla = eval memoria e -- -> (Map String String, Valor)
	let resExpr = toBool (snd dupla)
	
	-- SI HAY ERROR PREGUNTANDO POR LA FLAG LO AGREGO AL STRING DE SALIDA
	if (Map.member "-1" (fst dupla)) then do
		(fst dupla, salida ++ ( (fst dupla) Map.! "-1"))
	else if (resExpr == True) then do
		-- EJECUTAR STATEMENT linea
		(execute (fst dupla) st (salida ++ "#7#") ) 
		-- (fst t1,(snd t1) ++ "#7.5#")
	else do
		(memoria,salida ++ "#8#")
		
		
---------


-- AwkiProg como lista
-- String de entrada
-- Memoria inicial
-- 
-- Devuelve la memoria con NR incrementado
--runAwkiIter :: AwkiProg -> [String] -> Num -> Map String String -> Map String String
--runAwkiIter awp lineas indice m = do
	
--	let awpList = awkiProgToList awp -- Lo paso a lista
--
--	map (aux) 

--	Map.insert "$1" "esto es una var" m 

	-- print varAutomaticas3




-- AwkiProg como lista
-- String de entrada
-- Memoria inicial
-- 
-- Devuelve la memoria con NR incrementado
--runAwkiIter :: [(Patron,Statement)] -> String -> Map String String -> Map String String
--runAwkiIter awp str m = do


--	Map.insert "$1" "esto es una var" m 

--	run 
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
ordenarAwkiProg xs = AwkiProg (( (filter esBegin (awkiProgToList xs))) ++ ( (filter esExpr (awkiProgToList xs))) ++ ( (filter esEnd (awkiProgToList xs))))

esBegin :: (Patron,Statement) -> Bool
esBegin (a,b) = (a == BEGIN)

esExpr :: (Patron,Statement) -> Bool
esExpr (a,b) = (a /= BEGIN && a /= END)

esEnd :: (Patron,Statement) -> Bool
esEnd (a,b) = (a == END)

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



evalError :: Map String String -> Bool
evalError m = Map.member "-1" m 

