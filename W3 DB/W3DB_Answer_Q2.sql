-- ANSWERS TO SQL-Questions_2

-- Switch to the 'W3' database
USE W3;
GO

-- ******************************************************************************************************
-- QUESTION 1
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


-- ******************************************************************************************************
-- QUESTION 2
-- This stored procedure filters products based on an optional category name and price range, with default values for flexibility.
CREATE PROCEDURE FilterProducts (@categoryname VARCHAR(150) = Null, @MinPrice INT = 0, @MaxPrice INT = Null)
AS BEGIN
SELECT * FROM products p join categories c
ON p.CategoryID = c.CategoryID
WHERE Price between @MinPrice and ISNULL(@MaxPrice, (SELECT MAX(Price) FROM products))
and CategoryName = ISNULL(@categoryname, c.CategoryName)
END

EXEC FilterProducts @MinPrice = 10, @MaxPrice = 150, @Categoryname = 'Beverages';


-- ******************************************************************************************************
-- QUESTION 3
--  Create and alter a stored procedure to filter products by name, price range, and optionally category, and then execute it with a minimum price of 10 and a query for 'chef'.
CREATE PROCEDURE sp_products (@query VARCHAR(50) = '',
							  @minPrice MONEY = 0,
							  @maxPrice  MONEY = NULL)
AS
BEGIN
	IF @maxPrice IS NULL
	BEGIN
		SET @maxPrice = (SELECT MAX(Price) FROM Products)
	END
	SELECT * 
	FROM Products
	WHERE Price BETWEEN @minPrice AND @maxPrice
	AND ProductName LIKE '%' + @query + '%'
END

------------------------------------------------------------

ALTER PROCEDURE sp_products (@query VARCHAR(50) = '', 
							 @categoryID INT = NULL,	
							 @minPrice MONEY = 0,
							 @maxPrice MONEY = NULL)
AS
BEGIN
	IF @maxPrice IS NULL
	BEGIN
		SET @maxPrice = (SELECT MAX(Price) FROM Products)
	END
	
	SELECT * 
	FROM Products
	WHERE Price BETWEEN @minPrice AND @maxPrice
	AND CategoryID = ISNULL(@categoryID, 2) --- ISNULL function is used to return the second value if the first one is NULL
	AND ProductName LIKE '%' + @query + '%'
END

-- Execute the procedure with @minPrice = 10
EXEC sp_products @query='chef', @minPrice = 10



*********************************************************************************************
-- QUESTION 4
-- Create a stored procedure to get customer orders, filtered by name, city, country, and payment amounts, and ordered by total payment.
ALTER PROCEDURE sp_CustomersOrders (
	@CustomerName VARCHAR(150) = '',
	@MinAmount MONEY = 0,
	@MaxAmount MONEY = NULL,
	@City VARCHAR(150) = NULL,
	@Country VARCHAR(150) = NULL)
AS
BEGIN
	WITH cte_report AS (
		SELECT 
			c.CustomerName,
			c.ContactName,
			c.City,
			c.Country, 
			SUM(p.Price * od.Quantity) AS Total_paid,
			COUNT(o.CustomerID) AS Total_orders,
			SUM(od.Quantity) AS Total_quantity 
		FROM customers c 
		JOIN orders o ON c.CustomerID = o.CustomerID
		JOIN order_details od ON o.OrderID = od.OrderID
		JOIN products p ON od.ProductID = p.ProductID
		GROUP BY c.CustomerName, c.ContactName, c.City, c.Country
		HAVING 
			c.CustomerName LIKE '%' + @CustomerName + '%' 
			AND c.City = ISNULL(@City, c.City) 
			AND c.Country = ISNULL(@Country, c.Country)
	)

	SELECT * 
	FROM cte_report
	WHERE Total_paid BETWEEN @MinAmount AND ISNULL(@MaxAmount, (SELECT MAX(Total_paid) FROM cte_report))
	ORDER BY Total_paid DESC
END

-- EXECUTE THE STORED PROCEDURE WITH @Country = 'Canada'
EXEC sp_CustomersOrders @Country = 'Canada'


*********************************************************************************************
-- QUESTION 5
-- Create two stored procedures to generate and print a pattern of asterisks and hashes, where the first uses variables to build the pattern and the second prints it directly

CREATE PROCEDURE create_pattern (@n INT = 2)
AS
BEGIN
    DECLARE @x INT = 1
    WHILE @x <= @n
    BEGIN
        SET @text = REPLICATE(' * ', @n - @x)
        SET @text1 = REPLICATE(' # ', @x)
        PRINT(CONCAT(@text, @text1))
        SET @x += 1
    END
END



CREATE PROCEDURE create_pattern2 (@n INT = 2)
AS
BEGIN
    DECLARE @x INT = 1
    WHILE @x <= @n
    BEGIN
        PRINT(REPLICATE(' * ', @n - @x) + REPLICATE(' # ', @x))
        SET @x += 1
    END
END


EXEC create_pattern2 @n=8



*********************************************************************************************
-- QUESTION 6
-- Create a procedure to search customers by country or/and city, and execute it with two variations of parameter order.

ALTER PROCEDURE sp_search_customers(@Country VARCHAR(50), @City VARCHAR(50))
AS
BEGIN    
    SELECT * FROM customers
    WHERE City = @City OR Country = @Country
END



EXEC sp_search_customers @Country='France', @City='Madrid'

EXEC sp_search_customers @City='Madrid', @Country='Spain'

