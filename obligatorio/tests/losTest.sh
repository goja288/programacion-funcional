# clean
rm ../awki
rm ../*.o
rm ../*.hi

# build
cd ..
ghc -o awki Awki.hs
cd tests

# run tests

progs[0]='{ print $NR, $NF, $0, $1, $2, $3, $4, $(2 - 2) }' 
progs[1]='BEGIN {print a++ , ++b, c--, --d}'
progs[2]='{i = 1; while (i < NF) {acum+=i; i++}; print "La suma es:" , acum}'
progs[3]='{i = 1; while (i < NF) {acum+=i; i++}; print "La suma es:" , acum}'
progs[4]='{for(i=1;i<=5;i++); print "square of", i, "is", i*i}'
progs[5]='{i = 1; while (i <= NF) {acum+= $i;if (i == $i) {exit} else {print i++}}; print "La suma es: ", acum}; END {print $0}'
progs[6]='{do {i+=1; print i} while (i<5)}'
progs[7]='BEGIN {}'
progs[8]='BEGIN {print}'
progs[9]='BEGIN {if (1) {var = 56} else {var = 432}}; END {print var}'
progs[10]='BEGIN {if (0) {var = 56} else {var = 432}}; END {print var}'
progs[11]='BEGIN {while (i<4) {i+=1}}; END {print i}'
progs[12]='BEGIN {do {i+=1} while (i<4)}; END {print i}'
progs[13]='BEGIN {var = 34}; END {print var}'
progs[14]='BEGIN {exit; var = 56}; END {print var}'
progs[15]='1<3 {print $0}'
progs[16]='1<1 {print $0}'
progs[17]='1<0 {print $0}'
progs[18]='1>3 {print $0}'
progs[19]='1>1 {print $0}'
progs[20]='1>0 {print $0}'
progs[21]='1>=3 {print $0}'
progs[22]='1>=1 {print $0}'
progs[23]='1>=0 {print $0}'
progs[24]='1<=3 {print $0}'
progs[25]='1<=1 {print $0}'
progs[26]='1<=0 {print $0}'
progs[27]='1==3 {print $0}'
progs[28]='1==1 {print $0}'
progs[29]='1!=3 {print $0}'
progs[30]='1!=1 {print $0}'
progs[31]='{print 1+(-10)}'
progs[32]='{print 1-(-10)}'
progs[33]='{print 1*(-10)}'
progs[34]='{print 10/(-10)}'
progs[35]='{print 1 % (-10)}'
progs[36]='{var = 5; var+=3  ;print var}'
progs[37]='{var = 5; var-=3  ;print var}'
progs[38]='{var = 5; var*=3  ;print var}'
progs[39]='{var = 6; var/=3;print var}'
progs[40]='{var = 5; var%=3  ;print var}'
progs[41]='{var = 5; var+=var  ;print var}'
progs[42]='{var = 5; var-=var  ;print var}'
progs[43]='{var = 5; var*=var  ;print var}'
progs[44]='{var = 5; var/=var  ;print var}'
progs[45]='{var = 5; var%=var  ;print var}'
progs[46]='{var = 0; var++  ;print var}'
progs[47]='{var = 0; var--  ;print var}'
progs[48]='{var = 0; --var  ;print var}'
progs[49]='{var = 0; ++var  ;print var}'
progs[50]='{var = 0; +var  ; print var}'
progs[51]='{var = 0; -var  ; print var}'
progs[52]='{var = 1; !var  ; print var}; 1{var = 0; !var; print var}'
progs[53]='{var = 1; var2 = 0; var3 = (var && var2)  ; print var3}'
progs[54]='{var = 1; var2 = 1; var3 = (var && var2)  ; print var3}'
progs[55]='{var = 0; var2 = 1; var3 = (var && var2)  ; print var3}'
progs[56]='{var = 0; var2 = 0; var3 = (var && var2)  ; print var3}'
progs[57]='{var = 1; var2 = 0; var3 = (var || var2)  ; print var3}'
progs[58]='{var = 1; var2 = 1; var3 = (var || var2)  ; print var3}'
progs[59]='{var = 0; var2 = 1; var3 = (var || var2)  ; print var3}'
progs[60]='{var = 0; var2 = 0; var3 = (var || var2)  ; print var3}'
progs[61]='BEGIN {x = 5};END {x += (x = 7); print x}' 
progs[62]='BEGIN {x = 5};END {x -= (x = 7); print x}' 
progs[63]='BEGIN {x = 5};END {x *= (x = 7); print x}' 
progs[64]='BEGIN {x = 5};END {x /= (x = 7); print x}' 
progs[65]='BEGIN {x = 5};END {x %= (x = 7); print x}' 
progs[66]='(x = 5) || (x = 7) {print x}'
progs[67]='(x = 0) || (x = 7) {print x}'
progs[68]='(x = 0) && (x = 7) {print x}'
progs[69]='(x = 1) && (x = 7) {print x}'
progs[70]='BEGIN {i = 4; while (i != 5) {i--; print $i}}'
progs[71]='BEGIN {print "Begin"; exit; var = 5}; 1 {var--; print var}; END {print var; exit; print "End"}'
#progs[72]='BEGIN {myVar = 72}; ($3 == 34) && ($4 == 34) {print $1}; ($3 < 87) || ($4 <315) {i = 22; while (i < 550) {print $1; i++}; print myVar; var2 += (517 * ((myVar || 45) + (var && (3 < 7))))}; $1 == "games" {print myVar, var, (mayVar+=(var = var)); var3++}; $1 != "sebarl" {print "blah", "bleh", (5+7),(537-2+3*3)}; 1 {a = 3; while (a<50) {h = 5; do{for(n = h; n<20;n+=3){print a, h, n, $(a*h*n)};h++} while(h<14); a++}}; $2 == "x" {if (var3211) {if (1) {print "blah"} else {print "blehman"}} else { if ("blah") {print "ohyeahman"} else {print "ohnoes!"}}}; END {blahman557 = "SPAMMASTER"; exit}'

# comparacion de strings
progs[153]='{var = "pepe"; var2 = "es"; var3 = (var && var2); print var3 }'
progs[154]='{var = "pepe"; var2 = "es";  var3 = (var && var2)  ; print var3}'
progs[155]='{var = "pepe"; var2 = "es";  var3 = (var && var2)  ; print var3}'
progs[156]='{var = "winnie"; var2 = "winnie"; var3 = (var && var2)  ; print var3}'
progs[160]='{var = "winnie"; var2 = "winnie"; var3 = (var || var2)  ; print var3}'

# % modulo que
progs[161]='{print 1 % (-1)}'
progs[162]='{print 20 % (3)}'
progs[163]='{print 20 % (-3)}'
progs[164]='{print -20 % (3)}'
progs[165]='{print -20 % (-3)}'


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
