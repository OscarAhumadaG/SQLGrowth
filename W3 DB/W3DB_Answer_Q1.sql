-- ANSWERS FOR SQL-Questions_1 

-- BASIC QUERIES

-- Switch to the 'W3' database
USE W3;
GO

-- QUESTION 1
-- Employees who are born before MAY 29 of 1960 
SELECT LastName, FirstName, BirthDate 
FROM employees 
WHERE BirthDate < '1960-05-29';

-- QUESTION 2
-- Employees where their last name contains at least two “a” but NOT consecutive two ‘a’ (e.g. “aa”)
SELECT LastName, FirstName
FROM employees
WHERE LastName LIKE '%a%a%'  -- At least two 'a's
AND LastName NOT LIKE '%aa%'; -- Exclude consecutive 'a's

-- QUESTION 3
-- Display the total number of products in Category 2
SELECT CategoryID, COUNT(*) AS TotalProduct 
FROM products 
WHERE CategoryID = 2
GROUP BY CategoryID;

-- QUESTION 4
-- Total price of products for each category
SELECT categoryID, SUM(price) AS sum_price_Category 
FROM products
GROUP BY CategoryID;

-- QUESTION 5
-- Create a Common Table Expression (CTE) called DiscountRecord
WITH DiscountRecord AS (
    SELECT ProductName, Price,
    CASE
        WHEN Price < 25 THEN Price -- No discount if the price is less than 25
        WHEN Price < 50 THEN (Price * 0.85) -- 15% discount if the price is between 25 and 50
        WHEN Price > 50 THEN (Price * 0.8) -- 20% discount if the price is above 50
    END AS PriceDiscounted -- Resulting discounted price
    FROM products
)

-- Select the total discounted price and the total amount discounted from the CTE
SELECT 
    SUM(PriceDiscounted) AS TotalDiscountedPrice, -- Sum of all discounted prices
    (SUM(Price) - SUM(PriceDiscounted)) AS TotalDiscounted -- Total discount applied
FROM DiscountRecord;


-- QUESTION 6
-- This stored procedure filters products based on an optional category name and price range, with default values for flexibility.
CREATE PROCEDURE FilterProducts (@categoryname VARCHAR(150) = Null, @MinPrice INT = 0, @MaxPrice INT = Null)
AS BEGIN
SELECT * FROM products p join categories c
ON p.CategoryID = c.CategoryID
WHERE Price between @MinPrice and ISNULL(@MaxPrice, (SELECT MAX(Price) FROM products))
and CategoryName = ISNULL(@categoryname, c.CategoryName)
END

EXEC FilterProducts @MinPrice = 10, @MaxPrice = 150, @Categoryname = 'Beverages';

