-- Create the database
CREATE DATABASE MyOwnRestaurant;
GO

-- Use the database
USE MyOwnRestaurant;
GO

-- Create Customers table
CREATE TABLE Customers (
    CustomerID INT IDENTITY(1,1) PRIMARY KEY,   -- Auto-incrementing primary key
    FirstName VARCHAR(100) NOT NULL,            -- Ensure that FirstName cannot be NULL
    LastName VARCHAR(100) NOT NULL,             -- Ensure that LastName cannot be NULL
    Age TINYINT CHECK (Age >= 0 AND Age <= 120),-- Adding a CHECK constraint for valid age range
    Cust_Address VARCHAR(100),
    Cust_Phone VARCHAR(20)                      -- Adjusted phone number length to a more typical value
);

-- Create Staff table
CREATE TABLE Staff (
    EmployeeID INT IDENTITY(1,1) PRIMARY KEY,   -- Auto-incrementing primary key
    FirstName VARCHAR(100) NOT NULL,            -- Ensure that FirstName cannot be NULL
    Dob DATE NOT NULL,                          -- Ensure that Date of Birth cannot be NULL
    PhoneNumber VARCHAR(20) NOT NULL            -- Ensure that phone number is mandatory
);

-- Create Products table
CREATE TABLE Products (
    ProductID INT IDENTITY(1,1) PRIMARY KEY,    -- Auto-incrementing primary key
    ProductName VARCHAR(150) NOT NULL,          -- Ensure that ProductName cannot be NULL
    Unit INT NOT NULL CHECK (Unit > 0),         -- Ensure valid Unit value (greater than 0)
    Price DECIMAL(10, 2) NOT NULL CHECK (Price >= 0) -- Use DECIMAL for price and add CHECK constraint
);

-- Create Orders table with nullable EmployeeID
CREATE TABLE Orders (
    OrderID INT IDENTITY(1,1) PRIMARY KEY,      -- Auto-incrementing primary key
    ProductID INT NOT NULL,                     -- ProductID cannot be NULL
    Quantity INT NOT NULL CHECK (Quantity > 0), -- Ensure valid quantity (greater than 0)
    CustomerID INT NOT NULL,                    -- CustomerID cannot be NULL
    Order_Status VARCHAR(150) NOT NULL,         -- Ensure Order_Status cannot be NULL
    OrderDate DATE NOT NULL DEFAULT GETDATE(),  -- Automatically set the OrderDate to the current date
    EmployeeID INT NULL,                        -- EmployeeID is now nullable for ON DELETE SET NULL

    -- Foreign key constraints
    CONSTRAINT FK_Orders_Products FOREIGN KEY (ProductID) REFERENCES Products(ProductID) ON DELETE CASCADE,
    CONSTRAINT FK_Orders_Customers FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID) ON DELETE CASCADE,
    CONSTRAINT FK_Orders_Staff FOREIGN KEY (EmployeeID) REFERENCES Staff(EmployeeID) ON DELETE SET NULL
);

GO

-- Inserting multiple customer records into the Customers table with their respective details: 
-- FirstName, LastName, Age, Address, and Phone Number.
INSERT INTO  Customers VALUES 
('Oscar','Ahumada',33,'Rues de Lunan','35765468734'),
('Dayana', 'Rueda', 29, 'Rue de Leclipse','3017658934'),
('Luis', 'Morales', 20, 'Rue St. Catherine','3257894582'),
('Mateo', 'Gomez', 49, 'Rue La Linea','8974659364'),
('Leidy', 'Camargo', 36, 'Rue NorthWest PD.','98026485234')



-- Deleting customers who are either 33 years old or whose first name is 'Luis'.
DELETE FROM Customers WHERE Age = 33 OR FirstName = 'Luis';

-- Deleting all customer records from the Customers table (this will leave the table empty).
DELETE FROM Customers;


-- Write a query to restore the above backup file onto MyOwnRestaurant database
RESTORE DATABASE MyOwnRestaurant
FROM DISK "c:\backup\MyOwnRestaurant.bak"
WITH REPLACE



-- Write a WHILE loop to print the following pattern given the number of rows as input.
-- 01 *####
-- 02 **###
-- 03 ***##
-- 04 ****#
-- 05 *****

DECLARE @n INT = 5
DECLARE @i INT = 1
DECLARE @t1 VARCHAR(400)
DECLARE @t2 VARCHAR(400)
WHILE @i <= @n
	
	BEGIN
	IF LEN(@n) < 2
	BEGIN 
	SET @t1 = RIGHT(CONCAT(REPLICATE('0',LEN(@n)+1),@i), len(@n)+1)
	SET @t2 = REPLICATE(' * ',@i)+ REPLICATE(' # ', @n-@i)
	END

	ELSE
	BEGIN
	SET @t1 = RIGHT(CONCAT(REPLICATE('0',LEN(@n)),@i), len(@n))
	SET @t2 = REPLICATE(' * ',@i)+ REPLICATE(' # ', @n-@i)
	END
	print(@t1 + @t2)

	SET @i += 1
	END 


-- SECOND APPROACH


DECLARE @n INT = 5
DECLARE @i INT = 1
WHILE @i <= @n
	
	BEGIN
	IF LEN(@n) < 2
	BEGIN 
	PRINT ( RIGHT(CONCAT(REPLICATE('0',LEN(@n)+1),@i), len(@n)+1)+ REPLICATE(' * ',@i) + REPLICATE(' # ', @n-@i))
	END

	ELSE
	BEGIN
	PRINT ( RIGHT(CONCAT(REPLICATE('0',LEN(@n)),@i), len(@n))+ REPLICATE(' * ',@i) + REPLICATE(' # ', @n-@i))
	END
	SET @i += 1
	END


-- How CONCAT works
SELECT CONCAT('Hello ', 'World') AS Greeting;

-- How REPLICATE works
SELECT REPLICATE('abc', 3) AS RepeatedString;

-- How RIGHT works
SELECT RIGHT('abcdefg', 3) AS LastThreeCharacters;

-- Combined Example CONCAT &  REPLICATE
DECLARE @n INT = 5;

-- Concatenate '0' repeated (5 - 1) times with '12345'
SELECT CONCAT(REPLICATE('0', @n - 1), '12345') AS Result;


-- Combined Example CONCAT &  REPLICATE & RIGHT
DECLARE @number INT = 25;
SELECT RIGHT(CONCAT(REPLICATE('0', 5), @number), 5) AS FormattedNumber;


