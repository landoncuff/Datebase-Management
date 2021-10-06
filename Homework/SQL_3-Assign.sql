SELECT * FROM Airlines;

SELECT * FROM Airports;

SELECT * FROM Flights;

SELECT * FROM Planes;

-- Step 1

SELECT CONCAT(a.AirportCity, ', ', a.AirportState) AS 'Airport Location', COUNT(f.FlightID) AS FlightCount
FROM Airports a JOIN Flights f
ON a.AirportCode = f.ArriveCode
WHERE ArriveDateTime <= getDate()
GROUP BY a.AirportCity, a.AirportState
HAVING COUNT(f.FlightID) < 30
ORDER BY 2 DESC
GO

-- Step 2

SELECT  CONCAT(p.Manufacturer, ', ', p.Model) AS 'Plane', COUNT(f.FlightID) AS NumberOfFlights
FROM Planes p JOIN Flights f
ON p.PlaneID = f.PlaneID
GROUP BY p.Manufacturer, p.Model
ORDER BY 2 DESC;
GO


-- Step 3

UPDATE Planes
SET NumberOfSeats =
	CASE
		WHEN Model = '787 Dreamliner' THEN 510
		WHEN Model = '737-900' THEN 155
		WHEN Model = 'RJ-45' THEN 51
		WHEN Model = '747-400' THEN 189
		WHEN Model = 'A300' THEN 162
		WHEN Model = 'A330' THEN 187
		WHEN Model = '727-200' THEN 90
	END
;


-- Step 4

SELECT f.FlightID, f.ArriveCode, f.DepartCode, f.ArriveDateTime, f.DepartDateTime, CEILING(p.NumberOfSeats*.60) AS 'Sixty Percent Full',  
CEILING(p.NumberOfSeats*.75) AS 'Seventy Five Percent Full', CEILING(p.NumberOfSeats*.95) AS 'Ninety Five Percent Full'
FROM Flights f JOIN Planes p
ON f.PlaneID = p.PlaneID;
GO

-- Step 5

SELECT f.FlightID, a.AirlineName, f.DepartDateTime, f.ArriveDateTime, f.DepartCode, f.ArriveCode
FROM Flights f JOIN Airlines a
ON f.AirlineID = a.AirlineID
WHERE MONTH(f.DepartDateTime) = 10 OR MONTH(f.ArriveDateTime) = 10
ORDER BY DAY(f.DepartDateTime) DESC, DAY(f.ArriveDateTime) DESC
GO
