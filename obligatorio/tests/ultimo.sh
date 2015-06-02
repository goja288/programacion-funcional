# clean
rm ../awki
rm ../*.o
rm ../*.hi

# build
cd ..
ghc -o awki Awki.hs
cd tests

# run tests

progs[72]='BEGIN {myVar = 72}; ($3 == 34) && ($4 == 34) {print $1}; ($3 < 87) || ($4 <315) {i = 22; while (i < 550) {print $1; i++}; print myVar; var2 += (517 * ((myVar || 45) + (var && (3 < 7))))}; $1 == "games" {print myVar, var, (mayVar+=(var = var)); var3++}; $1 != "sebarl" {print "blah", "bleh", (5+7),(537-2+3*3)}; 1 {a = 3; while (a<50) {h = 5; do{for(n = h; n<20;n+=3){print a, h, n, $(a*h*n)};h++} while(h<14); a++}}; $2 == "x" {if (var3211) {if (1) {print "blah"} else {print "blehman"}} else { if ("blah") {print "ohyeahman"} else {print "ohnoes!"}}}; END {blahman557 = "SPAMMASTER"; exit}'

IFS="" # to avoid spaces messing the array...

for prog in ${progs[@]}
do
  echo "running $prog ..."
  awk "$prog" entradas/ej2.txt > salidas/awk-output-myn.txt
  cat entradas/ej2.txt | ./../awki "$prog" > salidas/awki-output-myn.txt
  diff -b salidas/awk-output-myn.txt salidas/awki-output-myn.txt
done

# cleanup
#rm awki-output.txt
#rm awk-output.txt
rm ../awki
rm ../*.o
rm ../*.hi
