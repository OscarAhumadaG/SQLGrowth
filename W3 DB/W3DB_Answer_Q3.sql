-- ANSWERS TO SQL-Questions_3

-- Switch to the 'W3' database
USE W3;
GO

-- Get detailed info about the 'products' table, including columns, data types, constraints, and indexes.
EXEC sp_help 'dbo.products';

-- Retrieve column info for 'products', including column names, data types, nullability, and max length.
SELECT *
FROM sys.columns
WHERE object_id = OBJECT_ID('dbo.products');

-- ******************************************************************************************************
-- QUESTION 1
-- Create a table called "products_copy"

CREATE TABLE [dbo].[products_copy](
	[ProductID] [INT] NOT NULL,
	[ProductName] [VARCHAR](255) NULL,
	[SupplierID] [INT] NULL,
	[CategoryID] [INT] NULL,
	[Unit] [VARCHAR](255) NULL,
	[Price] [MONEY] NULL)

-- ******************************************************************************************************
-- QUESTION 2
-- Declare variables and create a cursor to select products with an even price
DECLARE @ProductID INT, @ProductName VARCHAR(200), @SupplierID INT, @CategoryID INT,
@Unit VARCHAR(255), @Price MONEY

DECLARE BackUpOddNumbers CURSOR
	FOR SELECT * FROM products WHERE (Price % 2 = 0)
OPEN BackUpOddNumbers
FETCH NEXT FROM BackUpOddNumbers INTO @ProductID, @ProductName, @SupplierID, @CategoryID, @Unit, @Price
WHILE @@FETCH_STATUS = 0
	BEGIN 
	INSERT INTO products_copy VALUES(@ProductID, @ProductName, @SupplierID, @CategoryID, @Unit, @Price)
	FETCH NEXT FROM BackUpOddNumbers INTO @ProductID, @ProductName, @SupplierID, @CategoryID, @Unit, @Price
	END
CLOSE BackUpOddNumbers
DEALLOCATE BackUpOddNumbers

-- For Verifying everything was stored into products_copy
SELECT * FROM products_copy;

-- ******************************************************************************************************
-- QUESTION 3
-- Write a function named LegalAge with a birth date as an input and returns a Boolean status if the person is in the legal age (+18) or not.

-------------------------------------------------------------------------
-- Create a function GetAge to calculate the age in years based on the birthdate.
CREATE FUNCTION GetAge (@Birthdate DATETIME)
RETURNS SMALLINT
AS
BEGIN
	RETURN DATEDIFF(YEAR,@Birthdate,GETDATE())
END

-------------------------------------------------------------------------
-- Create a function LegalAge that checks if the age is 18 or older, returning 'True' or 'False'.
CREATE FUNCTION LegalAge (@Birthdate DATETIME)
RETURNS VARCHAR (250)
AS
BEGIN
	IF dbo.GetAge(@Birthdate) >= 18
		RETURN 'True'
	RETURN 'False'
END
---------------------------------------------------------------

SELECT EmployeeID,LastName, FirstName, Dbo.LegalAge(BirthDate) AS Legal FROM employees

-- ******************************************************************************************************
-- QUESTION 4
-- Write a function to give SupplierID as an input and return the name of the supplier as an output on W3 database using CURSOR.
CREATE FUNCTION SupplierName (@SupplierID INT)
RETURNS VARCHAR (250)
AS
BEGIN
	DECLARE @SupplierName VARCHAR(250) 
	DECLARE  cur_SupplierName CURSOR 
	FOR  SELECT SupplierName FROM suppliers where SupplierID = @SupplierID
    OPEN cur_SupplierName
	FETCH NEXT FROM cur_SupplierName INTO @SupplierName
	CLOSE cur_SupplierName --Close it
	DEALLOCATE cur_SupplierName
RETURN @SupplierName
END

SELECT ProductID, ProductName, dbo.SupplierName(SupplierID) AS SupplierName FROM products;

-- ******************************************************************************************************
-- QUESTION 5
-- Cursor to iterate through Products table and print ProductID, ProductName, and Price
DECLARE @ProductID INT, @ProductName VARCHAR(50), @Price MONEY
DECLARE  cur_products CURSOR 
FOR  SELECT ProductID, ProductName, Price FROM Products
OPEN cur_products
FETCH NEXT FROM cur_products INTO @ProductID, @ProductName, @Price
WHILE @@FETCH_STATUS = 0
	BEGIN
		PRINT (CONCAT(@ProductID,'-',@ProductName,'-',@Price))
		FETCH NEXT FROM cur_products INTO @ProductID, @ProductName, @Price
	END
CLOSE cur_products --Close it
DEALLOCATE cur_products -- Remove it form RAM


-- ******************************************************************************************************
-- QUESTION 6 
-- Write a SQL query that prints the CustomerName and Country for all customers from Canada, using a cursor.
DECLARE @CustomerName  VARCHAR(250), @Country VARCHAR(150)
DECLARE cur_cust_canada CURSOR
	FOR SELECT CustomerName , Country FROM customers WHERE  Country='Canada'
OPEN cur_cust_canada
FETCH NEXT FROM cur_cust_canada INTO @CustomerName, @Country

WHILE @@FETCH_STATUS = 0
	BEGIN 
	PRINT(CONCAT(@CustomerName,' / ',@Country))
	FETCH NEXT FROM cur_cust_canada INTO @CustomerName, @Country
	END

CLOSE cur_cust_canada
DEALLOCATE cur_cust_canada



-- Second approach

DECLARE @CustomerName2  VARCHAR(250), @Country2 VARCHAR(150)
DECLARE cur_cust_canada2 CURSOR
	FOR SELECT CustomerName , Country FROM customers
OPEN cur_cust_canada2
FETCH NEXT FROM cur_cust_canada2 INTO @CustomerName2, @Country2
WHILE @@FETCH_STATUS = 0
	BEGIN 
		IF @Country2 = 'Canada'
		BEGIN 
			PRINT(CONCAT(@CustomerName2,' / ',@Country2))
		END
		FETCH NEXT FROM cur_cust_canada2 INTO @CustomerName2, @Country2
	END
CLOSE cur_cust_canada2
DEALLOCATE cur_cust_canada2
