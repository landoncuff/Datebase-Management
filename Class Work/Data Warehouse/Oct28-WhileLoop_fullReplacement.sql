SELECT * FROM dwDateDim;


SELECT MIN(SaleDate), MAX(SaleDate)
FROM BookSales;
GO

SELECT DATEDIFF(DAY, '4/1/2021', '12/31/2022');
GO


ALTER PROCEDURE fillDates
	(@StartDate DATE, @EndDate DATE)
AS 
BEGIN 
	--DECLARE @StartDate DATE = '4/1/2021';
	--DECLARE @EndDate DATE = '12/31/2022';
	
	WHILE @StartDate <= @EndDate
	BEGIN
		INSERT INTO dwDateDim
		VALUES(
		-- RawDate
		@StartDate, 
		-- day of week
		DATENAME(WEEKDAY, @StartDate), 
		-- month
		DATENAME(MONTH, @StartDate), 
		-- quarter
		CONCAT('Q',DATEPART(QUARTER, @StartDate), '-', YEAR(@StartDate)),
		-- YearNumber
		YEAR(@StartDate),
		-- getting the current timestamp of when this data was entered into the warehouse
		CURRENT_TIMESTAMP);
		-- or getDate()
		SET @StartDate = DATEADD(DAY, 1, @StartDate);
	END;
END;
GO

EXEC fillDates @StartDate = '1/1/2023', @EndDate = '12/31/2023';
GO




ALTER PROC fillBooks
AS 
BEGIN
	
	ALTER TABLE dwSalesFacts
	NOCHECK CONSTRAINT FK__dwSalesFac__ISBN__4AB81AF0;

	DELETE FROM dwBooksDim;

	INSERT INTO dwBooksDim

	SELECT ISBN, BookTitle, BookPrice, NumPages, PubDate, NULL, getDate()
	FROM Books;

END;
GO

EXEC fillBooks;
GO

SELECT * FROM dwBooksDim;









SELECT * FROM dwDateDim;

-- business process is sales of copies of sales that have happend
-- looking at the first sale date and the most recent sale date
SELECT MIN(SaleDate), MAX(SaleDate)
FROM BookSales;
GO
-- how many days we are adding to the database
SELECT DATEDIFF(DAY, '4/1/2021', '12/31/2022');
GO

-- preload of every single set date that have accorred and might accore in the future



-- create a program to populate the dwDateDim table with one record per date from April 1st, 2021 - December 31st, 2022
-- while loop
--PROCEDURE or PROC 

-- creating the procedure and naming it fillDates
-- head of the program is AS and above
-- body of the program is BEGIN to END

-- DROP PROC fillDates
-- Create to create a proc
-- update a proc by using Alter
ALTER PROCEDURE fillDates
	-- hold varibales that are argguments to the procedure and that are required in order to delcare 
	-- will be feed into the program as you run it
	-- doing this you will need to provide a start date and end date in order to run
	-- you can set default values if you need
	(@StartDate DATE, @EndDate DATE)
AS 
BEGIN 
	-- Creating variables
	
	--DECLARE @StartDate DATE = '4/1/2021';
	--DECLARE @EndDate DATE = '12/31/2022';
	-- setting the variable
	-- SET @StartDate = '4/1/2021';

	-- creating the loop to increment one day at a time until all desired dates are inserted
	-- we want a start date and we want an end date
	WHILE @StartDate <= @EndDate
	-- another code block for the loop
	BEGIN

		-- write the SQL DML that will insert the values
		-- will get the week day of april 1st 2021 
		-- getting the month as a string because the data type is VARCHAR
		INSERT INTO dwDateDim
		VALUES(
		-- RawDate
		@StartDate, 
		-- day of week
		DATENAME(WEEKDAY, @StartDate), 
		-- month
		DATENAME(MONTH, @StartDate), 
		-- quarter
		CONCAT('Q',DATEPART(QUARTER, @StartDate), '-', YEAR(@StartDate)),
		-- YearNumber
		YEAR(@StartDate),
		-- getting the current timestamp of when this data was entered into the warehouse
		CURRENT_TIMESTAMP);
		-- or getDate()

		-- will change the data in the while loop to make it kickout and not make an never ending date
		-- adding a day to start date each time it goes through the loop
		SET @StartDate = DATEADD(DAY, 1, @StartDate);
	END;
END;
GO

-- Execute
-- will execute the program 
-- it is like calling a function 
EXEC fillDates @StartDate = '1/1/2023', @EndDate = '12/31/2023';
GO
-- if you know the order that is required then you can do this
-- EXEC fillDates '1/1/2023', '12/31/2023';







-- keeping data warehouse in sync with relational database
-- realtional database is used for day to day
-- data warehouse is the big picture
-- writing programs that take a snapshot to update the data warehouse from the realtional database
-- three ways to sync your data
	-- 1. full replacement. Dump contents from warehouse and then recopy the realtional database
	-- 2. Incremental
	-- 3. Differentail

-- A program that will snapshot books data from the realtional database to the data warehouse, with full replacement
-- every night we are going to dump our dwBooks data in the warehouse and copy over
ALTER PROC fillBooks
AS 
BEGIN
	-- temporarily suspend refential integrity on ISBN in the fact table
	-- do this because it will throw an error because we are making orphan rows in the Fact table by removing the ISBN
	-- do it off the foreign keys which are only in the fact table
	ALTER TABLE dwSalesFacts
	NOCHECK CONSTRAINT FK__dwSalesFac__ISBN__4AB81AF0;


	-- dumping/Empty the data from the data warehouse before inserting the new information from the realtional database
	DELETE FROM dwBooksDim;

-- if you have the select statement is the correct to the result set then you dont have to have a values clause
	-- wanting to insert into the warehouse
	INSERT INTO dwBooksDim
	-- getting the book data from the realtional database
	SELECT ISBN, BookTitle, BookPrice, NumPages, PubDate, NULL, getDate()
	FROM Books;

	-- Re-enforce refential integrity on ISBN in the fact table
END;
GO
-- run the fillBooks program
EXEC fillBooks;
GO

SELECT * FROM dwBooksDim;