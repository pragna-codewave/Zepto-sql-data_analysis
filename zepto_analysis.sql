-- =========================================
-- ZEPTO DATA ANALYSIS PROJECT
-- =========================================
-- This project performs end-to-end SQL analysis on Zepto dataset
-- including data cleaning, exploration, and business insights
-- =========================================

-- =========================================
-- BUSINESS PROBLEM
-- =========================================
-- Zepto wants to analyze:
-- 1. Which products give best value to customers?
-- 2. Which categories generate highest revenue?
-- 3. Are there high-value items going out of stock?
-- 4. How effective are discounts across categories?

Use master
Go
-- =========================================
-- 1. CREATE DATABASE
-- =========================================
-- Creating a fresh database to store Zepto data
-- This step ensures a fresh working environment by deleting any existing database
-- and creating a new database named Zepto_Analytics for analysis.

  IF EXISTS(SELECT 1 FROM sys.databases where name = 'Zepto_Analytics')
BEGIN
   ALTER DATABASE Zepto_Analytics SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
   DROP DATABASE Zepto_Analytics
END

Create DATABASE Zepto_Analytics
GO

USE Zepto_Analytics
GO
     
-- =========================================
-- 2. CREATE TABLE
-- =========================================
-- Creating table structure to store product data

IF OBJECT_ID('dbo.Zepto','U') IS NOT NULL
   DROP TABLE dbo.Zepto
CREATE TABLE dbo.Zepto(
Category NVARCHAR(100) ,
Name NVARCHAR(100) NOT NULL,
MRP DECIMAL(8,2),
Discount_Percent NUMERIC(5,2),
Available_Quantity INT,
Discounted_Selling_Price NUMERIC(8,2),
Weight_In_Grams  INTEGER,
Out_Of_Stock NVARCHAR(50),
Quantity INT
)

--Import Objects into table
TRUNCATE TABLE dbo.Zepto
GO

-- =========================================
-- 3. IMPORT DATA
-- =========================================
-- Loading CSV data into SQL Server using BULK INSERT for efficient loading of large data.
     
BULK INSERT dbo.Zepto
FROM 'C:\Users\ASUS\Desktop\Sql\Zepto\zepto.csv'
WITH(
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    TABLOCK
);
GO

-- =========================================
-- 4. DATA EXPLORATION
-- =========================================

ALTER TABLE dbo.Zepto
ADD sku_id INT IDENTITY(1,1) PRIMARY KEY

-- Viewing first few rows to understand the dataset structure and values.
--Sample data
SELECT TOP 10 * 
FROM dbo.Zepto

-- Counting total number of records in the dataset.
SELECT COUNT(*) FROM dbo.Zepto

-- Checking for missing or null values in important columns.
SELECT * 
FROM dbo.Zepto
WHERE Category is NULL
OR Name is NULL
OR MRP is NULL
OR Discount_Percent is NULL
OR Available_Quantity is NULL
OR Discounted_Selling_Price is NULL
OR Weight_In_Grams is NULL
OR Out_Of_Stock is NULL
OR Quantity is NULL

-- Identifying different product categories available in the dataset.
SELECT DISTINCT Category
FROM dbo.Zepto

-- Analyzing how many products are in stock vs out of stock.
SELECT 
Out_of_stock,
COUNT(Out_of_stock) as No_of_items
FROM dbo.zepto
Group BY Out_of_stock

-- Finding products that appear multiple times in the dataset.
SELECT 
name,
COUNT(name) as No_of_items
FROM dbo.Zepto
GROUP BY name
HAVING COUNT(name) > 1
ORDER BY COUNT(name) DESC

-- =========================================
-- 5. DATA CLEANING
-- =========================================

  -- Identifying products with zero price, which are invalid for analysis.
SELECT *
FROM dbo.Zepto
WHERE MRP = 0 or Discounted_Selling_Price = 0

-- Removing records with zero MRP or selling price to ensure data accuracy.
DELETE dbo.zepto
WHERE MRP = 0 or Discounted_Selling_Price = 0

-- Converting price values from paise to rupees for better readability and analysis.
UPDATE dbo.Zepto
SET MRP = MRP/100.0,
   Discounted_Selling_Price =  Discounted_Selling_Price/100.0

--Check the Update
SELECT *
FROM dbo.Zepto

-- =========================================
-- 6. BUSINESS ANALYSIS
-- =========================================

