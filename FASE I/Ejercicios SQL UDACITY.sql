-- 2.11 Ejercicios JOIN

--Provide a table for all web_events associated with account name of Walmart. There should be three columns. 
--Be sure to include the primary_poc, time of the event, and the channel for each event. 
--Additionally, you might choose to add a fourth column to assure only Walmart events were chosen.

SELECT a.name, a.primary_poc, w.occurred_at, w.channel
FROM web_events w
JOIN accounts a
ON w.account_id = a.id
WHERE a.name = 'Walmart';

-- Provide a table that provides the region for each sales_rep along with their associated accounts. 
--Your final table should include three columns: the region name, the sales rep name, and the account name. 
--Sort the accounts alphabetically (A-Z) according to account name.

SELECT r.name region, s.name rep, a.name account
FROM region r
JOIN sales_reps s
ON a.sales_rep_id = s.id
ON r.id = s.region_id
JOIN accounts a
ORDER BY a.name;

-- Provide the name for each region for every order, as well as the account name and the unit price they paid (total_amt_usd/total) for the order. 
--Your final table should have 3 columns: region name, account name, and unit price. 
--A few accounts have 0 for total, so I divided by (total + 0.01) to assure not dividing by zero.

SELECT r.name region, a.name account, (o.total_amt_usd/(o.total+0.01)) unit_price
FROM orders o
JOIN accounts a
ON o.account_id = a.id
JOIN sales_reps s
ON s.id = a.sales_rep_id
JOIN region r
ON r.id = s.region_id;

--2.19 Quiz Last CHECK

-- Provide a table that provides the region for each sales_rep along with their associated accounts. 
-- This time only for the Midwest region. 
-- Your final table should include three columns: the region name, the sales rep name, and the account name. 
-- Sort the accounts alphabetically (A-Z) according to account name.

SELECT r.name Region, s.name Sales_Rep_Name, a.name Account
FROM region r
JOIN sales_reps s
ON s.region_id = r.id
JOIN accounts a
ON a.sales_rep_id = s.id
WHERE r.name = 'Midwest'
ORDER BY a.name;

-- Provide a table that provides the region for each sales_rep along with their associated accounts. 
-- This time only for accounts where the sales rep has a first name starting with S and in the Midwest region.
-- Your final table should include three columns: the region name, the sales rep name, and the account name. 
-- Sort the accounts alphabetically (A-Z) according to account name.

SELECT r.name Region, s.name Sales_Rep_Name, a.name Account
FROM region r
JOIN sales_reps s
ON s.region_id = r.id
JOIN accounts a
ON a.sales_rep_id = s.id
WHERE r.name = 'Midwest' AND s.name LIKE 'S%'
ORDER BY a.name;

-- Provide a table that provides the region for each sales_rep along with their associated accounts. 
-- This time only for accounts where the sales rep has a last name starting with K and in the Midwest region. 
-- Your final table should include three columns: the region name, the sales rep name, and the account name. 
-- Sort the accounts alphabetically (A-Z) according to account name.

SELECT r.name Region, s.name Sales_Rep_Name, a.name Account
FROM region r
JOIN sales_reps s
ON s.region_id = r.id
JOIN accounts a
ON a.sales_rep_id = s.id
WHERE r.name = 'Midwest' AND s.name LIKE '% K%'
ORDER BY a.name;

-- Provide the name for each region for every order, 
-- as well as the account name and the unit price they paid (total_amt_usd/total) for the order. 
-- However, you should only provide the results if the standard order quantity exceeds 100. 
-- Your final table should have 3 columns: region name, account name, and unit price. 
-- In order to avoid a division by zero error, adding .01 to the denominator here is helpful total_amt_usd/(total+0.01).

SELECT r.name Region, a.name Account, (o.total_amt_usd/(o.total+0.01)) unit_price
FROM orders o
JOIN accounts a
ON o.account_id = a.id
JOIN sales_reps s
ON s.id = a.sales_rep_id
JOIN region r
ON r.id = s.region_id
WHERE O.standard_qty > 100;

