<?php
    function nl2br2($string) {
        $string = str_replace(array("\r\n", "\r", "\n"), "<br />", $string);
        return $string;
    }

    $message=shell_exec("mkdir -p ../www2 2>&1");
    print_r(nl2br2($message));
    $message=shell_exec("tar -xvzf ../site.tar.gz -C ../www2 --strip-components=1 2>&1");
    print_r(nl2br2($message));

    $message=shell_exec("rsync --verbose --recursive ./professional-powershell ../www2 2>&1");
    print_r(nl2br2($message));
    $message=shell_exec("rsync --verbose --recursive --delete-after ../www2/ ../www/ 2>&1");
    print_r(nl2br2($message));

    $message=shell_exec("rm -rfv ../www2/* ../www2/.htaccess 2>&1");
    print_r(nl2br2($message));
    $message=shell_exec("rmdir ../www2 2>&1");
    print_r(nl2br2($message));
    $message=shell_exec("rmdir ../site.tar.gz 2>&1");
    print_r(nl2br2($message));
?>