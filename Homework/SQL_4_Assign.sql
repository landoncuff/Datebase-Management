--Step 1:

-- Write SQL to remove the word 'Airlines' from any carrier that has that string in the Airlines table. For example, if 'Delta Airlines' is in the table, your SQL should change that value to just 'Delta'. This must be a single query that addresses all records that have 'Airlines' in them, and should fix them all at the same time. It must be written with the assumption that other records containing 'Airlines' could exist, and if they did exist, it would change them as well.

UPDATE Airlines
SET AirlineName = REPLACE(AirlineName, 'Airlines', '');

--Step 2:

-- Flight number 1000 flew from (or will fly) from Pittsburgh, PA (PIT), on Tuesday, July 30th, 2019 at 06:28. American airlines' Airbus A330, which was last serviced on Jan 23, 2020, was the aircraft used for the flight. The flight arrived (will arrive) in Dallas-Fort Wroth, TX (DFW), on Tuesday, July 30th, 2019 at 09:45

-- Flights that are in the future use future tense verbs (e.g. ...will fly...), while flights that are in the past use past tense verbs (e.g. ...flew...).
-- There are correct suffixes on the ends of the date numbers (e.g. 17th, 23rd, 1st, etc.)
-- The query returns exactly the number of rows in the Flights table.
-- The query only returns one column, labeled "The Statement".
-- The times are correctly expressed in HH:mm format.
-- City names and airport codes are shown correctly.


SELECT CONCAT('Flight number ', f.FlightID, ' ', IIF(f.DepartDateTime > getDate(), 'will fly from', 'flew from'), ' ',
CONCAT(aiDepart.AirportCity, ', ', aiDepart.AirportState), ' ', '(',aiDepart.AirportCode,')', ', on', ' ', DATENAME(WEEKDAY, f.DepartDateTime), ', ',
DATENAME(MONTH, f.DepartDateTime), ' ', DAY(f.DepartDateTime), 
CASE WHEN DATEPART(DAY, f.DepartDateTime) = 11 THEN 'th'
WHEN  RIGHT(DATEPART(DAY, f.DepartDateTime),1) LIKE '%1' THEN 'st'
WHEN DATEPART(DAY, f.DepartDateTime) = 12 THEN 'th'
WHEN DATEPART(DAY, f.DepartDateTime) = 13 THEN 'th'
WHEN  RIGHT(DATEPART(DAY, f.DepartDateTime),1) LIKE '%2' THEN 'nd'
WHEN  RIGHT(DATEPART(DAY, f.DepartDateTime),1) LIKE '%3' THEN 'rd'
ELSE 'th'
END, ', ', YEAR(f.DepartDateTime), ' at ', CONVERT(varchar(5), DepartDateTime, 108), '. ', a.AirlineName, ' airlines'' ', 
CONCAT(p.Manufacturer, ' ', p.Model), ', which was last serviced on ', CONVERT(varchar, p.LastServiceDate, 107),
', was the aircraft used for the flight. The flight ', 
IIF(f.ArriveDateTime > getDate(), 'will arrive', 'arrived'), ' in ', CONCAT(aiArr.AirportCity, ', ', aiArr.AirportState), ' (', 
aiArr.AirportCode, '), on ', DATENAME(WEEKDAY, f.ArriveDateTime), ', ',
DATENAME(MONTH, f.ArriveDateTime), ' ', DAY(f.ArriveDateTime),
CASE WHEN DATEPART(DAY, f.ArriveDateTime) = 11 THEN 'th'
WHEN  RIGHT(DATEPART(DAY, f.ArriveDateTime),1) LIKE '%1' THEN 'st'
WHEN DATEPART(DAY, f.ArriveDateTime) = 12 THEN 'th'
WHEN DATEPART(DAY, f.ArriveDateTime) = 13 THEN 'th'
WHEN  RIGHT(DATEPART(DAY, f.ArriveDateTime),1) LIKE '%2' THEN 'nd'
WHEN  RIGHT(DATEPART(DAY, f.ArriveDateTime),1) LIKE '%3' THEN 'rd'
ELSE 'th'
END, ', ', YEAR(f.ArriveDateTime), ' at ', CONVERT(varchar(5), ArriveDateTime, 108), '.') AS 'The Statment'
FROM Flights f JOIN Airports aiDepart
ON f.DepartCode = aiDepart.AirportCode
JOIN Airports aiArr 
ON f.ArriveCode = aiArr.AirportCode
JOIN Airlines a 
ON f.AirlineID = a.AirlineID
JOIN Planes p 
ON f.PlaneID = p.PlaneID;
GO


--Step 3:

-- Write a SQL statement that will return a distinct list of carriers, in alphabetical order, for all airlines that fly aircraft manufactured by Airbus. Do not use any joins in this SQL statement.

SELECT AirlineName 
FROM Airlines
WHERE AirlineID IN 
		(SELECT AirlineID
		FROM Planes
		WHERE Manufacturer = 'Airbus')
ORDER BY AirlineName;

