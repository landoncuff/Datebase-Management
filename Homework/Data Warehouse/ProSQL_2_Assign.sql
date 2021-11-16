-- STEP 1

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

-- STEP 2

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

-- STEP 3
SELECT * FROM dwPlanesDim;
GO

ALTER TRIGGER PlanesLastServiceDateChange ON Planes
AFTER UPDATE 
AS 
BEGIN
	DECLARE @NewLastServiceDate DATE;
	SELECT @NewLastServiceDate = LastServiceDate 
	FROM INSERTED;

	UPDATE dwPlanesDim
	SET LastService = @NewLastServiceDate,
				ServiceStatus = IIF(DATEDIFF(DAY, @NewLastServiceDate, getDate()) <= 45, 'Current', 'Review Service')
	WHERE PlaneID IN (SELECT PlaneID FROM INSERTED)
END;
GO

-- STEP 4

SELECT * FROM Planes;
SELECT * FROM dwPlanesDim;

UPDATE Planes
SET LastServiceDate =  '10/30/2021'
WHERE PlaneID = 100;

UPDATE Planes
SET LastServiceDate = '8/20/2021'
WHERE PlaneID = 107;


-- STEP 5

SELECT PlaneID, ServiceStatus, LastService
FROM dwPlanesDim
WHERE PlaneID = 100 OR PlaneID = 107;