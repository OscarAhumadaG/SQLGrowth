-- ANSWERS TO SQL-Questions_4

-- Switch to the 'W3' database
USE W3;
GO


-- QUESTION 1

-- Create a trigger on the table of “products” of W3 database to keep track of every price increase in a table called “products_log”. 
CREATE TABLE Product_log(
		productLogID INT NOT NULL IDENTITY (1,1),
		ProductId INT NOT NULL,
		OldPrice MONEY,
		NewPrice MONEY,
		ModifiedDate DATETIME
		PRIMARY KEY CLUSTERED(productLogID))


CREATE TRIGGER trg_product_log ON Products
AFTER  UPDATE
AS BEGIN
	
	INSERT INTO Product_log
		(ProductId, OldPrice, NewPrice,ModifiedDate)
		SELECT D.ProductID, D.Price, I.Price, GETDATE() 
		FROM DELETED AS D
	    JOIN INSERTED AS I ON D.ProductID = I.ProductID
			WHERE D.Price < I.Price
END

-- TEST TRIGGER trg_product_log
-- Insert a test product
INSERT INTO Products (ProductID ,ProductName, SupplierID, CategoryID, Unit, Price)
VALUES (78, 'Test Product', 25, 8, '48pies', 100.00);

-- Update the price to trigger the log
UPDATE Products
SET Price = 120.00
WHERE ProductID = 78; 

-- Check if the information was logged by trigger
SELECT * FROM Product_log;


-- QUESTION 2

-- Write a command to disable and enable the above-mentioned trigger
DISABLE TRIGGER trg_product_log ON dbo.Products




