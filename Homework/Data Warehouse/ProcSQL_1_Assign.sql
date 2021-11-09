
SELECT * FROM dwAirlinesDim;
SElECT * FROM dwAirportsAgg;
SELECT * FROM dwDateDim;
SELECT * FROM dwFlightFacts;
SELECT * FROM dwPlanesDim;
GO

-- STEP 1

-- pulling information from the Airport table
SELECT * FROM dwAirportsAgg;
SELECT * FROM Flights;

-- Creating the query first before making the Procedure statement
-- We are needing to create two differnt subqueries in order to get the right info

-- Query getting the count of depart flights
SELECT DepartCode, COUNT(FlightID)
FROM Flights
GROUP BY DepartCode;

-- query to get the count of arrive flights
SELECT ArriveCode, COUNT(FlightID)
FROM Flights
GROUP BY ArriveCode;

-- connecting the two quires to get the information 
SELECT ArriveCode, d.DepartCount, a.ArriveCount
FROM 
	(SELECT DepartCode, COUNT(FlightID) AS DepartCount
		FROM Flights
		GROUP BY DepartCode) d JOIN
	(SELECT ArriveCode, COUNT(FlightID) AS ArriveCount
		FROM Flights
		GROUP BY ArriveCode) a
ON d.DepartCode = a.ArriveCode
GROUP BY ArriveCode, d.DepartCount, a.ArriveCount;

-- creating the procedure statement
CREATE PROC fillAirport
-- ALTER PROC fillAirport
AS
BEGIN
	ALTER dwFlightFacts
	NOCHECK CONSTRAINT FK__dwFlightF__Desti__49C3F6B7, 
	FK__dwFlightF__Origi__48CFD27E;

	DELETE FROM dwAirportsAgg

	INSERT INTO dwAirportsAgg

	SELECT a.ArriveCode, d.DepartCount, a.ArriveCount, getDate()
	FROM 
		(SELECT DepartCode, COUNT(FlightID) AS DepartCount
			FROM Flights
			GROUP BY DepartCode) d JOIN
		(SELECT ArriveCode, COUNT(FlightID) AS ArriveCount
			FROM Flights
			GROUP BY ArriveCode) a
	ON d.DepartCode = a.ArriveCode
	GROUP BY a.ArriveCode, d.DepartCount, a.ArriveCount;

	ALTER dwFlightFacts
	CHECK CONSTRAINT FK__dwFlightF__Desti__49C3F6B7,
	FK__dwFlightF__Origi__48CFD27E;
	
END;
GO

EXEC fillAirport;
GO




-- Step 2


SELECT * FROM Planes;
GO
SELECT * FROM dwPlanesDim
GO


ALTER PROC fillPlanes
	(@NeedsService INT, @CantFly INT)
AS 
BEGIN
		ALTER FROM dwFlightFacts
		NOCHECK CONSTRAINT FK__dwFlightF__Plane__45F365D3;

		DELETE FROM dwPlanesDim

		INSERT INTO dwPlanesDim

		SELECT PlaneID, Manufacturer, Model, PurchaseDate, NumberOfSeats, LastServiceDate, 
		IIF(DATEDIFF(DAY, LastServiceDate, getDate())) < @NeedsSevice, 'Current', 
		IIF(DATEDIFF(DAY, LastServiceDate, getDate())) < @CantFly, 'Service Soon', 'Can''t Fly Until Serviced')), getDate()
		FROM Planes;

		ALTER FROM dwFlightFacts
		CHECK CONSTRAINT FK__dwFlightF__Plane__45F365D3;
END;
GO

EXEC fillPlanes @NeedsService = 70, @CantFly = 300;
GO


-- Step 3

SELECT * FROM Airlines;
SELECT * FROM dwAirlinesDim;
GO

CREATE PROC fillAirlines
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

SELECT * FROM dwDateDim;
GO

ALTER PROC fillDate
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
		VALUES(
		@StartDate,
		DATENAME(HOUR, @StartDate),
		DATENAME(WEEKDAY, @StartDate),
		DATENAME(MONTH, @StartDate),
		CONCAT('Q', DATEPART(QUARTER, @StartDate), '-', YEAR(@StartDate)),
		YEAR(@StartDate),
		getDate())

		SET @StartDate = DATEADD(HOUR, 1, @StartDate)
	END;
END;
GO

EXEC fillDate;
GO

-- STEP 5


SELECT * FROM dwFlightFacts
SELECT * FROM Flights
GO


CREATE PROC fillFlightFact
AS
BEGIN
	INSERT INTO dwFlightFacts
	
	SELECT FlightID, PlaneID, AirlineID, DepartCode, ArriveCode, NULL, NULL, DepartDateTime, ArriveDateTime, getDate()
	FROM Flights
END;
GO

EXEC fillFlightFact