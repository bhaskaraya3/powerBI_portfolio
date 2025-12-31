-- Coffee Sales Analysis - SQL EDA

-- Top 10 highest sales per day 
SELECT
date1,
COUNT(*) AS per_day_orders
FROM coffee1
GROUP BY date1
ORDER BY per_day_orders DESC
LIMIT 10;

-- Sales month-wise
SELECT
YEAR(date1) AS year,
MONTH(date1) AS month,
COUNT(*) AS total_sales
FROM coffee1
GROUP BY year,month
ORDER BY total_sales DESC
;

-- Payment type
SELECT
cash_type,
COUNT(*) AS count
FROM coffee1
GROUP BY cash_type;

 -- sum of spending via card type
SELECT
cash_type,
ROUND(SUM(money),0) AS total_spend
FROM coffee1
GROUP BY cash_type;

-- highest orders 
SELECT
coffee_name,
COUNT(*) AS count
FROM coffee1
GROUP BY coffee_name
ORDER BY count DESC;

-- total spending on coffee
SELECT
coffee_name,
ROUND(SUM(money),0) AS total_spent,
COUNT(*) AS count
FROM coffee1
GROUP BY coffee_name
ORDER BY total_spent DESC;

-- Coffee contribution to total revenue
SELECT
coffee_name,
ROUND(SUM(money),0) AS total_spent,
ROUND(SUM(money) * 100.0 / SUM(SUM(money)) OVER(),2) AS revenue_pct
FROM coffee1
GROUP BY coffee_name
ORDER BY total_spent DESC;

-- Pareto Analysis(80/20)
SELECT
coffee_name,
total_spent,
ROUND(SUM(total_spent) OVER (ORDER BY total_spent DESC)/ SUM(total_spent) OVER () * 100,2) AS cumulative_pct
FROM(
    SELECT
	coffee_name,
	ROUND(SUM(money),0) AS total_spent
    FROM coffee1
    GROUP BY coffee_name
) t
ORDER BY total_spent DESC;

-- AVG order value
SELECT
ROUND(AVG(money),2) AS avg_order_value
FROM coffee1;

 -- payment type avg value
SELECT
cash_type,
ROUND(AVG(money), 2) AS avg_order_value
FROM coffee1
GROUP BY cash_type;

-- Best & worst days of week (HUGE insight)
SELECT
DAYNAME(date1) AS day_name,
COUNT(*) AS total_orders,
ROUND(SUM(money),0) AS total_revenue
FROM coffee1
GROUP BY day_name
ORDER BY total_orders DESC;

-- Month-over-Month growth (ADVANCED)
SELECT
year,
month,
total_sales,
total_sales -
LAG(total_sales) OVER (ORDER BY year, month) AS mom_growth
FROM (
    SELECT
	YEAR(date1) AS year,
	MONTH(date1) AS month,
	COUNT(*) AS total_sales
    FROM coffee1
    GROUP BY year, month
) t;

-- Revenue volatility (stability analysis)
SELECT
DATE_FORMAT(date1, '%Y-%m') AS `year_month`,
ROUND(AVG(money),2) AS avg_order_value,
ROUND(STDDEV(money),2) AS volatility
FROM coffee1
GROUP BY `year_month`;

-- Payment behavior insight (conversion style)
SELECT
cash_type,
COUNT(*) AS orders,
ROUND(SUM(money),0) AS revenue,
ROUND(SUM(money)/COUNT(*),2) AS avg_ticket_size
FROM coffee1
GROUP BY cash_type;

-- Consistency of products 
SELECT
coffee_name,
ROUND(AVG(money),2) AS avg_price,
ROUND(STDDEV(money),2) AS price_variation
FROM coffee1
GROUP BY coffee_name
ORDER BY price_variation;




