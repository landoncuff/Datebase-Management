SELECT * FROM Airports;
GO
SELECT * FROM Airlines;
GO
SELECT * FROM Planes;
GO


-- Step 1
-- Add Allegiant Airlines to the list of airline names

INSERT INTO Airlines
VALUES('Allegiant Airlines');
GO

-- Step 2

-- Change Southwest to be Southwest Airlines
UPDATE Airlines
SET AirlineName = 'Southwest Airlines'
WHERE AirlineID = 3;
GO



-- Step 3

-- . Any flights now scheduled, or that may be scheduled in the future, originating at SFO airport in San Francisco and landing in New York (JFK) after September of this year have been cancelled. Write SQL that will remove any flights that match this criteria, ensuring that your SQL will not only work to remove the correct flight(s) now, but would also remove any flights added later between these two airports after September. In other words, every time your SQL query is run now or in the future, it should remove any flights from SFO to JFK if they are scheduled to occur after September of this year. Your SQL should not remove flights from San Francisco to New York that have already been completed, if any.

-- Remove any flights that match originate at San Francisco and land in New York after September of this year
DELETE FROM Flights
WHERE DepartCode = 'SFO' AND ArriveCode = 'JFK' AND ArriveDateTime > '2021-09-30 00:00:00';
GO

-- making sure I was getting the correct dates
/*SELECT * FROM Flights
WHERE DepartCode = 'SFO' AND ArriveCode = 'JFK' AND ArriveDateTime > '2021-09-30 00:00:00';
GO*/



-- Step 4

-- List each airline name with a count of the number of flights (past, present or future), even if the airline hasn’t flown any flights. Sort from most flights to fewest flights. Alias the count column as "Flight Count"
-- List each airline name with a count of the number of flights (past, precent, future), even if the airline has not flown any flights. Sort form most flights to fewest
SELECT a.AirlineName, COUNT(f.FlightID) AS 'Flight Count'
FROM Flights f RIGHT JOIN Airlines a
ON f.AirlineID = a.AirlineID
GROUP BY a.AirlineName
ORDER BY 2 DESC;
GO

-- Step 5

--List each airport location's city and state together in a single column, and the number of flights that have arrived, or will arrive in the future, in each city (do not display the airport code of arrival). Alphabetize by city. Alias the count column as "Arrival Count".

-- list of each airport city and state together in a single column, and the number of flights that have arrived
SELECT CONCAT(a.AirportCity, ', ', a.AirportState) AS 'Airport Name', COUNT(f.ArriveDateTime) AS 'Arrival Count'
FROM Flights f JOIN Airports a
ON f.ArriveCode = a.AirportCode
GROUP BY a.AirportCity, a.AirportState
ORDER BY AirportCity;
GO

-- Step 6

--  List the airlines (sorted alphabetically) and the aircraft they fly (manufacturer and model together in single column, also sorted alphabetically)
-- sort airlines and the aircraft they fly 
SELECT a.AirlineName, CONCAT(p.Manufacturer, ', ', p.Model) AS 'Aircraft'
FROM Planes p JOIN Airlines a
ON p.AirlineID = a.AirlineID
ORDER BY a.AirlineName, p.Manufacturer;
GO