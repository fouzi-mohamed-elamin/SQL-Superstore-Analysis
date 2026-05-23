-- ============================================================
-- Project  : Superstore Sales Analysis
-- File     : 01 - Sales Analysis (15 Questions)
-- Author   : FOUZI MOHAMED ELAMIN DJAFFRI
-- Date     : May 2026
-- Tool     : MySQL 8.0
-- Dataset  : Sample Superstore (Tableau) — also on Kaggle
-- Goal     : Identify sales trends, profit drivers, and loss areas
-- ============================================================
 
 
-- ==============================
-- Q1: Total Sales, Profit, Orders
-- ==============================
SELECT 
    sum(sales)  AS total_sales,
    sum(profit) AS total_profit,
    count(*)    AS total_orders
FROM superstore;
 
-- INSIGHTS:
-- first look at the overall business performance
-- how much we sold, how much we made
 
 
-- ==============================
-- Q2: Top 10 Products by Sales
-- ==============================
SELECT 
    product_name, 
    sum(sales) AS total_sales
FROM superstore
GROUP BY product_name
ORDER BY total_sales DESC
LIMIT 10;
 
-- INSIGHTS:
-- Canon imageCLASS drives the highest revenue
-- these are the products to keep in stock
 
 
-- ==============================
-- Q3: Sales & Profit by Category
-- ==============================
SELECT 
    category,
    sum(sales)  AS total_sales,
    sum(profit) AS total_profit,
    count(*)    AS total_orders
FROM superstore
GROUP BY category
ORDER BY total_profit DESC;
 
-- INSIGHTS:
-- Technology brings the most profit
-- Furniture has high sales but low profit
-- worth investigating furniture pricing
 
 
-- ==============================
-- Q4: Sales & Profit by Region
-- ==============================
SELECT 
    region,
    sum(sales)  AS total_sales,
    sum(profit) AS total_profit
FROM superstore
GROUP BY region
ORDER BY total_profit DESC;
 
-- INSIGHTS:
-- West is the strongest region
-- Central is underperforming despite decent sales
 
 
-- ==============================
-- Q5: Top 10 Customers by Profit
-- ==============================
SELECT 
    customer_name,
    sum(profit) AS total_profit,
    sum(sales)  AS total_sales,
    count(*)    AS total_orders
FROM superstore
GROUP BY customer_name
ORDER BY total_profit DESC
LIMIT 10;
 
-- INSIGHTS:
-- high sales does not always mean high profit
-- these customers are the most valuable to retain
 
 
-- ==============================
-- Q6: Product Sales % of Total
-- ==============================
SELECT  
    product_name,
    sum(sales) AS product_sales,
    sum(sales) * 100 / (SELECT sum(sales) FROM superstore) AS percentage
FROM superstore
GROUP BY product_name
ORDER BY percentage DESC;
 
-- INSIGHTS:
-- Canon imageCLASS = 2.68% of total sales
-- no single product dominates
-- revenue is spread across many products
 
 
-- ==============================
-- Q7: States Losing Money
-- ==============================
SELECT 
    state,
    sum(profit) AS total_profit,
    sum(sales)  AS total_sales
FROM superstore
GROUP BY state
HAVING total_profit < 0
ORDER BY total_profit ASC;
 
-- INSIGHTS:
-- these states cost more than they generate
-- high discounts in these states could be the reason
-- need to review shipping and discount strategy
 
 
-- ==============================
-- Q8: Best and Worst Sub-Categories
-- ==============================
WITH best AS (
    SELECT sub_category, sum(profit) AS total_profit
    FROM superstore
    GROUP BY sub_category
    HAVING total_profit > 0
    ORDER BY total_profit DESC
    LIMIT 5
),
worst AS (
    SELECT sub_category, sum(profit) AS total_profit
    FROM superstore
    GROUP BY sub_category
    HAVING total_profit < 0
    ORDER BY total_profit ASC
    LIMIT 5
)
SELECT * FROM best
UNION ALL
SELECT * FROM worst;
 
-- INSIGHTS:
-- Copiers and Phones are the most profitable
-- Tables and Bookcases are losing money
-- consider reviewing pricing on losing sub-categories
 
 
-- ==============================
-- Q9: Shipping Days by Ship Mode
-- ==============================
SELECT 
    ship_mode,
    avg(datediff(ship_date, order_date)) AS avg_days,
    min(datediff(ship_date, order_date)) AS min_days,
    max(datediff(ship_date, order_date)) AS max_days
FROM superstore
GROUP BY ship_mode
ORDER BY avg_days ASC;
 
