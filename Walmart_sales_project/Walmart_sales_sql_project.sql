CREATE DATABASE IF NOT EXISTS salesDataWalmart;
USE salesDataWalmart;
SELECT * FROM salesdatawalmart.sales;
CREATE TABLE IF NOT EXISTS sales(
	invoice_id VARCHAR(30) NOT NULL PRIMARY KEY,
    branch VARCHAR(5) NOT NULL,
    city VARCHAR(30) NOT NULL,
    customer_type VARCHAR(30) NOT NULL,
    gender VARCHAR(30) NOT NULL,
    product_line VARCHAR(100) NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    quantity INT NOT NULL,
    tax_pct FLOAT(6,4) NOT NULL,
    total DECIMAL(12, 4) NOT NULL,
    date DATETIME NOT NULL,
    time TIME NOT NULL,
    payment VARCHAR(15) NOT NULL,
    cogs DECIMAL(10,2) NOT NULL,
    gross_margin_pct FLOAT(11,9),
    gross_income DECIMAL(12, 4),
    rating FLOAT(2, 1)
);
/* time_of_day */
SELECT time,
		(case 
			when `time` between "00:00:00" and "12:00:00" then "Morning"
            when `time` between "12:01:00" and "16:00:00" then "Afternoon"
            else "Evening"
            end) as Time_of_day
from sales;

alter table sales add column time_of_day varchar(20);

update sales
set time_of_day = (case 
			when `time` between "00:00:00" and "12:00:00" then "Morning"
            when `time` between "12:01:00" and "16:00:00" then "Afternoon"
            else "Evening"
            end);
            
            
/*day_name*/

select date,
			dayname(date)day_name 
from sales;

alter table sales add column day_name varchar(10);
update sales 
set day_name =dayname(date);

/*Month_name*/
select date,monthname(date)Month_name from sales;
alter table sales add column month_name varchar(10);
update sales
set month_name = monthname(date);


/*Generic*/
/*How many unique cities does the data have?*/
select distinct city from sales;
/*In which city is each branch?*/
select distinct branch from sales;

/*PRODUCT*/
/*1. How many unique product lines does the data have?*/
select count(distinct product_line)productline from sales;
/*2. What is the most common payment method?*/
select payment,count(payment)cnt from sales
group by payment
order by cnt desc;
/*3. What is the most selling product line?*/
select product_line,count(product_line)cnt from sales
group by product_line
order by cnt desc;
/*4. What is the total revenue by month?*/
select month_name,sum(total)Total from sales
group by 1
order by Total desc;
/*5. What month had the largest COGS?*/
select month_name,sum(cogs)m_cogs from sales
group by month_name
order by m_cogs desc;
/*6. What product line had the largest revenue?*/
select product_line,sum(total)Total_revenue from sales 
group by product_line
order by Total_revenue desc;
/*7. What is the city with the largest revenue?*/
select city,sum(total)l_revenue from sales 
group by city
order by l_revenue desc;
/*8. What product line had the largest VAT?*/
select product_line,sum(tax_pct)l_vat from sales 
group by product_line
order by l_vat desc;
/*9. Fetch each product line and add a column to those product line showing "Good", "Bad". Good if its greater than average sales*/
select product_line,round(avg(total),2)Avg_sales,sum(total)Total,
(case when sum(total)>avg(total) then "Good" 
else "Bad"
end) as Status 
from sales
group by product_line
order by Avg_sales desc;
/*10. Which branch sold more products than average product sold?*/
select branch,sum(quantity)T_qty
from sales
group by branch
having sum(quantity)>avg(quantity);
/*11. What is the most common product line by gender?*/
select gender,product_line,count(gender)total_cnt from sales 
group by gender,product_line
order by total_cnt desc;
/*12. What is the average rating of each product line?*/
select product_line,round(avg(rating),2)Avg_rating from sales
group by product_line
order by Avg_rating desc;



/*SALES*/
/*1. Number of sales made in each time of the day per weekday*/
select time_of_day,count(*) as total_sales from sales
where day_name ='Monday'
group by time_of_day
order by total_sales desc;
/*2. Which of the customer types brings the most revenue?*/
select customer_type,sum(total)Revenue from sales 
group by customer_type
order by Revenue desc;
/*3. Which city has the largest tax percent/ VAT */
select city,round(avg(tax_pct),2)avg_per from sales 
group by city
order by avg_per desc;
/*4. Which customer type pays the most in VAT?*/
select customer_type, round(avg(tax_pct),2)Tax from sales
group by customer_type
order by tax desc;


/*CUSTOMER*/
/*1. How many unique customer types does the data have?*/
select customer_type, count(distinct customer_type)c_type from sales
group by customer_type;
/*2. How many unique payment methods does the data have?*/
select payment, count(distinct payment)c_payment from sales
group by payment;
/*3. What is the most common customer type?*/

/*4. Which customer type buys the most?*/
select customer_type, count(*)c_cnt from sales
group by customer_type;
/*5. What is the gender of most of the customers?*/
select gender,count(*)G_cnt from sales 
group by gender;
/*6. What is the gender distribution per branch?*/
select gender,count(*)B_cnt from sales
where branch = "B"
group by gender
order by B_cnt desc;
/*7. Which time of the day do customers give most ratings?*/
select time_of_day,avg(Rating)Avg_rating from sales 
group by time_of_day
order by Avg_rating desc;
/*8. Which time of the day do customers give most ratings per branch?*/
select  time_of_day,avg(Rating)Avg_rating from sales 
where branch="c"
group by time_of_day
order by Avg_rating desc;
/*9. Which day fo the week has the best avg ratings?*/
select day_name,avg(rating)avg_rating from sales 
group by day_name
order by day_name;
/*10. Which day of the week has the best average ratings per branch?*/
select day_name,round(avg(rating),2)avg_rating from sales 
where branch="B"
group by day_name
order by day_name;