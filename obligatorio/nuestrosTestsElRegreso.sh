# clean
rm awki
rm *.o
rm *.hi

# build
ghc -o awki Awki.hs

# run tests

# operaciones basicas y acumuladores
progs[0]='BEGIN { a = 5; b = 4; c = 7; t = a + b * c; print t + 2 }'
progs[1]='BEGIN { a = 10; b = 60; c = b - a; print c / 2 }'
progs[2]='BEGIN { a = 40; b = 21; b += a; z = 90; z -= b }; END { print a; print b; print z }'
progs[3]='BEGIN { a = 2; b = 50; b /= a; z = 100; z %= b }; END { print a; print b; print z }'
progs[4]='BEGIN { k += 5; e -= 8; t /= 8; w %= 50; print k; print e; print t; print w }; END {print k; print e; print t; print w}'
progs[5]='BEGIN { a = 25 + 80 - 10 * 2 / 2; print a }; END {a += 5; print a; print pe}'
# == !=
progs[6]='BEGIN { if (1 == 1) {print "ok"} else {print "fail";}}'
progs[7]='BEGIN { if (1 != 1) {print "fail"} else {print "ok";}}'
progs[8]='BEGIN { if (4 != 5) {print "ok"} else {print "fail";}}'
progs[9]='BEGIN { if (4 == 5) {print "fail"} else {print "ok";}}'
progs[10]='BEGIN { if (4 == 28) {print "fail"} else {print "ok";}}'
# > >=
progs[11]='BEGIN { if (1 >= 1) {print "ok"} else {print "fail";}}'
progs[12]='BEGIN { if (1 >= 2) {print "fail"} else {print "ok";}}'
progs[13]='BEGIN { if (2 >= 1) {print "ok"} else {print "fail";}}'
progs[14]='BEGIN { if (4 > 5) {print "fail"} else {print "ok";}}'
progs[15]='BEGIN { if (4 > 4) {print "fail"} else {print "ok";}}'
progs[16]='BEGIN { if (5 > 4) {print "ok"} else {print "fail";}}'
# < <=
progs[17]='BEGIN { if (1 <= 1) {print "ok"} else {print "fail";}}'
progs[18]='BEGIN { if (2 <= 1) {print "fail"} else {print "ok";}}'
progs[19]='BEGIN { if (1 <= 2) {print "ok"} else {print "fail";}}'
progs[20]='BEGIN { if (5 < 4) {print "fail"} else {print "ok";}}'
progs[21]='BEGIN { if (4 < 4) {print "fail"} else {print "ok";}}'
progs[22]='BEGIN { if (4 < 5) {print "ok"} else {print "fail";}}'

progs[23]='BEGIN { a = 25 + 10; b = 450}; END {if (b < a) {print "fail"} else {print "ok";}}'
progs[24]='BEGIN { if (a == a) {print "ok"} else {print "fail";}}'

#progs[25]='BEGIN { for (i = 1; i <= 20; i++) total += 2 }; END { print total }'
#progs[26]='BEGIN { for (i = 10; i >= 0; i--) total += 2 }; END { print total }'
#progs[27]='BEGIN { for (i = 1; i <= 5; i++) print "cuerpo for", i }; END { print "fin" }'
# Exit en for
#progs[28]='BEGIN { for (i = 1; i <= 8; i++) {print "cuerpo for", i; if (i == 4) exit} }; END { print "fin" }'
#progs[29]='BEGIN { for (i = 1; 1 == 1; i++) {print "cuerpo for", i; if (i == 4) exit} }; END { print "fin" }'

#progs[30]='BEGIN { i = 1; while (i <= 10) { print "The square of ", i, " is ", i*i; i++ } }'
#progs[31]='BEGIN { i = 10; while (i > 0) { print "The square of ", i, " is ", i*i; i-- } }'
# Exit en while
#progs[32]='BEGIN { i = 10; while (i > 0) { print "The square of ", i, " is ", i*i; i--; if (i == 4) exit } }; END { print "fin" }'
#progs[33]='BEGIN { i = 10; while (1) { print "The square of ", i, " is ", i*i; i--; if (i == 4) exit } }; END { print "fin" }'

progs[34]='END { print $0; print $2; print $3; print $4; print $5; }'
# Orden de los patrones
progs[35]='END { print a }; BEGIN { a = 28 * 2 }; END { print 45 }; 1 == 1 { print "ohhh noo" }; BEGIN { b = a + 2 }; END { print b }; BEGIN { print "Haskell" }'
# Exit en do while
#progs[36]='BEGIN {f = 15; do { if (f == 5) exit; --f } while (f >= 3); print "fin"}; END { print "fin" }'
#progs[37]='BEGIN {f = 15; do { if (f == 5) exit; --f } while (1); print "fin"}; END { print "fin" }'


IFS="" # to avoid spaces messing the array...

for prog in ${progs[@]}
do
  echo "running $prog ..."
  awk "$prog" tests/TestsPyP/sample.txt > tests/TestsPyP/salidas/awk-output.txt
  #echo "running (AWKI) $prog ..."
  cat tests/TestsPyP/sample.txt | ./awki "$prog" > tests/TestsPyP/salidas/awki-output.txt
  diff -b tests/TestsPyP/salidas/awk-output.txt tests/TestsPyP/salidas/awki-output.txt
done

# cleanup
#rm awki-output.txt
#rm awk-output.txt
rm awki
rm *.o
rm *.hi
