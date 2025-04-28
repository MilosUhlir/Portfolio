<html>
<head><meta charset="UTF-8"></head>
<body>

<?php
  include('databaze.php');

  $db = connect_db();
  $r = $db->query('SELECT * FROM fish');

  if ($r === false) {
    echo 'chyba: '.$db->errno.': '.$db->error.'<br>';
  } else {
    $rows = $r->fetch_all(MYSQLI_ASSOC);
    echo '<table border=1>';
    echo '<tr> <th>id</th>'.
              '<th>species</th>'.
              '<th>name</th>'.
              '<th>cost</th></tr>';
    foreach ($rows as $fish) {
      // print_r($fish);
      echo '<tr><td>'.$fish['id'].'</td>'
              .'<td>'.$fish['species'].'</td>'
              .'<td>'.$fish['name'].'</td>'
              .'<td>'.$fish['cost'].'</td></tr>';
    }
    echo '</table>';
    echo '<br>';
    // print_r($r);
    
  }


  $a = 5;

  echo 'hodnota a = '.$a.'<br>';

  print_r(3+$a/3*sin(3.2));
  echo '<br>';

  $p = []; # array()
  $p[3] = 2;
  $p['ahoj'] = 2.67;
  $p[0] = 'xxx';
  print_r($p);
  echo '<br>';

  foreach($p as $x) {
    echo $x.'<br>';
  }

  foreach($p as $k=>$x) {
    echo $k.' -> '.$x.'<br>';
  }
?>


</body>
</html>