--Q1.Find the top 10 best value products based on discount percentage
-- Identifying top 10 products with highest discount percentage.
SELECT Distinct TOP 10 name,
mrp,
Discounted_Selling_Price,
Discount_Percent
FROM dbo.zepto
ORDER BY Discount_Percent DESC

--Q2.What are the product with high mrp but out of stock
-- Finding high-value products that are currently out of stock,
-- indicating potential missed sales opportunities.
SELECT DISTINCT *
FROM dbo.zepto
WHERE Out_Of_Stock = 'True' and mrp > 300
ORDER BY mrp DESC

--Q3.Calculate estimated revenue for each category
-- Calculating estimated revenue for each category based on
-- selling price and available quantity.
SELECT
Category,
SUM(Discounted_Selling_Price * Available_Quantity) as Estimated_Revenue
FROM dbo.Zepto
GROUP BY Category
ORDER BY SUM(Discounted_Selling_Price * Available_Quantity)

--Q4.Find all the products where mrp is greater than 500 and disount is less than 10%
-- Identifying expensive products with low discounts to understand pricing strategy.
SELECT distinct name, 
mrp,
Discount_Percent
FROM dbo.Zepto
WHERE mrp > 500 and Discount_Percent < 10
ORDER BY MRP DESC,Discount_Percent DESC

--Q5.Identify the top 5 categories offering highest average discount percentage
-- Finding top categories offering highest average discounts.
SELECT TOP 5
Category,
AVG(Discount_Percent) as AvgDiscount
FROM dbo.zepto
GROUP BY Category
ORDER BY AVG(Discount_Percent) DESC

--Q6.Find the price per gram for the products above 100g and sort by best value
-- Calculating price per gram to determine best-value products for customers.
SELECT 
Distinct Name,
MRP,
Discounted_Selling_Price,
Weight_In_Grams,
CAST(Discounted_Selling_Price * 1.0 / Weight_In_Grams AS DECIMAL(10,2))  as PricePerGram
FROM dbo.Zepto
WHERE Weight_In_Grams > 100
ORDER BY CAST(Discounted_Selling_Price * 1.0 / Weight_In_Grams AS DECIMAL(10,2)) 

--Q7.Group the products into categories like low,medium,bulk
-- Categorizing products into Low, Medium, and Bulk based on weight.
SELECT 
Distinct name,
Weight_In_Grams,
CASE 
    WHEN Weight_In_Grams<=1000 THEN 'LOW'
    WHEN Weight_In_Grams<=5000 THEN 'Medium'
    ELSE 'Bulk'
END
FROM dbo.zepto

--Q8.What is total inventory weight per category
-- Calculating total inventory weight per category to understand stock distribution.
SELECT 
Category,
SUM(Weight_In_Grams * Available_Quantity) as Total_weight_Grams
FROM dbo.zepto
GROUP BY Category

--Q9.Find the top 3 products in each category based on discount percentage
-- Ranking products within each category based on highest discount percentage.
-- ROW_NUMBER() assigns a unique rank to each product within its category.
-- Filtering top 3 products from each category to identify best deals.

SELECT *
FROM (
    SELECT 
        Category,
        Name,
        Discount_Percent,
        ROW_NUMBER() OVER(PARTITION BY Category ORDER BY Discount_Percent DESC) AS rn
    FROM dbo.Zepto
) t
WHERE rn <= 3

--Q10.Find categories with revenue higher than average revenue
-- Calculating total revenue for each category using selling price and available quantity.
-- Using a Common Table Expression (CTE) to store category-wise revenue.
-- Comparing each category's revenue with overall average revenue.
-- Identifying high-performing categories.

WITH Category_Revenue AS (
    SELECT 
        Category,
        SUM(Discounted_Selling_Price * Available_Quantity) as Revenue
    FROM dbo.Zepto
    GROUP BY Category
)
SELECT *
FROM Category_Revenue
WHERE Revenue > (
    SELECT AVG(Revenue) FROM Category_Revenue
)

-- =========================================
-- FINAL BUSINESS CONCLUSION
-- =========================================
-- 1. Pricing and discount strategies are inconsistent across categories.
-- 2. High-value products often lack discounts, impacting conversions.
-- 3. Bulk products provide better value but may require promotion.
-- 4. Inventory distribution needs optimization to avoid stockouts and overstocking.
-- 5. Data-driven pricing and inventory management can significantly improve profitability.






