SELECT *
FROM employee_demographics;

SELECT first_name,
 last_name,
 birth_date,
 age,
 (age + 10) * 10
FROM parks_and_recreation.employee_demographics;


SELECT DISTINCT gender
FROM parks_and_recreation.employee_demographics;


## WHERE CLAUSE
 SELECT *
 FROM employee_salary
 WHERE first_name='Leslie';
 
 SELECT *
 FROM employee_salary
 WHERE salary > 50000;
 
SELECT *
FROM employee_demographics
WHERE gender = 'Female';

SELECT *
FROM employee_demographics
WHERE  birth_date > '1990-01-01';

## LOGICAL OPERATORS  AND & OR & NOT
SELECT *
FROM employee_demographics
WHERE  birth_date > '1990-01-01'
AND gender = 'Female';


SELECT *
FROM employee_demographics
WHERE  birth_date > '1990-01-01'
OR NOT gender = 'Female';



-- LIKE STATEMENT---
SELECT *
FROM employee_demographics
WHERE  (first_name = 'Leslie' AND age = 44) or age > 50;

SELECT *
FROM employee_demographics
WHERE  first_name LIKE 'a%' ;

SELECT *
FROM employee_demographics
WHERE  first_name LIKE 'a__';

SELECT *
FROM employee_demographics
WHERE  first_name LIKE 'a___';

SELECT *
FROM employee_demographics
WHERE  first_name LIKE 'a_%';

SELECT *
FROM employee_demographics
WHERE  birth_date LIKE '1988%s';



--- GROUP BY ---
SELECT gender
FROM employee_demographics
GROUP BY gender;

SELECT gender, AVG(age),MAX(age), min(age), count(age)
FROM employee_demographics
GROUP BY gender;

-- ORDER  BY ---
SELECT *
FROM employee_demographics
ORDER BY  first_name ASC;

SELECT *
FROM employee_demographics
ORDER BY  first_name DESC;

SELECT *
FROM employee_demographics
ORDER BY  gender,age ASC;

SELECT *
FROM employee_demographics
ORDER BY  5,4;


-- HAVING---
SELECT gender,Avg(age)
FROM employee_demographics
GROUP BY  gender
HAVING AVG(age) > 40 ;


 SELECT occupation, AVG(salary)
 FROM employee_salary
 WHERE occupation  LIKE '%manager%'
 GROUP BY occupation
 HAVING AVG(salary) > 70000;


-- LIMITING AND ALIASING --

SELECT *
FROM employee_demographics
ORDER BY Age DESC
LIMIT 3;


SELECT *
FROM employee_demographics
ORDER BY Age DESC
LIMIT 2,1;    ## @ position 2 on the table the next row


-- ALIASING---
SELECT gender, avg(age) as Avg_age
FROM employee_demographics
GROUP BY gender
HAVING Avg_age > 40;

-- JOINS ---

# INNER JOINS

SELECT *
FROM employee_demographics AS dem 
INNER JOIN employee_salary AS Sel
	ON dem.employee_id = Sel.employee_id;    		# indentation not necessary

SELECT dem.employee_id, age, occupation
FROM employee_demographics AS dem 
INNER JOIN employee_salary AS Sel
	ON dem.employee_id = Sel.employee_id;

-- OUTER JOINS--
SELECT *
FROM employee_demographics AS dem 
LEFT JOIN employee_salary AS Sel
	ON dem.employee_id = Sel.employee_id;

SELECT *
FROM employee_demographics AS dem 
RIGHT JOIN employee_salary AS Sel
	ON dem.employee_id = Sel.employee_id;



-- SELF JOIN-
SELECT *
FROM employee_salary  AS emp1
JOIN employee_salary AS emp2
ON emp1.employee_id = emp2.employee_id;

SELECT *
FROM employee_salary  AS emp1
JOIN employee_salary AS emp2
ON emp1.employee_id + 1 = emp2.employee_id;


SELECT *
FROM employee_salary  AS emp1
JOIN employee_salary AS emp2
ON emp1.employee_id = emp2.employee_id;	

SELECT emp1.employee_id AS emp_santa,
emp1.first_name AS first_name_santa,
emp1.last_name AS last_name_santa,
emp2.employee_id AS em_santa,
emp2.first_name AS first_name_santa,
emp2.last_name AS last_name_santa
FROM employee_salary  AS emp1
JOIN employee_salary AS emp2
ON emp1.employee_id = emp2.employee_id;


