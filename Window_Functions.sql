DROP TABLE IF EXISTS STUDENTS;

CREATE TABLE students (
    student_id INT,
    subject VARCHAR(20),
    score INT
);

INSERT INTO students (student_id, subject, score) VALUES
(1, 'Math', 85),
(1, 'English', 92),
(1, 'Science', 87),
(2, 'Math', 91),
(2, 'English', 88),
(2, 'Science', 93),
(3, 'Math', 78),
(3, 'English', 85),
(3, 'Science', 90),
(4, 'Math', 92),
(4, 'English', 86),
(4, 'Science', 89),
(5, 'Math', 90),
(5, 'English', 88),
(5, 'Science', 85),
(6, 'Math', 93),
(6, 'English', 82),
(6, 'Science', 90);

select * from students;

DROP TABLE IF EXISTS SALARIES;

CREATE TABLE salaries (
    id INT,
    name VARCHAR(20),
    city VARCHAR(20),
    dept VARCHAR(20),
    salary FLOAT
);

INSERT INTO SALARIES (id, name, city, dept, salary) VALUES
(21, 'Dhanya', 'Chennai', 'hr', 75),
(22, 'Bob', 'London', 'hr', 71),
(31, 'Akira', 'Chennai', 'it', 89),
(32, 'Grace', 'Berlin', 'it', 60),
(33, 'Steven', 'London', 'it', 103),
(34, 'Ramesh', 'Chennai', 'it', 103),
(35, 'Frank', 'Berlin', 'it', 120),
(41, 'Cindy', 'Berlin', 'sales', 95),
(42, 'Yetunde', 'London', 'sales', 95),
(43, 'Alice', 'Berlin', 'sales', 100);



/*Aggregate Window Functions*/
/*How to compute the average score for each student (and have the average shown as a separate column)?*/

SELECT *, 
AVG(score) OVER (PARTITION BY student_id) average_score
FROM students;

/* 
Aggregation functions used with Window functions
1.min(value): returns the minimum value across all window rows
2.max(value): returns the maximum value
3.count(value): returns the count of non-null values
4.avg(value): returns the average value
5.sum(value): returns the sum total value
6.group_concat(value, separator): returns a string combining values using separator (SQLite and MySQL only)
*/

/*Ranking*/
/*How to rank the students in descending order of their Total Score and score?. Where, Total score is the sum of scores in all three subjects.*/

WITH CTE AS (
SELECT *,
AVG(score) OVER (Partition BY student_id) average_score,
sum(score) OVER (Partition BY student_id) sum_score
FROM students)

SELECT *, RANK() OVER (order by sum_score DESC, score desc) as srank
FROM CTE

/*
Ranking Functions
1.row_number(): returns the row ordinal number
2.dense_rank(): returns row rank
3.rank(): returns row rank with possible gaps (see below)
4.ntile(n): splits all rows into n groups and returns the index of the group that the row belongs to
*/

/*How to find the percentage diff increase in salaries of employees one row above?*/

with sal_lag AS (SELECT *,
lag(salary) over (order by id asc) as prev_salary
FROM salaries)

SELECT *, round(((salary/prev_salary)-1)*100,2) as perc_diff
FROM sal_lag

/*How to compute the perc difference between the min and max values of salary in each department, while keeping the entries ordered by salary?*/

WITH min_max as (
SELECT *, 
min(salary) over (partition by dept order by salary asc) as min_salary,
max(salary) over (partition by dept order by dept) as max_salary
FROM salaries)

SELECT *,
round(((min_salary/max_salary)-1)*100,2) as perc_diff
FROM min_max

/* 
Offset functions
1.lag(value, offset): returns the value from the record that is offset rows behind the current one
2.lead(value, offset): returns the value from the record that is offset rows ahead of the current one
3.first_value(value): returns the value from the first row of the frame
4.last_value(value): returns the value from the last row of the frame
5.nth_value(value, n): returns the value from the n-th row of the frame
*/

/* Rolling Aggregates with ROWS BETWEEN clause */
/* Compute difference between the minimum and the second last value. */
/* CTE Example */

WITH min_max as (
SELECT *, 
min(salary) over (partition by dept order by salary asc) as min_salary,
max(salary) over (partition by dept order by dept) as max_salary,
count(*) over (partition by dept order by dept) as cnt
FROM salaries)

,CTE AS (SELECT *,
min_salary,
nth_value(salary, cnt-1) over (partition by dept order by dept) as last_minus_1
FROM min_max)

SELECT *,
(last_minus_1 - min_salary) as DIFF
FROM CTE

/* Rows Between Example */
/*
Understanding ROWS BETWEEN Clause
The syntax is:
ROWS BETWEEN <lower_bound> AND <upper_bound>
The purpose of the ROWS clause is to specify the starting and the ending row of the frame in relation to the ‘current row’.

Starting and ending rows might be fixed or relative to the current row based on the following keywords:

1.CURRENT ROW: the current row
2.UNBOUNDED PRECEDING: all rows before the current row -> fixed
3.UNBOUNDED FOLLOWING: all rows after the current row -> fixed
4.‘n’ PRECEDING: ‘n’ rows before the current row -> relative
5.‘n’ FOLLOWING: ‘n’ rows after the current row -> relative

Example 1: ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING: Frame would include the entire window for each iteration.
Example 2: ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW: would include from 1st row in window to current row.
Example 3: ROWS BETWEEN UNBOUNDED PRECEDING AND 2 PRECEDING: would include from 1st row in window to 2 rows BEFORE the current row.
Example 4: ROWS BETWEEN UNBOUNDED PRECEDING AND 3 FOLLOWING: would include from 1st row in window to 3 rows AFTER the current row.
*/

with tmp as (
select id, 
        name, 
        city, 
        dept, 
        salary,
        first_value(salary) over (partition by dept order by salary asc) as min_salary,
        last_value(salary) over (partition by dept 
                                 order by salary 
                                 rows between unbounded preceding and unbounded following) as max_salary,
        count(*) over (partition by dept 
                                 order by salary 
                                 rows between unbounded preceding and unbounded following) as count
from salaries)
, tmp2 as (select id,name,city,dept,salary,
        min_salary, 
        nth_value(salary, count-1) over (partition by dept 
                                         order by salary
                                        rows between unbounded preceding and unbounded following) as last_minus_1_salary
from tmp)

SELECT *, (last_minus_1_salary - min_salary) as DIFF 
FROM tmp2;
