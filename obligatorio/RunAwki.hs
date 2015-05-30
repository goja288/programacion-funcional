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

	-- Inicializo la memoria 
	let memoria = Map.fromList [("NR",show 0),("NF",show 0),("-3",show 0)]

	-- Tomo la entrada y la separo por lineas
	let lineas = lines entrada

	-- Ordeno el AwkiProg (BEGIN's al ppio, END's al final y el resto en el medio) - NO TIENE MUCHO SENTIDO AHORA
	let awkiProgOrdenado = ordenarAwkiProg awkiProg

	-- BEGIN
	let awpBEGIN = AwkiProg ( (filter esBegin (awkiProgToList awkiProgOrdenado)))
	let resBEGIN = procesarBeginsEnds awpBEGIN ("") memoria

	-- EXPR
	let awpEXPR = AwkiProg ( (filter esExpr (awkiProgToList awkiProgOrdenado)))
	let resEXPR = procesarLinea awpEXPR (snd resBEGIN) lineas 0 (fst resBEGIN)

	-- END
	let awpEND = AwkiProg ( (filter esEnd (awkiProgToList awkiProgOrdenado)))
	let resEND = procesarBeginsEnds awpEND (snd resEXPR) (fst resEXPR) 

	-- Obtenglo los BEGINS


	-- let salida = "ESTA ES LA SALIDA \n"
    
    -- Para cada linea de la entrada {
    	-- Para cada regla (patron,accion) del programa {
        	-- if cumple patron
                -- then ejecutar accion sobre linea
		-- } 
	-- }

	let a = (snd resEND)
	a

----
-- procesarBeginsEnds
----
procesarBeginsEnds :: AwkiProg -> String -> Map String String -> (Map String String,String)
procesarBeginsEnds awp salida memoria = do

		let listaPatronAccion = awkiProgToList awp
		if (not(Map.member "-1" memoria)) then do 			
			-- let res = aux2 memoria linea salida (Pat (Lit 1),Sequence [Print [Field (Lit 0)]]) -- TODO !!!!!!! CORREGIR ESTO PARA QUE RECORRA TODO EL PROGRAMA
			recorrerPatronStatement memoria "" listaPatronAccion salida
		else do
			(memoria,salida)
----
-- END procesarBeginsEnd
----

-- 
procesarLinea :: AwkiProg -> String -> [String] -> Int -> Map String String -> (Map String String,String)
procesarLinea awp salida lineas indice memoria = do

	if (indice < (length lineas)) then do
		
		let linea = (lineas !! indice) 
		let campos = words linea
		let nr = indice
  		let nf = length campos
  
  		let duplaMemoriaNfAnterior = aux3 memoria 
  		let memoria = duplaMemoriaNfAnterior
  		let nfAnterior = show nf	

		let memoriaConCampos = agregarVariablesCampos campos 1  memoria 
		let memoria = memoriaConCampos 

		let memoriaAux = Map.insert "0" (linea) memoria
		let memoria = memoriaAux -- Como forzar haskel :S

  		-- El -3 guarda la linea anterior
  		-- let varAutomaticas = [("NR",show indice),("NF",show (length (words linea))),("-3",nfAnterior),("0",linea)]

  		-- actualizo nr y nf y -3
  		let memoriaNR = Map.insert "NR" (show indice) memoria
  		let memoriaNF = Map.insert "NF" (show (length (words linea))) memoriaNR
  		let memoriaMenos3 = Map.insert "-3" nfAnterior memoriaNF
  		let memoria = Map.insert "0" linea memoriaMenos3

		
		let listaPatronAccion = awkiProgToList awp
		if (not(Map.member "-1" memoria)) then do 
			
			-- let res = aux2 memoria linea salida (Pat (Lit 1),Sequence [Print [Field (Lit 0)]]) -- TODO !!!!!!! CORREGIR ESTO PARA QUE RECORRA TODO EL PROGRAMA
			let res = recorrerPatronStatement memoria linea listaPatronAccion salida

			if (Map.member "-1" (fst res)) then do 
		--		-- ERROR
				(fst res,(snd res))
			else do
				let indiceInc = indice + 1 
				procesarLinea awp (snd res) lineas indiceInc (fst res)
				-- (memoria,salida ++ "#2.5#")
		else do
			(memoria,salida)
	else do
		(memoria,salida)


agregarVariablesCampos :: [String] -> Int -> Map String String -> Map String String
agregarVariablesCampos [] _ memoria = memoria
agregarVariablesCampos (x:xs) indice memoria = do
	let indiceInc = indice + 1
	Map.insert (show indice) x (agregarVariablesCampos xs indiceInc memoria )


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
	| length awkiList == 0 = (memoria,salida)
	| otherwise = aux2 memoria linea salida (head awkiList)


aux2 :: Map String String -> String -> String -> (Patron,Statement) -> (Map String String,String)
aux2 memoria linea salida (BEGIN,st) = 
	if (Map.member "-1" memoria) then do
		(memoria,salida)
	else do
		(execute memoria st (salida))
aux2 memoria linea salida (END,st) =  
	if (Map.member "-1" memoria) then do
		(memoria,salida)
	else do
		(execute memoria st (salida))
aux2 memoria linea salida (Pat e,st) = do
	let dupla = eval memoria e -- -> (Map String String, Valor)
	let resExpr = toBool (snd dupla)
	
	-- SI HAY ERROR PREGUNTANDO POR LA FLAG LO AGREGO AL STRING DE SALIDA
	if (Map.member "-1" (fst dupla)) then do
		(fst dupla, salida ++ ( (fst dupla) Map.! "-1"))
	else if (resExpr == True) then do
		-- EJECUTAR STATEMENT linea
		(execute (fst dupla) st (salida) ) 
		-- (fst t1,(snd t1) ++ "#7.5#")
	else do
		(memoria,salida)
	

aux3 :: Map String String -> Map String String
aux3 memoria  
	| (Map.member "-3" memoria) =
		let nfAnterior = memoria Map.! "-3"
		in 
			quitarVariablesPesos (toInt (Str nfAnterior)) memoria
	| otherwise = 
		memoria


quitarVariablesPesos :: Int -> Map String String -> Map String String
quitarVariablesPesos tope memoria  
	| (tope == 0) = memoria 
	| (tope > 1) = do
		let topeAux = tope - 1
		let memoriaAux = Map.delete (show tope) memoria
		quitarVariablesPesos topeAux memoriaAux    
	| otherwise =  Map.delete (show tope) memoria
---------



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

