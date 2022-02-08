<head>
  <title>Statistics</title>
 </head>
 <body>

<?php
// PHP code just started

ini_set('error_reporting', E_ALL);
ini_set('display_errors', true);
// display errors

$db = mysqli_connect("dbase.cs.jhu.edu", "21fa_stan29", "kZnwaP7CvT");
// ********* Remember to use your MySQL username and password here ********* //

if (!$db) {

	echo "Connection failed!";

} else {

	$password = $_POST['password'];
	// This says that the $cr_cnt variable should be assigned a value obtained as an
	// input to the PHP code. In this case, the input is called 'ssn'.

	mysqli_select_db($db,"21fa_stan29_db");
	// ********* Remember to use the name of your database here ********* //

	mysqli_multi_query($db,"CALL Stats('$password')");
	// a simple call to a MySQL stored procedure. You would hope that now we have
	// the output of this procedure, as in the str_len.php example, but that is
	// not necessarily the case, unfortunately.
	$result = mysqli_store_result($db);

	if (!$result) {

		echo "Query failed!\n";
		print mysqli_error($db);

	} else {
		while ($myrow = mysqli_fetch_array($result)) {
			if ($myrow[0] == 'Access Denied!') {
				echo 'Wrong password, access denied!';
			} else {
				echo "<table border=1>\n";
				echo "<tr><td>HW1 (Mean)</td><td>HW2a (Mean)</td><td>HW2b (Mean)</td><td>Midterm (Mean)</td><td>HW3 (Mean)</td><td>FExam (Mean)</td></tr>\n";
				printf("<tr><td>%f</td><td>%f</td><td>%f</td><td>%f</td><td>%f</td><td>%f</td></tr>\n", $myrow["HW1 (Mean)"],$myrow["HW2a (Mean)"],$myrow["HW2b (Mean)"],$myrow["Midterm (Mean)"],$myrow["HW3 (Mean)"],$myrow["FExam (Mean)"]);
                printf("Mean: \n");
			}

		}
	}

	if (mysqli_more_results($db)) {
		mysqli_next_result($db);
		$result2 = mysqli_store_result($db);
		if ($result2) {
			
                while ($myrow = mysqli_fetch_array($result2)) {
                    echo "<table border=1>\n";
                    echo "<tr><td>HW1 (Standard Deviation)</td><td>HW2a (Standard Deviation)</td><td>HW2b (Standard Deviation)</td><td>Midterm (Standard Deviation)</td><td>HW3 (Standard Deviation)</td><td>FExam (Standard Deviation)</td></tr>\n";
                    printf("<tr><td>%f</td><td>%f</td><td>%f</td><td>%f</td><td>%f</td><td>%f</td></tr>\n", $myrow["HW1 (Standard Deviation)"],$myrow["HW2a (Standard Deviation)"],$myrow["HW2b (Standard Deviation)"],$myrow["Midterm (Standard Deviation)"],$myrow["HW3 (Standard Deviation)"],$myrow["FExam (Standard Deviation)"]);
                    printf("Standard Deviation: \n");
                    
                        
                        
                }

			}
	}

	if (mysqli_more_results($db)) {
		mysqli_next_result($db);
		$result3 = mysqli_store_result($db);
		if ($result3) {
            while ($myrow = mysqli_fetch_array($result3)) {
                echo "<table border=1>\n";
                echo "<tr><td>HW1 (Max)</td><td>HW2a (Max)</td><td>HW2b (Max)</td><td>Midterm (Max)</td><td>HW3 (Max)</td><td>FExam (Max)</td></tr>\n";
                printf("<tr><td>%f</td><td>%f</td><td>%f</td><td>%f</td><td>%f</td><td>%f</td></tr>\n", $myrow["HW1 (Max)"],$myrow["HW2a (Max)"],$myrow["HW2b (Max)"],$myrow["Midterm (Max)"],$myrow["HW3 (Max)"],$myrow["FExam (Max)"]);
                printf("Max: \n");      
            }

		}
	}

    if (mysqli_more_results($db)) {
	    	mysqli_next_result($db);
	        $result4 = mysqli_store_result($db);
		if ($result4) {
            while ($myrow = mysqli_fetch_array($result4)) {
                echo "<table border=1>\n";
                echo "<tr><td>HW1 (Min)</td><td>HW2a (Min)</td><td>HW2b (Min)</td><td>Midterm (Min)</td><td>HW3 (Min)</td><td>FExam (Min)</td></tr>\n";
                printf("<tr><td>%f</td><td>%f</td><td>%f</td><td>%f</td><td>%f</td><td>%f</td></tr>\n", $myrow["HW1 (Min)"],$myrow["HW2a (Min)"],$myrow["HW2b (Min)"],$myrow["Midterm (Min)"],$myrow["HW3 (Min)"],$myrow["FExam (Min)"]);
                printf("Min: \n");      
            }
		}
	}
}
	// PHP code about to end

?>
 </body>
