module Memoria where


type Memoria = (String,String)

newMemoria :: String -> String -> String
newMemoria clave valor = (clave,valor)

getClave :: String -> [Memoria] -> String
getClave clave memoria

