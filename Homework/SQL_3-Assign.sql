SELECT * FROM Airlines;

SELECT * FROM Airports;

SELECT * FROM Flights;

SELECT * FROM Planes;

-- Step 1

--List the location of the airport of arrival and number of flights each airport has received, sorted from most flights to fewest, for all airports that have received fewer than 30 flights arrive as of the moment you run your query. Since your query could be run at any moment on any day, this means that you must use system date and time information to ensure you include all flights that have arrived as of the moment the query is run.

SELECT CONCAT(a.AirportCity, ', ', a.AirportState) AS 'Airport Location', COUNT(f.FlightID) AS FlightCount
FROM Airports a JOIN Flights f
ON a.AirportCode = f.ArriveCode
WHERE ArriveDateTime <= getDate()
GROUP BY a.AirportCity, a.AirportState
HAVING COUNT(f.FlightID) < 30
ORDER BY 2 DESC
GO

-- Step 2

--List the number of flights flown by each *kind* of aircraft (put manufacturer and model together in a single column), from most to fewest.

SELECT  CONCAT(p.Manufacturer, ', ', p.Model) AS 'Plane', COUNT(f.FlightID) AS NumberOfFlights
FROM Planes p JOIN Flights f
ON p.PlaneID = f.PlaneID
GROUP BY p.Manufacturer, p.Model
ORDER BY 2 DESC;
GO


-- Step 3

-- The number of seats attribute in the Planes table is null. In a single SQL statement, update it so that every aircraft has the correct number of seats as indicated here:

--787 Dreamliner: 510 Seats
--737-900: 155 Seats
--RJ-45: 51 Seats
--747-400: 189 Seats
--A300: 162 Seats
--A330: 187 Seats
--727-200: 90 Seats

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

-- Write a query to list each Flight ID, the airport codes of origin and destination, start and end dates and times, and three columns showing the number of seats occupied when the plane is 60% full, 75% full, and 95% full. Note that you cannot sell a partial seat, so if there is a remainder in your equations, the count of seats sold should be pushed up to the next whole seat. Alias these last three calculated columns with appropriately descriptive names.

SELECT f.FlightID, f.ArriveCode, f.DepartCode, f.ArriveDateTime, f.DepartDateTime, CEILING(p.NumberOfSeats*.60) AS 'Sixty Percent Full',  
CEILING(p.NumberOfSeats*.75) AS 'Seventy Five Percent Full', CEILING(p.NumberOfSeats*.95) AS 'Ninety Five Percent Full'
FROM Flights f JOIN Planes p
ON f.PlaneID = p.PlaneID;
GO

-- Step 5

-- Write a query to show the Flight ID, the airline name, departure date and time, and airport codes of origin and destination for all flights that occur in the month of October. This query should be written so that whenever it is run, it will *always* return only those flights, past or future, which occur in October, regardless of year. If any part of a flight occurs in October, it must be included. This means that if a flight takes off before midnight on September 30th, and lands at its destination early in the morning on October 1st, it will be included in the query results. The same would be true for flights that depart late on the last day of October but arrive in the early morning of November 1st. Sort your results so that the flights that depart at the end of October will be at the top, and the flights at the beginning of the month will be at the bottom.

SELECT f.FlightID, a.AirlineName, f.DepartDateTime, f.ArriveDateTime, f.DepartCode, f.ArriveCode
FROM Flights f JOIN Airlines a
ON f.AirlineID = a.AirlineID
WHERE MONTH(f.DepartDateTime) = 10 OR MONTH(f.ArriveDateTime) = 10
ORDER BY DAY(f.DepartDateTime) DESC, DAY(f.ArriveDateTime) DESC
GO
