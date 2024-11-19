/* Write a solution to report all the employees with their primary department. 
For employees who belong to one department, report their only department.
Return the result table in any order.*/

WITH t1 AS (
			SELECT 	*, COUNT(*) OVER(PARTITION BY employee_id) cnt 
			FROM Employee
			)

SELECT employee_id, department_id
FROM t1
WHERE (cnt=1) OR (cnt<>1 AND primary_flag='Y');

-- Second aproach
(SELECT employee_id, max(department_id) department_id
FROM Employee
GROUP BY employee_id
HAVING COUNT(employee_id) = 1)

UNION

(SELECT employee_id, department_id
FROM Employee
WHERE primary_flag = 'Y')

ORDER BY employee_id;

-- 610. Triangle Judgement
-- La suma de dos de sus lados debe ser mayor a la longitud del tercer lado
SELECT 	*, 
		CASE WHEN x+y > z and x+z > y and y+z > x
		THEN 'Yes' ELSE 'No' 
		END AS triangle 
		-- IIF(x + y > z AND x + z > y AND y + z > x, 'Yes', 'No') AS triangle
FROM triangle;


-- 180. Consecutive Numbers
-- Find all numbers that appear at least three times consecutively.

SELECT DISTINCT l1.num AS ConsecutiveNums
FROM Logs l1
JOIN Logs l2 ON l1.id = l2.id - 1
JOIN Logs l3 ON l1.id = l3.id - 2
WHERE l1.num = l2.num AND l2.num = l3.num;


-- 1164. Product Price at a Given Date
SELECT
    product_id,
    MAX(new_price) OVER (PARTITION BY product_id ORDER BY change_date DESC) AS price
FROM Products
WHERE change_date <= '2019-08-16'

UNION

SELECT
    product_id,
    10 AS price
FROM Products
GROUP BY product_id
HAVING MIN(change_date) > '2019-08-16'

-- 1204. Last Person to Fit in the Bus

-- Hay que encontrar en orden de turn, los pesos de las personas que van subiendo.

