
SELECT * FROM dwAirlinesDim;
SElECT * FROM dwAirportsAgg;
SELECT * FROM dwDateDim;
SELECT * FROM dwFlightFacts;
SELECT * FROM dwPlanesDim;
GO

-- Step 1

-- pulling information from the Airport table
SELECT * FROM Airports;
SELECT * FROM Flights;


SELECT f.DepartCode, COUNT(a.AirportCode)
FROM Flights f JOIN Airports a
ON f.DepartCode = a.AirportCode
GROUP BY f.DepartCode;

SELECT f.ArriveCode, COUNT(a.AirportCode)
FROM Flights f JOIN Airports a
ON f.ArriveCode = a.AirportCode
GROUP BY f.ArriveCode

SELECT f.ArriveCode, COUNT(aa.AirportCode), f.DepartCode, COUNT(ad.AirportCode)
FROM Flights f JOIN Airports aa
ON f.ArriveCode = aa.AirportCode
JOIN Airports ad 
ON f.DepartCode = ad.AirportCode
GROUP BY f.ArriveCode, f.DepartCode;



SELECT COUNT(FlightID), ArriveCode
FROM Flights
WHERE ArriveCode = 'MIA'
GROUP BY ArriveCode;


SELECT COUNT(FlightID), DepartCode
FROM Flights
WHERE DepartCode = 'MIA'
GROUP BY DepartCode;
GO

CREATE PROC fillAirport
AS
BEGIN
END;
GO

EXEC fillAirport;
GO


-- Step 2


SELECT * FROM Planes;
SELECT * FROM dwPlanesDim;
GO


CREATE PROC fillPlanes
	(@LastSurviced INT, @SinceServiced INT)
AS 
BEGIN

		
		SELECT PlaneID, Manufacturer, Model, PurchaseDate,NumberOfSeats, LastServiceDate, NULL, getDate()
		FROM Planes;
END;
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