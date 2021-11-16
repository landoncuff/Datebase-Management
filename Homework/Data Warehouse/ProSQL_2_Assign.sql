-- STEP 1 : Create three custom functions. The first will convert an airport code into the location for that airport. The second will convert an Airline ID into the name of the airline. The third will convert a Plane ID into the Make and Model the plane, displayed as a single value. Comment each of the three functions in your script. 

-- Convert Airport Code into the location of the airport
SELECT * FROM Airports;
GO

SELECT CONCAT(AirportCity, ', ', AirportState)
FROM Airports
WHERE AirportCode = 'LAX';
GO

CREATE FUNCTION AirportCodeToLocation 
	(@AirportCode CHAR(3))
		RETURNS VARCHAR(27)
AS 
BEGIN
	DECLARE @Location VARCHAR(27);
	SELECT @Location = CONCAT(AirportCity, ', ', AirportState)
	FROM Airports
	WHERE AirportCode = @AirportCode;

	RETURN @Location
END;
GO

-- AirlineID into the name of airline
SELECT * FROM Airlines;
GO

SELECT AirlineName
FROM Airlines
WHERE AirlineID = 2;
GO

CREATE FUNCTION AirlineToAirlineName 
	(@AirlineID INT)
		RETURNS VARCHAR(20)
AS 
BEGIN
	DECLARE @NameOfAirline VARCHAR(20);
	SELECT @NameOfAirline = AirlineName
	FROM Airlines
	WHERE AirlineID = @AirlineID;

	RETURN @NameOfAirline
END;
GO

-- PlaneID into the Make and Model 
SELECT * FROM Planes;
GO
SELECT CONCAT(Manufacturer, ', ', Model)
FROM Planes
WHERE PlaneID = 115;
GO

ALTER FUNCTION PlaneToMakeAndModel 
	(@PlaneID INT)
		RETURNS VARCHAR(46)
AS 
BEGIN
	DECLARE @MakeAndModel VARCHAR(46);
	SELECT @MakeAndModel = CONCAT(Manufacturer, ', ', Model)
	FROM Planes
	WHERE PlaneID = @PlaneID;

	RETURN @MakeAndModel
END;
GO

-- STEP 2 : Using the functions you created in Step 1, write a SQL statement that will display the following sentence for every record in the dwFlightFacts table: "[Airline Name] flew a [Kind of Plane] from [City of Origin Name] to [City of Destination Name] arriving on [Date of Arrival] at [Time of Arrival]." The use of your functions will enable you to write this query without needing any joins to other tables.

SELECT * FROM dwFlightFacts;
GO

SELECT CONCAT(dbo.AirlineToAirlineName(AirlineID), ' Flew a ', dbo.PlaneToMakeAndModel(PlaneID), ' from ', dbo.AirportCodeToLocation(OriginAirport), ' to ', dbo.AirportCodeToLocation(DestinationAirport),
	' arrving on ', DATENAME(WEEKDAY, ArrivalDateTime), ', ', DATENAME(MONTH, ArrivalDateTime), ' ', DAY(ArrivalDateTime), 
	CASE WHEN DATEPART(DAY, ArrivalDateTime) = 11 THEN 'th'
	WHEN  RIGHT(DATEPART(DAY, ArrivalDateTime),1) LIKE '%1' THEN 'st'
	WHEN DATEPART(DAY, ArrivalDateTime) = 12 THEN 'th'
	WHEN DATEPART(DAY, ArrivalDateTime) = 13 THEN 'th'
	WHEN  RIGHT(DATEPART(DAY, ArrivalDateTime),1) LIKE '%2' THEN 'nd'
	WHEN  RIGHT(DATEPART(DAY, ArrivalDateTime),1) LIKE '%3' THEN 'rd'
	ELSE 'th'
	END, ', ', YEAR(ArrivalDateTime), ' at ', CONVERT(varchar(5), ArrivalDateTime, 108)) AS 'Flight Facts'
FROM dwFlightFacts;
GO

-- STEP 3 :  Create a trigger on the Planes table so that each time a plane's last service date is updated in the relational database table (Planes), the trigger should update the dwPlanesDim table's LastService date to whatever the new ServiceDate is in Planes, AND set the 'ServiceStatus' column to "Current", but only if the 'LastService' date is within the past 45 days. If the updated last service date is not within the past 45 days, the 'ServiceStatus' should be set to "Review Service" by the trigger. The only record in the dwPlanesDim table to be affected by the trigger should be the one whose last service date was changed in the Planes table. Comment the trigger code in your script file.

SELECT * FROM dwPlanesDim;
GO

ALTER TRIGGER PlanesLastServiceDateChange ON Planes
AFTER UPDATE 
AS 
BEGIN
	DECLARE @NewLastServiceDate DATE, @PlaneID INT;
	SELECT @NewLastServiceDate = LastServiceDate, @PlaneID = PlaneID FROM INSERTED;

	UPDATE dwPlanesDim
	SET LastService = @NewLastServiceDate,
				ServiceStatus = IIF(DATEDIFF(DAY, @NewLastServiceDate, getDate()) <= 45, 'Current', 'Review Service')
	--WHERE PlaneID IN (SELECT PlaneID FROM INSERTED)
	WHERE PlaneID = @PlaneID;
END;
GO

-- STEP 4 : Write two SQL statements that will cause your trigger to fire. The first query should update one airplane's last service date to within the last 45 days, and the second query should update one airplane's last service date to more than 45 days ago. You can pick whichever two planes you want for this step. Comment these in your script file.

SELECT * FROM Planes;
SELECT * FROM dwPlanesDim;

UPDATE Planes
SET LastServiceDate =  '10/30/2021'
WHERE PlaneID = 100;

UPDATE Planes
SET LastServiceDate = '8/20/2021'
WHERE PlaneID = 107;


-- STEP 5 : Write a SQL statement querying the dwPlanesDim table that shows the two planes you updated in the Planes table, demonstrating the correct 'ServiceStatus' value for each of the two planes. Comment this in your script file. 

SELECT PlaneID, ServiceStatus, LastService
FROM dwPlanesDim
WHERE PlaneID = 100 OR PlaneID = 107;