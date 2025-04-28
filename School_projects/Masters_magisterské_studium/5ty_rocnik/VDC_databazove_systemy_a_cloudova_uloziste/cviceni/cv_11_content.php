<?php
    header('Content-Type: application/json');

    $data = [
        "x" => 5,
        "name" => "Pavel",
        "d" => ["a" => 1, "b" => "<b>xxx</b>"]
    ];

    echo json_encode($data);