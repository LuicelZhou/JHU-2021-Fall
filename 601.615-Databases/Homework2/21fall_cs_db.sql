/*Query 1*/
SELECT CONCAT(S.fname,' ',S.lname) AS StuName, S.age AS Age, S.sex AS Sex, C.city_name AS City
FROM VotedForElectioninUS V, Student S, City C, USCandidate U
WHERE S.StuID = V.StuID AND S.citY_code = C.city_code AND U.candidateid = V.candidateid AND V.year BETWEEN '2016' AND '2020' AND U.candidatename = 'Donald Trump';

/*Query 2*/
SELECT DISTINCT CONCAT(S.fname,' ',S.lname) AS StuName, D.dname AS Major
FROM Student S, Department D, Course C, Faculty F, Enrolled_in E
WHERE (S.major = D.dno AND S.advisor = F.facid  AND F.fname = 'Jason' AND F.lname = 'Eisner') 
OR (S.major = D.dno AND E.stuid = S.stuid AND C.cid = E.cid AND C.instructor = F.facid AND F.fname = 'Jason' AND F.lname = 'Eisner');

/*Query 3*/
SELECT CONCAT(S.fname,' ',S.lname) AS StuName, D.dname  AS MajorName
FROM Student S, Department D
WHERE S.major = D.dno 
EXCEPT
SELECT CONCAT(S.fname,' ',S.lname) AS StuName, D.dname  AS MajorName
FROM Student S, Department D, Course C, Faculty F, Enrolled_in E
WHERE (S.major = D.dno AND S.advisor = F.facid  AND F.fname = 'Jason' AND F.lname = 'Eisner') 
OR (S.major = D.dno AND E.stuid = S.stuid AND C.cid = E.cid AND C.instructor = F.facid AND F.fname = 'Jason' AND F.lname = 'Eisner');
 
/*Query 5*/
SELECT CONCAT(S.fname,' ',S.lname) AS StuName, D.dname AS Major
FROM Student S, Department D
WHERE S.major = D.dno AND NOT EXISTS (
SELECT *
FROM Student S1, Course C, Enrolled_in E
WHERE S.stuid = E.stuid AND C.cid = E.cid AND C.dno = S.major);

/*Query 6*/
SELECT A.activity_name AS Activity, COUNT(P.stuid) as StuNum
FROM Activity A, Participates_in P
WHERE A.actid = P.actid
GROUP BY P.stuid
HAVING COUNT(P.stuid) >= 3
ORDER BY COUNT(P.stuid) DESC, A.activity_name;

/*Query 8*/
SELECT CONCAT(S.fname,' ',S.lname) AS StuName, D.dname AS Major, COUNT(P.actid)
FROM Student S, Participates_in P, Department D, Enrolled_in E
WHERE S.stuid = P.stuid AND E.stuid = S.stuid AND S.major = D.dno 
AND NOT EXISTS ( SELECT * 
FROM Student S1, Enrolled_in E1 
WHERE S1.stuid = E1.stuid AND ( E.grade IN ('C+', 'C' ,'C-' ,'D' ))) 
GROUP BY S.stuid
HAVING COUNT( P.actid ) >= 2;


/*Query 9*/
SELECT stuname AS StuName, major AS Major, activitynumber AS ActivityNumber
FROM(
SELECT CONCAT(S.fname,' ',S.lname) AS StuName, D.DName AS Major, count(P.actid) AS ActivityNumber
FROM Loves L, Student S, Department D, Participates_in P
WHERE S.major = D.dno AND S.stuid = P.stuid AND L.whoisloved = S.stuid
GROUP BY S.stuid) A
WHERE activitynumber IN (SELECT MAX(activitynumber) FROM ( SELECT CONCAT(S.fname,' ',S.lname) AS StuName, D.DName AS Major, count(P.actid) AS ActivityNumber
FROM Loves L, Student S, Department D, Participates_in P
WHERE S.major = D.dno AND S.stuid = P.stuid AND L.whoisloved = S.stuid
GROUP BY S.stuid) A);


