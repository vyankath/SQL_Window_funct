-- Window Functions:-
SELECT * FROM student_score;
-- Find the highest and lowest score in the dataset.
SELECT * , 
          MAX(score) over() as max_score,
          MIN(score) over() as min_score
from student_score;
-- Find the highest and lowest score in the dataset from each department.
SELECT * , 
		 MAX(score) over(partition by dep_name) as max_dscore,
         MIN(score) over(partition by dep_name) as min_dscore
from student_score;
------------------------------------------------------------------------------

-- Calculate the row number for each student based on their score.
select *,
         row_number() OVER(ORDER BY student_name) as alph_name
from student_score;
-- Calculate the row number for each student based on their score by each department.
select *,
         row_number() OVER(partition by dep_name ORDER BY student_name) as alph_name
from student_score;
-------------------------------------------------------------------------------------
-- Calculate the rank of each student based on their score.
SELECT *,
         RANK() OVER(ORDER BY score DESC) as over_all_rank
from student_score;
------------------------------------------------------------
SELECT *,
         DENSE_RANK() OVER(ORDER BY score DESC) as over_all_drank
from student_score;

-- Calculate the department wise rank of each student based on their score.
select *,
         rank() over(partition by dep_name order by score desc) as dep_wise_rank
from student_score; -- duplicates the rank
--------------------------------------------------------------
select *,
         dense_rank() over(partition by dep_name order by score desc) as dep_wise_drank
from student_score;
---------------------------------------------------------------------------------------
-- Compute the average score of students for each department.
select *,
        avg(score) over(partition by dep_name) as avg_dscore
 from student_score;
 ----------------------------------------------------------------------------------------
  -- Find the cumulative score across all students from each department.
SELECT *,
		AVG(score) over(partition by dep_name order by score) as cum_dscore
from student_score;
--------------------------------------------------------------------------------------
 -- Find the cumulative average score across all students.
 SELECT *,
         AVG(score) over(order by score) as cum_avg_score 
from student_score;
---------------------------------------------------------------------------------------
-- Calculate the difference between each student’s score and the average score for their department.
SELECT *,
		AVG(score) over(partition by dep_name) as avg_score,
        score - avg(score) over(partition by dep_name) as diff_avg_mark
from student_score;
-----------------------------------------------------------------------------------------
-- Display the top scorer in each department using ROW_NUMBER
select * from (select *,
        row_number() OVER(partition by dep_name order by score desc) as row_no
from student_score) as stud_row_rank
where row_no = 1;
-----------------------------------------------------------------------------------------
-- Get the lag (previous score) for each student.
select *,
        lag(score) over(order by score) lag_score
from student_score;
-- Get the lag (previous score) for each student department wise.
select *,
        lag(score) over(partition by dep_name order by score) as lag_dscore
from student_score;
-- similarly usning lead we can find next student's score as well (put lead insted of lag) 
-----------------------------------------------------------------------------
-----------------------------------------------------------------------------
-- Calculate the difference between each student’s score and the highest score in their department.
select *,
        MAX(score) over(partition by dep_name) as max_score,
        MAX(score) over(partition by dep_name) - score as score_diff
from student_score;
------------------------------------------------------------------------------
-- Find the moving average of scores over the last 3 students (ordered by student_id).
SELECT *,
        AVG(score) over(partition by dep_name order by student_id ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) as moving_avg
from student_score;
/* A moving average (also known as a rolling average or running average) is a statistical technique used to smooth out data points by calculating the average of a specific 
   number of consecutive data points in a dataset. It "moves" across the data to give insight into trends over time or across rows.
   (student scores), a 3-row moving average calculates the average of the current student's score and the scores of the previous 2 students (within the same department).
   Why Use ROWS BETWEEN? The ROWS BETWEEN clause defines the window of rows used to calculate the moving average. It specifies how many*/
-----------------------------------------------------------------------------------------
-- Find the cumulative sum of scores for each department.
SELECT *,
        SUM(score) over(partition by dep_name order by student_id) as cum_dsum
from student_score;
/* Running Total:- The cumulative sum of all previous rows up to the current row.
   Moving Total (Moving Average):- The sum/average over a sliding window of rows (previous and/or)*/
-----------------------------------------------------------------------------------------
-- For each student, calculate the percentage of their score compared to the department’s total score.
select *,
        (score * 100) / sum(score) over(partition by dep_name) as perc_score
from student_score;
------------------------------------------------------------------------------------------
-- Calculate the difference between each student’s score and the next student’s score.
select *,
        score - lead(score) over(partition by dep_name order by student_id) as lead_diff
from student_score;
-----------------------------------------------------------------------------------------
-- Compute the average score of the top 3 students in each department.
with ranked_score as 
(select *,
        row_number() over(partition by dep_name order by score desc) dep_score_row
from student_score)
select dep_name, avg(score) as avg_dscore
from ranked_score
where dep_score_row <=3
group by dep_name;
----------------------------------------------------------------------------------------
-- Find the department-wise top scorer using NTILE to split the department scores into 2 groups (high and low).
SELECT *,
        NTILE(2) OVER (PARTITION BY dep_name ORDER BY score DESC) AS performance_group 
FROM student_score;
/*The NTILE() function in SQL is a window function that distributes rows of a result set into a specified number of roughly equal buckets or tiles. 
  It is used to divide a dataset into n buckets (tiles), where each row is assigned a bucket number from 1 to n.
  The purpose of NTILE() is to rank the rows and divide them into groups, which can be useful for performing analysis based on percentile ranks or for equally distributing rows
  into groups for further comparison.*/
----------------------------------------------------------------------------------------
-- Calculate the highest score of the previous 2 students (using ROWS BETWEEN)
select *,
		max(score) OVER(partition by dep_name order by student_id rows between 2 preceding and current row ) as max_prev_2 
from student_score;
----------------------------------------------------------------------------------------
-- Assign rank to students and break ties based on student_name in case of a score tie (use RANK and student_name).
SELECT student_id, student_name, score, RANK() OVER (ORDER BY score DESC, student_name) AS ranks -- due to use of student_name in order by dupictae ranks got eliminated
FROM student_score;
----------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------
-- Find students whose scores are above the overall 75th percentile, using PERCENT_RANK. 
select student_name,score from 
(SELECT *, 
        percent_rank() OVER(order by score desc) as percent_score
from student_score) as perent_rank
where percent_score > 0.50;