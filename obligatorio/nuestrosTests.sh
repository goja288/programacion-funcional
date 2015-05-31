# clean
rm awki
rm *.o
rm *.hi

# build
ghc -o awki Awki.hs

# run tests

#progs[0]='(NR >= 5) { f = 1; do { if ($f != "") print $f; ++f } while (f <= 3) }'
# progs[1]='(NR <= 5) { f = 1; do { if ($f != "") print $f; ++f } while (f <= 3) }'
# progs[2]='(NR >= 5) { f = 1; do { if ($f == "") print $f; ++f } while (f <= 3) }'
# progs[3]='(NR >= 5) { f = 1; do { if ($f != "") print f; ++f } while (f <= 3) }'
# progs[4]='(NR >= 5) { f = 1; do { if ($f != "") print $f; f++ } while (f <= 3) }'
# progs[5]='(NR >= 5) { f = 5; do { if ($f != "") print $f; f-- } while (f >= 3) }'
# progs[6]='(NR >= 5) { f = 3; do { if ($f != "") print $f; f-- } while (f >= 0) }'
# progs[7]='(NR >= 5) { f = 5; do { if ($f != "") print $f; --f } while (f >= 3) }'
# progs[8]='(NR >= 5) { f = 5; do { if ($f != "") print f + f; --f } while (f >= 3) }'
# progs[9]='(NR >= 5) { f = 5; do { if ($f != "") print f - f; --f } while (f >= 3) }'
# progs[10]='(NR >= 5) { f = 5; do { if ($f != "") print f * f; --f } while (f >= 3) }'
# progs[11]='(NR >= 5) { f = 5; do { if ($f != "") print f / f; --f } while (f >= 3) }'
# progs[12]='(NR >= 5) { f = 5; do { if ($f != "") print f + f; --f } while (!(f >= 3)) }'
# progs[13]='BEGIN { f = 5; do { if ($f != "") print f + f; --f } while (f >= 3) }; (NR >= 5) { f = 5; do { if ($f != "") print f + f; --f } while (f >= 3) }'
# progs[13]='BEGIN { f = 5; do { if ($f != "") print f + f; --f } while (f >= 3) }; (NR >= 5) { f = 5; do { if ($f != "") print f + f; --f } while (f >= 3) }; END { f = 5; do { if ($f != "") print f + f; --f } while (f >= 3) }; (f = 1) { f = 5; do { if ($f != "") print f + f; --f } while (f >= 3) }'
 progs[14]='BEGIN {if (1>o) {print "hola"} else {print "chau"}}'
 progs[15]='BEGIN {if (a = 1>0) {print a} else {print "chau"}}'