/*Query 12*/
SELECT dormid AS DormID, student_capacity AS Capacity
FROM(
SELECT D.dormid, D.student_capacity,COUNT(H.amenid) AS AmenNum
FROM Has_amenity as H, Dorm as D
WHERE H.dormid = D.dormid
GROUP BY H.dormid) A
WHERE A.amennum IN (SELECT MAX(amennum) FROM ( SELECT amennum
FROM(
SELECT D.dormid, D.student_capacity,COUNT(H.amenid) AS AmenNum
FROM Has_amenity as H, Dorm as D
WHERE H.dormid = D.dormid
GROUP BY H.dormid)B )C);

/*Query 13*/
SELECT AVG(S.age) AS AvgAge
FROM Student S 
WHERE S.stuid IN (
SELECT stuid FROM Student S1 
EXCEPT
SELECT P.stuid FROM Participates_in P, Student S2 WHERE P.stuid = S2.stuid );

/*Query 15*/
SELECT stuname AS StuName, majorname AS MajorName, advisorname AS AdvisorName
FROM(
SELECT CONCAT(S.fname,' ',S.lname) AS StuName, D.dname AS MajorName, CONCAT( F.fname, " ", F.lname ) AS AdvisorName, distance
FROM Student S, Department D, Direct_distance D1, Faculty F, Enrolled_in E, Course C, City C1
WHERE S.stuid = E.stuid  AND E.cid = C.cid  AND C.cname = 'COMPUTER VISION' AND S.major = D.dno  AND F.facid = S.advisor 
AND C1.city_name = 'Baltimore' AND C1.state = 'MD' AND ( C1.city_code = D1.city1_code AND S.city_code = D1.city2_code )
GROUP BY E.stuid) A
WHERE distance IN (SELECT MAX(distance) FROM (
SELECT CONCAT(S.fname,' ',S.lname) AS StuName, D.dname AS MajorName, CONCAT( F.fname, " ", F.lname ) AS AdvisorName, distance
FROM Student S, Department D, Direct_distance D1, Faculty F, Enrolled_in E, Course C, City C1
WHERE S.stuid = E.stuid  AND E.cid = C.cid  AND C.cname = 'COMPUTER VISION' AND S.major = D.dno  AND F.facid = S.advisor 
AND C1.city_name = 'Baltimore' AND C1.state = 'MD' AND ( C1.city_code = D1.city1_code AND S.city_code = D1.city2_code )
GROUP BY E.stuid) A );
 
/*Query 16*/
SELECT stuname AS StuName, sex AS Sex, dormid AS DormID, dormname AS DormName
FROM ( SELECT CONCAT(S.fname,' ',S.lname) AS StuName, S.sex AS Sex, D1.dormid AS DormID, D1.dorm_name AS DormName, D2.distance
FROM Dorm D1, Lives_in L, Direct_distance D2, Student S, City C
WHERE D1.dormid = L.dormid AND S.stuid = L.stuid AND S.city_code = D2.city2_code AND C.city_name = 'Baltimore' AND C.state = 'MD' AND C.city_code = D2.city1_code
GROUP BY S.stuid) A
WHERE distance IN (SELECT MAX(distance) FROM (SELECT CONCAT(S.fname,' ',S.lname) AS StuName, S.sex AS Sex, D1.dormid AS DormID, D1.dorm_name AS DormName, D2.distance
FROM Dorm D1, Lives_in L, Direct_distance D2, Student S, City C
WHERE D1.dormid = L.dormid AND S.stuid = L.stuid AND S.city_code = D2.city2_code AND C.city_name = 'Baltimore' AND C.state = 'MD' AND C.city_code = D2.city1_code
GROUP BY S.stuid) B);

/*Query 18*/
SELECT CONCAT(S.fname,' ',S.lname) AS StuName
FROM Student S, City C,Lives_in L,Dorm D1, Department D2, Has_Allergy H
WHERE S.city_code = C.city_code AND C.city_name = 'New York' AND L.stuid = S.stuid AND L.dormid = D1.dormid AND D1.dorm_name = 'Wolman'
AND S.major = D2.dno AND D2.dname = 'Computer Science' AND S.stuid = H.stuid AND H.allergy = 'Peanut Butter';

/*Query 20*/
SELECT C.cname AS CourseName, C.cid AS CourseID, COUNT(E.stuid) AS NumberEnrolled
FROM Course C,Enrolled_in E
WHERE C.cid = E.cid
GROUP BY E.stuid
HAVING COUNT(E.stuid)<3;

