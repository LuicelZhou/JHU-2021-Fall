<head>
  <title>Show Percentages</title>
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

	$ssn = $_POST['ssn'];
	// This says that the $cr_cnt variable should be assigned a value obtained as an
	// input to the PHP code. In this case, the input is called 'ssn'.

	mysqli_select_db($db,"21fa_stan29_db");
	// ********* Remember to use the name of your database here ********* //

	mysqli_multi_query($db,"CALL ShowPercentages($ssn)");
	// a simple call to a MySQL stored procedure. You would hope that now we have
	// the output of this procedure, as in the str_len.php example, but that is
	// not necessarily the case, unfortunately.
	$result = mysqli_store_result($db);

	if (!$result) {

		echo "Query failed!\n";
		print mysqli_error($db);

	} else {
		while ($myrow = mysqli_fetch_array($result)) {
			if ($myrow[0] == 'Invalid SSN!') {
				echo 'Invalid SSN';
			} else {
				echo "<table border=1>\n";
				echo "<tr><td>SSN</td><td>HW1</td><td>HW2a</td><td>HW2b</td><td>Midterm</td><td>HW3</td><td>FExam</td></tr>\n";
				printf("<tr><td>%s</td><td>%f</td><td>%f</td><td>%f</td><td>%f</td><td>%f</td><td>%f</td></tr>\n", $myrow["SSN"],$myrow["HW1"],$myrow["HW2a"],$myrow["HW2b"],$myrow["Midterm"],$myrow["HW3"],$myrow["FExam"]);
			}

		}
	}

	if (mysqli_next_result($db)) {
		$result2 = mysqli_store_result($db);
		if ($result2) {
			if ($myrow[0] == 'Invalid SSN!') {
				echo 'Invalid SSN';
			} else {
				while ($myrow = mysqli_fetch_array($result2)) {
					if ($myrow[0] == 'Invalid SSN!') {
						echo 'Invalid SSN';
					} else {
						echo $myrow[0];
					
					}
				}

			}
		}
	}
}
	// PHP code about to end

?>
 </body>
