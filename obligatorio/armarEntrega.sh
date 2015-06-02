rm -rf entrega/
mkdir entrega/
cp Eval.hs entrega/ 
cp Execute.hs entrega/
cp RunAwki.hs entrega/
cd entrega/
tar -czvf TareaFP.tar.gz Eval.hs Execute.hs RunAwki.hs
md5sum * > md5.txt