/*Query 23*/
SELECT COUNT(E.Grade) as A_Rate, C.cid AS CourseID
FROM Course C, Enrolled_in E, Department D
WHERE C.dno = D.dno AND C.cid = E.cid AND (D.dname = 'Computer Science' OR D.dname = 'ECE') AND (E.grade = 'A' OR E.grade = 'A+')
GROUP BY E.stuid;

/*Query 25*/
SELECT  CONCAT(S.fname,' ',S.lname) AS StuName
FROM Student S
WHERE NOT EXISTS( 
SELECT DISTINCT A.allergytype FROM Allergy_Type A 
EXCEPT
SELECT DISTINCT A1.allergytype FROM Allergy_Type A1, Has_Allergy H WHERE H.allergy = A1.allergy AND S.stuid = H.stuid );

/*Query 26*/
SELECT allergy AS AllergyName, allergytype AS AllergyType
FROM(
SELECT A.allergy, A.allergytype ,COUNT(A.allergy) AS AllergyCount
FROM Student S, Has_Allergy H, Allergy_Type A 
WHERE S.stuid = H.stuid AND S.age > 25 AND A.allergy = H.allergy 
GROUP BY H.Allergy
ORDER BY COUNT(A.allergy) DESC) A
HAVING MAX(A.allergycount);

/*Query 27*/
SELECT DISTINCT(CASE WHEN stu1<stu2 THEN CONCAT(stu1,' ',stu2) ELSE CONCAT(stu2,' ',stu1) END) AS RoommatePairs 
FROM( SELECT DISTINCT A.stu1, A.stu2
FROM(SELECT L1.stuid AS stu1, L2.stuid AS stu2
FROM Lives_in L1,Lives_in L2
WHERE L1.dormid = L2.dormid AND L1.room_number = L2.room_number AND NOT L1.stuid = L2.stuid ) A
WHERE NOT EXISTS (
SELECT * 
FROM Preferences P1, Preferences P2 
WHERE P1.stuid = A.stu1 AND P2.stuid = A.stu2  AND P1.musictype = P2.musictype AND P1.SleepHabits = P2.SleepHabits 
AND (P1.Smoking = P2.Smoking OR ( P1.Smoking = 'Yes' AND P2.Smoking = 'no-accept') OR ( P1.smoking = 'no' AND P2.smoking = 'no-accept')))) A
GROUP BY roommatepairs;

/*Query 28*/
SELECT CONCAT(ROUND((COUNT(DISTINCT S1.stuid)/COUNT(DISTINCT S2.stuid)) * 100,2), '%') AS Percentage,D.dname AS Major, D.dno AS MajorNum
FROM Student S1, Student S2, Department D 
WHERE S1.major = D.dno  AND S2.major = D.dno  AND S1.stuid IN (
SELECT DISTINCT S.stuid FROM Student S, Preferences P WHERE S.stuid = P.stuid AND P.smoking = "no" ) 
GROUP BY majornum
HAVING COUNT(S1.stuid)>=1;

/*Query 29*/
SELECT dno AS MajorNum, dname AS MajorName
FROM(
SELECT(COUNT( DISTINCT S1.stuid )/ COUNT( DISTINCT S2.stuid)) AS Percentage, D.dname, D.dno 
FROM Student S1,Student S2, Department D 
WHERE S1.major = D.dno  AND S2.major = D.dno AND S1.StuID IN ( SELECT DISTINCT S.stuid FROM Student S, Preferences P WHERE S.stuid = P.stuid AND P.smoking = "no" ) 
GROUP BY D.dno
HAVING COUNT(S1.stuid) > 3) A
WHERE percentage IN (SELECT MAX(percentage) FROM (
SELECT(COUNT( DISTINCT S1.stuid )/ COUNT( DISTINCT S2.stuid)) AS Percentage, D.dname, D.dno 
FROM Student S1,Student S2, Department D 
WHERE S1.major = D.dno  AND S2.major = D.dno AND S1.StuID IN ( SELECT DISTINCT S.stuid FROM Student S, Preferences P WHERE S.stuid = P.stuid AND P.smoking = "no" ) 
GROUP BY D.dno
HAVING COUNT(S1.stuid) > 3) B);

