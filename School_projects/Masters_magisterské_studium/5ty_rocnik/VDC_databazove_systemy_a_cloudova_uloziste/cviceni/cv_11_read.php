<?php




    $data = file_get_contents("https://mrkev.fme.vutbr.cz/~m221208/cv_11_content.php");
    $data = json_decode($data, true);
    echo "<pre>";
    print_r($data);
    echo $data->name;
    // echo "<pre>".$data."</pre>";