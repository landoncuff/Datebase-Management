-- Homework 1 examples from pro

-- Step 1: agg table with derived tables

SELECT * FROM dwAirportsAgg;
GO

CREATE PROC fillAirportAgg
AS
BEGIN

-- ALTER TABLE dwFlightFacts
-- NOCHECK CONSTRAINT -- forgien key

DELETE FROM dwAirportsAgg;
INSERT INTO dwAirportsAgg

SELECT d.DepartCode, d.DepartFlightCount, a.ArriveFlightCount, getDate()
FROM
	(SELECT DepartCode, COUNT(FlightID) AS DepartFlightCount
	FROM Flights
	GROUP BY DepartCode) d JOIN
	(SELECT ArriveCode, COUNT(FlightID) AS ArriveFlightCount
	FROM Flights
	GROUP BY ArriveCode) a
ON d.DepartCode = a.ArriveCode
GROUP BY DepartCode, DepartFlightCount, ArriveFlightCount;
END;
GO

EXEC fillAirportAgg;
GO

-- STEP 2: 
-- fill dwPlansDIm

CREATE PROC fillPlanesDim
	(@NeedsService INT, @CantFly INT)
AS
BEGIN

-- ALTER TABLE dwFlightFacts
-- NOCHECK 

DELETE FROM dwPlanesDim

INSERT INTO dwPlanesDim
SELECT PlaneID, Manufacturer, Model, PurchaseDate, NumberOfSeats, LastServiceDate, 
	CASE
	-- when one of the these statements is true, it will auto kick out of the case
		WHEN DATEDIFF(DAY, LastServiceDate, getDate()) <= @NeedsService THEN 'Current'
		WHEN DATEDIFF(DAY, LastServiceDate, getDate()) <= @CantFly THEN 'Needs Service Soon'
		-- Checking for nulls
		-- WHEN LastServiceDate IS NULL THEN 'Missing Data'
		ELSE 'Can''t Fly until serviced'
	END, getDate()
FROM Planes;
END;
GO

EXEC fillPlanesDim 60, 120;
GO


-- STEP 3

-- Incremental updates
-- Fill airlines diemsion with incremental updates

CREATE PROC fillAirlinesDim
AS 
BEGIN
	INSERT INTO dwAirlinesDim
	SELECT AirlineID, AirlineName, getDate()
	FROM Airlines
	WHERE AirlineID NOT IN (SELECT AirlineID FROM dwAirlinesDim);
END;
GO

EXEC fillAirlines;
GO 


-- STEP 4

-- fill the date dimension table with hourly dates for 2020/21

CREATE PROC fillDateDim
AS
BEGIN	
	-- dont have to set the time because it defaults at 00:00:0000 (Midnight)
	DECLARE @StartDate DATETIME = '1/1/2020';
	-- dont have to set the time because it defaults at 00:00:0000 (Midnight)
	DECLARE @EndDate DATETIME = '1/1/2022';
	-- dont make it less than or equal because we dont have the 1 of January 2022
	WHILE @StartDate < @EndDate
	BEGIN
		INSERT INTO dwDateDim
		VALUES (
			@StartDate,
			-- hour of the day
			DATEPART(HOUR, @StartDate),
			DATENAME(WEEKDAY, @StartDate),
			DATENAME(MONTH, @StartDate),
			CONCAT('Q', DATEPART(QUARTER, @StartDate), '-', YEAR(@StartDate)),
			YEAR(@StartDate),
			getDate());

		SET @StartDate = DATEADD(HOUR, 1, @StartDate);

	END;
END;
GO

-- STEP 5

-- 
CREATE PROC fillFlightFact
AS
BEGIN
	INSERT INTO dwFlightFacts
	
	SELECT FlightID, PlaneID, AirlineID, DepartCode, ArriveCode, NULL, NULL, DepartDateTime, ArriveDateTime, getDate()
	FROM Flights
END;
GO

EXEC fillFlightFact

-- Class NOTES FOR FUNCTIONS:


-- Creating a new function:

-- we give you an ISBN and we will give you back a title of the book
-- custom scalar function that will receive an ISBN and return the book title for that ISBN

CREATE FUNCTION ISBNToTitle 
	-- we have to provide the arguments for the functions. Function will always have agruments
	-- variable that can hold an ISBN
	-- the arugment must be the correct data type and value.
	-- The agrument needs a returns value or data type (BookTitle in the books table has a VARCHAR(100) that is what we are wanting to return)
	(@ISBN CHAR(14)
		RETURNS VARCHAR(100))
AS 
BEGIN
	
END;
GO