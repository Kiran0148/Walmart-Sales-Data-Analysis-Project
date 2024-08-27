use  walmart_sales;
show tables;
select * from walmartsales;
ALTER TABLE walmartsales
ADD column time_of_day varchar(10);
SET sql_safe_updates=0; 
UPDATE walmartsales
SET time_of_day =
case
WHEN hour(time)< 12 then "Morning"
WHEN hour(time)< 18 then "Afternoon"
ELSE "Evening"
END;
ALTER table walmartsales
ADD column day_name text;
update walmartsales
SET day_name=dayname(str_to_date(date,"%m/%d/%Y"))
;
ALTER TABLE walmartsales
ADD column month_name text;
UPDATE walmartsales
SET month_name=monthname(str_to_date(date,"%m/%d/%Y"))
;
ALTER TABLE walmartsales
change `Invoice ID` Invoice_ID text;
ALTER TABLE walmartsales
change `customer type` Customer_type text;
ALTER TABLE walmartsales
change `Product line` Product_line text;
ALTER TABLE walmartsales
change `Unit price` Unit_price double;
ALTER TABLE walmartsales
change `Tax 5%` vat double;
ALTER TABLE walmartsales
change `gross margin percentage` gross_margin_percentage double;
ALTER TABLE walmartsales
change `gross income` gross_income double;

/*  How many unique cities does the data have ?  */
SELECT DISTINCT(City) FROM walmartsales;

/* In which city is each branch ?  */
select distinct city ,branch from walmartsales;

/* PRODUCTS  */
/*  How many unique productlines does the data have ? */
SELECT DISTINCT COUNT(Product_line) FROM walmartsales;

/*  What is the most common payment method ? */
SELECT MAX(Payment)  as M_P , BRANCH 
FROM walmartsales 
group by BRANCH;

/*  What is the most selling product line?  */

SELECT product_line
FROM walmartsales
GROUP BY product_line
ORDER BY COUNT(product_line)DESC
LIMIT 1;


/* What is the total revenue by month? */

SELECT month_name, SUM(cogs)
FROM walmartsales
group by month_name;

/*  What month had the largest COGS? */
SELECT month_name as largest_Cogs_month
FROM walmartsales
ORDER BY Cogs DESC
LIMIT 1;
/* What product line had the largest revenue? */
SELECT Product_line
FROM walmartsales
ORDER BY Cogs DESC
limit 1;

/*  What is the city with the largest revenue?  */
SELECT city
FROM walmartsales
ORDER BY Cogs DESC
limit 1;

/*  . What product line had the largest VAT?  */
SELECT Product_line
FROM walmartsales
ORDER BY VAT DESC
limit 1;

/* Fetch each product line and add a column to those product line showing "Good","Bad"Good if its greaterthan average sales  */
SELECT Product_line,AVG(total)AS A,
if(AVG(total)>(SELECT avg(total) FROM walmartsales),"Good","Bad")AS category
FROM walmartsales
GROUP BY Product_line;



/*  Which branch sold more products than average product sold?   */
SELECT Branch ,SUM(Quantity)
FROM walmartsales
GROUP BY Branch
HAVING SUM(Quantity)>AVG(Quantity)
limit 1;

/*  What is the most common product line by gender?  */
SELECT Product_line,Gender
FROM walmartsales
GROUP BY Product_line,Gender
ORDER BY COUNT(Gender) DESC
LIMIT 1;

/*  What is the average rating of each product line  */
SELECT Product_line,avg(rating) as Avg_rating
FROM walmartsales
group by Product_line;

/* SALES */
/*  Number of sales made in each time of the day per weekday  */
SELECT COUNT(*),day_name,time_of_day
FROM walmartsales
GROUP BY 2,3
ORDER BY
FIELD(day_name,"Monday","Tuesday","Wednesday","Thursday","Friday","Saturday","Sunday"),
FIELD(time_of_day,"Morning","Afternoon","Evening");

/*  Which of the customer types brings the most revenue?  */
SELECT Customer_type,SUM(Cogs)
FROM walmartsales
GROUP BY Customer_type
ORDER BY SUM(Cogs) DESC
LIMIT 1;

/*  Which city has the largest tax percent/ VAT (Value Added Tax)?  */
SELECT city
FROM walmartsales
GROUP BY city
ORDER BY SUM(VAT) DESC
LIMIT 1;

/*   Which customer type pays the most in VAT?  */
SELECT Customer_type
FROM walmartsales
GROUP BY Customer_type
ORDER BY SUM(VAT) DESC
LIMIT 1;

/* CUSTOMER */
/*   How many unique customer types does the data have?  */
SELECT COUNT(DISTINCT Customer_type)
FROM walmartsales;

/*  How many unique payment methods does the data have?  */
SELECT COUNT(DISTINCT Payment)
FROM walmartsales;

/*  What is the most common customer type?  */
SELECT Customer_type
FROM walmartsales
GROUP BY Customer_type
ORDER BY COUNT(Customer_type)DESC
LIMIT 1;

/*  Which customer type buys the most?  */
SELECT Customer_type,MAX(Quantity) AS TOTAL
FROM walmartsales
GROUP BY Customer_type
ORDER BY TOTAL DESC
LIMIT 1;               

/*  What is the gender of most of the customers?  */
SELECT Gender
FROM walmartsales
GROUP BY Gender
ORDER BY COUNT(Gender) DESC
LIMIT 1;

/*  What is the gender distribution per branch?  */
SELECT Branch,Gender,COUNT(Gender)
FROM walmartsales
GROUP BY Branch,Gender
ORDER BY Branch ASC;

/*  Which time of the day do customers give most ratings  */
SELECT time_of_day
FROM walmartsales
GROUP BY time_of_day
ORDER BY COUNT(rating) DESC
LIMIT 1;

/*  Which time of the day do customers give most ratings per branch?  */
SELECT Branch,time_of_day,COUNT(rating)
FROM walmartsales
GROUP BY Branch,time_of_day
ORDER BY COUNT(rating)DESC
LIMIT 1;

/*  Which day of the week has the best avg ratings  */
SELECT day_name
FROM walmartsales
GROUP BY day_name
ORDER BY AVG(rating) DESC
LIMIT 1; 

/*  Which day of the week has the best average ratings per branch  */
SELECT Branch,AVG(rating)
FROM walmartsales
GROUP BY Branch
ORDER BY Branch ASC;