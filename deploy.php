<?php
    function nl2br2($string) {
        $string = str_replace(array("\r\n", "\r", "\n"), "<br />", $string);
        return $string;
    }

    $message=shell_exec("sh ./deploy.sh 2>&1");
    print_r(nl2br2($message));
?>