-- 4529320 4666259
module RunAwki(runAwki) where

import Data.Map (Map)
import qualified Data.Map as Map

import AwkiSA
import Parser
import Eval
import Execute

runAwki :: AwkiProg -> String -> String
runAwki awkiProg entrada = 
	let 
	memoria = Map.fromList [("NR",Num 0),("NF",Num 0),("-3",Num 0)] -- Inicializo la memoria 
	lineas = lines entrada -- Tomo la entrada y la separo por lineas
	-- BEGIN
	awpBEGIN = AwkiProg ( (filter esBegin (awkiProgToList awkiProg)))	
	resBEGIN = procesarBeginsEnds awpBEGIN ("") memoria

	-- La parte del medio como diria Darwin Debocatti
	awpEXPR = AwkiProg ( (filter esExpr (awkiProgToList awkiProg)))
	resEXPR = procesarLinea awpEXPR (snd resBEGIN) lineas 0 (fst resBEGIN)

	-- Borro de la memoria el exit, asi puedo usarlo en la seccion END
	memSinExit = Map.delete "-2" (fst resEXPR)

	-- END
	awpEND = AwkiProg ( (filter esEnd (awkiProgToList awkiProg))) 

	resEND = procesarBeginsEnds awpEND (snd resEXPR) memSinExit
	
	in ((snd resEND))


procesarBeginsEnds :: AwkiProg -> String -> Map String Valor -> (Map String Valor,String)
procesarBeginsEnds awp salida memoria =
		let 
		listaPatronAccion = awkiProgToList awp
		in if (not(Map.member "-1" memoria)) then
				recorrerPatronStatement memoria "" listaPatronAccion salida
			else
				(memoria,salida)

procesarLinea :: AwkiProg -> String -> [String] -> Int -> Map String Valor -> (Map String Valor,String)
procesarLinea awp salida lineas indice memoria 
	| (indice >= (length lineas)) = (memoria, salida)
	| (Map.member "-2" memoria) = (memoria,salida) -- Si hay un exit no sigo procesando las lineas 
	| otherwise = 
		let
		linea = (lineas !! indice) 
		campos = words linea
		nr = indice
  		nf = length campos
  
  		duplaMemoriaNfAnterior = definirTope memoria 
  		memoria1 = duplaMemoriaNfAnterior
  		nfAnterior = nf	

		memoriaConCampos = agregarVariablesCampos campos 1  memoria1
		memoria2 = memoriaConCampos 

		memoriaAux = Map.insert "0" (Str (linea)) memoria2
		memoria3 = memoriaAux -- Como forzar haskel :S

  		-- actualizo nr y nf y -3
  		indiceInc = indice + 1 
  		memoriaNR = Map.insert "NR" (Num indiceInc) memoria3
  		memoriaNF = Map.insert "NF" (Num (length (words linea))) memoriaNR
  		memoriaMenos3 = Map.insert "-3" (Num nfAnterior) memoriaNF
  		memoria4 = Map.insert "0" (Str linea) memoriaMenos3

		listaPatronAccion = awkiProgToList awp
		in if (not(Map.member "-1" memoria4)) then			
			let 
			res = recorrerPatronStatement memoria4 linea listaPatronAccion (salida)
			in if (Map.member "-1" (fst res)) then
					(fst res, (snd res))
				else
					let indiceInc = indice + 1 
					in procesarLinea awp (snd res) lineas indiceInc (fst res)
			else
				(memoria4,salida)

agregarVariablesCampos :: [String] -> Int -> Map String Valor -> Map String Valor
agregarVariablesCampos [] _ memoria = memoria
agregarVariablesCampos (x:xs) indice memoria = do
	let indiceInc = indice + 1
	Map.insert (show indice) (Str x) (agregarVariablesCampos xs indiceInc memoria )

recorrerPatronStatement :: Map String Valor -> String -> [(Patron,Statement)] -> String -> (Map String Valor, String)
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

ejecutarPatronStatement :: Map String Valor -> String -> String -> (Patron,Statement) -> (Map String Valor,String)
ejecutarPatronStatement memoria linea salida (BEGIN,st) = 
	if ((Map.member "-1" memoria) || (Map.member "-2" memoria)) then
		(memoria,salida)
	else
		(execute memoria st (salida))
ejecutarPatronStatement memoria linea salida (END,st) =  
	if ((Map.member "-1" memoria)  || (Map.member "-2" memoria)) then
		(memoria,salida)
	else
		(execute memoria st (salida))
ejecutarPatronStatement memoria linea salida (Pat e,st) =
	let 
	dupla = eval memoria e
	resExpr = toBool (snd dupla)
	in 
	if (Map.member "-1" (fst dupla)) then
		(fst dupla, salida ++ (show ((fst dupla) Map.! "-1")))
	else if (Map.member "-2" (fst dupla)) then -- Me fijo si hay un exit
		(fst dupla, salida) 
	else 
		if (resExpr == True) then
			(execute (fst dupla) st salida) 
		else
			(fst dupla,salida)
	
definirTope :: Map String Valor -> Map String Valor
definirTope memoria  
	| (Map.member "-3" memoria) =
		let nfAnterior = memoria Map.! "-3"
		in 
			quitarVariablesPesos (toInt (nfAnterior)) memoria
	| otherwise = 
		memoria

quitarVariablesPesos :: Int -> Map String Valor -> Map String Valor
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

evalError :: Map String Valor -> Bool
evalError m = Map.member "-1" m
