--1934. Confirmation Rate
select
  s.user_id,
  round(avg(if(c.action = "confirmed", 1, 0)), 2) as confirmation_rate
from
  Signups as s
  left join Confirmations as c on s.user_id = c.user_id
group by
  user_id;

-- 1251. Average Selling Price
SELECT 
    p.product_id, 
    COALESCE(ROUND(SUM(p.price * u.units * 1.0) / SUM(u.units), 2), 0) AS average_price
FROM 
    prices p
LEFT JOIN 
    unitsSold u
ON 
    p.product_id = u.product_id
AND 
    u.purchase_date 
BETWEEN 
    p.start_date AND p.end_date
GROUP BY 
    p.product_id;

-- 1075. Project Employees I
SELECT
  p.project_id,
  ROUND(AVG(e.experience_years * 1.0), 2) as average_years
FROM
  project p
  LEFT JOIN employee e ON p.employee_id = e.employee_id
GROUP BY
  p.project_id;

-- 1633. Percentage of Users Attended a Contest
SELECT
  contest_id,
  round( count(user_id) * 100  * 1.0 / (select count(user_id) from users), 2) as percentage
FROM
  register
group by
  contest_id
order by
  percentage DESC, contest_id;

-- 1211. Queries Quality and Percentage
-- We define query quality as: The average of the ratio between query rating and its position.
select
  query_name,
  round(avg(cast(rating as decimal) / position), 2) as quality,
  round( sum( case when rating < 3 then 1 else 0 end ) * 100.0 / count(*), 2) as poor_query_percentage
from
  Queries
WHERE
  query_name is NOT NULL
group by
    query_name;

-- 1193. Monthly Transactions I
SELECT  
    SUBSTRING( CONVERT(VARCHAR(7), trans_date, 20) , 1, 7) AS month, -- ** SUBSTRING ** 
    country, count(id) as trans_count, 
    SUM(CASE WHEN state = 'approved' then 1 else 0 END) as approved_count, 
    SUM(amount) as trans_total_amount, 
    SUM(CASE WHEN state = 'approved' then amount else 0 END) as approved_total_amount
FROM 
    Transactions
GROUP BY 
    SUBSTRING( CONVERT(VARCHAR(7), trans_date, 20), 1, 7), country

-- 1174. Immediate Food Delivery II
with New as (
    select 
        distinct customer_id, 
        min(order_date) as order_date, 
        min(customer_pref_delivery_date) as customer_pref_delivery_date
    from Delivery
    group by customer_id
)

select
round(sum(iif(order_date=customer_pref_delivery_date, 100.0, 0)) / count(order_date), 2) --**IIF()**
as immediate_percentage
from New

-- 550. Game Play Analysis IV
WITH t1 AS(
  SELECT
    player_id,
    MIN(event_date) AS min_date
  FROM
    Activity
  GROUP BY
    player_id
)
SELECT
  ROUND( COUNT(DISTINCT a.player_id) * 1.0 / COUNT(DISTINCT t1.player_id), 2) AS fraction
FROM
  Activity a
RIGHT JOIN t1 ON a.player_id = t1.player_id
AND a.event_date = DATEADD(day, 1, min_date);

-- 2356. Number of Unique Subjects Taught by Each Teacher
SELECT
  teacher_id,
  COUNT(DISTINCT subject_id) AS cnt
FROM
  Teacher
GROUP BY
  teacher_id;

-- 1141. User Activity for the Past 30 Days I
-- SOLUCION MIA
SELECT
  activity_date AS day,
  COUNT(DISTINCT user_id) AS active_users
FROM
  Activity
WHERE
  activity_date BETWEEN '2019-06-28'
  AND '2019-07-27'
GROUP BY
  activity_date;

-- SOLUCION CON WINDOW FUNCTION
SELECT
  day,
  COUNT(rnk) AS active_users
FROM
  (
    SELECT
      activity_date AS day,
      user_id,
      ROW_NUMBER() OVER (PARTITION BY activity_date, user_id) AS rnk
    FROM
      activity
    WHERE
      DATEDIFF('2019-07-28', activity_date) <= 30
      AND DATEDIFF('2019-07-28', activity_date) >= 0
  ) AS e
WHERE
  e.rnk = 1
GROUP BY
  day;

-- ALTERNATIVA CON WITH
WITH e AS (
  SELECT
    activity_date AS day,
    user_id,
    ROW_NUMBER() OVER (PARTITION BY activity_date, user_id) AS rnk
  FROM
    activity
  WHERE
    DATEDIFF('2019-07-28', activity_date) <= 30
    AND DATEDIFF('2019-07-28', activity_date) >= 0
)
SELECT
  day,
  COUNT(rnk) AS active_users
FROM
  e
WHERE
  e.rnk = 1
GROUP BY
  day;

-- 1070. Product Sales Analysis III
WITH CTE AS (
  SELECT
    product_id,
    MIN(year) AS minyear
  FROM
    Sales
  GROUP BY
    product_id
)
SELECT
  s.product_id,
  s.year AS first_year,
  s.quantity,
  s.price
FROM
  Sales s
  INNER JOIN CTE ON cte.product_id = s.product_id
  AND s.year = cte.minyear;

-- 596. Classes More Than 5 Students
-- Write a solution to find all the classes that have at least five students.
-- SOLUCION MYSQL Y SQL SERVER
SELECT
  class
FROM
  courses
GROUP BY
  class
HAVING
  COUNT(*) >= 5;

-- 1729. Find Followers Count
-- Write a solution that will, for each user, return the number of followers.
-- Return the result table ordered by user_id in ascending order.
SELECT
  user_id,
  COUNT(follower_id) AS followers_count
FROM
  followers
GROUP BY
  user_id
ORDER BY
  user_id;

-- 619. Biggest Single Number
-- A single number is a number that appeared only once in the MyNumbers table.
-- Find the largest single number. If there is no single number, report null.
SELECT
  MAX(num) AS num
FROM
  (
    SELECT
      num
    FROM
      mynumbers
    GROUP BY
      num
    HAVING
      COUNT(num) = 1
  ) AS a ;
  
  -- 1045. Customers Who Bought All Products
  -- Write a solution to report the customer ids from the Customer table that bought all the products in the Product table.
  WITH t1 AS (
    SELECT
      COUNT(product_key) AS total_productos
    FROM
      product
  )
SELECT
  DISTINCT customer_id,
  COUNT(product_key) AS total_productos_dist
FROM
  customer
GROUP BY
  customer_id
HAVING
  COUNT(product_key) = (
    SELECT
      total_productos
    FROM
      t1
  );

-- 1321. Restaurant Growth
WITH fechas AS (
  SELECT
    DISTINCT c1.visited_on AS fecha
  FROM
    customer c1
    JOIN customer c2 ON DATEADD(day, -6, c1.visited_on) = c2.visited_on
)
SELECT
  f.fecha as visited_on,
  SUM(c.amount) as amount,
  ROUND(
    CAST(SUM(c.amount) AS FLOAT) / COUNT(DISTINCT c.visited_on),
    2
  ) as average_amount
FROM
  customer c
  JOIN fechas f ON c.visited_on BETWEEN DATEADD(day, -6, f.fecha)
  AND f.fecha
GROUP BY
  f.fecha;