/*Query 30*/
SELECT A.allergytype as AllergyType, H.Allergy AS AllergyName, C.state AS State 
FROM Student S, City C, Has_Allergy H, Allergy_Type A 
WHERE S.city_code = C.city_code AND H.StuID = S.stuid AND A.allergy = H.allergy 
GROUP BY C.state 
HAVING COUNT(S.stuid) >= 2
ORDER BY COUNT( H.Allergy ) DESC;


/*Query 32*/
SELECT DISTINCT CONCAT(S.fname,' ',S.lname) AS StuName, S.age AS Age, D.dname AS Major, CONCAT(F.fname,' ',F.lname) AS AdvisorName
FROM Student S, Department D, Enrolled_in E, Faculty F, Course C
WHERE S.stuid = E.stuid AND S.major = D.dno AND S.advisor = F.facid AND E.cid = C.cid AND C.Instructor = S.advisor;

/*Query 33*/
SELECT D.division AS Division, COUNT(E.stuid) AS EnrollNumber
FROM Department D, Enrolled_in E, Course C
WHERE D.dno = C.dno AND E.cid = C.cid
GROUP BY D.division
ORDER BY COUNT(E.stuid);

/*Query 34*/
SELECT DISTINCT F.fname AS FirstName, COUNT(F.fname) as NameCount
FROM Faculty F
GROUP BY F.fname
HAVING COUNT(fname) > 1
ORDER BY COUNT(fname) DESC;

/*Query 35*/
SELECT fname AS FirstName, nameCount AS NameCount
FROM( SELECT fname, SUM(NameCount) AS NameCount
FROM ( 
SELECT X.fname, X.NameCount
FROM (SELECT S.fname, COUNT(*) AS NameCount, RANK() over (ORDER BY COUNT(*) DESC) AS Rank
FROM Student S
GROUP BY S.fname) X
UNION ALL
SELECT Y.fname, Y.NameCount
FROM (SELECT F.fname, COUNT(*) AS NameCount, RANK() over (ORDER BY COUNT(*) DESC) AS Rank
FROM Faculty F 
GROUP BY F.fname) Y) T
GROUP BY fname 
) A
WHERE namecount IN (SELECT MAX(namecount) FROM(SELECT fname, SUM(NameCount) AS NameCount
FROM (  SELECT X.fname, X.NameCount
FROM (SELECT S.fname, COUNT(*) AS NameCount, RANK() over (ORDER BY COUNT(*) DESC) AS Rank
FROM Student S
GROUP BY S.fname) X
UNION ALL
SELECT Y.fname, Y.NameCount
FROM (SELECT F.fname, COUNT(*) AS NameCount, RANK() over (ORDER BY COUNT(*) DESC) AS Rank
FROM Faculty F 
GROUP BY F.fname) Y) T
GROUP BY fname 
) B);


/*Query 36*/
SELECT dname AS Department, enrollnum AS EnrollNumber
FROM( SELECT dname , SUM(enroll_count) as enrollnum
FROM(
SELECT D.dname, COUNT(E.stuid) as enroll_count
FROM Department D, Enrolled_in E, Course C
WHERE D.dno = C.dno AND E.cid = C.cid
GROUP BY E.cid
ORDER BY COUNT(E.stuid)) A
GROUP BY dname) B
WHERE enrollnum IN (SELECT MIN(enrollnum) FROM (
SELECT dname , SUM(enroll_count) as enrollnum
FROM( SELECT D.dname, COUNT(E.stuid) as enroll_count
FROM Department D, Enrolled_in E, Course C
WHERE D.dno = C.dno AND E.cid = C.cid
GROUP BY E.cid
ORDER BY COUNT(E.stuid)) A
GROUP BY dname)B);

/*Query 37*/ 
SELECT CONCAT(S.fname, ' ', S.lname) AS StuName, C.cname AS CourseName, CONCAT(F.fname, ' ', F.lname) AS InstructorName, E.grade AS Grade
FROM Student S,  Enrolled_in E, Faculty F,Preferences P, Course C
WHERE S.stuid = P.stuid AND E.cid = C.cid AND F.facid = C.instructor AND E.stuid = S.stuid 
AND P.sleephabits = 'EarlyRiser' AND P.smoking = 'no' AND S.stuid NOT IN (SELECT S2.stuid FROM Student S2, Has_Allergy H WHERE S2.stuid = H.stuid);

