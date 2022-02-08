-- 	Q1 single student's raw scores
DELIMITER //
DROP PROCEDURE ShowRawScores;
CREATE PROCEDURE ShowRawScores(IN ssn VARCHAR(4))
BEGIN
	IF ssn IN (SELECT Rawscores.SSN FROM Rawscores) AND ssn NOT IN ('0001','0002') THEN
	SELECT * FROM Rawscores WHERE Rawscores.SSN = ssn;
	ELSE
	SELECT 'Invalid SSN!' AS 'Error Message';
	END IF;
END//

DELIMITER ;

-- Q2 print a single student's percentage scores and weighted average
DELIMITER //
DROP PROCEDURE ShowPercentages;
CREATE PROCEDURE ShowPercentages(IN ssn VARCHAR(4))
BEGIN
IF ssn IN (SELECT Rawscores.SSN FROM Rawscores) AND ssn NOT IN ('0001','0002') THEN 
SELECT R.SSN AS SSN, CONCAT(R.HW1 * (1/T.HW1) * 100,'%') AS HW1, CONCAT(R.HW2a * (1/T.HW2a) * 100,'%') AS HW2a, CONCAT(R.HW2b * (1/T.HW2b) * 100,'%') AS HW2b,CONCAT(R.Midterm * (1/T.Midterm) * 100,'%') AS Midterm,CONCAT(R.HW3 * (1/T.HW3) * 100,'%') AS HW3,CONCAT(R.FExam * (1/T.FExam) * 100,'%') AS FExam
FROM Rawscores R, TotalPoints T
WHERE R.SSN = ssn;
SELECT CONCAT('The cumulative course average for ', R.FName,' ',R.LName,' ','is ',R.HW1 * W.HW1 + R.HW2a* W.HW2a + R.HW2b *  W.HW2b + R.Midterm *W.Midterm + R.HW1 * W.HW3 + R.FExam *  W.FExam)
FROM Rawscores R, WtdPts W
WHERE R.SSN = ssn;
ELSE
SELECT "Invalid SSN!" AS 'Error Message';
END IF;
END//

DELIMITER ;


-- Q3 print full table of the raw scores
DELIMITER //
DROP PROCEDURE AllRawScores;
CREATE PROCEDURE AllRawScores (
	IN password VARCHAR ( 15 )) BEGIN
	IF
		password IN ( SELECT CurPasswords FROM Passwords ) THEN
		SELECT
			* 
		FROM
			Rawscores 
		ORDER BY
			Section,
			LName,
			FName;
		ELSE SELECT
			'Access Denied!' AS 'Error Message';
	END IF;
END//

DELIMITER ;

-- Q4 print a full table of the percentage scores and weighted total
DELIMITER //
DROP PROCEDURE AllPercentages;
CREATE PROCEDURE AllPercentages(
	IN PASSWORD VARCHAR ( 15 ))
BEGIN
	IF
		PASSWORD IN ( SELECT CurPasswords FROM Passwords ) THEN
		SELECT
			R.SSN AS SSN,
			CONCAT( R.HW1 * ( 1 / T.HW1 ) * 100, '%' ) AS HW1,
			CONCAT( R.HW2a * ( 1 / T.HW2a ) * 100, '%' ) AS HW2a,
			CONCAT( R.HW2b * ( 1 / T.HW2b ) * 100, '%' ) AS HW2b,
			CONCAT( R.Midterm * ( 1 / T.Midterm ) * 100, '%' ) AS Midterm,
			CONCAT( R.HW3 * ( 1 / T.HW3 ) * 100, '%' ) AS HW3,
			CONCAT( R.FExam * ( 1 / T.FExam ) * 100, '%' ) AS FExam,
			CONCAT( R.FExam * ( 1 / T.FExam ) * 100, '%' ) AS WeightedAverage 
		FROM
			Rawscores R,
			TotalPoints T;
		ELSE SELECT
			'Access Denied!' AS 'Error Message';
	END IF;
END//

DELIMITER ;

-- Q5 Compute aggregate statistics on the tables (601.415/615 only)
DELIMITER //
DROP PROCEDURE Stats;
CREATE PROCEDURE Stats(
	IN PASSWORD VARCHAR ( 15 ))
BEGIN
	IF
		PASSWORD IN ( SELECT CurPasswords FROM Passwords ) THEN
		SELECT
			CONCAT( AVG( A.HW1 ), "%" ) AS 'HW1 (Mean)',
			CONCAT( AVG( HW2a ), "%" ) AS 'HW2a (Mean)',
			CONCAT( AVG( HW2b ), "%" ) AS 'HW2b (Mean)',
			CONCAT( AVG( Midterm ), "%" ) AS 'Midterm (Mean)',
			CONCAT( AVG( HW3 ), "%" ) AS 'HW3 (Mean)',
			CONCAT( AVG( FExam ), "%" ) AS 'FExam (Mean)' 
		FROM
			PercentageScores A;
		SELECT
			CONCAT( STD( HW1 ), "%" ) AS 'HW1 (Standard Deviation)',
			CONCAT( STD( HW2a ), "%" ) AS 'HW2a (Standard Deviation)',
			CONCAT( STD( HW2b ), "%" ) AS 'HW2b (Standard Deviation)',
			CONCAT( STD( Midterm ), "%" ) AS 'Midterm (Standard Deviation)',
			CONCAT( STD( HW3 ), "%" ) AS 'HW3 (Standard Deviation)',
			CONCAT( STD( FExam ), "%" ) AS 'FExam (Standard Deviation)' 
		FROM
			PercentageScores A;
		SELECT
			CONCAT( MAX( HW1 ), "%" ) AS 'HW1 (Max)',
			CONCAT( MAX( HW2a ), "%" ) AS 'HW2a (Max)',
			CONCAT( MAX( HW2b ), "%" ) AS 'HW2b (Max)',
			CONCAT( MAX( Midterm ), "%" ) AS 'Midterm (Max)',
			CONCAT( MAX( HW3 ), "%" ) AS 'HW3 (Max)',
			CONCAT( MAX( FExam ), "%" ) AS 'FExam (Max)' 
		FROM
			PercentageScores A;
		SELECT
			CONCAT( MIN( HW1 ), "%" ) AS 'HW1 (Min)',
			CONCAT( MIN( HW2a ), "%" ) AS 'HW2a (Min)',
			CONCAT( MIN( HW2b ), "%" ) AS 'HW2b (Min)',
			CONCAT( MIN( Midterm ), "%" ) AS 'Midterm (Min)',
			CONCAT( MIN( HW3 ), "%" ) AS 'HW3 (Min)',
			CONCAT( MIN( FExam ), "%" ) AS 'FExam (Min)' 
		FROM
			PercentageScores;
		ELSE SELECT
			'Access Denied!' AS 'Error Message';
		
	END IF;
