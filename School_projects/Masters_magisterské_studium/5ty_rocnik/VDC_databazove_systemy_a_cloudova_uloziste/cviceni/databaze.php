<?php


function connect_db()
{
    //  parametry:
    //    1. server, localhost znaci stejny pocitac, na kterem bezi www server
    //    2. db uzivatel; zde vase m123456
    //    3. heslo k db, stejne jako se prihlasujete na phpMyAdmin
    //    4. vybrane db schema, opet pro vas m123456

    $dbconn = new mysqli("localhost", "m221208", "mrkev.4720", "m221208");
    $dbconn->autocommit(FALSE);
  
    return $dbconn;
}

// substituce podle klicu $params ve formatu ?klic
// priklad: $sql = 'SELECT * FROM student WHERE id=?id AND jmeno LIKE "?jmeno" ';
//          $params = ['id' => 5, 'jmeno' => 'Jiri "z" podebrad'];

// lepe pouzit Prepared Statements in MySQLi
// https://www.w3schools.com/php/php_mysql_prepared_statements.asp

function safe_sql_string($sql, $params, $db)
{
    $translations = [];
    foreach($params as $name => $value) {
        $translations['?'.$name] = $db->real_escape_string($value);
    }
    $result = strtr($sql, $translations);
    return $result;
}