/*Query 38*/
SELECT CONCAT(S.fname,' ',S.lname) AS StuName, S.age AS Age
FROM Student S
WHERE S.age = ( SELECT MIN(S.age) FROM Student S )
UNION
SELECT CONCAT(S.fname,' ',S.lname) AS StuName, S.age AS Age
FROM Student S
WHERE S.age = (SELECT MAX(S.age) FROM Student S );

/*Query 39*/
SELECT D.DName AS Department, A.anum AS ANumber, COUNT( E2.StuID ) AS EnrollNumber, CONCAT(ROUND((A.anum / COUNT( E2.StuID) *100),2),'%') AS Percentage
FROM (
SELECT COUNT( E1.stuid ) AS ANum, C1.dno 
FROM Course C1, Enrolled_in E1 
WHERE C1.CID = E1.CID AND E1.Grade IN ( 'A+', 'A', 'A-' ) 
GROUP BY C1.dno) A, Enrolled_in E2, Department D, Course C2 
WHERE A.dno = C2.dno AND E2.CID = C2.CID AND C2.DNO = D.DNO 
GROUP BY C2.dno;

/*Query 40*/
SELECT DISTINCT(CASE WHEN stuname1<stuname2 THEN CONCAT(stuname1,',',stuname2) ELSE CONCAT(stuname2,',',stuname1) END) AS CouresePairs
FROM(
SELECT DISTINCT CONCAT( S1.fname,' ', S1.lname ) AS StuName1, CONCAT( S2.fname, ' ', S2.lname ) AS StuName2 
FROM(
SELECT E1.stuid AS ID1, E2.stuid AS ID2 
FROM Enrolled_in E1, Enrolled_in E2 
WHERE E1.cid = E2.cid AND NOT E1.stuid = E2.stuid) P, Student S1, Student S2 
WHERE S1.stuid = P.id1 AND S2.stuid = P.id2 AND S1.fname = S2.fname) Pair;

/*Query 41*/
SELECT COUNT(*) AS TotalNumber
FROM Student S, Preferences P, Department D
WHERE S.stuid = P.stuid AND P.smoking = 'Yes' AND S.major = D.dno AND D.dname = 'Computer Science'  
AND S.stuid NOT IN ( SELECT DISTINCT L.wholikes FROM Likes L);

/*Query 44*/
SELECT C.cid AS CID, C.cname AS CourseName, C.credits AS Credits, E.grade AS LetGrade, G.gradepoint AS GradePoint
FROM Course C, Student S, Enrolled_in E, Gradeconversion G
WHERE S.stuid = E.stuid AND E.cid = C.cid AND S.fname = 'Bruce' AND S.lname = 'Wilson' AND E.grade = G.lettergrade;

/*Query 45*/
SELECT S.stuid AS StuID, SUM(credits) AS TotalCredit, ROUND(SUM(credits * gradepoint) / SUM(credits),1) AS GPA
FROM (SELECT C.cid AS CID, D.dno, C.credits AS Credits, G.gradepoint AS GradePoint
FROM Course C, Student S, Enrolled_in E, Gradeconversion G, Department D
WHERE S.stuid = E.stuid AND E.cid = C.cid AND S.fname = 'Bruce' AND S.lname = 'Wilson' AND E.grade = G.lettergrade AND D.dno = C.dno) B, Student S
WHERE S.major = B.dno AND S.fname = 'Bruce' AND S.lname = 'Wilson';

/*Query 46*/
SELECT CONCAT(S.fname,' ', S.lname) AS StuName, ROUND(SUM(credits * gradepoint) / SUM(credits),1) AS GPA
FROM (SELECT C.cid AS CID, D.dno, C.credits AS Credits, G.gradepoint AS GradePoint
FROM Course C, Student S, Enrolled_in E, Gradeconversion G, Department D
WHERE S.stuid = E.stuid AND E.cid = C.cid AND E.grade = G.lettergrade AND D.dno = C.dno) B, Student S
WHERE S.major = B.dno
GROUP BY S.stuid;

