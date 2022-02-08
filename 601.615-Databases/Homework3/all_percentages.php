<head>
  <title>All Percentages</title>
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

	$result = mysqli_query($db,"CALL AllPercentages('$password')");
	// a simple call to a MySQL stored procedure. You would hope that now we have
	// the output of this procedure, as in the str_len.php example, but that is
	// not necessarily the case, unfortunately.

	if (!$result) {

		echo "Query failed!\n";
		print mysqli_error($db);

	} else {
		echo "<table border=1>\n";
		echo "<tr><td>ssn</td><td>HW1</td><td>HW2a</td><td>HW2b</td><td>Midterm</td><td>HW3</td><td>FExam</td><td>Cumulative Score</td></tr>\n";
		while ($myrow = mysqli_fetch_array($result)) {
			if ($myrow[0] == 'Access Denied!') {
				echo 'Access Denied!';
			} else {
				printf("<tr><td>%s</td><td>%s</td><td>%s</td><td>%s</td><td>%f</td><td>%f</td><td>%f</td><td>%f</td></tr>\n", $myrow["SSN"], $myrow["HW1"],$myrow["HW2a"],$myrow["HW2b"],$myrow["Midterm"],$myrow["HW3"],$myrow["FExam"],$myrow['WeightedAverage']);
			}

		}





	}

}

// PHP code about to end

?>
 </body>
