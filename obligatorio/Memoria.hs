module Memoria where

import Data.Maybe

type Memoria = (String,String)

newMemoria :: String -> String -> Memoria
newMemoria clave valor = (clave,valor)

newMemoriaLista :: [Memoria]
newMemoriaLista = []

-- TODO hacer el chequeo de errores 
getValor :: String -> [Memoria] -> String
getValor clave memoria = fromJust (lookup clave memoria)

addElem :: Memoria -> [Memoria] -> [Memoria]
addElem mem [] = mem:[]
addElem mem ((x,y):xs)
	| x == fst mem = mem:xs -- Actualizo si existe 
	| xs == [] = (x,y):(mem:xs) -- Agrego si no esta
	| x /= fst mem = (x,y):(addElem mem xs) -- Llamado recursivo
