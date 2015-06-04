cd ..
# clean
rm awki
rm *.o
rm *.hi

# build
ghc -o awki Awki.hs

cd correccion/

../awki "$(cat 1.awk)" < 1.txt > mi_salida1.txt
../awki "$(cat 2.awk)" < 2.txt > mi_salida2.txt
../awki "$(cat 3.awk)" < 3.txt > mi_salida3.txt
../awki "$(cat 4.awk)" < 4.txt > mi_salida4.txt
../awki "$(cat 5.awk)" < 5.txt > mi_salida5.txt
../awki "$(cat 6.awk)" < 6.txt > mi_salida6.txt
../awki "$(cat 7.awk)" < 7.txt > mi_salida7.txt
../awki "$(cat 8.awk)" < 8.txt > mi_salida8.txt
../awki "$(cat 9.awk)" < 9.txt > mi_salida9.txt
../awki "$(cat 10.awk)" < 10.txt > mi_salida10.txt


echo "** TEST 1"
diff -b -E mi_salida1.txt s1.txt
echo "** TEST 2"
diff -b -E mi_salida2.txt s2.txt
echo "** TEST 3"
diff -b -E mi_salida3.txt s3.txt
echo "** TEST 4"
diff -b -E mi_salida4.txt s4.txt
echo "** TEST 5"
diff -b -E mi_salida5.txt s5.txt
echo "** TEST 6"
diff -b -E mi_salida6.txt s6.txt
echo "** TEST 7"
diff -b -E mi_salida7.txt s7.txt
echo "** TEST 8"
diff -b -E mi_salida8.txt s8.txt
echo "** TEST 9"
diff -b -E mi_salida9.txt s9.txt
echo "** TEST 10"
diff -b -E mi_salida10.txt s10.txt
