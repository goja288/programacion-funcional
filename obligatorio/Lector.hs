-- module Lector(main) where

import qualified Data.Map as Map
import Memoria
import Data.Char

--- TODO usar el Data.Map

main :: IO ()
main = do
  	contents <- getContents
  
  	let varAutomaticas = newMemoriaLista
  	--let varAux = addElem ("testNombre","testValor") varAutomaticas 
  	
  	--let varAutomaticasAux = Map.fromList [] -- Inicializo el mapa

  
  	-- [("testN","test")]
  	--let r = map (lector varAutomaticasAux) (lines s)
  	--print varAutomaticasAux
  	putStrLn "LINEAS: "
  	let lineas = lines contents
  	print lineas

  	let campos = map words lineas
  	putStrLn "CAMPOS: "
  	print campos 

	-- Numero de linea 
  	let nr = length lineas
  	putStrLn "NR: "
  	print nr 
	-- let varAutomaticas2 = insertarVariable "NR" (show nr) varAutomaticasAux
	--let varAutomaticas2 = insertarVariable "NR" (show nr) varAutomaticasAux
  	--let varAutomaticasAux = varAutomaticas2 


  	-- Cantidad de campos que tiene la linea
  	let nf = last (map length campos)
  	putStrLn "NF: "
  	print nf 
	--let varAutomaticas2 = insertarVariable "NF" (show nf) varAutomaticasAux
	--let varAutomaticasAux = varAutomaticas2
  	
	let varAutomaticas2 = Map.fromList [("NF",show nf),("NR",show nr)] 

	print varAutomaticas2;

	let varAutomaticas3 = Map.insert "$1" "esto es una var" (varAutomaticas2) 
	print varAutomaticas3


	-- Obtener valor 
	let valor = Map.lookup "NF" varAutomaticas3

	putStrLn $ "ESTO es el valor de NF: " ++ (show valor)

  	




-- https://hackage.haskell.org/package/containers-0.4.0.0/docs/Data-Map.html


insertarVariable :: String -> String -> [Memoria] -> [Memoria]
insertarVariable clave valor mem = addElem (newMemoria clave valor) mem


--listaIndice :: [Num a] -> [String] -> [(Num,String)] -> [(Num,String)]
--listaIndice a [] _ = []
--listaIndice a (x:xs) resultado = do 
--	[(a,x)]:listaIndice a++ x xs 


lector :: [Memoria] -> String -> String 
lector mem s =  "hola"



--obtenerCampos :: [String] -> [(String,String)]
--obtenerCampos linea =
--	map word

