<head>
  <title>All Raw Scores</title>
 </head>
 <body>

<?php
// PHP code just started

ini_set('error_reporting', E_ALL);
ini_set('display_errors', true);
// display errors

$db = mysqli_connect("dbase.cs.jhu.edu", "21fa_yzhou193", "E1hL7yOSEP");
// ********* Remember to use your MySQL username and password here ********* //

if (!$db) {

        echo "Connection failed!";

} else {

        $password = $_POST['password'];
        // This says that the $cr_cnt variable should be assigned a value obtained as an
        // input to the PHP code. In this case, the input is called 'ssn'.

        mysqli_select_db($db,"21fa_yzhou193_db");
        // ********* Remember to use the name of your database here ********* //

        $result = mysqli_query($db,"CALL AllRawScores('$password')");

        if (!$result) {

                echo "Query failed!\n";
                print mysqli_error($db);

        } else {
          
          echo "<table border=1>\n";
          echo "<tr><td>ssn</td><td>LName</td><td>FName</td><td>Section</td><td>HW1</td><td>HW2a</td><td>HW2b</td><td>Midterm</td><td>HW3</td><td>FExam</td></tr>\n";   
                while ($myrow = mysqli_fetch_array($result)) {
                        if ($myrow[0] == 'Access Denied!') {
                                echo 'Access Denied!';
                        } else {
                                printf("<tr><td>%s</td><td>%s</td><td>%s</td><td>%s</td><td>%f</td><td>%f</td><td>%f</td><td>%f</td><td>%f</td><td>%f</td></tr>\n", $myrow["SSN"], $myrow["LName"],$myrow["FName"],$myrow["Section"],$myrow["HW1"],$myrow["HW2a"],$myrow["HW2b"],$myrow["Midterm"],$myrow["HW3"],$myrow["FExam"]);
                        }

                }





        }

}

// PHP code about to end

?>
 </body>