# progs[16]='END { f = 5; do { if ($f != "") print f + f; --f } while (f >= 3) }; (NF > 0) {}; BEGIN { BODY = "YES"; PRINT = "YES"; }; END { if ( BODY == "YES" && PRINT == "YES" ) print $0 }'
# progs[17]='END { f = 5; do { if ($f != "") print f + f; --f } while (f >= 3) }; (NF > 0) {}; BEGIN { BODY = "YES"; PRINT = "YES"; }; END { if ( BODY == "No" && PRINT == "YES" ) print $0 }'
# progs[18]='END { f = 5; do { if ($f != "") print f + f; --f } while (f >= 3) }; (NF > 0) {}; BEGIN { BODY = "YSO"; PRINT = "YES"; }; END { if ( BODY == "YES" && PRINT == "YES" ) print $0 }'
# progs[19]='END { f = 5; do { if ($f != "") print f + f; --f } while (f >= 3) }; (NF > 0) {}; BEGIN { BODY = "YES"; PRINT = "ES"; }; END { if ( BODY == "YES" && PRINT == "YES" ) print $0 }'
# progs[20]='END { exit; f = 5; do { if ($f != "") print f + f; --f } while (f >= 3) }; (NF > 0) {}; BEGIN { BODY = "YES"; PRINT = "YES"; }; END { if ( BODY == "YES" && PRINT == "YES" ) print $0 }'
# progs[21]='END { f = 5; do { if ($f != "") print f + f; --f } while (f >= 3) }; (NF > 0) {exit;}; BEGIN { BODY = "YES"; PRINT = "YES"; }; END { if ( BODY == "YES" && PRINT == "YES" ) print $0 }'
# progs[22]='END { f = 5; do { if ($f != "") print f + f; --f } while (f >= 3) }; BEGIN { BODY = "YES"; PRINT = "YES"; }; END { if ( BODY == "YES" && PRINT == "YES" ) print $0 }'
 progs[23]='{if (NR > 1) exit; print }; END {print "The End" }'
 progs[24]='BEGIN {if (NR > 2) exit; print }; END {print "The End" }'
 progs[25]='(NR > 1) {if (NR > 1) exit; print $1 }; END {print "The End" }'
 progs[26]='END {if (NR > 1) exit; print }; END {print "The End" }'
 progs[27]='BEGIN {if (NF > 1) exit; print }; BEGIN {print "The End" }'
 progs[28]='1 {if (NF > 1) exit; print }; END {print "The End" }'

 progs[29]='{if (NR < 1) exit; print }; END {print "The End" }'
 progs[30]='BEGIN {if (NR < 2) exit; print }; END {print "The End" }'
 progs[31]='(NR < 1) {if (NR < 1) exit; print $1 }; END {print "The End" }'
 progs[32]='END {if (NR < 1) exit; print }; END {print "The End" }'
 progs[33]='BEGIN {if (NF < 1) exit; print }; BEGIN {print "The End" }'
 progs[34]='1 {if (NF < 1) exit; print }; END {print "The End" }'

 progs[35]='{if (NR == 1) exit; print }; END {print "The End" }'
 progs[36]='BEGIN {if (NR == 2) exit; print }; END {print "The End" }'
 progs[37]='(NR == 1) {if (NR == 1) exit; print $1 }; END {print "The End" }'
 progs[38]='END {if (NR == 1) exit; print }; END {print "The End" }'
 progs[39]='BEGIN {if (NF == 1) exit; print }; BEGIN {print "The End" }'
 progs[40]='1 {if (NF == 1) exit; print }; END {print "The End" }'

 progs[41]='{if (NR != 1) exit; print }; END {print "The End" }'
 progs[42]='BEGIN {if (NR != 2) exit; print }; END {print "The End" }'
 progs[43]='(NR != 1) {if (NR != 1) exit; print $1 }; END {print "The End" }'
 progs[44]='END {if (NR != 1) exit; print }; END {print "The End" }'
 progs[45]='BEGIN {if (NF != 1) exit; print }; BEGIN {print "The End" }'
 progs[46]='1 {if (NF != 1) exit; print }; END {print "The End" }'

 progs[47]='{if (NR > -1) exit; print }; END {print "The End" }'
 progs[48]='BEGIN {if (NR > +2) exit; print }; END {print "The End" }'
 progs[49]='(NR > 1) {if (+2 > +2) exit; print $1 }; END {print "The End" }'
 progs[50]='END {if (+2 > -2) exit; print }; END {print "The End" }'
 progs[51]='BEGIN {if (-2 > +2) exit; print }; BEGIN {print "The End" }'
 progs[52]='1 {if (!1) exit; print }; END {print "The End" }'

 progs[53]='BEGIN {if (1) exit; print }; END {print "The End" }'
 progs[54]='BEGIN {if (1) exit; print }; END {exit}'
 progs[55]='BEGIN {if (!1) exit; print }; END {print "The End" }'
 progs[56]='BEGIN {if (!1) exit; print }; END {exit}'
 progs[57]='BEGIN {if (NF == 1) exit; print }; BEGIN {print "The End" }'
 progs[58]='BEGIN { print NF }; BEGIN {print "The End" }'
 progs[59]='BEGIN {if (NR != 2) exit; print }; END {print "The End" }; {}'

# progs[60]='BEGIN {print "\t"}'
 #progs[61]='BEGIN {print "hoa","\t","paa"}'
 #progs[62]='BEGIN { print "\t","hoa","\t" }'
 #progs[63]='BEGIN { print "\t","\t","\t" }'
 #progs[64]='BEGIN { print "\t","\t","hoa" }'
 #progs[65]='BEGIN { print "que pa\tjeje" }'

# progs[66]='BEGIN {print "\n"}'
# progs[67]='BEGIN {print "hoa","\n","paa"}'
# progs[68]='BEGIN { print "\n","hoa","\n" }'
# progs[69]='BEGIN { print "\n","\n","\n" }'
# progs[70]='BEGIN { print "\n","\n","hoa" }'
# progs[71]='BEGIN { print "que pa\njeje" }'



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
#rm ../tests/TestsPyP/awki-output.txt
#rm ../tests/TestsPyP/awk-output.txt
rm awki
rm *.o
rm *.hi