-- INSIGHTS:
-- Same Day is the fastest as expected
-- Standard Class takes up to 7 days
-- worth checking if shipping cost matches delivery speed
 
 
-- ==============================
-- Q10: Discount Impact on Profit
-- ==============================
SELECT 
    discount,
    count(*)              AS total_orders,
    avg(profit)           AS avg_profit,
    sum(sales)            AS total_sales,
    CASE 
        WHEN avg(profit) > 0 THEN 'Profitable'
        WHEN avg(profit) = 0 THEN 'Break Even'
        ELSE 'Losing'
    END AS status
FROM superstore
GROUP BY discount
ORDER BY discount ASC;
 
-- INSIGHTS:
-- 0 to 20 percent discount = still profitable
-- 30 percent and above = losing money
-- 50 percent discount = -310 loss per order
-- never go above 20 percent discount
 
 
-- ==============================
-- Q11: Monthly Sales Growth
-- Uses: LAG() Window Function
-- ==============================
WITH monthly AS (
    SELECT 
        year(order_date)     AS year,
        month(order_date)    AS month,
        sum(sales)           AS total_sales
    FROM superstore
    GROUP BY year(order_date), month(order_date)
)
SELECT 
    year,
    month,
    total_sales,
    LAG(total_sales) OVER (ORDER BY year, month) AS prev_month_sales,
    total_sales - LAG(total_sales) OVER (ORDER BY year, month) AS growth
FROM monthly
ORDER BY year, month;
 
-- INSIGHTS:
-- Q4 consistently shows highest sales
-- negative growth months need investigation
-- overall trend is growing year over year
 
 
-- ==============================
-- Q12: Customer Profit Ranking
-- Uses: RANK() Window Function
-- ==============================
SELECT 
    customer_name,
    sum(profit)                                   AS total_profit,
    sum(sales)                                    AS total_sales,
    RANK() OVER (ORDER BY sum(profit) DESC)       AS profit_rank
FROM superstore
GROUP BY customer_name
ORDER BY profit_rank
LIMIT 10;
 
-- INSIGHTS:
-- top ranked customers deserve priority service
-- some customers rank high with fewer orders
-- quality of orders matters more than quantity
 
 
-- ==============================
-- Q13: Running Total Sales
-- Uses: SUM() OVER() Window Function
-- ==============================
WITH monthly AS (
    SELECT 
        year(order_date)  AS year,
        month(order_date) AS month,
        sum(sales)        AS total_sales
    FROM superstore
    GROUP BY year(order_date), month(order_date)
)
SELECT 
    year,
    month,
    total_sales,
    sum(total_sales) OVER (ORDER BY year, month) AS running_total
FROM monthly;
 
-- INSIGHTS:
-- shows how revenue accumulates over time
-- useful for tracking progress toward yearly targets
 
 
-- ==============================
-- Q14: Yearly Sales Growth
-- Uses: LAG() Window Function
-- ==============================
WITH yearly AS (
    SELECT 
        year(order_date) AS year,
        sum(sales)       AS total_sales,
        sum(profit)      AS total_profit
    FROM superstore
    GROUP BY year(order_date)
)
SELECT 
    year,
    total_sales,
    total_profit,
    LAG(total_sales) OVER (ORDER BY year) AS prev_year_sales,
    total_sales - LAG(total_sales) OVER (ORDER BY year) AS yearly_growth
FROM yearly
ORDER BY year;
 
-- INSIGHTS:
-- sales are growing each year
-- but profit growth is slower than sales growth
-- discount strategy might be hurting margins
 
 
-- ==============================
-- Q15: Regional Report by Category
-- Uses: Stored Procedure with input parameter
-- Usage: CALL region_report('West') | 'East' | 'Central' | 'South'
-- ==============================
DELIMITER $$
CREATE PROCEDURE region_report(IN p_region VARCHAR(50))
BEGIN
    SELECT 
        category,
        sum(sales)  AS total_sales,
        sum(profit) AS total_profit,
        count(*)    AS total_orders,
        CASE 
            WHEN sum(profit) > 0 THEN 'Profitable'
            ELSE 'Losing'
        END AS status
    FROM superstore
    WHERE region = p_region
    GROUP BY category
    ORDER BY total_profit DESC;
END $$
DELIMITER ;
 
-- CALL region_report('West');
-- CALL region_report('East');
-- CALL region_report('Central');
-- CALL region_report('South');
 
-- INSIGHTS:
-- helps compare category performance per region
-- useful for regional managers to make decisions
