# clean
rm awki
rm *.o
rm *.hi

# build
#ghc -o awki Awki.hs

# tests
cd tests
./testsGlobales.sh
cd ..