-- Provide the name for each region for every order, 
-- as well as the account name and the unit price they paid (total_amt_usd/total) for the order. 
-- However, you should only provide the results if the standard order quantity exceeds 100 
-- and the poster order quantity exceeds 50. 
-- Your final table should have 3 columns: region name, account name, and unit price. 
-- Sort for the smallest unit price first. 
-- In order to avoid a division by zero error, adding .01 to the denominator here is helpful (total_amt_usd/(total+0.01).

SELECT r.name region, a.name account, (o.total_amt_usd/(o.total+0.01)) unit_price
FROM orders o
JOIN accounts a
ON o.account_id = a.id
JOIN sales_reps s
ON s.id = a.sales_rep_id
JOIN region r
ON r.id = s.region_id
WHERE O.standard_qty > 100 AND poster_qty > 50
ORDER BY unit_price;

-- Provide the name for each region for every order, 
-- as well as the account name and the unit price they paid (total_amt_usd/total) for the order. 
-- However, you should only provide the results if the standard order quantity exceeds 100 
-- and the poster order quantity exceeds 50. 
-- Your final table should have 3 columns: region name, account name, and unit price. 
-- Sort for the largest unit price first. 
-- In order to avoid a division by zero error, adding .01 to the denominator here is helpful (total_amt_usd/(total+0.01).

SELECT r.name region, a.name account, (o.total_amt_usd/(o.total+0.01)) unit_price
FROM orders o
JOIN accounts a
ON o.account_id = a.id
JOIN sales_reps s
ON s.id = a.sales_rep_id
JOIN region r
ON r.id = s.region_id
WHERE O.standard_qty > 100 AND poster_qty > 50
ORDER BY unit_price DESC;

-- What are the different channels used by account id 1001? 
-- Your final table should have only 2 columns: account name and the different channels. 
-- You can try SELECT DISTINCT to narrow down the results to only the unique values.

SELECT DISTINCT a.id id, a.name account, w.channel
FROM accounts a
JOIN web_events w
ON a.id = w.account_id
WHERE a.id = 1001;

-- Find all the orders that occurred in 2015. 
-- Your final table should have 4 columns: occurred_at, account name, order total, and order total_amt_usd.

SELECT o.occurred_at year_occurred, a.name account, o.total total_orders, o.total_amt_usd total_cash
FROM orders o
JOIN accounts a 
ON o.account_id = a.id
WHERE o.occurred_at BETWEEN '01-01-2015' AND '01-01-2016'
ORDER BY o.occurred_at DESC;

-- 3.14 GROUP BY

-- Which account (by name) placed the earliest order? 
-- Your solution should have the account name and the date of the order.

SELECT a.name, o.occurred_at 
FROM accounts a
JOIN orders o
ON a.id = o.account_id 
ORDER BY o.occurred_at
LIMIT 1;

-- Find the total sales in usd for each account. 
-- You should include two columns - the total sales for each company's orders in usd and the company name.

SELECT a.name, SUM(o.total_amt_usd) total_sales 
FROM accounts a
JOIN orders o
ON a.id = o.account_id 
GROUP BY a.name;

-- Via what channel did the most recent (latest) web_event occur, which account was associated with this web_event?
-- Your query should return only three values - the date, channel, and account name.

SELECT a.name, w.occurred_at, w.channel
FROM accounts a
JOIN web_events w
ON w.account_id = a.id
ORDER BY w.occurred_at DESC
LIMIT 1;

-- Find the total number of times each type of channel from the web_events was used. 
-- Your final table should have two columns - the channel and the number of times the channel was used.

SELECT w.channel, COUNT(*) times
FROM web_events w
GROUP BY w.channel;

-- Who was the primary contact associated with the earliest web_event?

SELECT a.primary_poc
FROM web_events w
JOIN accounts a
ON a.id = w.account_id
ORDER BY w.occurred_at
LIMIT 1;

-- What was the smallest order placed by each account in terms of total usd. 
-- Provide only two columns - the account name and the total usd. 
-- Order from smallest dollar amounts to largest.

SELECT a.name, MIN(total_amt_usd) smallest_order
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY a.name
ORDER BY smallest_order;

-- Find the number of sales reps in each region. 
-- Your final table should have two columns - the region and the number of sales_reps. 
-- Order from fewest reps to most reps.

SELECT r.name, COUNT(s.*) total_sales_reps
FROM region r
JOIN sales_reps s
ON r.id = s.region_id
GROUP BY r.name
ORDER BY total_sales_reps;

-- For each account, determine the average amount of each type of paper they purchased across their orders. 
-- Your result should have four columns - one for the account name 
-- and one for the average quantity purchased for each of the paper types for each account.

SELECT a.name, AVG(o.standard_qty) avg_stand, AVG(o.gloss_qty) avg_gloss, AVG(o.poster_qty) avg_post
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY a.name;

-- For each account, determine the average amount spent per order on each paper type. 
-- Your result should have four columns - one for the account name and one for the average amount spent on each paper type.

SELECT a.name, AVG(o.standard_amt_usd) avg_spent_stand, AVG(o.gloss_amt_usd) avg_spent_gloss, AVG(o.poster_amt_usd) avg_spent_poster
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY a.name;

-- Determine the number of times a particular channel was used in the web_events table for each sales rep. 
-- Your final table should have three columns:
-- the name of the sales rep, the channel, and the number of occurrences. 
-- Order your table with the highest number of occurrences first.

SELECT s.name, w.channel, COUNT(w.channel) used
FROM web_events w
JOIN accounts a
ON w.account_id = a.id
JOIN sales_reps s
ON s.id = a.sales_rep_id
GROUP BY w.channel, s.name
ORDER BY used DESC;

-- Determine the number of times a particular channel was used in the web_events table for each region. 
-- Your final table should have three columns: 
-- the region name, the channel, and the number of occurrences. 
-- Order your table with the highest number of occurrences first.

SELECT r.name, w. channel, COUNT(w.channel) used
FROM web_events w
JOIN accounts a 
ON w.account_id = a.id
JOIN sales_reps s
ON s.id = a.sales_rep_id
JOIN region r
ON s.region_id = r.id
GROUP BY r.name, w.channel
ORDER BY used DESC;

-- 3.20 DISTINCT

-- Use DISTINCT to test if there are any accounts associated with more than one region.

SELECT DISTINCT id, name
FROM accounts;

-- 3.23 HAVING 

-- How many of the sales reps have more than 5 accounts that they manage?

SELECT s.id, s.name, COUNT(a.id) num_accounts
FROM sales_reps s
JOIN accounts a
ON s.id = a.sales_rep_id
GROUP BY s.id, s.name
HAVING COUNT(a.id) > 5
ORDER BY num_accounts;

-- How many accounts have more than 20 orders?

SELECT a.name ,COUNT(a.id) total_orders
FROM accounts a
JOIN orders o 
ON a.id = o.account_id
GROUP BY a.name
HAVING COUNT(a.id) > 20
ORDER BY total_orders;

-- Which account has the most orders?

SELECT a.name, COUNT(a.id) total_orders
FROM accounts a
JOIN orders o 
ON a.id = o.account_id
GROUP BY a.name
ORDER BY total_orders DESC
LIMIT 1;

-- Which accounts spent more than 30,000 usd total across all orders?

SELECT a.id, a.name, SUM(o.total_amt_usd) total_spent
FROM accounts a
JOIN orders o 
ON a.id = o.account_id
GROUP BY a.name, a.id
HAVING SUM(o.total_amt_usd) > 30000
ORDER BY total_spent;

-- Which accounts spent less than 1,000 usd total across all orders?

SELECT a.id, a.name, SUM(o.total_amt_usd) total_spent
FROM accounts a
JOIN orders o 
ON a.id = o.account_id
GROUP BY a.name, a.id
HAVING SUM(o.total_amt_usd) < 1000
ORDER BY total_spent;

-- Which account has spent the most with us?

SELECT a.id, a.name, SUM(o.total_amt_usd) total_spent
FROM accounts a
JOIN orders o 
ON a.id = o.account_id
GROUP BY a.name, a.id
ORDER BY total_spent DESC
LIMIT 1;

-- Which account has spent the least with us?

SELECT a.id, a.name, SUM(o.total_amt_usd) total_spent
FROM accounts a
JOIN orders o 
ON a.id = o.account_id
GROUP BY a.name, a.id
ORDER BY total_spent
LIMIT 1;

-- Which accounts used facebook as a channel to contact customers more than 6 times?

SELECT a.id, a.name, w.channel, COUNT(*) use_of_channel
FROM accounts a
JOIN web_events w
ON a.id = w.account_id
GROUP BY a.id, a.name, w.channel
HAVING COUNT(*) > 6 AND w.channel = 'facebook'
ORDER BY use_of_channel;

-- Which account used facebook most as a channel?

SELECT a.id, a.name, w.channel, COUNT(*) use_of_channel
FROM accounts a
JOIN web_events w
ON a.id = w.account_id
GROUP BY a.id, a.name, w.channel
HAVING w.channel = 'facebook'
ORDER BY use_of_channel DESC
LIMIT 1;

-- Which channel was most frequently used by most accounts?

SELECT a.id, a.name, w.channel, COUNT(*) use_of_channel
FROM accounts a
JOIN web_events w
ON a.id = w.account_id
GROUP BY a.id, a.name, w.channel
ORDER BY use_of_channel DESC
LIMIT 10;

-- 3.27 Date functions

-- Find the sales in terms of total dollars for all orders in each year, ordered from greatest to least. 
-- Do you notice any trends in the yearly sales totals?

SELECT DATE_PART('year', occurred_at) ord_year,  SUM(total_amt_usd) total_spent
FROM orders
GROUP BY 1
ORDER BY 2 DESC;

-- Which month did Parch & Posey have the greatest sales in terms of total dollars? 
-- Are all months evenly represented by the dataset?

SELECT DATE_PART('month', occurred_at) ord_month,  SUM(total_amt_usd) total_spent
FROM orders
WHERE occurred_at BETWEEN '2014-01-01' AND '2017-01-01'
GROUP BY 1
ORDER BY 2 DESC;

-- El mes de Diciembre

-- Which year did Parch & Posey have the greatest sales in terms of total number of orders? 
-- Are all years evenly represented by the dataset?

SELECT DATE_PART('year', occurred_at) ord_year,  COUNT(*) total_sales
FROM orders
GROUP BY 1
ORDER BY 2 DESC;

-- El año 2016 registraron mas ordenes.

-- Which month did Parch & Posey have the greatest sales in terms of total number of orders? 
-- Are all months evenly represented by the dataset?

SELECT DATE_PART('month', occurred_at) ord_month,  COUNT(*) total_sales
FROM orders
GROUP BY 1
ORDER BY 2 DESC;


-- In which month of which year did Walmart spend the most on gloss paper in terms of dollars?

SELECT DATE_TRUNC('month', o.occurred_at) ord_date, SUM(o.gloss_amt_usd) tot_spent
FROM orders o 
JOIN accounts a
ON a.id = o.account_id
WHERE a.name = 'Walmart'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1;

-- 3.31 CASE

-- Write a query to display for each order, the account ID, total amount of the order, and the level of the order 
-- ‘Large’ or ’Small’ - depending on if the order is $3000 or more, or smaller than $3000.

SELECT account_id, total_amt_usd,
	CASE WHEN total_amt_usd > 3000 THEN 'Large'
	ELSE 'Small' END AS order_level
FROM orders;

-- Write a query to display the number of orders in each of three categories, 
-- based on the total number of items in each order. 
-- The three categories are: 'At Least 2000', 'Between 1000 and 2000' and 'Less than 1000'.

SELECT CASE WHEN total >= 2000 THEN 'At Least 2000'
	  WHEN total >= 1000 AND total < 2000 THEN 'Between 1000 and 2000'
      ELSE 'Less than 1000' END AS order_category,
COUNT(*) AS order_count
FROM orders
GROUP BY 1;

-- We would like to understand 3 different levels of customers based on the amount associated with their purchases. 
-- The top level includes anyone with a Lifetime Value (total sales of all orders) greater than 200,000 usd.
-- The second level is between 200,000 and 100,000 usd. 
-- The lowest level is anyone under 100,000 usd. 
-- Provide a table that includes the level associated with each account. 
-- You should provide the account name, the total sales of all orders for the customer, and the level. 
-- Order with the top spending customers listed first.

SELECT a.name, SUM(total_amt_usd) total_spent, 
        CASE WHEN SUM(total_amt_usd) > 200000 THEN 'top'
        WHEN  SUM(total_amt_usd) > 100000 THEN 'middle'
        ELSE 'low' END AS customer_level
FROM orders o
JOIN accounts a
ON o.account_id = a.id 
GROUP BY a.name
ORDER BY 2 DESC;


-- We would now like to perform a similar calculation to the first, 
-- but we want to obtain the total amount spent by customers only in 2016 and 2017. 
-- Keep the same levels as in the previous question. 
-- Order with the top spending customers listed first.

SELECT a.name, SUM(total_amt_usd) total_spent, 
        CASE WHEN SUM(total_amt_usd) > 200000 THEN 'top'
        WHEN  SUM(total_amt_usd) > 100000 THEN 'middle'
        ELSE 'low' END AS customer_level
FROM orders o
JOIN accounts a
ON o.account_id = a.id 
WHERE occurred_at > '2015-12-31'
GROUP BY 1
ORDER BY 2 DESC;


-- We would like to identify top performing sales reps, which are sales reps associated with more than 200 orders.
-- Create a table with the sales rep name, the total number of orders, 
-- and a column with top or not depending on if they have more than 200 orders. 
-- Place the top sales people first in your final table.

SELECT s.name, COUNT(*) total_orders, 
		CASE WHEN COUNT(*) > 200 THEN 'top' 
		ELSE 'low' END AS customer_level
FROM orders o
JOIN accounts a
ON o.account_id = a.id
JOIN sales_reps s
ON s.id = a.sales_rep_id
GROUP BY 1
ORDER BY customer_level DESC;

-- The previous didn't account for the middle, nor the dollar amount associated with the sales. 
-- Management decides they want to see these characteristics represented as well. 
-- We would like to identify top performing sales reps, 
-- which are sales reps associated with more than 200 orders or more than 750000 in total sales. 
-- The middle group has any rep with more than 150 orders or 500000 in sales. 
-- Create a table with the sales rep name, the total number of orders, total sales across all orders, 
-- and a column with top, middle, or low depending on this criteria. 
-- Place the top sales people based on dollar amount of sales first in your final table. 
-- You might see a few upset sales people by this criteria!

SELECT s.name, COUNT(*) num_orders, SUM(o.total_amt_usd) total_spent,
		CASE WHEN COUNT(*) > 200 OR SUM(o.total_amt_usd) > 750000 THEN 'top'
        WHEN COUNT(*) > 150 OR SUM(o.total_amt_usd) > 500000 THEN 'middle'
        ELSE 'low' END AS sales_rep_level
FROM orders o
JOIN accounts a
ON o.account_id = a.id 
JOIN sales_reps s
ON s.id = a.sales_rep_id
GROUP BY s.name
ORDER BY 3 DESC; 

-- 4.3 SUBQUERIES

SELECT * FROM
	(SELECT DATE_PART('day', w.occurred_at) AS day, w.channel, COUNT(*) num_events
	FROM web_events w
	GROUP BY day, w.channel
	ORDER BY day;) data_from_query;
	
-- 
	
SELECT channel, AVG(events) AS average_events
FROM 	(SELECT DATE_TRUNC('day',occurred_at) AS day, channel, COUNT(*) as events
		FROM web_events 
		GROUP BY 1,2) sub
GROUP BY channel
ORDER BY 2 DESC;

-- 

SELECT DATE_TRUNC('month', MIN(occurred_at)) as min_month
FROM orders;


SELECT AVG(standard_qty) avg_std, AVG(gloss_qty) avg_gls, AVG(poster_qty) avg_pst
FROM orders
WHERE DATE_TRUNC('month',occurred_at) = (SELECT DATE_TRUNC('month', MIN(occurred_at)) as min_month 
										FROM orders);
										
-- 4.9 SUBQUERY MANIA

-- Provide the name of the sales_rep in each region with the largest amount of total_amt_usd sales.

SELECT t3.rep_name , t2.region_name, t2.max_sales
FROM
	(SELECT region_name, MAX(total_amt) max_sales
	FROM (
		SELECT s.name rep_name, r.name region_name, SUM(o.total_amt_usd) total_amt
		FROM sales_reps s
		JOIN region r
		ON s.region_id = r.id
		JOIN accounts a
		ON a.sales_rep_id = s.id
		JOIN orders o
		ON o.account_id = a.id
		GROUP BY 1, 2) t1
	GROUP BY 1) t2
JOIN (
	SELECT s.name rep_name, r.name region_name, SUM(o.total_amt_usd) total_sales
	FROM sales_reps s
	JOIN region r
	ON s.region_id = r.id
	JOIN accounts a
	ON a.sales_rep_id = s.id
	JOIN orders o
	ON o.account_id = a.id
	GROUP BY 1, 2
	ORDER BY 3 DESC) t3
ON t2.region_name = t3.region_name AND t2.max_sales = t3.total_sales;

-- For the region with the largest (sum) of sales total_amt_usd, how many total (count) orders were placed?

SELECT r.name, COUNT(o.total) total_orders
FROM sales_reps s
JOIN accounts a
ON a.sales_rep_id = s.id
JOIN orders o
ON o.account_id = a.id
JOIN region r
ON r.id = s.region_id
GROUP BY r.name
HAVING SUM(o.total_amt_usd) =
	(SELECT MAX(total_amt)
	FROM 
		(SELECT r.name region_name, SUM(o.total_amt_usd) total_amt
		FROM region r
		JOIN sales_reps s
		ON r.id = s.region_id
		JOIN accounts a
		ON a.sales_rep_id = s.id
		JOIN orders o
		ON o.account_id = a.id
		GROUP BY 1) sub);


-- How many accounts had more total purchases than 
-- the account name which has bought the most standard_qty paper throughout their lifetime as a customer?

-- QUERY para sacar el account con mayor numero de compras de papel estandar.
SELECT a.name account_name, SUM(o.standard_qty) total_stnd, SUM(o.total) total
FROM accounts a
JOIN orders o 
ON a.id = o.account_id
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1;

SELECT COUNT(*)
FROM (	SELECT a.name
		FROM accounts a
		JOIN orders o 
		ON a.id = o.account_id
		GROUP BY 1
		HAVING SUM(o.total) > (	SELECT total
								FROM (	SELECT a.name account_name, SUM(o.standard_qty) total_stnd, SUM(o.total) total
										FROM accounts a
										JOIN orders o 
										ON a.id = o.account_id
										GROUP BY 1
										ORDER BY 2 DESC
										LIMIT 1) inner_tab)
										) counter_tab;


-- For the customer that spent the most (in total over their lifetime as a customer) total_amt_usd, 
-- how many web_events did they have for each channel?

--Con esta query sacamos el account que más ha gastado.
SELECT a.name, SUM(o.total_amt_usd) total_spent
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY a.name
ORDER BY total_spent DESC
LIMIT 1;


-- Con esta query sacamos el total events por cada channel.
SELECT w.channel, COUNT(*) total_events
FROM web_events w
GROUP BY 1;

-- Con esta query sacamos solo el nombre del account que mas ha gastado.
SELECT name 
FROM (	SELECT a.name, SUM(o.total_amt_usd) total_spent
		FROM accounts a	
		JOIN orders o
		ON a.id = o.account_id
		GROUP BY a.name
		ORDER BY total_spent DESC
		LIMIT 1
		) account_max_spent;


--Solucion final
SELECT a.name, w.channel, COUNT(*) total_events
FROM web_events w
JOIN accounts a
ON a.id = w.account_id AND a.name = (	SELECT name 
										FROM (	SELECT a.name, SUM(o.total_amt_usd) total_spent
												FROM accounts a	
												JOIN orders o
												ON a.id = o.account_id
												GROUP BY a.name
												ORDER BY total_spent DESC
												LIMIT 1
												) account_max_spent)
GROUP BY 1, 2
ORDER BY 3 DESC;


-- What is the lifetime average amount spent in terms of total_amt_usd for the top 10 total spending accounts?

-- Primero sacamos el top 10.
SELECT a.name, SUM(o.total_amt_usd) total_spent
FROM accounts a 
JOIN orders o
ON a.id = o.account_id
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10;

--Ahora hacemos el avg
SELECT AVG(total_spent)
FROM (
		SELECT a.name, SUM(o.total_amt_usd) total_spent
		FROM accounts a 
		JOIN orders o
		ON a.id = o.account_id
		GROUP BY 1
		ORDER BY 2 DESC
		LIMIT 10
)temp;


-- What is the lifetime average amount spent in terms of total_amt_usd, 
-- including only the companies that spent more per order, on average, than the average of all orders.

SELECT AVG(o.total_amt_usd) avg_all 
FROM orders o;

SELECT o.account_id, AVG(o.total_amt_usd) 
FROM orders o 
GROUP BY 1 
HAVING AVG(o.total_amt_usd) > (	SELECT AVG(o.total_amt_usd) avg_all 
								FROM orders o);

SELECT AVG(avg_amt) 
FROM (	SELECT o.account_id, AVG(o.total_amt_usd) avg_amt 
		FROM orders o 
		GROUP BY 1 
		HAVING AVG(o.total_amt_usd) > (	SELECT AVG(o.total_amt_usd) avg_all 
										FROM orders o)) temp_table; 

-- 4.13 WITH

-- Provide the name of the sales_rep in each region with the largest amount of total_amt_usd sales

WITH	t1 AS (	SELECT s.name rep_name, r.name region_name, SUM(o.total_amt_usd) total_amt
				FROM sales_reps s
				JOIN accounts a
				ON a.sales_rep_id = s.id
				JOIN orders o
				ON o.account_id = a.id
				JOIN region r
				ON r.id = s.region_id
				GROUP BY 1,2
				ORDER BY 3 DESC),

		t2 AS (	SELECT region_name, MAX(total_amt) total_amt
				FROM t1
				GROUP BY 1)

SELECT t1.rep_name , t1.region_name, t1.total_amt
FROM t1
JOIN t2
ON t1.region_name = t2.region_name AND t1.total_amt = t2.total_amt;


-- For the region with the largest sales total_amt_usd, how many total orders were placed?

WITH	t1 AS (	SELECT r.name region_name, SUM(o.total_amt_usd) total_amt
				FROM region r
				JOIN sales_reps s
				ON r.id = s.region_id
				JOIN accounts a
				ON a.sales_rep_id = s.id
				JOIN orders o
				ON o.account_id = a.id
				GROUP BY 1),

		t2 AS (	SELECT MAX(total_amt)
				FROM t1)

SELECT r.name, COUNT(o.total) total_orders
FROM sales_reps s
JOIN accounts a
ON a.sales_rep_id = s.id
JOIN orders o
ON o.account_id = a.id
JOIN region r
ON r.id = s.region_id
GROUP BY r.name
HAVING SUM(o.total_amt_usd) = (SELECT * FROM t2);


-- How many accounts had more total purchases than the account name which has bought the most standard_qty paper throughout their lifetime as a customer?


WITH	t1 AS (	SELECT a.name account_name, SUM(o.standard_qty) total_stnd, SUM(o.total) total
				FROM accounts a
				JOIN orders o 
				ON a.id = o.account_id
				GROUP BY 1
				ORDER BY 2 DESC
				LIMIT 1),

		t2 AS (	SELECT total
				FROM t1),

		t3 AS (	SELECT a.name
				FROM accounts a
				JOIN orders o 
				ON a.id = o.account_id
				GROUP BY 1
				HAVING SUM(o.total) > (SELECT * FROM t2))

SELECT COUNT(*)
FROM t3;

-- For the customer that spent the most (in total over their lifetime as a customer) total_amt_usd, how many web_events did they have for each channel?

WITH	t1 AS (	SELECT a.name, SUM(o.total_amt_usd) total_spent
				FROM accounts a	
				JOIN orders o
				ON a.id = o.account_id
				GROUP BY a.name
				ORDER BY total_spent DESC
				LIMIT 1),

		t2 AS (SELECT name 
			FROM t1)

SELECT a.name, w.channel, COUNT(*) total_events
FROM web_events w
JOIN accounts a
ON a.id = w.account_id AND a.name = (SELECT * FROM t2)
GROUP BY 1, 2
ORDER BY 3 DESC;


-- What is the lifetime average amount spent in terms of total_amt_usd for the top 10 total spending accounts?

WITH t1 AS (SELECT a.id, a.name, SUM(o.total_amt_usd) tot_spent
			FROM orders o
			JOIN accounts a
			ON a.id = o.account_id
			GROUP BY a.id, a.name
			ORDER BY 3 DESC
			LIMIT 10)

SELECT AVG(tot_spent)
FROM t1;


-- What is the lifetime average amount spent in terms of total_amt_usd, 
-- including only the companies that spent more per order, on average, than the average of all orders.

WITH	t1 AS (	SELECT AVG(o.total_amt_usd) avg_all 
				FROM orders o),

		t2 AS (SELECT o.account_id, AVG(o.total_amt_usd) avg_amt 
			FROM orders o 
			GROUP BY 1 
			HAVING AVG(o.total_amt_usd) > (SELECT * FROM t1))

SELECT AVG(avg_amt) 
FROM t2; 

-- 5.3 DATA CLEANNING

--1
SELECT RIGHT(website, 3), COUNT(*)
FROM accounts
GROUP BY 1;

--2
SELECT LEFT(name, 1), COUNT(*)
FROM accounts
GROUP BY 1
ORDER BY 2 DESC;

--3
SELECT SUM(num) AS nums, SUM(letter) AS letters
FROM (
    SELECT name, 
           CASE WHEN LEFT(UPPER(name), 1) BETWEEN '0' AND '9' THEN 1 ELSE 0 END AS num,
           CASE WHEN LEFT(UPPER(name), 1) NOT BETWEEN '0' AND '9' THEN 1 ELSE 0 END AS letter
    FROM accounts
) t1;

--4
SELECT SUM(voc) AS vocales, SUM(con) AS consonantes
FROM (
    SELECT name, 
           CASE WHEN LEFT(UPPER(name), 1) IN ('A', 'E', 'I', 'O', 'U') THEN 1 ELSE 0 END AS voc,
           CASE WHEN LEFT(UPPER(name), 1) IN ('A', 'E', 'I', 'O', 'U') THEN 0 ELSE 1 END AS con
    FROM accounts
) t1;


-- 5.6 
SELECT LEFT(primary_poc, STRPOS(primary_poc, ' ') -1 ) first_name, RIGHT(primary_poc, LENGTH(primary_poc) - STRPOS(primary_poc, ' ')) last_name
FROM accounts;



-- 6.3 WINDOW FUNCTIONS

SELECT standard_amt_usd,
       SUM(standard_amt_usd) OVER (ORDER BY occurred_at) AS running_total
FROM orders;


SELECT standard_amt_usd, DATE_TRUNC('year',occurred_at) AS year, 
       SUM(standard_amt_usd) OVER (PARTITION BY DATE_TRUNC('year',occurred_at) ORDER BY occurred_at ) AS running_total_per_year
FROM orders;

--Ranking Total Paper Ordered by Account
SELECT id, account_id, total,
      RANK() OVER (PARTITION BY account_id ORDER BY total DESC) AS total_rank
FROM orders;

SELECT id,
       account_id,
       standard_qty,
       DATE_TRUNC('month', occurred_at) AS month,
       DENSE_RANK() OVER (PARTITION BY account_id) AS dense_rank,
       SUM(standard_qty) OVER (PARTITION BY account_id) AS sum_std_qty,
       COUNT(standard_qty) OVER (PARTITION BY account_id) AS count_std_qty,
       AVG(standard_qty) OVER (PARTITION BY account_id) AS avg_std_qty,
       MIN(standard_qty) OVER (PARTITION BY account_id) AS min_std_qty,
       MAX(standard_qty) OVER (PARTITION BY account_id) AS max_std_qty
FROM orders;

-- 6.14 ALIASES

SELECT id,
       account_id,
       DATE_TRUNC('year',occurred_at) AS year,
       DENSE_RANK() OVER account_year_window AS dense_rank,
       total_amt_usd,
       SUM(total_amt_usd) OVER account_year_window AS sum_total_amt_usd,
       COUNT(total_amt_usd) OVER account_year_window AS count_total_amt_usd,
       AVG(total_amt_usd) OVER account_year_window AS avg_total_amt_usd,
       MIN(total_amt_usd) OVER account_year_window AS min_total_amt_usd,
       MAX(total_amt_usd) OVER account_year_window AS max_total_amt_usd
FROM orders

WINDOW account_year_window AS (PARTITION BY account_id ORDER BY DATE_TRUNC('year',occurred_at));


--6.17 Comparando colum con la colum anterior

WITH t1 as (
		SELECT occurred_at,
		SUM(total_amt_usd) AS total_amt_usd
		FROM orders 
		GROUP BY 1)

SELECT occurred_at,
       total_amt_usd,
       LEAD(total_amt_usd) OVER (ORDER BY occurred_at) AS lead,
       LEAD(total_amt_usd) OVER (ORDER BY occurred_at) - total_amt_usd AS lead_difference
FROM t1;



--Solucion curso
SELECT occurred_at,
       total_amt_usd,
       LEAD(total_amt_usd) OVER (ORDER BY occurred_at) AS lead,
       LEAD(total_amt_usd) OVER (ORDER BY occurred_at) - total_amt_usd AS lead_difference
FROM (
SELECT occurred_at,
       SUM(total_amt_usd) AS total_amt_usd
  FROM orders 
 GROUP BY 1
) sub

-- 6.21 PERCENTILES.

-- Use the NTILE functionality to divide the accounts into 4 levels in terms of the amount of standard_qty for their orders. 
-- Your resulting table should have the account_id, the occurred_at time for each order, the total amount of standard_qty paper purchased,
-- and one of four levels in a standard_quartile column.

SELECT account_id,
       occurred_at,
	   standard_qty,
	   NTILE(4) OVER (PARTITION BY account_id ORDER BY standard_qty) AS standard_quartile
FROM orders
ORDER BY 1;


--Solucion pagina.
SELECT
       account_id,
       occurred_at,
       standard_qty,
       NTILE(4) OVER (PARTITION BY account_id ORDER BY standard_qty) AS standard_quartile
  FROM orders 
 ORDER BY account_id DESC


 -- Use the NTILE functionality to divide the accounts into two levels in terms of the amount of gloss_qty for their orders. 
 -- Your resulting table should have the account_id, the occurred_at time for each order, the total amount of gloss_qty paper purchased, 
 -- and one of two levels in a gloss_half column.
SELECT
       account_id,
       occurred_at,
       gloss_qty,
       NTILE(2) OVER (PARTITION BY account_id ORDER BY gloss_qty) AS gloss_half
FROM orders
ORDER BY 1 DESC;

-- Use the NTILE functionality to divide the orders for each account into 100 levels in terms of the amount of total_amt_usd for their orders. 
-- Your resulting table should have the account_id, the occurred_at time for each order, the total amount of total_amt_usd paper purchased, 
-- and one of 100 levels in a total_percentile column.

SELECT
       account_id,
       occurred_at,
       total_amt_usd,
       NTILE(100) OVER (PARTITION BY account_id ORDER BY total_amt_usd) AS total_percentile
FROM orders
ORDER BY 1 DESC;

-- 7.3 FULL OUTER JOIN

SELECT * 
FROM accounts a
FULL JOIN sales_reps s
ON s.id = a.sales_rep_id;

-- 7.6 

SELECT * 
FROM accounts a
LEFT JOIN sales_reps s
ON a.sales_rep_id = s.id AND a.primary_poc < s.name;


-- 7.9 

SELECT we1.id AS we_id,
       we1.account_id AS we1_account_id,
       we1.occurred_at AS we1_occurred_at,
       we1.channel AS we1_channel,
       we2.id AS we2_id,
       we2.account_id AS we2_account_id,
       we2.occurred_at AS we2_occurred_at,
       we2.channel AS we2_channel
  FROM web_events we1 
 LEFT JOIN web_events we2
   ON we1.account_id = we2.account_id
  AND we1.occurred_at > we2.occurred_at
  AND we1.occurred_at <= we2.occurred_at + INTERVAL '1 day'
ORDER BY we1.account_id, we2.occurred_at;


-- 7.12
-- Perform the union in your first query (under the Appending Data via UNION header) 
-- in a common table expression and name it double_accounts. 
-- Then do a COUNT the number of times a name appears in the double_accounts table. 
-- If you do this correctly, your query results should have a count of 2 for each name.

WITH double_accounts AS (
    SELECT *
      FROM accounts
    
    UNION ALL
    
    SELECT *
      FROM accounts
)

SELECT name,
       COUNT(*) AS name_count
 FROM double_accounts 
GROUP BY 1
ORDER BY 2 DESC;

-- 7.18 Unión de subconsultas.

WITH	orders AS		(SELECT	DATE_TRUNC('day',o.occurred_at) AS date,
							COUNT(DISTINCT a.sales_rep_id) AS active_sales_reps,
							COUNT(DISTINCT o.id) AS orders
						FROM   accounts a
						JOIN   orders o
						ON     o.account_id = a.id
						GROUP BY 1), 
		web_events AS	(SELECT	DATE_TRUNC('day', we.occurred_at) AS date,
								COUNT(we.id) AS web_visits
						FROM	web_events we
						GROUP BY 1)


SELECT	COALESCE(o.date, we.date) AS date,
		o.active_sales_reps,
		o.orders,
		we.web_visits
FROM	orders o
FULL JOIN web_events we
ON we.date = o.date
ORDER BY 1 DESC;