/*Query 48*/
SELECT D.dormid AS DormID, D.dorm_name AS DormName, AVG(A.gpa) as AvgGPA
FROM (SELECT S.stuid, ROUND(SUM(credits * gradepoint) / SUM(credits),1) AS GPA
FROM (SELECT C.cid AS CID, D.dno, C.credits AS Credits, G.gradepoint AS GradePoint
FROM Course C, Student S, Enrolled_in E, Gradeconversion G, Department D
WHERE S.stuid = E.stuid AND E.cid = C.cid AND E.grade = G.lettergrade AND D.dno = C.dno) B, Student S
WHERE S.major = B.dno
GROUP BY S.stuid) A, Dorm D,Student S, Lives_in L
WHERE A.stuid = S.stuid AND D.dormid = L.dormid AND S.stuid = L.stuid
GROUP BY D.dormid
ORDER BY AVG(A.gpa) DESC;

/*Query 49*/
SELECT A.dno AS Department, A.musictype AS MusicType, A.TotalNumber AS TotalNumber
FROM (SELECT D1.dno, P.musictype, COUNT(S.stuid) AS TotalNumber
FROM (SELECT D.dno
FROM Department D, Student S
WHERE D.dno = S.Major
GROUP BY D.dno
HAVING COUNT(S.stuid) > 3) D1, Student S, Preferences P
WHERE S.stuid = P.stuid AND S.major = D1.dno
GROUP BY D1.dno, P.musictype) A
WHERE NOT EXISTS
(SELECT * FROM (SELECT D1.dno, P.musictype, COUNT(S.stuid) AS TotalNumber
FROM (SELECT D.dno
FROM Department D, Student S
WHERE D.dno = S.Major
GROUP BY D.dno
HAVING COUNT(S.stuid) > 3) D1, Student S, Preferences P
WHERE S.stuid = P.stuid AND S.major = D1.dno
GROUP BY D1.dno, P.musictype) B WHERE B.dno =A.dno  and A.totalnumber<B.totalnumber); 

/*Query 50*/
DROP TABLE GradeMap;
CREATE TABLE GradeMap
(
 LetterGrade VARCHAR(2),
 NextGrade VARCHAR(2)
 );
INSERT INTO GradeMap VALUES ( 'A+', 'A' ),( 'A', 'A-' ),( 'A-', 'B+' ),( 'B+', 'B' ),( 'B', 'B-' ),( 'B-', 'C+' ),( 'C+', 'C' ),( 'C', 'C-' ),( 'C-', 'D+' ), ( 'D', 'D-' ),( 'F', 'F' );	

/*Update: donnot run*/

-- UPDATE Enrolled_in E SET E.grade = G.nextgrade 
-- FROM GradeMap G
-- INNER JOIN GradeMap G ON E.grade = G.lettergrade 
-- WHERE E.stuid IN (
-- SELECT E.stuid
-- FROM Student S, Enrolled_in E, Course C, Faculty F 
-- WHERE S.stuid = E.stuid  AND E.cid = C.cid AND C.instructor = F.facid  AND S.lname = F.lname);

/*Query 52*/
SELECT dormname AS DormName, gender AS Gender
FROM(
SELECT D.dorm_name AS DormName, D.gender AS Gender,B.percentage
FROM Dorm D,(
SELECT A.Trump / COUNT(*) AS percentage, L1.dormid  
FROM Lives_in L1, Student S1,
(SELECT D.dormid, COUNT(L.stuid) AS Trump
FROM Lives_in L, VotedForElectioninUS V, Dorm D 
WHERE L.stuid = V.stuid AND D.dormid = L.dormid AND V.CandidateID IN ( SELECT U.CandidateId FROM USCandidate U WHERE U.candidatename = 'Donald Trump' ) 
GROUP BY D.dormid ) A 
WHERE L1.stuid = S1.stuid AND A.dormid = L1.dormid 
GROUP BY L1.dormid ) B 
WHERE D.dormid = B.dormid) C 
WHERE percentage IN (SELECT MAX(percentage) FROM( SELECT D.dorm_name AS DormName, D.gender AS Gender,B.percentage
FROM Dorm D,(
SELECT A.Trump / COUNT(*) AS percentage, L1.dormid  
FROM Lives_in L1, Student S1,
(SELECT D.dormid, COUNT(L.stuid) AS Trump
FROM Lives_in L, VotedForElectioninUS V, Dorm D 
WHERE L.stuid = V.stuid AND D.dormid = L.dormid AND V.CandidateID IN ( SELECT U.CandidateId FROM USCandidate U WHERE U.candidatename = 'Donald Trump' ) 
GROUP BY D.dormid ) A 
WHERE L1.stuid = S1.stuid AND A.dormid = L1.dormid 
GROUP BY L1.dormid ) B 
WHERE D.dormid = B.dormid) C );

