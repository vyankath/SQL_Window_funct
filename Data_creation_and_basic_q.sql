create database stu_score;
use stu_score;
DROP TABLE IF EXISTS student_score;

CREATE TABLE student_score (
  student_id SERIAL PRIMARY KEY,
  student_name VARCHAR(30),
  dep_name VARCHAR(40),
  score INT
);

INSERT INTO student_score VALUES (11, 'Ibrahim', 'Computer Science', 80);
INSERT INTO student_score VALUES (7, 'Taiwo', 'Microbiology', 76);
INSERT INTO student_score VALUES (9, 'Nurain', 'Biochemistry', 80);
INSERT INTO student_score VALUES (8, 'Joel', 'Computer Science', 90);
INSERT INTO student_score VALUES (10, 'Mustapha', 'Industrial Chemistry', 78);
INSERT INTO student_score VALUES (5, 'Muritadoh', 'Biochemistry', 85);
INSERT INTO student_score VALUES (2, 'Yusuf', 'Biochemistry', 70);
INSERT INTO student_score VALUES (3, 'Habeebah', 'Microbiology', 80);
INSERT INTO student_score VALUES (1, 'Tomiwa', 'Microbiology', 65);
INSERT INTO student_score VALUES (4, 'Gbadebo', 'Computer Science', 80);
INSERT INTO student_score VALUES (12, 'Tolu', 'Computer Science', 67);

----------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------
-- Find the max, min and average score of students in each department.
SELECT 
    dep_name,
    MAX(score) AS ms,
    MIN(score) AS mis,
    ROUND(AVG(score), 2)
FROM
    student_score
GROUP BY dep_name;
-------------------------------------------------------------------------------------------
-- List students whose score is greater than the average score of their department.
SELECT 
    *
FROM
    student_score
WHERE
    score > (SELECT 
            AVG(score)
        FROM
            student_score s2
        WHERE
            s2.dep_name = student_score.dep_name);
---------------------------------------------------------------------------------------------
-- Write a query to count how many students are in each department.
SELECT 
    dep_name, COUNT(student_id) AS no_of_students
FROM
    student_score
GROUP BY dep_name;
----------------------------------------------------------------------------------------------
-- Find departments where the average score is greater than 80.
SELECT 
    dep_name, AVG(score) AS avg_score
FROM
    student_score
GROUP BY dep_name
HAVING avg_score > 75;
-----------------------------------------------------------------------------------------------
-- List the departments with the highest individual score.
SELECT 
    dep_name, MAX(score) AS max_score
FROM
    student_score
GROUP BY dep_name
HAVING MAX(score) = (SELECT 
        MAX(score)
    FROM
        student_score);