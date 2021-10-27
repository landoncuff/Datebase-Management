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

CREATE PROCEDURE fillDates
AS 
BEGIN 
	-- Creating variables
	DECLARE @StartDate DATE;
	-- write the SQL DML that will insert the values
	-- will get the week day of april 1st 2021 
	-- getting the month as a string because the data type is VARCHAR
	INSERT INTO dwDateDim
	VALUES(
	-- RawDate
	'4/1/2021', 
	-- day of week
	DATENAME(WEEKDAY, '4/1/2021'), 
	-- month
	DATENAME(MONTH, '4/1/2021'), 
	-- quarter
	CONCAT('Q',DATEPART(QUARTER, '4/1/2021'), '-', YEAR('4/1/2021')),
	-- YearNumber
	YEAR('4/1/2021'),
	CURRENT_TIMESTAMP)
	-- or getDate()
END;
GO

-- Execute
-- will execute the program 
EXEC fillDates;
