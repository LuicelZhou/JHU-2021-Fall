<head>
  <title>Change Scores</title>
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
	$ssn = $_POST['ssn'];
	$assignmentName = $_POST['assignmentName'];
	$newScore = $_POST['newScore'];
	// This says that the $cr_cnt variable should be assigned a value obtained as an
	// input to the PHP code. In this case, the input is called 'ssn'.

	mysqli_select_db($db,"21fa_stan29_db");
	// ********* Remember to use the name of your database here ********* //

	$multi_result = mysqli_multi_query($db,"CALL ChangeScores('$password', '$ssn', '$assignmentName', '$newScore')");
	// a simple call to a MySQL stored procedure. You would hope that now we have
	// the output of this procedure, as in the str_len.php example, but that is
	// not necessarily the case, unfortunately.

	$result = mysqli_store_result($db);
	if (!$result) {

		echo "Query failed!\n";
		print mysqli_error($db);

	} else {
		while ($myrow = mysqli_fetch_array($result)) {
			//echo $myrow[0];
			if ($myrow[0] == 'Access Denied!') {
				echo 'Wrong password, access denied!';
			} elseif ($myrow[0] == 'Invalid SSN!') {
				echo "Invalid SSN!";
			} else{
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
echo "</tr>\n";
echo "<p>Result before Change</p>";
			}
		}
	}


	if (mysqli_next_result($db)) {
		$result2 = mysqli_store_result($db);
		if ($result2) {

			//	echo "Query failed!\n";
			//	print mysqli_error($db);

			//} else {
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
while ($myrow = mysqli_fetch_array($result2)) {
	if ($myrow[0] == 'Access Denied!') {
		echo 'Wrong password, access denied!';
	} else {
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
		echo "</tr>\n";
		echo "<p>Result after Change</p>\n";
	}
}
		}

	} else {
		echo "Input invalid, change is not applied";
	}





}


?>
</body>
