BEGIN { print "ERROR" };

{print $1 / $2};

END {print "no llego hasta aqui"}