/*Query 53*/
SELECT dorm_name AS DormName, totaloccupancy AS TotalOccupancy, student_capacity AS OfficalCapaacity
FROM(
SELECT D.dorm_name, COUNT(L.stuid) AS TotalOccupancy, D.student_capacity
FROM Dorm D, Lives_in L
WHERE D.dormid = L.dormid
GROUP BY D.dormid) A
WHERE totaloccupancy IN (SELECT MAX(totaloccupancy) FROM (
SELECT D.dorm_name, COUNT(L.stuid) AS TotalOccupancy, D.student_capacity
FROM Dorm D, Lives_in L
WHERE D.dormid = L.dormid
GROUP BY D.dormid) A);

/*Query 54*/
SELECT DISTINCT CONCAT( S.fname,' ', S.lname ) AS StuName, S.age AS Age, C.city_name AS CityName
FROM Lives_in L1, Student S, City C 
WHERE S.stuid = L1.stuid  AND S.city_code = C.city_code  AND L1.dormid = (
SELECT A.dormid
FROM(
SELECT D.dorm_name, D.dormid, COUNT(L.stuid) AS TotalOccupancy
FROM Dorm D, Lives_in L
WHERE D.dormid = L.dormid
GROUP BY D.dormid) A
WHERE totaloccupancy IN (SELECT MAX(totaloccupancy) FROM (
SELECT D.dorm_name, COUNT(L.stuid) AS TotalOccupancy
FROM Dorm D, Lives_in L
WHERE D.dormid = L.dormid
GROUP BY D.dormid) A));

/*Query 55*/
SELECT D.dorm_name AS DormName, D.student_capacity AS OfficalCapacity
FROM Dorm D, Lives_in L
WHERE D.dormid = L.dormid
GROUP BY D.dormid
HAVING COUNT(L.stuid) > D.student_capacity;


/*Query 56*/
SELECT D.dorm_name AS DormName, D.student_capacity AS OfficalCapacity, COUNT(L.stuid) as ActualNumbers, CONCAT((COUNT(L.stuid) - D.student_capacity) / D.student_capacity,'%') AS PercantageAbove
FROM Dorm D, Lives_in L
WHERE D.dormid = L.dormid
GROUP BY D.dormid
HAVING COUNT(L.stuid) > D.student_capacity;

/*Query 59*/
SELECT DISTINCT R.research_area AS ResearchArea, S.major AS Major, CONCAT(S.fname,' ', S.lname) AS StuName
FROM Student S, Researches R, Member_of M, Minor_in M1 
WHERE S.stuid = R.stuid AND (R.facmentorid = M.facid AND NOT S.major = M.dno ) OR (R.stuid = M1.stuid AND NOT M1.dno = M.dno);

/*Query 61*/
SELECT DISTINCT P.stuid AS StuID1, CONCAT(P.fname,' ', P.lname)AS StuName1, S.stuid AS StuID2, CONCAT(S.fname,' ', S.lname) AS StuName2
FROM (SELECT C.stuid, S.fname, S.lname
FROM CovidDiagnosis C, Student S
WHERE C.TestResult = 'Positive' AND C.testdate > DATE_SUB('2020-09-29',INTERVAL 4 DAY) AND C.stuid = S.stuid) P, Student S, Close_Contact JOIN Close_Contact C
WHERE S.stuid = C.stuid1 AND C.stuid2 = P.stuid AND C.minduration <= 30;

