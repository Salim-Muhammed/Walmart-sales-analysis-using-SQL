         --WALMART SALES ANALYSIS--
---------------------------------------------

DROP TABLE IF EXISTS walmart_sales;
CREATE TABLE walmart_sales(
                            invoice_id VARCHAR(15),
                            branch	CHAR(1),	
                            city  VARCHAR(25),  
                            customer_type	VARCHAR(15),
                            gender	VARCHAR(15),
                            product_line VARCHAR(55),	
                            unit_price	FLOAT,
                            quantity    INT, 	
                            vat	FLOAT,
                            total	FLOAT,
                            date	date,	
                            time time,
                            payment_method	VARCHAR(15),
                            rating FLOAT
                        );

SELECT * FROM walmart_sales;

--QUESTIONS

/*
-- ---------------------------------------------
-- Business Problems :: Basic Level
-- ---------------------------------------------
Q.1 Find the total sales amount for each branch
Q.2 Calculate the average customer rating for each city.
Q.3 Count the number of sales transactions for each customer type.
Q.4 Find the total quantity of products sold for each product line.
Q.5 Calculate the total VAT collected for each payment method.



-- ---------------------------------------------
-- Business Problems :: Medium Level
-- ---------------------------------------------
Q.6 Find the total sales amount and average customer rating for each branch.
Q.7 Calculate the total sales amount for each city and gender combination.
Q.8 Find the average quantity of products sold for each product line to female customers.
Q.9 Count the number of sales transactions for members in each branch.
Q.10 Find the total sales amount for each day. (Return day name and their total sales order DESC by amt)




-- ---------------------------------------------
-- Business Problems :: Advanced Level
-- ---------------------------------------------
Q.11 Calculate the total sales amount for each hour of the day
Q.12 Find the total sales amount for each month. (return month name and their sales)
Q.13 Calculate the total sales amount for each branch where the average customer rating is greater than 7.
Q.14 Find the total VAT collected for each product line where the total sales amount is more than 50000.
Q.15 Calculate the average sales amount for each gender in each branch.
Q.16 Count the number of sales transactions for each day of the week.
Q.17 Find the total sales amount for each city and customer type combination where the number of sales transactions is greater than 50.
Q.18 Calculate the average unit price for each product line and payment method combination.
Q.19 Find the total sales amount for each branch and hour of the day combination.
Q.20 Calculate the total sales amount and average customer rating for each product line where the total sales amount is greater than 1000.
Q.21 Calculate the total sales amount for morning (6 AM to 12 PM), afternoon (12 PM to 6 PM), and evening (6 PM to 12 AM) periods using the time condition.

*/



--SOLUTIONS

--Q.1 Find the total sales amount for each branch

SELECT 
     branch,
	 SUM(total) as total_sales_amt
FROM walmart_sales
GROUP BY 1;

--Q.2 Calculate the average customer rating for each city.

SELECT 
     city,
	 avg(rating) as avg_customer_rating
FROM walmart_sales
GROUP BY 1;

--Q.3 Count the number of sales transactions for each customer type.

SELECT 
     customer_type,
	 COUNT(invoice_id) as sales_transaction
FROM walmart_sales
GROUP BY 1;

--Q.4 Find the total quantity of products sold for each product line.

SELECT 
     product_line,
	 SUM(quantity) as total_quantity
FROM walmart_sales
GROUP BY 1;

--Q.5 Calculate the total VAT collected for each payment method.

SELECT 
     payment_method,
	 SUM(vat) as total_vat
FROM walmart_sales
GROUP BY 1;

                                                                        
--Q6. Find the total sales amount and average customer rating for each branch.

SELECT 
     branch,
	 SUM(total) as total_sales_amt,
	 AVG(rating) as avg_customer_rating
FROM walmart_sales
GROUP BY 1;

--Q7. Calculate the total sales amount for each city and gender combination.

SELECT 
     city,
	 gender,
	 SUM(total) as total_sales_amt
FROM walmart_sales
GROUP BY 1,2
ORDER BY 1,2;

--Q8. Find the average quantity of products sold for each product line to female customers.

SELECT 
     product_line,
	 AVG(quantity) as avg_quantity
FROM walmart_sales
WHERE gender = 'Female'
GROUP BY 1;


