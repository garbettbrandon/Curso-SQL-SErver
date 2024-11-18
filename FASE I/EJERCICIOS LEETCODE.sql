-- CONFIRMATION RATE
WITH 	con AS 			(SELECT user_id, 
								COUNT(action) as actions_comfirmed
						FROM confirmations
						WHERE action = 'confirmed'
						GROUP BY 1),
		tim AS			(SELECT user_id, 
								COUNT(action) as actions_timeout
						FROM confirmations
						WHERE action = 'timeout'
						GROUP BY 1)

SELECT s.user_id, ROUND(con.actions_comfirmed/(con.actions_comfirmed + tim.actions_timeout), 2) as confirmation_rate
FROM Signups s
JOIN Confirmations c
ON s.user_id = c.user_id
JOIN con
ON con.user_id = c.user_id
JOIN tim 
ON tim.user_id = con.user_id
GROUP BY 1, 2;


-- SOLUCION
select 	s.user_id, 
		round(avg(if(c.action="confirmed",1,0)),2) as confirmation_rate
from Signups as s 
left join Confirmations as c 
on s.user_id= c.user_id 
group by user_id;


-- 1251. Average Selling Price
SELECT p.product_id, COALESCE(round((sum(price * units) / sum(units)),2),0) AS average_price
FROM prices p
JOIN unitsSold u
ON p.product_id = u.product_id
AND u.purchase_date BETWEEN p.start_date AND p.end_date
GROUP BY 1;

--SOLUCION
SELECT p.product_id, IFNULL(round(sum(price * units) / sum(units),2),0) AS average_price
FROM prices p
LEFT JOIN unitsSold u
ON p.product_id = u.product_id
AND u.purchase_date BETWEEN p.start_date AND p.end_date
GROUP BY 1;

-- 1075. Project Employees I
SELECT p.project_id, ROUND(AVG(e.experience_years),2) as average_years
FROM project p
LEFT JOIN employee e
ON p.employee_id = e.employee_id
GROUP BY 1;

-- 1633. Percentage of Users Attended a Contest
SELECT 	contest_id, 
		round(count(user_id)*100/(select count(user_id) from users) , 2) as percentage
FROM register
group by 1
order by 2 DESC,1;

-- 1211. Queries Quality and Percentage

-- We define query quality as: The average of the ratio between query rating and its position.

select 	query_name, 
		round(avg(cast(rating as decimal) / position), 2) as quality,
		round(sum(case when rating < 3 then 1 else 0 end) * 100 / count(*), 2) as poor_query_percentage
from Queries
WHERE query_name is NOT NULL
group by 1;

-- 1193. Monthly Transactions I
select left(trans_date, 7) month, country 
from Transactions
GROUP BY 1, 2;

-- 1174. Immediate Food Delivery II
SELECT as inmediate_percentage
from delivery;

-- If the customer's preferred delivery date is the same as the order date, then the order is called immediate;
-- otherwise, it is called scheduled.
if order_date = customer_pref_delivery_date then 'immediate' else 'scheduled';

-- The first order of a customer is the order with the earliest order date that the customer made. 
-- It is guaranteed that a customer has precisely one first order.

select customer_id, min(order_date) as first_order
from Delivery
group by 1;

-- mi SOLUCION
SELECT as inmediate_percentage
from delivery;

-- Solucion página.
SELECT round(avg(order_date = customer_pref_delivery_date)*100,2) as immediate_percentage
from delivery
where (customer_id, order_date) in 	(select customer_id, min(order_date) as first_order
									from Delivery
									group by 1);

-- 550. Game Play Analysis IV
-- Write a solution to report the fraction of players that logged in again on the day after the day they first logged in,
-- rounded to 2 decimal places. 
-- In other words, you need to count the number of players that logged in for at least two consecutive days
-- starting from their first login date, then divide that number by the total number of players.

-- SOLUCION SQL SERVER
WITH 	t1 	AS(	SELECT player_id, MIN(event_date) AS min_date 
				FROM Activity
				GROUP BY player_id)

SELECT ROUND(COUNT(DISTINCT a.player_id) * 1.0/ COUNT(DISTINCT t1.player_id),2) AS fraction 
FROM Activity a
RIGHT JOIN t1
ON a.player_id = t1.player_id AND a.event_date = DATEADD(day, 1, min_date);

-- SOLUCION MYSQL
WITH 	t1 	AS(	SELECT player_id, MIN(event_date) AS min_date 
				FROM Activity
				GROUP BY player_id)

SELECT ROUND(COUNT(DISTINCT a.player_id) * 1.0/ COUNT(DISTINCT t1.player_id),2) AS fraction 
FROM Activity a
RIGHT JOIN t1
ON a.player_id = t1.player_id AND a.event_date = ADDDATE(min_date, INTERVAL 1 DAY);

-- SOLUCION ALTERNATIVA MYSQL
WITH 	t1 AS (	SELECT COUNT(DISTINCT player_id) as total 
				FROM Activity),
		t2 AS (	SELECT player_id, MIN(event_date) AS first_login 
				FROM Activity 
				GROUP BY player_id)

