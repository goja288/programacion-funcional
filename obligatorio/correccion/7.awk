BEGIN {
    print "probando el exit"
};

$2 >= 3 ;
$2 < 3 { exit };
END { print "Se termina";
    exit;
    print "esto no sale"
}
