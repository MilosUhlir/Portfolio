
<?php
  require('databaze.php');
  $db = connect_db();
  if(isset($_POST["fname"]) && isset($_POST["lname"])){
    $fname = $_POST["fname"];
    $lname = $_POST["lname"];
    $sql = 'SELECT * FROM tank'
          .' WHERE capacity >= "$p1"'
          .' AND salinity >= "$p2"';
          
    $sql = safe_sql_string(
      $sql, 
      ['p1' => $fname, 'p2' => $lname], 
      $db);
          
    $r = $db->query($sql);
    if($r === false) {
      echo 'chyba: '.$db->errno.': '
           .$db->error.'<br>'; 
    } else {
      print_r($r->fetch_all(MYSQLI_ASSOC));
    }
  }
?>

<!DOCTYPE html>
<html>
<body>

<h2>HTML Forms</h2>

<pre>
GET:
<?php print_r($_GET); ?>
POST:
<?php print_r($_POST); ?>
</pre>

<form action="" method="POST">
  <label for="fname">First name:</label><br>
  <input type="text" id="fname" name="fname" value=""><br>
  <label for="lname">Last name:</label><br>
  <input type="text" id="lname" name="lname" value=""><br><br>
  <input type="submit" value="Submit">
</form> 

<p>If you click the "Submit" button, the form-data will be sent to a page called "/action_page.php".</p>

</body>
</html>