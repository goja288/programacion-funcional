# clean
rm awki
rm *.o
rm *.hi

# build
ghc -o awki Awki.hs

# run tests

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
#progs[11]='!(NR >= 5) { for (f=1; f <= 3; ++f) if ($f != "") print $f }'
progs[12]='{ line = $0 }; { print line }'
progs[13]='{ one = 1 }; { lines += one }; END { print lines }'
#progs[14]='{ while (i < NF) i++ }; END { print i }'
#progs[15]='{ i = 0; while (i < NF) i++ }; { f += i }; END { print f }'
progs[16]='{ print }; END { print "END" }; BEGIN { print "BEGIN" }'
progs[17]='END { print "end 1" }; BEGIN { print "begin 1" }; END { print "end 2" }; BEGIN { print "begin 2" }'

# Cristian y Gonza
progs[49]='END { print "end 1" }; BEGIN { print "begin 1" }; {print "NF-1:", (NF-1)}; END { print "end 2" }; BEGIN { print "begin 2" }'
## exit
progs[50]='END { print "end 1" }; BEGIN { print "begin 1" }; {exit}; {print "NF-1:", (NF-1)}; END { print "end 2" }; BEGIN { print "begin 2" }'
progs[51]='END { print "end A" }; BEGIN { print "begin 1" }; { if (NR < NF) exit}; {print "(NF-1) :", (NF-1)}; END { print "end B" }; BEGIN { print "begin 2" }'
progs[52]='END { print "end A" }; BEGIN { print "begin 1" }; { if (NR < NF) exit}; {print "(NF-1) :", (NF-1)}; END { print "end B" }; BEGIN { exit }; BEGIN { print "begin 3" }'
progs[53]='END { exit }; BEGIN { print "begin 1" }; { if (NR < NF) exit}; {print "(NF-1) :", (NF-1)}; END { print "end B" }; BEGIN { exit }; BEGIN { print "begin 3" }'


# exit en el begin
# exit en el medio y que queden inst
# exit en el end

IFS="" # to avoid spaces messing the array...

for prog in ${progs[@]}
do
  echo "running $prog ..."
  awk "$prog" tests/sample.txt > salidas/awk-output.txt
  cat tests/sample.txt | ./awki "$prog" > salidas/awki-output.txt
  diff -b salidas/awk-output.txt salidas/awki-output.txt
done

# cleanup
#rm salidas/awki-output.txt
#rm salidas/awk-output.txt
rm awki
rm *.o
rm *.hi
