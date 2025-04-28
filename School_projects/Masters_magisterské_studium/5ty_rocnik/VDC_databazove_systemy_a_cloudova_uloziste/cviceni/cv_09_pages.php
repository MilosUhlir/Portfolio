
<?php
    require('databaze.php');
    $db = connect_db();

    if (isset($_GET['page'])) {
        $page = $_GET['page'];
    } else {
        $page = 'list';
    }

    if ($page == 'list') {
        $r = $db->query('SELECT * FROM fish');
        $fish_rows = $r->fetch_all(MYSQLI_ASSOC);
    } elseif ($page == 'detail') {
        $fid = $_GET['fid'];
        $sql = safe_sql_string(
            'SELECT * FROM fish WHERE id="?fid"',
            ['fid' => $fid],
            $db
        );
        $r = $db->query($sql);
        $fish = $r->fetch_assoc();
    }

?>




<html>
    <head>
        <meta charset="UTF=8">
        <title>pages</title>
    </head>
    <body>
        <h1>THIS IS A TEST</h1>
        <?php
            if ($page == 'list') {
                echo '<table border=1>
                <tr><th>id</th><th>kind</th><th>name</th><th>$$$</th></tr>';
                foreach ($fish_rows as $fish) {
                    echo '<tr><td>'
                    .'<a href="?page=detail&fid='
                    .$fish['id'].'">'
                    .$fish['id'].'</td>'
                    .'<td>'.$fish['species'].'</td>'
                    .'<td>'.$fish['name'].'</td>'
                    .'<td>'.$fish['cost'].'</td></tr>';
                }
                echo '</table>';
            } elseif ($page == 'detail') {
                echo '<pre>';
                print_r($fish);
                echo '</pre>';
                echo '<a href="?page=list">Zpět na seznam</a>';
            }
        ?>
    </body>
</html>