SELECT ROUND(COUNT(DISTINCT player_id) / (SELECT * FROM t1), 2) AS fraction
FROM Activity
WHERE (player_id, DATE_SUB(event_date, INTERVAL 1 DAY)) IN (SELECT * FROM t2);


-- 2356. Number of Unique Subjects Taught by Each Teacher
-- Write a solution to calculate the number of unique subjects each teacher teaches in the university.

-- SOLUCION PARA SQL SERVER Y MYSQL
SELECT teacher_id, COUNT(DISTINCT subject_id) AS cnt
FROM Teacher
GROUP BY teacher_id;

-- 1141. User Activity for the Past 30 Days I
-- Write a solution to find the daily active user count for a period of 30 days ending 2019-07-27 inclusively. 
-- A user was active on someday if they made at least one activity on that day.

-- SOLUCION MIA
SELECT activity_date AS day, COUNT(DISTINCT user_id) AS active_users
FROM Activity
WHERE activity_date BETWEEN '2019-06-28' AND '2019-07-27'
GROUP BY activity_date;

-- SOLUCION CON WINDOW FUNCTION
SELECT 
    day,
    COUNT(rnk) AS active_users
FROM (
    SELECT 
        activity_date AS day,
        user_id,
        ROW_NUMBER() OVER (PARTITION BY activity_date, user_id) AS rnk 
    FROM activity
    WHERE DATEDIFF('2019-07-28', activity_date) <= 30 
      AND DATEDIFF('2019-07-28', activity_date) >= 0
) AS e
WHERE e.rnk = 1
GROUP BY day;

-- ALTERNATIVA CON WITH
WITH e AS 	(SELECT	activity_date AS day,
					user_id,
					ROW_NUMBER() OVER (PARTITION BY activity_date, user_id) AS rnk 
			FROM activity
			WHERE DATEDIFF('2019-07-28', activity_date) <= 30 
			AND DATEDIFF('2019-07-28', activity_date) >= 0
)

SELECT 	day,
		COUNT(rnk) AS active_users
FROM e
WHERE e.rnk = 1
GROUP BY day;

-- 1070. Product Sales Analysis III
-- Write a solution to select the product id, year, quantity, 
-- and price for the first year of every product sold.

-- MI SOLUCION (MAL)
SELECT 	s.product_id, 
		MIN(year) AS first_year,
		MIN(quantity),
		price
FROM Sales s
JOIN product p
ON s.product_id = p.product_id
GROUP BY product_id;

-- SOLUCION MYSQL
SELECT 	product_id, 
		year as first_year, 
		quantity,
		price
FROM Sales
WHERE (product_id,year) in (SELECT product_id, MIN(year)
							FROM Sales
							GROUP BY product_id);
							
							
-- SOLUCION SQL SERVER
WITH CTE AS (
    SELECT product_id, MIN(year) AS minyear 
	FROM Sales 
    GROUP BY product_id 
)

SELECT s.product_id, s.year AS first_year, s.quantity, s.price 
FROM Sales s
INNER JOIN CTE 
ON cte.product_id = s.product_id  AND s.year = cte.minyear;



-- 596. Classes More Than 5 Students
-- Write a solution to find all the classes that have at least five students.

-- SOLUCION MYSQL Y SQL SERVER
SELECT class 
FROM courses
GROUP BY class
HAVING COUNT(*) >= 5;


-- 1729. Find Followers Count
-- Write a solution that will, for each user, return the number of followers.
-- Return the result table ordered by user_id in ascending order.

SELECT user_id, COUNT(follower_id) AS followers_count
FROM followers
GROUP BY user_id
ORDER BY user_id;


-- 619. Biggest Single Number
-- A single number is a number that appeared only once in the MyNumbers table.
-- Find the largest single number. If there is no single number, report null.


SELECT MAX(num) AS num 
FROM (	SELECT num 
		FROM mynumbers
		GROUP BY num 
		HAVING COUNT(num)=1) AS a
		
		
-- 1045. Customers Who Bought All Products
-- Write a solution to report the customer ids from the Customer table that bought all the products in the Product table.

WITH t1 AS (SELECT COUNT(product_key) AS total_productos
FROM product)

SELECT DISTINCT customer_id, COUNT(product_key) AS total_productos_dist
FROM customer
GROUP BY customer_id
HAVING COUNT(product_key) = (SELECT total_productos FROM t1);


-- 1321. Restaurant Growth
WITH fechas AS (
    SELECT
        DISTINCT c1.visited_on AS fecha
    FROM 
        customer c1
    JOIN 
        customer c2 
        ON DATEADD(day, -6, c1.visited_on) = c2.visited_on
)
SELECT
    f.fecha as visited_on, 
    SUM(c.amount) as amount,
    ROUND(CAST(SUM(c.amount) AS FLOAT) / COUNT(DISTINCT c.visited_on), 2) as average_amount
FROM 
    customer c
JOIN 
    fechas f
    ON c.visited_on BETWEEN DATEADD(day, -6, f.fecha) AND f.fecha
GROUP BY f.fecha