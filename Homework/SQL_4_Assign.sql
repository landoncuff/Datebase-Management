--Step 1:

UPDATE Airlines
SET AirlineName = REPLACE(AirlineName, 'Airlines', '');

--Step 2:

SELECT CONCAT('Flight number ', f.FlightID, ' ', IIF(f.DepartDateTime > getDate(), 'will fly from', 'flew from'), ' ',
CONCAT(aiDepart.AirportCity, ', ', aiDepart.AirportState), ' ', '(',aiDepart.AirportCode,')', ', on', ' ', DATENAME(WEEKDAY, f.DepartDateTime), ', ',
DATENAME(MONTH, f.DepartDateTime), ' ', DAY(f.DepartDateTime), ', ', YEAR(f.DepartDateTime), ' at ', CONVERT(varchar(5), DepartDateTime, 108), '. ',
a.AirlineName, ' airlines'' ', CONCAT(p.Manufacturer, ' ', p.Model), ', which was last serviced on ', CONVERT(varchar, p.LastServiceDate, 107),
', was the aircraft used for the flight. The flight will arrive in ',CONCAT(aiArr.AirportCity, ', ', aiArr.AirportState), ' (', 
aiArr.AirportCode, '), on ', DATENAME(WEEKDAY, f.ArriveDateTime), ', ',
DATENAME(MONTH, f.ArriveDateTime), ' ', DAY(f.ArriveDateTime), ', ', YEAR(f.ArriveDateTime), ' at ', CONVERT(varchar(5), ArriveDateTime, 108), '.')
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
SELECT AirlineName 
FROM Airlines
WHERE AirlineID IN 
		(SELECT AirlineID
		FROM Planes
		WHERE Manufacturer = 'Airbus')
ORDER BY AirlineName;