--Q9. Count the number of sales transactions for members in each branch.

SELECT 
      branch,
	  COUNT(invoice_id) as num_sales_transaction
FROM walmart_sales
WHERE customer_type = 'Member'
GROUP BY 1;

--Q10. Find the total sales amount for each day. (Return day name and their total sales order DESC by amt)

SELECT 
	TO_CHAR(date,'Day') as day,
	SUM(total) as total_sales_amt
FROM walmart_sales
GROUP BY 1
ORDER BY 2 DESC;

--Q.11 Calculate the total sales amount for each hour of the day

SELECT 
    EXTRACT(HOUR FROM time) as hour,
	SUM(total) as total_sales_amt
FROM walmart_sales
GROUP BY 1;

--Q.12 Find the total sales amount for each month. (return month name and their sales)

SELECT 
     TO_CHAR(date,'Month') as month,
	 SUM(total) as total_sales_amt
FROM walmart_sales
GROUP BY 1;

--Q.13 Calculate the total sales amount for each branch where the average customer rating is greater than 7.

WITH cte AS
		(SELECT 
			 branch,
			 SUM(total) AS total_sales_amt,
			 AVG(rating) as avg_cust_rating
		FROM walmart_sales
		GROUP BY 1)
SELECT * FROM cte WHERE avg_cust_rating > 7 ;


--Q.14 Find the total VAT collected for each product line where the total sales amount is more than 50000.

WITH cte AS 
	   (SELECT 
			 product_line,
			 SUM(vat) as total_vat,
			 SUM(total) AS total_sales_amt
		FROM walmart_sales 
		GROUP BY 1)
SELECT * FROM cte WHERE total_sales_amt > 50000;


--Q.15 Calculate the average sales amount for each gender in each branch.

SELECT 
     branch,
	 gender,
	 AVG(total) as avg_sales_amt
FROM walmart_sales
GROUP BY 1,2
ORDER BY 1 ;

--Q.16 Count the number of sales transactions for each day of the week.

SELECT 
     TO_CHAR(date,'Day') as day,
	 COUNT(invoice_id) as num_sales_transaction
FROM walmart_sales
GROUP BY 1

--Q.17 Find the total sales amount for each city and customer type combination where the number of sales transactions is greater than 50.

WITH cte AS 
		(SELECT 
			 city,
			 customer_type,
			 SUM(total) AS total_sales_amt,
			 COUNT(invoice_id) AS num_sales_transaction
		FROM walmart_sales
		GROUP BY 1,2
		ORDER BY 1)
SELECT * FROM cte WHERE num_sales_transaction > 50;


--Q.18 Calculate the average unit price for each product line and payment method combination.

SELECT 
     product_line,
	 payment_method,
	 AVG(unit_price) as avg_unit_price
FROM walmart_sales
GROUP BY 1,2
ORDER  BY 1;

--Q.19 Find the total sales amount for each branch and hour of the day combination.

SELECT 
     branch,
	 EXTRACT(HOUR FROM time) as hour,
	 SUM(total) as total_sales_amt
FROM walmart_sales
GROUP BY 1,2
ORDER BY 1


--Q.20 Calculate the total sales amount and average customer rating for each product line where the total sales amount is greater than 50000.

WITH cte AS 
		(SELECT 
			 product_line,
			 SUM(total) AS total_sales_amt,
			 AVG(rating) AS avg_cust_rating
		FROM walmart_sales
		GROUP BY 1)
SELECT * FROM cte WHERE total_sales_amt > 50000;

--Q.21 Calculate the total sales amount for morning (6 AM to 12 PM), afternoon (12 PM to 6 PM), and evening (6 PM to 12 AM) periods using the time condition.


WITH cte AS(
SELECT *,
      CASE WHEN EXTRACT(HOUR FROM time) BETWEEN 6 AND 12 THEN 'Morning'
	       WHEN EXTRACT(HOUR FROM time) > 12 AND EXTRACT(HOUR FROM time) <= 18 THEN 'Afternoon'
	  ELSE 'Evening'
	  END AS periods
FROM walmart_sales)
SELECT
     periods,
	 SUM(total) AS total_sales_amt
FROM cte 
GROUP BY 1;

	  