-- JOINING MULTIPLETABLES TOGETHER--

SELECT *
FROM employee_salary  AS emp1
INNER JOIN employee_salary AS emp2
	ON emp1.employee_id = emp2.employee_id
INNER JOIN parks_departments AS pd
	ON emp2.dept_id = pd.department_id
    ;
    
    
    -- UNION --
    
    SELECT *
    FROM employee_demographics
    UNION   				# union(Distinct)
    SELECT *
    FROM employee_salary;
    
    
    SELECT first_name, last_name
    FROM employee_demographics
    UNION
    SELECT first_name, last_name
    FROM employee_salary;
    
    SELECT first_name, last_name,  'Old Man'
    FROM employee_demographics
    WHERE age > 40 AND gender = 'Male'
    UNION
    SELECT first_name, last_name, 'Old Lady'
    FROM employee_demographics
    WHERE age > 40 AND gender = 'Female'
    UNION
    SELECT first_name, last_name, 'Highly Paid Employee'
    FROM employee_salary
    WHERE salary > 70000
    ORDER BY first_name
    ;
    
    
    -- LENGTH --
SELECT first_name, length(first_name)
FROM employee_demographics;

-- UPPER CASE --

SELECT first_name, UPPER(first_name)
FROM employee_demographics;

 -- LOWER CASE --
SELECT first_name, lower(first_name)
FROM employee_demographics;

-- TRIM --
SELECT LTRIM ('             SKY         ');        # LEFT TRIM
SELECT RTRIM ('             SKY         ');			# RIGHT TRIMs



-- ITERATE ---
SELECT first_name, 
LEFT(first_name,3),
RIGHT(first_name,3)
FROM employee_demographics;


-- SUBSTRING--

SELECT first_name,
LEFT(first_name, 3),
RIGHT(last_name, 3),
SUBSTRING(first_name,3,2),
birth_date,
SUBSTRING(birth_date,6,2) AS birth_Month
FROM employee_demographics;


-- REPLACE--

SELECT first_name, REPLACE (first_name, 'a','z')
FROM employee_demographics;


-- LOCATE --

SELECT LOCATE('x', 'Alenxander');

-- CONCATINATE --
SELECT first_name, last_name,
CONCAT(first_name,' ', last_name) AS FULL_NAME
FROM employee_demographics;


-- CASE STATEMENT --
SELECT first_name, last_name, age,
CASE
WHEN age <= 30 THEN 'YOUNG'
WHEN age BETWEEN 30 AND 50 THEN 'OLD'
WHEN age >=50 THEN "ON DEATH DOOR " 
END as AGE_BRACKET

	
FROM employee_demographics;


-- PAY INCREASE AND BONUS
-- < 50000 = 5%
-- > 50000 = 7%
-- FINANCE = 10%

SELECT first_name, last_name, salary,
CASE 
	WHEN salary < 50000 THEN salary * 1.05
    WHEN salary > 50000 THEN salary * 1.07
END AS NEW_SALARY,
CASE 
	WHEN dept_id  = 6 THEN salary*0.10
END  AS BONUS 
FROM employee_salary
;


-- SUBQUERIES--
SELECT *
FROM employee_demographics
WHERE employee_id IN (
						SELECT employee_id
                        FROM employee_salary
                        WHERE dept_id =1
)
;
SELECT first_name, last_name,salary,
(SELECT AVG(salary)
FROM employee_salary
)
FROM employee_salary;


SELECT gender, max(age), min(age), AVG(age), COUNT(age)
FROM employee_demographics
GROUP BY gender;

SELECT  AVG(`max(age)`)
FROM (
SELECT gender,
 max(age),
 min(age),
 AVG(age),
 COUNT(age)
FROM employee_demographics
GROUP BY gender
)  AS agg_table
;

SELECT  AVG(max_age)
FROM (
SELECT gender,
 max(age) AS max_age,
 min(age) AS min_age,
 AVG(age) AS avg_age,
 COUNT(age) AS count_age
FROM employee_demographics
GROUP BY gender
)  AS agg_table
;


-- WINDOW FUNCTION --
SELECT gender, avg(salary) as avg_salary
FROM employee_demographics AS dem
JOIN  employee_salary AS sal
	ON  dem.employee_id = sal.employee_id
    GROUP BY gender
    
    ;
    