/*Query 63*/
SELECT DISTINCT P.stuid AS StuID1, CONCAT( P.fname,' ', P.lname ) AS Stu1Name, S.stuid AS StuID2,CONCAT( S.fname,' ', S.lname ) AS Stu2Name
FROM (SELECT C.stuid, S.fname, S.lname
FROM CovidDiagnosis C, Student S
WHERE C.TestResult = 'Positive' AND C.testdate >= DATE_SUB('2020-09-29',INTERVAL 14 DAY) AND C.stuid = S.stuid) P, Student S, Close_Contact JOIN Close_Contact C
WHERE S.stuid = C.stuid1 AND C.stuid2 = P.stuid AND C.minduration <= 30
UNION
SELECT DISTINCT D.stuid AS StuID1,CONCAT(D.fname, ' ', D.lname ) AS Stu1Name, S.stuid AS StuID2, CONCAT( S.fname, ' ', S.lname ) AS Stu2Name
FROM (SELECT C.stuid,  S.fname, S.lname
FROM CovidDiagnosis C, Student S
WHERE C.TestResult = 'Positive' AND C.testdate >= DATE_SUB('2020-09-29',INTERVAL 14 DAY) AND C.stuid = S.stuid) D, Student S, Participates_in P1, Participates_in P2
WHERE S.stuid = P1.stuid AND D.stuid = P2.stuid AND P1.actid = P2.actid AND NOT P1.stuid = D.stuid;


/*Query 65*/
SELECT DISTINCT F.facid AS ProfID, CONCAT(F.fname,' ',F.lname) AS ProfName
FROM Course C, Faculty F
EXCEPT
SELECT DISTINCT F.facid AS ProfID, CONCAT(F.fname,' ',F.lname) AS ProfName
FROM Course C, Slept_In_Class S, Faculty F
WHERE C.cid =  S.cid AND F.facid = C.instructor;

/*Query 66*/
SELECT CONCAT(S.fname,' ',S.lname) as StuName, S.age AS Age, D.dname AS Major
FROM Student S, Department D,
( SELECT E1.stuid FROM Enrolled_in E1
EXCEPT
SELECT E.stuid FROM Enrolled_in E,Course C, Department D
WHERE E.cid = C.cid AND C.dno = D.dno AND D.dname = 'Computer Science' ) A
WHERE S.stuid = A.stuid AND S.major = D.dno;

/* Query 67*/
SELECT CONCAT( S.fname,' ', S.lname ) AS StuName, S.age AS Age, D.dname AS Major
FROM Student S, Enrolled_in E, Department D
WHERE S.stuid = E.stuid AND D.dno = S.major 
GROUP BY S.stuid 
HAVING COUNT(E.cid) = (SELECT COUNT(C.cid) FROM Course C, Department D 
WHERE C.dno = D.dno AND D.dname = 'Computer Science' );

/*Query 69*/
SELECT CONCAT(S.fname,' ', S.lname) AS StuName, S.age AS Age, D.dname AS Major, C.cid AS CourseNum, C.cname AS CourseName, E.grade AS Grade 
FROM Enrolled_in E, Gradeconversion G, Student S, Department D, Course C 
WHERE E.grade = G.lettergrade  AND S.stuid = E.stuid AND S.major = D.dno AND E.cid = C.cid 
AND G.gradepoint >= ALL (
SELECT G.gradepoint 
FROM Enrolled_in E1, Gradeconversion G1 
WHERE E1.Grade = G1.lettergrade AND E.cid = E1.cid );

/*Query 70*/
SELECT CONCAT(S.fname,' ',S.lname) AS StuName, S.age AS Sex, D.dname AS Major, COUNT(E.cid) AS TotalNum
FROM Enrolled_in E, Course C, Department D, Student S
WHERE S.stuid = E.stuid AND C.dno = D.dno AND E.cid = C.cid AND D.dname = 'Computer Science' 
GROUP BY E.stuid 
HAVING COUNT(E.cid) >= 2;

/*Query 71*/
/* List the Student ID, sex, Student name, and city name he/she lives in, for all the students who have worked at McDonald's after 2019 and spent the most of the time(hours per week) on Football. */
SELECT DISTINCT S.stuid AS StuID, CONCAT(S.fname,' ', S.lname) AS StuName, S.sex AS Sex, C.city_name AS City
FROM Student S, City C, Worked_at W
WHERE S.city_code = C.city_code AND S.stuid = W.stuid AND W.company = 'Microsoft'
AND W.start_date > '2019-01-01' AND S.stuid = (
SELECT stuid
FROM(
SELECT S.stuid, S.hoursperweek
FROM SportsInfo S
WHERE S.sportname = 'Football'
GROUP BY S.stuid) A
WHERE hoursperweek IN (SELECT MAX(hoursperweek) FROM ( SELECT S.stuid, S.hoursperweek
FROM SportsInfo S
WHERE S.sportname = 'Football'
GROUP BY S.stuid) B));