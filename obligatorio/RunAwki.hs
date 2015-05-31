module RunAwki(runAwki) where

import AwkiSA
import Memoria

import Data.Map (Map)
import qualified Data.Map as Map

import Parser
import Eval
import Execute

runAwki :: AwkiProg -> String -> String
runAwki awkiProg entrada = 
	let 
	memoria = Map.fromList [("NR",show 0),("NF",show 0),("-3",show 0)] -- Inicializo la memoria 
	lineas = lines entrada -- Tomo la entrada y la separo por lineas
	--awkiProgOrdenado = ordenarAwkiProg awkiProg 	-- Ordeno el AwkiProg (BEGIN's al ppio, END's al final y el resto en el medio) - NO TIENE MUCHO SENTIDO AHORA
	awpBEGIN = AwkiProg ( (filter esBegin (awkiProgToList awkiProg)))	-- BEGIN
	resBEGIN = procesarBeginsEnds awpBEGIN ("") memoria
	awpEXPR = AwkiProg ( (filter esExpr (awkiProgToList awkiProg)))	-- EXPR
	resEXPR = procesarLinea awpEXPR (snd resBEGIN) lineas 0 (fst resBEGIN)
	awpEND = AwkiProg ( (filter esEnd (awkiProgToList awkiProg))) -- END

	-- Borro el exit
	memSinExit = Map.delete "-2" (fst resEXPR)

	resEND = procesarBeginsEnds awpEND (snd resEXPR) memSinExit -- END
	in (snd resEND)

----
-- procesarBeginsEnds
----
procesarBeginsEnds :: AwkiProg -> String -> Map String String -> (Map String String,String)
procesarBeginsEnds awp salida memoria =
		let 
		listaPatronAccion = awkiProgToList awp
		in if (not(Map.member "-1" memoria)) then
			-- let res = ejecutarPatronStatement memoria linea salida (Pat (Lit 1),Sequence [Print [Field (Lit 0)]]) -- TODO !!!!!!! CORREGIR ESTO PARA QUE RECORRA TODO EL PROGRAMA
				recorrerPatronStatement memoria "" listaPatronAccion salida
			else
				(memoria,salida)
----
-- END procesarBeginsEnd
----

-- 
procesarLinea :: AwkiProg -> String -> [String] -> Int -> Map String String -> (Map String String,String)
procesarLinea awp salida lineas indice memoria 
	| (indice >= (length lineas)) = (memoria, salida)
	| (Map.member "-2" memoria) = (memoria,salida) -- Si hay un exit no sigo procesando las lineas 
	| otherwise = 
		let
		linea = (lineas !! indice) 
		campos = words linea
		nr = indice
  		nf = length campos
  
  		duplaMemoriaNfAnterior = aux3 memoria 
  		memoria1 = duplaMemoriaNfAnterior
  		nfAnterior = show nf	

		memoriaConCampos = agregarVariablesCampos campos 1  memoria1
		memoria2 = memoriaConCampos 

		memoriaAux = Map.insert "0" (linea) memoria2
		memoria3 = memoriaAux -- Como forzar haskel :S

  		-- El -3 guarda la linea anterior
  		-- let varAutomaticas = [("NR",show indice),("NF",show (length (words linea))),("-3",nfAnterior),("0",linea)]

  		-- actualizo nr y nf y -3
  		indiceInc = indice + 1 
  		memoriaNR = Map.insert "NR" (show indiceInc) memoria3
  		memoriaNF = Map.insert "NF" (show (length (words linea))) memoriaNR
  		memoriaMenos3 = Map.insert "-3" nfAnterior memoriaNF
  		memoria4 = Map.insert "0" linea memoriaMenos3

		
		listaPatronAccion = awkiProgToList awp
		in if (not(Map.member "-1" memoria4)) then			
			-- let res = ejecutarPatronStatement memoria linea salida (Pat (Lit 1),Sequence [Print [Field (Lit 0)]]) -- TODO !!!!!!! CORREGIR ESTO PARA QUE RECORRA TODO EL PROGRAMA
			let 
			res = recorrerPatronStatement memoria4 linea listaPatronAccion (salida)
			in if (Map.member "-1" (fst res)) then
		--		-- ERROR
					(fst res,(snd res))
				else
					let indiceInc = indice + 1 
					in procesarLinea awp (snd res) lineas indiceInc (fst res)
				-- (memoria,salida ++ "#2.5#")
			else
				(memoria4,salida)



agregarVariablesCampos :: [String] -> Int -> Map String String -> Map String String
agregarVariablesCampos [] _ memoria = memoria
agregarVariablesCampos (x:xs) indice memoria = do
	let indiceInc = indice + 1
	Map.insert (show indice) x (agregarVariablesCampos xs indiceInc memoria )


recorrerPatronStatement :: Map String String -> String -> [(Patron,Statement)] -> String -> (Map String String, String)
recorrerPatronStatement memoria linea awkiList salida 
	| evalError memoria  == True = (memoria, salida)
	| length awkiList > 1 = 
			let dupla =  ejecutarPatronStatement memoria linea salida (head awkiList)
			in 
				if (evalError (fst dupla) == True) then 
					dupla
				else
					recorrerPatronStatement (fst dupla) linea (tail awkiList) (snd dupla)	
	| length awkiList == 1 = ejecutarPatronStatement memoria linea salida (head awkiList)
	| length awkiList == 0 = (memoria,salida)



ejecutarPatronStatement :: Map String String -> String -> String -> (Patron,Statement) -> (Map String String,String)
ejecutarPatronStatement memoria linea salida (BEGIN,st) = 
	if ((Map.member "-1" memoria) || (Map.member "-2" memoria)) then
		(memoria,salida)
	else
		(execute memoria st (salida))
ejecutarPatronStatement memoria linea salida (END,st) =  
	if ((Map.member "-1" memoria)  || (Map.member "-2" memoria)) then -- TODO NO ESTA ESPECIFICADO EN LA LETRA SI HAY UN exit EN LA SECCION END
		(memoria,salida)
	else
		(execute memoria st (salida))

ejecutarPatronStatement memoria linea salida (Pat e,st) =
	let 
	dupla = eval memoria e -- -> (Map String String, Valor)
	resExpr = toBool (snd dupla)
	
	in 
	-- SI HAY ERROR PREGUNTANDO POR LA FLAG LO AGREGO AL STRING DE SALIDA
	if (Map.member "-1" (fst dupla)) then
		(fst dupla, salida ++ ( (fst dupla) Map.! "-1"))
	else if (Map.member "-2" (fst dupla)) then -- Me fijo si hay un exit
		(fst dupla, salida) 
	else 
		if (resExpr == True) then
			-- EJECUTAR STATEMENT linea
			(execute (fst dupla) st (salida) ) 
			-- (fst t1,(snd t1) ++ "#7.5#")
		else
			(fst dupla,salida)
	

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

esBegin :: (Patron,Statement) -> Bool
esBegin (a,b) = (a == BEGIN)

esExpr :: (Patron,Statement) -> Bool
esExpr (a,b) = (a /= BEGIN && a /= END)

esEnd :: (Patron,Statement) -> Bool
esEnd (a,b) = (a == END)

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

