<head>
  <title>Show Raw Scores</title>
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

	$result = mysqli_query($db,"CALL ShowRawScores($ssn)");
	// a simple call to a MySQL stored procedure. You would hope that now we have
	// the output of this procedure, as in the str_len.php example, but that is
	// not necessarily the case, unfortunately.

	if (!$result) {

		echo "Query failed!\n";
		print mysqli_error($db);

	} else {
		//$row = mysqli_fetch_array($result, MYSQLI_BOTH);
		// printf("%s (%s)\n", $row[0], $row["CountryCode"]);
		// $res = mysqli_fetch_assoc($result);
		//    print_r($row);
		//if ($row[0] == 'Invalid SSN!') {
		//      echo "Invalid SSN!";

		//} else {
		//              print_r($row);

		while ($myrow = mysqli_fetch_array($result)) {
			if ($myrow[0] == 'Invalid SSN!') {
				echo 'Invalid SSN';
			} else {
				echo "<table border=1>\n";
				echo "<tr>
					<td>ssn</td>
					<td>LName</td>
					<td>FName</td>
					<td>Section</td>
					<td>HW1</td>
					<td>HW2a</td>
					<td>HW2b</td>
					<td>Midterm</td>
					<td>HW3</td>
					<td>FExam</td>
					</tr>\n";

		echo "<tr>";
		echo "<td>" . $myrow["SSN"] . "</td>";
		echo "<td>" . $myrow["LName"] . "</td>";
		echo "<td>" . $myrow["FName"] . "</td>";
		echo "<td>" . $myrow["Section"] . "</td>";
		echo "<td>" . $myrow["HW1"] . "</td>";
		echo "<td>" . $myrow["HW2a"] . "</td>";
		echo "<td>" . $myrow["HW2b"] . "</td>";
		echo "<td>" . $myrow["Midterm"] . "</td>";
		echo "<td>" . $myrow["HW3"] . "</td>";
		echo "<td>" . $myrow["FExam"] . "</td>";
		echo "</tr>";


		// printf("<tr><td>%s</td><td>%s</td><td>%s</td><td>%s</td><td>%f</td><td>%f</td><td>%f</td><td>%f</td><td>%f</td><td>%f</td></tr>\n", $myrow["SSN"], $myrow["LName"],$myrow["FName"],$myrow["Section"],$myrow["HW1"],$myrow["HW2a"],$myrow["HW2b"],$myrow["Midterm"],$myrow["HW3"],$myrow["FExam"]);
			}

		}





	}

}

// PHP code about to end

?>
 </body>