SELECT dem.first_name,dem.last_name, gender,salary, 
SUM(salary) OVER (PARTITION BY gender ORDER BY dem.employee_id) as ROLLING_TOTAL
FROM employee_demographics AS dem
JOIN  employee_salary AS sal
	ON  dem.employee_id = sal.employee_id    
    ;
    
SELECT dem.first_name, dem.last_name,dem.employee_id, gender, salary,
ROW_NUMBER() OVER(PARTITION BY gender ORDER BY salary DESC) AS row_num,
RANK() OVER(PARTITION BY gender ORDER BY salary DESC) AS rank_num,
DENSE_RANK() OVER(PARTITION BY gender ORDER BY salary DESC) AS dense_rank_num

FROM employee_demographics as dem
JOIN employee_salary as sal
	ON dem.employee_id = sal.employee_id;
    
    
-- CTEs ---
WITH CTE_Example AS 
(
SELECT gender,AVG(salary) AS avg_sal,MAX(salary) AS max_sal, MIN(salary) AS min_sal,COUNT(salary) AS count_sal
FROM employee_demographics AS dem
JOIN employee_salary AS sal
	ON sal.employee_id = dem.employee_id
    GROUP BY gender
    )
   SELECT AVG(avg_sal)
   FROM CTE_Example
;

WITH CET_example001 AS
(SElECT employee_id, gender, birth_date
FROM employee_demographics
 WHERE birth_date > '1985-01-01'
 ), 
CET_example002 AS
 (
 SELECT employee_id, salary
 FROM employee_salary
 WHERE salary > 50000
 )
 SELECT *
 FROM CET_example001
 JOIN CET_example002
	ON CET_example001.employee_id = CET_example002.employee_id
;

WITH CTE_Example(Gender,AVG_sal, MAX_sal,MIN_sal,Count_sal) AS 
(
SELECT gender,AVG(salary),MAX(salary), MIN(salary),COUNT(salary) 
FROM employee_demographics AS dem
JOIN employee_salary AS sal
	ON sal.employee_id = dem.employee_id
    GROUP BY gender
    )
   SELECT *
   FROM CTE_Example
;

-- TEMPORARY TABLES --
CREATE TEMPORARY TABLE Temp_tables(
First_name  Varchar(50),
last_name Varchar(50),
favourite_movie varchar(100)
)
;
SELECT *
FROM Temp_tables;

INSERT INTO Temp_tables
VALUES ('Alex', 'Fredige', 'Avengers: The Endgame');

SELECT *
FROM Temp_tables; 

CREATE TEMPORARY TABLE  salary_over_50k
SELECT *
FROM employee_salary
WHERE salary >= 50000;

SELECT *
FROM salary_over_50k;



-- STORE PROCEDURE ---

CREATE PROCEDURE large_salaries()
SELECT * 
FROM employee_salary
WHERE salary >= 50000;
SELECT *
FROM employee_salary
WHERE salary >= 10000;


DELIMITER $$
CREATE PROCEDURE large_salaries2()
BEGIN
	SELECT *
    FROM employee_salary
    WHERE salary >= 50000;
    SELECT *
    FROM employee_salary
    WHERE salary >= 10000;
END $$
DELIMITER ;
CALL large_salaries2


DELIMITER $$
CREATE PROCEDURE large_salaries1(p_employee_id INT	)
BEGIN
	SELECT salary
    FROM employee_salary
    WHERE employee_id = p_employee_id ;
END $$
DELIMITER ;
CALL large_salaries1(2)


-- TRIGGER ---

DELIMITER $$
CREATE TRIGGER employee_insert
	AFTER INSERT ON employee_salary
    FOR EACH ROW
BEGIN
	INSERT INTO employee_demographics(employee_id, first_name, last_name)
    VALUE (NEW.employee_id, NEW.first_name, NEW.last_name);
END $$
DELIMITER ;

INSERT INTO employee_salary (employee_id, first_name, last_name, salary, dept_id)
VALUE("13", "ADEKUNLE", "ADELERU", "1000000", NULL);

SELECT *
FROM employee_salary;



DELIMITER $$
CREATE EVENT delete_retirees
ON SCHEDULE EVERY 30 SECOND
DO
BEGIN
	DELETE
    FROM employee_demographics
    WHERE age >=60;

END $$

DELIMITER ;

SELECT *
FROM employee_demographics;



