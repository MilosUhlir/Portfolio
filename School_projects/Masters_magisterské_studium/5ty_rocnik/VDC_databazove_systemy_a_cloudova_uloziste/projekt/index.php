
<?php
    require('../databaze.php');
    $db = connect_db();


    if (isset($_GET['page'])) {
        $page = $_GET['page'];
    } else {
        $page = 'db';
    }

    if ($page == 'db') {
        $r = $db->query('SELECT * FROM medicament');
        $drug_rows = $r->fetch_all(MYSQLI_ASSOC);
    } elseif ($page == 'input') {
        # code...
    } elseif ($page == 'pdf') {

    } elseif ($page == 'detail') {
        $drug_id = $_GET['drug_id'];
        $sql = safe_sql_string(
            'SELECT * FROM medicament m JOIN active_substance a_s ON m.active_substance_id=a_s.id WHERE m.id=?drug_id',
            ['drug_id' => $drug_id],
            $db
        );
        $r = $db->query($sql);
        $drug_detail = $r->fetch_assoc();
    }

?>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>Projekt VDC</title>

        <style>
            * {
                box-sizing: border-box;
            }
            header {
                padding: 30px;
                background-color: #666;
                text-align: center;
                font-size: 35px;
                color: white;
            }
            nav {
                float: left;
                padding: 20px;
                width: 20%;
                background-color: #ccc;
                height: 100%;
            }
            article {
                float: left;
                padding: 20px;
                background-color: #f1f1f1;
                width: 80%;
            }
            section::after {
                content: "";
                display: table;
                clear: both;
            }
            @media (max-width: 600px) {
                nav, article {
                    width: 100%;
                    height: 100%;
                }
            }
        </style>


    </head>

    <body>
        <header>
            <h1>Databáze léků</h1>
        </header>
        <!-- <h2> Ahoj Marťo, Ahoj Ondro 😁 </h2> -->
        
        <section>
            <nav>
                <ul>
                    <button onclick="location.href='?page=db'">Zobrazit databázi</button><br>
                    <button onclick="location.href='?page=input'">Formulář pro vkládání dat</button><br>
                    <button onclick="location.href='?page=pdf'">Uložit data jako PDF</button><br>
                    <!-- <button onclick="toggleImage()">Zobrazení ERD diagramu</button><br> -->
                    <button onclick="location.href='?page=erd'">Zobrazení ERD diagramu</button><br>
                    
                </ul>
            </nav>
            
            <article>
                <?php
                    $image_name = 'erd.png';
                    $image_path = '$image_name';
                    if ($page == 'home') {
                        // echo '<table border=1 >
                        // <tr><td><button onclick="location.href=\'?page=db\'">Zobrazit databázi</button></td></tr>
                        // <tr><td><button onclick="location.href=\'?page=input\'">Formulář pro vkládání dat</button><br></td></tr>
                        // <tr><td><button onclick="location.href=\'?page=pdf\'">Uložit data jako PDF</button><br></td></tr>
                        // </table>';
                    } elseif ($page == 'db') {
                        echo '<h2>Výpis databáze</h2>';
                        // echo '<tr><td><button onclick="toggleImage()">Zobrazení ERD diagramu</button><br></td></tr>';
                        // echo '<button onclick="window.open(\'erd.png\', \'_blank\')">Schéma databáze</button><br>';
                        
                        echo '<table border=1>
                        <tr>
                        <th>ID</th>
                        <th>Name</th>
                        <th>Producer</th>
                        <th>Needs prescription</th>
                        <th>Price</th>
                        <th>ATC code</th>
                        </tr>';
                        
                        foreach ($drug_rows as $drug) {
                            echo '<tr><td>'
                            .'<a href="?page=detail&drug_id='
                            .$drug['id'].'">'
                            .$drug['id'].'</td>'
                            .'<td>'.$drug['med_name'].'</td>'
                            .'<td>'.$drug['producer_idproducer'].'</td>';
                            if ($drug['prescription'] == 1) {
                                echo '<td>Yes</td>';
                            } else {
                                echo '<td>No</td>';
                            }
                            if ($drug['price'] == 0) {
                                echo '<td>---</td>';
                            } else {
                                echo '<td>'.$drug['price'].'</td>';
                            }
                            $atcid = $drug['ATC_code_id'];
                            $atc = $db->query('SELECT * FROM atc_code WHERE id="$atcid"');
                            $data = $atc->fetch_all(MYSQLI_ASSOC);
                            echo '<td>'.$data[0]['code'].'</td>';
                            // $test = $db->query("SELECT * FROM 'atc_code'");
                            // echo '<td>'.$test['id'].'</td>';
                            // echo '<td>'.$test['code'].'</td>';
                        };
                        
                        echo '</table>';
                        // echo '<button onclick="location.href=\'?page=home\'">Zpět na domovsou stránku</button><br>';
                    } elseif ($page == 'input') {
                        echo '<h2>Formulář pro vkládání dat do databáze</h2>';
                        // echo '<button onclick="location.href=\'?page=home\'">Zpět na domovsou stránku</button><br>';
                    } elseif ($page == 'pdf') {
                        echo '<h2>Vygenerovat PDF</h2>';
                        // echo '<button onclick="location.href=\'?page=home\'">Zpět na domovsou stránku</button><br>';
                    } elseif ($page == 'erd') {
                        echo '<img id=\'erdImage\' src=\'erd.png\' alt=\'Entity Relationship Diagram\'><br>';
                    } elseif ($page = 'detail') {
                        
                        echo '<table border=1>';
                        echo '<tr><th>parametr</th><th>hodnota</th></tr>';
                        
                        foreach ($drug_detail as $detail => $value) {
                            echo '<tr><td>'.$detail.'</td><td>'.$value.'</td></tr>';
                        }
                        // echo '<tr></tr>'
                        echo '</table><br>';

                        // echo '<pre>';
                        // print_r($drug_detail);
                        // echo '</pre>';
                        echo '<button onclick="location.href=\'?page=db\'">Zpět k databázi</button><br>';
                    }



                ?>
            </article>
        </section>
    </body>
    
    <script>
        function toggleImage() {
            const image = document.getElementById('erdImage')
            if (image.style.display === 'none') {
                image.style.display = 'block';
            } else {
                image.style.display = 'none';
            }
        }
    </script>

</html>
