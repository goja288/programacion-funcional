# clean
rm ../awki
rm ../*.o
rm ../*.hi

# build
cd ..
ghc -o awki Awki.hs
cd tests

##############
# Conjunto 1 #
##############

progs[0]='{ print }'
progs[1]='BEGIN { print "NR: ", NR, "NF: ", NF, "$0: ", $0, "$1: ", $1 }; END { print "NR: ", NR, "NF: ", NF, "$0: ", $0, "$1: ", $1 }'
progs[2]='{}'
progs[3]='1 > 0 { print }'
progs[4]='{ if (NF > max) max = NF }; END { print max }'
progs[5]='NF > 0'
progs[6]='{ if (NF > 0) print }'
progs[7]='{ nlines++ }; END { print nlines }'
progs[8]='{ nfields += NF }; END { print nfields }'
progs[9]='{ if (NR > 1) exit; print }; END { print "The end" }'
progs[10]='{ print NR, $0 }'
progs[11]='!(NR >= 5) { for (f=1; f <= 3; ++f) if ($f != "") print $f }'
progs[12]='{ line = $0 }; { print line }'
progs[13]='{ one = 1 }; { lines += one }; END { print lines }'
progs[14]='{ while (i < NF) i++ }; END { print i }'
progs[15]='{ i = 0; while (i < NF) i++ }; { f += i }; END { print f }'
progs[16]='{ print }; END { print "END" }; BEGIN { print "BEGIN" }'
progs[17]='END { print "end 1" }; BEGIN { print "begin 1" }; END { print "end 2" }; BEGIN { print "begin 2" }'

##############
# Conjunto 2 #
##############

progs[20]='END { print "end 1" }; BEGIN { print "begin 1" }; {print "NF-1:", (NF-1)}; END { print "end 2" }; BEGIN { print "begin 2" }'
progs[21]='END { print "end 1" }; BEGIN { print "begin 1" }; {exit}; {print "NF-1:", (NF-1)}; END { print "end 2" }; BEGIN { print "begin 2" }'
progs[22]='END { print "end A" }; BEGIN { print "begin 1" }; { if (NR < NF) exit}; {print "(NF-1) :", (NF-1)}; END { print "end B" }; BEGIN { print "begin 2" }'
progs[23]='END { print "end A" }; BEGIN { print "begin 1" }; { if (NR < NF) exit}; {print "(NF-1) :", (NF-1)}; END { print "end B" }; BEGIN { exit }; BEGIN { print "begin 3" }'
progs[24]='END { exit }; BEGIN { print "begin 1" }; { if (NR < NF) exit}; {print "(NF-1) :", (NF-1)}; END { print "end B" }; BEGIN { exit }; BEGIN { print "begin 3" }'

	#progs[25]='BEGIN { print "Antes de error div"; a = 5; b = 0; c = a / b; print "fail"}; END { print "fail"}'

##############
# Conjunto 3 #
##############

# operaciones basicas y acumuladores
progs[30]='BEGIN { a = 5; b = 4; c = 7; t = a + b * c; print t + 2 }'
progs[31]='BEGIN { a = 10; b = 60; c = b - a; print c / 2 }'
progs[32]='BEGIN { a = 40; b = 21; b += a; z = 90; z -= b }; END { print a; print b; print z }'
progs[33]='BEGIN { a = 2; b = 50; b /= a; z = 100; z %= b }; END { print a; print b; print z }'
progs[34]='BEGIN { k += 5; e -= 8; t /= 8; w %= 50; print k; print e; print t; print w }; END {print k; print e; print t; print w}'
progs[35]='BEGIN { a = 25 + 80 - 10 * 2 / 2; print a }; END {a += 5; print a; print pe}'
# == !=
progs[36]='BEGIN { if (1 == 1) {print "ok"} else {print "fail";}}'
progs[37]='BEGIN { if (1 != 1) {print "fail"} else {print "ok";}}'
progs[38]='BEGIN { if (4 != 5) {print "ok"} else {print "fail";}}'
progs[39]='BEGIN { if (4 == 5) {print "fail"} else {print "ok";}}'
progs[40]='BEGIN { if (4 == 28) {print "fail"} else {print "ok";}}'
# > >=
progs[41]='BEGIN { if (1 >= 1) {print "ok"} else {print "fail";}}'
progs[42]='BEGIN { if (1 >= 2) {print "fail"} else {print "ok";}}'
progs[43]='BEGIN { if (2 >= 1) {print "ok"} else {print "fail";}}'
progs[44]='BEGIN { if (4 > 5) {print "fail"} else {print "ok";}}'
progs[45]='BEGIN { if (4 > 4) {print "fail"} else {print "ok";}}'
progs[46]='BEGIN { if (5 > 4) {print "ok"} else {print "fail";}}'
# < <=
progs[47]='BEGIN { if (1 <= 1) {print "ok"} else {print "fail";}}'
progs[48]='BEGIN { if (2 <= 1) {print "fail"} else {print "ok";}}'
progs[49]='BEGIN { if (1 <= 2) {print "ok"} else {print "fail";}}'
progs[50]='BEGIN { if (5 < 4) {print "fail"} else {print "ok";}}'
progs[51]='BEGIN { if (4 < 4) {print "fail"} else {print "ok";}}'
progs[52]='BEGIN { if (4 < 5) {print "ok"} else {print "fail";}}'

progs[53]='BEGIN { a = 25 + 10; b = 450}; END {if (b < a) {print "fail"} else {print "ok";}}'
progs[54]='BEGIN { if (a == a) {print "ok"} else {print "fail";}}'

progs[55]='BEGIN { for (i = 1; i <= 20; i++) total += 2 }; END { print total }'
progs[56]='BEGIN { for (i = 10; i >= 0; i--) total += 2 }; END { print total }'
progs[57]='BEGIN { for (i = 1; i <= 5; i++) print "cuerpo for", i }; END { print "fin" }'
# Exit en for
progs[58]='BEGIN { for (i = 1; i <= 8; i++) {print "cuerpo for", i; if (i == 4) exit} }; END { print "fin" }'
progs[59]='BEGIN { for (i = 1; 1 == 1; i++) {print "cuerpo for", i; if (i == 4) exit} }; END { print "fin" }'

progs[60]='BEGIN { i = 1; while (i <= 10) { print "The square of ", i, " is ", i*i; i++ } }'
progs[61]='BEGIN { i = 10; while (i > 0) { print "The square of ", i, " is ", i*i; i-- } }'
# Exit en while
progs[62]='BEGIN { i = 10; while (i > 0) { print "The square of ", i, " is ", i*i; i--; if (i == 4) exit } }; END { print "fin" }'
progs[63]='BEGIN { i = 10; while (1) { print "The square of ", i, " is ", i*i; i--; if (i == 4) exit } }; END { print "fin" }'

progs[64]='END { print $0; print $2; print $3; print $4; print $5; }'
# Orden de los patrones
progs[65]='END { print a }; BEGIN { a = 28 * 2 }; END { print 45 }; 1 == 1 { print "ohhh noo" }; BEGIN { b = a + 2 }; END { print b }; BEGIN { print "Haskell" }'
# Exit en do while
#progs[36]='BEGIN {f = 15; do { if (f == 5) exit; --f } while (f >= 3); print "fin"}; END { print "fin" }'
#progs[37]='BEGIN {f = 15; do { if (f == 5) exit; --f } while (1); print "fin"}; END { print "fin" }'

##############
# Conjunto 4 #
##############

#progs[80]='(NR >= 5) { f = 1; do { if ($f != "") print $f; ++f } while (f <= 3) }'
# progs[81]='(NR <= 5) { f = 1; do { if ($f != "") print $f; ++f } while (f <= 3) }'
# progs[82]='(NR >= 5) { f = 1; do { if ($f == "") print $f; ++f } while (f <= 3) }'
# progs[83]='(NR >= 5) { f = 1; do { if ($f != "") print f; ++f } while (f <= 3) }'
# progs[84]='(NR >= 5) { f = 1; do { if ($f != "") print $f; f++ } while (f <= 3) }'
# progs[85]='(NR >= 5) { f = 5; do { if ($f != "") print $f; f-- } while (f >= 3) }'
# progs[86]='(NR >= 5) { f = 3; do { if ($f != "") print $f; f-- } while (f >= 0) }'
# progs[87]='(NR >= 5) { f = 5; do { if ($f != "") print $f; --f } while (f >= 3) }'
# progs[88]='(NR >= 5) { f = 5; do { if ($f != "") print f + f; --f } while (f >= 3) }'
# progs[89]='(NR >= 5) { f = 5; do { if ($f != "") print f - f; --f } while (f >= 3) }'
# progs[90]='(NR >= 5) { f = 5; do { if ($f != "") print f * f; --f } while (f >= 3) }'
# progs[91]='(NR >= 5) { f = 5; do { if ($f != "") print f / f; --f } while (f >= 3) }'
# progs[92]='(NR >= 5) { f = 5; do { if ($f != "") print f + f; --f } while (!(f >= 3)) }'
# progs[93]='BEGIN { f = 5; do { if ($f != "") print f + f; --f } while (f >= 3) }; (NR >= 5) { f = 5; do { if ($f != "") print f + f; --f } while (f >= 3) }'
# progs[93]='BEGIN { f = 5; do { if ($f != "") print f + f; --f } while (f >= 3) }; (NR >= 5) { f = 5; do { if ($f != "") print f + f; --f } while (f >= 3) }; END { f = 5; do { if ($f != "") print f + f; --f } while (f >= 3) }; (f = 1) { f = 5; do { if ($f != "") print f + f; --f } while (f >= 3) }'
 progs[94]='BEGIN {if (1>o) {print "hola"} else {print "chau"}}'
 progs[95]='BEGIN {if (a = 1>0) {print a} else {print "chau"}}'
# progs[96]='END { f = 5; do { if ($f != "") print f + f; --f } while (f >= 3) }; (NF > 0) {}; BEGIN { BODY = "YES"; PRINT = "YES"; }; END { if ( BODY == "YES" && PRINT == "YES" ) print $0 }'
# progs[97]='END { f = 5; do { if ($f != "") print f + f; --f } while (f >= 3) }; (NF > 0) {}; BEGIN { BODY = "YES"; PRINT = "YES"; }; END { if ( BODY == "No" && PRINT == "YES" ) print $0 }'
# progs[98]='END { f = 5; do { if ($f != "") print f + f; --f } while (f >= 3) }; (NF > 0) {}; BEGIN { BODY = "YSO"; PRINT = "YES"; }; END { if ( BODY == "YES" && PRINT == "YES" ) print $0 }'
# progs[99]='END { f = 5; do { if ($f != "") print f + f; --f } while (f >= 3) }; (NF > 0) {}; BEGIN { BODY = "YES"; PRINT = "ES"; }; END { if ( BODY == "YES" && PRINT == "YES" ) print $0 }'
# progs[100]='END { exit; f = 5; do { if ($f != "") print f + f; --f } while (f >= 3) }; (NF > 0) {}; BEGIN { BODY = "YES"; PRINT = "YES"; }; END { if ( BODY == "YES" && PRINT == "YES" ) print $0 }'
# progs[101]='END { f = 5; do { if ($f != "") print f + f; --f } while (f >= 3) }; (NF > 0) {exit;}; BEGIN { BODY = "YES"; PRINT = "YES"; }; END { if ( BODY == "YES" && PRINT == "YES" ) print $0 }'
# progs[102]='END { f = 5; do { if ($f != "") print f + f; --f } while (f >= 3) }; BEGIN { BODY = "YES"; PRINT = "YES"; }; END { if ( BODY == "YES" && PRINT == "YES" ) print $0 }'
 progs[103]='{if (NR > 1) exit; print }; END {print "The End" }'
 progs[104]='BEGIN {if (NR > 2) exit; print }; END {print "The End" }'
 progs[105]='(NR > 1) {if (NR > 1) exit; print $1 }; END {print "The End" }'
 progs[106]='END {if (NR > 1) exit; print }; END {print "The End" }'
 progs[107]='BEGIN {if (NF > 1) exit; print }; BEGIN {print "The End" }'
 progs[108]='1 {if (NF > 1) exit; print }; END {print "The End" }'

 progs[109]='{if (NR < 1) exit; print }; END {print "The End" }'
 progs[110]='BEGIN {if (NR < 2) exit; print }; END {print "The End" }'
 progs[111]='(NR < 1) {if (NR < 1) exit; print $1 }; END {print "The End" }'
 progs[112]='END {if (NR < 1) exit; print }; END {print "The End" }'
 progs[113]='BEGIN {if (NF < 1) exit; print }; BEGIN {print "The End" }'
 progs[114]='1 {if (NF < 1) exit; print }; END {print "The End" }'

 progs[115]='{if (NR == 1) exit; print }; END {print "The End" }'
 progs[116]='BEGIN {if (NR == 2) exit; print }; END {print "The End" }'
 progs[117]='(NR == 1) {if (NR == 1) exit; print $1 }; END {print "The End" }'
 progs[118]='END {if (NR == 1) exit; print }; END {print "The End" }'
 progs[119]='BEGIN {if (NF == 1) exit; print }; BEGIN {print "The End" }'
 progs[120]='1 {if (NF == 1) exit; print }; END {print "The End" }'

 progs[121]='{if (NR != 1) exit; print }; END {print "The End" }'
 progs[122]='BEGIN {if (NR != 2) exit; print }; END {print "The End" }'
 progs[123]='(NR != 1) {if (NR != 1) exit; print $1 }; END {print "The End" }'
 progs[124]='END {if (NR != 1) exit; print }; END {print "The End" }'
 progs[125]='BEGIN {if (NF != 1) exit; print }; BEGIN {print "The End" }'
 progs[126]='1 {if (NF != 1) exit; print }; END {print "The End" }'

 progs[127]='{if (NR > -1) exit; print }; END {print "The End" }'
 progs[128]='BEGIN {if (NR > +2) exit; print }; END {print "The End" }'
 progs[129]='(NR > 1) {if (+2 > +2) exit; print $1 }; END {print "The End" }'
 progs[130]='END {if (+2 > -2) exit; print }; END {print "The End" }'
 progs[131]='BEGIN {if (-2 > +2) exit; print }; BEGIN {print "The End" }'
 progs[132]='1 {if (!1) exit; print }; END {print "The End" }'

 progs[133]='BEGIN {if (1) exit; print }; END {print "The End" }'
 progs[134]='BEGIN {if (1) exit; print }; END {exit}'
 progs[135]='BEGIN {if (!1) exit; print }; END {print "The End" }'
 progs[136]='BEGIN {if (!1) exit; print }; END {exit}'
 progs[137]='BEGIN {if (NF == 1) exit; print }; BEGIN {print "The End" }'
 progs[138]='BEGIN { print NF }; BEGIN {print "The End" }'
 progs[139]='BEGIN {if (NR != 2) exit; print }; END {print "The End" }; {}'

# progs[140]='BEGIN {print "\t"}'
 #progs[141]='BEGIN {print "hoa","\t","paa"}'
 #progs[142]='BEGIN { print "\t","hoa","\t" }'
 #progs[143]='BEGIN { print "\t","\t","\t" }'
 #progs[144]='BEGIN { print "\t","\t","hoa" }'
 #progs[145]='BEGIN { print "que pa\tjeje" }'

# progs[146]='BEGIN {print "\n"}'
# progs[147]='BEGIN {print "hoa","\n","paa"}'
# progs[148]='BEGIN { print "\n","hoa","\n" }'
# progs[149]='BEGIN { print "\n","\n","\n" }'
# progs[150]='BEGIN { print "\n","\n","hoa" }'
# progs[151]='BEGIN { print "que pa\njeje" }'


IFS="" # to avoid spaces messing the array...

echo -e "\n############\n# Globales #\n############\n"
for prog in ${progs[@]}
do
	#echo "running $prog ..."
  	
  	awk "$prog" entradas/entrada.txt > salidas/awk-output-testsGlobales.txt
  	cat entradas/entrada.txt | ./../awki "$prog" > salidas/awki-output-testsGlobales.txt
  	diff -b salidas/awk-output-testsGlobales.txt salidas/awki-output-testsGlobales.txt
  	
done
echo -e "\n#######\n# Fin #\n#######\n"

# cleanup
rm salidas/awki-output-testsGlobales.txt
rm salidas/awk-output-testsGlobales.txt
rm ../awki
rm ../*.o
rm ../*.hi