WITH t1 AS (
    SELECT 
    turn, 
    person_name, 
    weight, 
    SUM(weight) OVER (ORDER BY turn ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS total_weight
    FROM Queue
    -- ORDER BY turn
)

SELECT TOP 1 person_name
FROM t1 
GROUP BY person_name,total_weight
HAVING MAX(total_weight) <= 1000
ORDER BY total_weight DESC;

-- Solucion leetcode
with cs as (
  select *,
    sum(weight) over(order by turn) as cum_sum
  from queue
)
select person_name from cs
where cum_sum = (select max(cum_sum) from cs where cum_sum <= 1000);


-- 1907. Count Salary Categories
/* Write a solution to calculate the number of bank accounts for each salary category. The salary categories are:
"Low Salary": All the salaries strictly less than $20000.
"Average Salary": All the salaries in the inclusive range [$20000, $50000].
"High Salary": All the salaries strictly greater than $50000.
The result table must contain all three categories. 
If there are no accounts in a category, return 0.*/

SELECT 'Low Salary' AS category, COUNT(*) AS accounts_count 
FROM Accounts
WHERE income < 20000

UNION

SELECT 'Average Salary' AS category, COUNT(*) AS accounts_count 
FROM Accounts
WHERE income BETWEEN 20000 AND 50000

UNION

SELECT 'High Salary' AS category, COUNT(*) AS accounts_count 
FROM Accounts
WHERE income > 50000

-- SOLUCION leetcode

SELECT 
    b.category
    ,COUNT(account_id)  accounts_count
FROM Accounts a
RIGHT OUTER JOIN (VALUES('Low Salary'),('High Salary'),('Average Salary')) AS b(category) 
    ON CASE WHEN income < 20000 THEN 'Low Salary'
        WHEN income > 50000 THEN 'High Salary'
        ELSE 'Average Salary' END = b.category
GROUP BY b.category


-- 1978. Employees Whose Manager Left the Company
SELECT employee_id
FROM employees
WHERE salary < 30000 AND manager_id NOT IN(select employee_id from employees); 


-- 626. Exchange Seats
SELECT 
	CASE 	WHEN id%2 = 0 THEN id-1
			WHEN id%2 <> 0 AND id < (SELECT MAX(id) FROM seats) THEN id+1 
			ELSE id END as id
	, student
FROM Seat
ORDER BY id;


-- 1341. Movie Rating
WITH 	conteo AS (
			SELECT user_id, COUNT(user_id) AS veces
			FROM movierating
			GROUP BY user_id
),
		ratings AS (
			SELECT movie_id, AVG(rating*10) AS avg_rating
			FROM movierating
			GROUP BY movie_id
)

-- Primer subconsulta para obtener la película con el mayor puntaje promedio
, 		top_movie AS (
			SELECT TOP 1 title AS results
			FROM movies m
			JOIN ratings r ON m.movie_id = r.movie_id
			where mr.created_at between '2020-02-01' and '2020-02-29'
			GROUP BY title, avg_rating
			ORDER BY avg_rating DESC
)

-- Segunda subconsulta para obtener el usuario que más ha calificado
, 		top_user AS (
			SELECT TOP 1 u.name
			FROM users u
			JOIN t1 ON t1.user_id = u.user_id
			GROUP BY u.name, veces
			HAVING MAX(veces) = veces
			ORDER BY veces DESC
)

-- Combina los resultados con UNION ALL
SELECT results FROM top_movie
UNION ALL
SELECT name FROM top_user;



-----------------------------------------------------------------------------

/* Write your T-SQL query statement below */
with 	small_user as (
			select top 1 name as results
			from(
				select mr.movie_id, u.user_id, m.title, mr.rating, u.name
				from movierating mr
				join movies m
				on mr.movie_id = m.movie_id
				join users u
				on mr.user_id = u.user_id) as t1
			group by t1.user_id, t1.name
			order by count(t1.user_id) desc, t1.name
),
		peli_alta as (
			select top 1 title as results
			from (
				select m.title, avg(mr.rating*10) as rating
				from MovieRating mr 
				join Movies m 
				on mr.movie_id = m.movie_id 
				where mr.created_at between '2020-02-01' and '2020-02-29'
				group by mr.movie_id, m.title) t2
			order by t2.rating desc, t2.title
)

select results from small_user
union all
select results from peli_alta

-- Solucion Sejo
WITH 	t1 AS (
			SELECT TOP 1 u.name AS results
			FROM users u
			JOIN movierating r 
			ON u.user_id = r.user_id
			JOIN movies m 
			ON r.movie_id = m.movie_id
			GROUP BY u.name
			ORDER BY COUNT(r.movie_id) DESC, u.name ASC),
		t2 AS (
			SELECT TOP 1 m.title AS results
			FROM movies m
			JOIN movierating r 
			ON m.movie_id = r.movie_id
			where created_at between '2020-02-01' and '2020-02-29'
			GROUP BY m.title
			ORDER BY AVG(r.rating*10) DESC, m.title ASC)

SELECT results FROM t1
UNION
SELECT results FROM t2




-- 602. Friend Requests II: Who Has the Most Friends
with all_user as (
	select requester_id
	from RequestAccepted
	union all 
	select accepter_id
	from RequestAccepted
)

select top 1 requester_id as id, count(requester_id) as num
from all_user
group by requester_id
order by count(requester_id) desc;

-- 585. Investments in 2016
with t1 as (
		select lat, lon, count(*) repe
		from insurance
		group by lat, lon
		having count(*) = 1
),
	t2 as (
		select tiv_2015, count(*) as repe
		from insurance
		group by tiv_2015
		having count(*) > 1
)

select round(sum(tiv_2016),2) as tiv_2016
from t1
join insurance i
on t1.lat = i.lat and t1.lon = i.lon
join t2 
on t2.tiv_2015 = i.tiv_2015



-- 185. Department Top Three Salaries
SELECT
    d.name AS Department,
    e.name AS Employee,
    e.salary AS Salary
FROM Department d
JOIN Employee e 
ON d.id = e.departmentId
WHERE
    e.salary IN (
        SELECT DISTINCT TOP 3 salary
        FROM Employee e2
        WHERE e2.departmentId = d.id
        ORDER BY salary DESC
    )
ORDER BY
    Department, Salary DESC;
	
-- con window function
WITH helper AS
(
    SELECT 
        E.name Employee, 
        E.salary Salary,
        D.name Department,
        DENSE_RANK() OVER (PARTITION BY D.id ORDER BY salary DESC) rank
    FROM Employee E JOIN Department D
    ON D.id = E.departmentId
)
SELECT 
    Employee, 
    Salary,
    Department
FROM helper
WHERE rank < 4;


-- Sergios reponsoe

SELECT  d.name as Department,
        e1.name as Employee, 
        e1.Salary 
FROM department d
JOIN employee e1
ON d.id = e1.departmentId
WHERE 3 > (
        SELECT COUNT(DISTINCT(e2.salary)) 
        FROM employee e2
        WHERE e2.salary > e1.salary
        AND e1.departmentid = e2.departmentid
); 