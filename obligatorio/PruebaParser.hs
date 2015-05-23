module PruebaParser where

import Parser
import AwkiSA


entrada1 :: String
entrada1 = "END { print \"end 1\" }; BEGIN { print \"begin 1\" }; END { print \"end 2\" }; BEGIN { print \"begin 2\" }"

salida1 = tryParse prog entrada1

entrada2 :: String
entrada2 = "END { print \" - DONE 1 -\" }; BEGIN { print \"inicio 1\" };  { print \"\\t\", $2}; { print \"\\t\", $3}; $2 == \"Kedar\" { exit }; BEGIN { print \"inicio 2\" }; END { print \" - DONE 2 -\" }"

salida2 = tryParse prog entrada2

entrada3 :: String
entrada3 = "END { print \" - DONE 1 -\" }; BEGIN { print \"inicio 1\", $1 }; { print \"\\t\", $2}; $2 == \"Kedar\" { exit }; { print \"\\t\", $3}; BEGIN { print \"inicio 2\" }; END { print \" - DONE 2 -\" }"

salida3 = tryParse prog entrada3
