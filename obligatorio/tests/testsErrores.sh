# clean
rm ../awki
rm *.o
rm *.hi

# build
cd ..
ghc -o awki Awki.hs
cd tests

# run tests

progs[0]='BEGIN { print "Antes de error div"; a = 5; b = 0; c = a / b; print "fail"}; END { print "fail"}'
progs[1]='BEGIN { print "Antes de error modulo"; a = 10; b = 0; c = a % b; print "fail"}; END { print "fail"}'
progs[2]='BEGIN { print "Antes de error acum div"; a = 40; b = 0; a /= b; z = 90; z -= b; print "fail" }; END { print "fail" }'
progs[3]='BEGIN { print "Antes de error acum modulo"; a = 40; b = 0; a %= b; z = 90; z -= b; print "fail" }; END { print "fail" }'
progs[4]='BEGIN { print "Antes de error $ < 0"; a = $(-1); print "fail" }; END { print "fail" }'
progs[5]='BEGIN { print "Antes de error $ < 0"; a = $(-18); print "fail" }; END { print "fail" }'
# Error en un for
progs[6]='BEGIN { print "Antes de error for"; for (i = 1; i <= 8; i++) { if (i == 4) a = 4/0}; print "fail" }; END { print "fail" }'
progs[7]='BEGIN { print "Antes de error for"; for (i = 1; i <= 8; i++) { if (i == 4) a /= 0}; print "fail" }; END { print "fail" }'
progs[8]='BEGIN { print "Antes de error for"; for (i = 1; i <= 8; i++) { if (i == 4) a %= 0}; print "fail" }; END { print "fail" }'
progs[9]='BEGIN { print "Antes de error for"; for (i = 1; i <= 8; i++) { if (i == 4) a = 4 % 0}; print "fail" }; END { print "fail" }'
progs[10]='BEGIN { print "Antes de error for"; for (i = 1; i <= 8; i++) { if (i == 4) a = $(-90)}; print "fail" }; END { print "fail" }'

# Error en while
 progs[11]='BEGIN { print "Antes de error while"; i = 1; while (i <= 10) { i++; if (i == 4) a = 4/0}; print "fail" }; END { print "fail" }'
 progs[12]='BEGIN { print "Antes de error while"; i = 1; while (i <= 10) {i++;  if (i == 4) a /= 0}; print "fail" }; END { print "fail" }'
 progs[13]='BEGIN { print "Antes de error while"; i = 1; while (i <= 10) {i++;  if (i == 4) a %= 0}; print "fail" }; END { print "fail" }'
 progs[14]='BEGIN { print "Antes de error while"; i = 1; while (i <= 10) {i++;  if (i == 4) a = 4 % 0}; print "fail" }; END { print "fail" }'
 progs[15]='BEGIN { print "Antes de error while"; i = 1; while (i <= 10) {i++;  if (i == 4) a = $(-90)}; print "fail" }; END { print "fail" }'
# Error en do while
 progs[16]='BEGIN { print "Antes de error do while"; i = 1; do { i++; if (i == 4) a = 4/0} while (i <= 10); print "fail" }; END { print "fail" }'
 progs[17]='BEGIN { print "Antes de error do while"; i = 1; do {i++; if (i == 4) a /= 0} while (i <= 10); print "fail" }; END { print "fail" }'
 progs[18]='BEGIN { print "Antes de error do while"; i = 1; do {i++;  if (i == 4) a %= 0} while (i <= 10); print "fail" }; END { print "fail" }'# progs[19]='BEGIN { print "Antes de error do while"; i = 1; do {i++;  if (i == 4) a = 4 % 0} while (i <= 10); print "fail" }; END { print "fail" }'
 progs[20]='BEGIN { print "Antes de error do while"; i = 1; do {i++;  if (i == 4) a = $(-90)} while (i <= 10); print "fail" }; END { print "fail" }'

IFS="" # to avoid spaces messing the array...

echo -e "\n############\n# Test de Errores #\n############\n"
for prog in ${progs[@]}
do
  #echo "running $prog ..."
  #awk "$prog" entrada.txt > awk-output.txt
  #echo "running (AWKI) $prog ..."
  cat entradas/entrada.txt | ./../awki "$prog" > salidas/awki-output-testErrores-parcial.txt
  #cat salidas/awki-output-testErrores.txt salidas/awki-output-testErrores-parcial.txt > salidas/awki-output-testErrores.txt 
  diff -b salidas/awki-output-testErrores.txt salidas/testsErrores.out
done

#cat tests/TestsPyP/salidas/awki-output-cg.txt

# cleanup
#rm salidas/awki-output-testErrores-parcial.txt
rm ../awki
rm ../*.o
rm ../*.hi