END//

DELIMITER ;

-- Q6 write a procedure to change student score
 
DELIMITER //
DROP PROCEDURE ChangeScores;
CREATE PROCEDURE ChangeScores ( IN PASSWORD VARCHAR ( 15 ), IN ssn VARCHAR ( 4 ), IN AssignmentName VARCHAR ( 10 ), IN NewScore DECIMAL ) BEGIN
 IF
  PASSWORD IN ( SELECT CurPasswords FROM Passwords ) THEN
  IF
   ssn IN ( SELECT R.SSN FROM Rawscores AS R ) AND ssn NOT IN ('0001', '0002') THEN
   SELECT
    * 
   FROM
    Rawscores
   WHERE Rawscores.SSN = ssn;
   CASE AssignmentName
   WHEN 'HW1' THEN
     UPDATE Rawscores
     SET Rawscores.HW1 = NewScore 
     WHERE
     Rawscores.SSN = ssn;
    
   WHEN 'HW2a' THEN
     UPDATE Rawscores 
     SET Rawscores.HW2a = NewScore 
     WHERE
     Rawscores.SSN = ssn;
    
   WHEN  'HW2b' THEN
     UPDATE Rawscores 
     SET Rawscores.HW2b = NewScore 
     WHERE
     Rawscores.SSN = ssn;
    
   WHEN 'Midterm' THEN
     UPDATE Rawscores 
     SET Rawscores.Midterm = NewScore 
     WHERE
     Rawscores.SSN = ssn;
    
   WHEN'HW3' THEN
     UPDATE Rawscores 
     SET Rawscores.HW3 = NewScore 
     WHERE
     Rawscores.SSN = ssn;

   WHEN  'FExam' THEN
     UPDATE Rawscores 
     SET Rawscores.FExam = NewScore 
     WHERE
     Rawscores.SSN = ssn;
   ELSE
     SELECT "Invalid Assignment Name!" AS 'Error Message';
   END CASE;
   SELECT DISTINCT
    * 
   FROM
    Rawscores
   WHERE Rawscores.SSN = ssn;
   
   ELSE SELECT
    'Invalid SSN!' AS 'Error Message';
   
  END IF;
  ELSE SELECT
    'Access Denied!' AS 'Error Message';
  
 END IF;
END//

DELIMITER ;


-- View for weighted points
DROP VIEW WtdPts;
CREATE VIEW WtdPts AS SELECT
( 1 / T.HW1 ) * W.HW1 AS HW1,
( 1 / T.HW2a ) * W.HW2a AS HW2a,
( 1 / T.HW2b ) * W.HW2b AS HW2b,
( 1 / T.Midterm ) * W.Midterm AS Midterm,
( 1 / T.HW3 ) * W.HW3 AS HW3,
( 1 / T.FExam ) * W.FExam AS FExam 
FROM
	TotalPoints T,
	Weights W;
	
	-- View for TotalPoints
DROP VIEW TotalPoints;
CREATE VIEW TotalPoints AS 
SELECT * FROM Rawscores
WHERE SSN = '0001';

-- View for weights
DROP VIEW Weights;
CREATE VIEW Weights AS 
SELECT * FROM Rawscores
WHERE SSN = '0002';

-- View for Percentage Scores
DROP VIEW PercentageScores;
CREATE VIEW PercentageScores AS SELECT
R.SSN AS SSN,
R.HW1 * ( 1 / T.HW1 ) * 100 AS HW1,
R.HW2a * ( 1 / T.HW2a ) * 100 AS HW2a,
R.HW2b * ( 1 / T.HW2b ) * 100 AS HW2b,
R.Midterm * ( 1 / T.Midterm ) * 100 AS Midterm,
R.HW3 * ( 1 / T.HW3 ) * 100 AS HW3,
R.FExam * ( 1 / T.FExam ) * 100 AS FExam,
R.HW1 * ( 1 / T.HW1 ) * W.HW1 + R.HW2a * ( 1 / T.HW2a ) * W.HW2a + R.HW2b * ( 1 / T.HW2b ) * W.HW2b + R.Midterm * ( 1 / T.Midterm ) * W.Midterm + R.HW1 * ( 1 / T.HW3 ) * W.HW3 + R.FExam * ( 1 / T.FExam ) * W.FExam AS WeightedAverage 
FROM
	Rawscores R,
	TotalPoints T,
	Weights W 
WHERE
	R.SSN NOT IN ( '0001', '0002' );