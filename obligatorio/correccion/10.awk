BEGIN { print "probando el error division por 0" };

{print $1 / $2};

END {print "no llego hasta aqui"}
