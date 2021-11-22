

-- STEP 1
ALTER TABLE dwFlightFacts
ALTER COLUMN ChangeAudit VARCHAR(12);

SELECT * FROM dwFlightFacts;
GO

-- STEP 2
CREATE TRIGGER FlagDwFLightTable ON Flights
AFTER UPDATE
AS 
BEGIN
	UPDATE dwFlightFacts
	SET ChangeAudit = 'Need Update'
	WHERE FlightID IN (SELECT FlightID FROM INSERTED);
END;
GO



-- STEP 3

SELECT * FROM dwDateDim;
GO

CREATE FUNCTION GetDepartArriveDateID
	(@DateDepart DATETIME)
		RETURNS INT
AS
BEGIN
	DECLARE @DateID INT;
	SELECT @DateID = DateID
    FROM dwDateDim 
    WHERE RawDate = CONVERT(Date, @DateDepart, 101)
	
	RETURN @DateID;
END;
GO

ALTER PROC fillFlightFact
AS
BEGIN
	INSERT INTO dwFlightFacts
	
	SELECT FlightID, PlaneID, AirlineID, DepartCode, ArriveCode, dbo.GetDepartArriveDateID(DepartDateTime), dbo.GetDepartArriveDateID(ArriveDateTime), 
	DepartDateTime, ArriveDateTime, getDate(), Null
	FROM Flights
END;
GO

EXEC fillFlightFact;
GO

SELECT *, dbo.GetDepartArriveDateID(DepartureDateTime), dbo.GetDepartArriveDateID(ArrivalDateTime)
FROM dwFlightFacts;
GO

-- STEP 4: 


SELECT * FROM Flights;
SELECT * FROM dwFlightFacts;
GO

ALTER PROC updateFlightFact
AS
BEGIN

	DECLARE @UpdatedFlightID INT, @PlaneID INT, @AirlineID INT, @DepartCode CHAR(3), @ArriveCode CHAR(3), @DepartDate DATETIME, @ArrivedDate DATETIME, @NewFlight INT;
	
	DECLARE MyFlightList CURSOR FOR 
	SELECT FlightID FROM dwFlightFacts WHERE ChangeAudit = 'Need Update';
	
	OPEN MyFlightList
		
		FETCH NEXT FROM MyFlightList INTO @NewFlight

		WHILE @@FETCH_STATUS = 0
		BEGIN
			SELECT @UpdatedFlightID = FlightID, @PlaneID = PlaneID, @AirlineID = AirlineID, @DepartCode = DepartCode, @ArriveCode = ArriveCode, @DepartDate = DepartDateTime,
			@ArrivedDate = ArriveDateTime
			FROM Flights;

			UPDATE dwFlightFacts
			SET PlaneID = @PlaneID, AirlineID = @AirlineID, OriginAirport = @DepartCode, DestinationAirport = @ArriveCode, 
			DepartureDateID = dbo.GetDepartArriveDateID(@DepartDate), ArrivalDateID = dbo.GetDepartArriveDateID(@ArrivedDate), DepartureDateTime = @DepartDate, 
			ArrivalDateTime = @ArrivedDate, RecTimestamp = getDate(), ChangeAudit = 'Updated'
			WHERE FlightID = @UpdatedFlightID

			FETCH NEXT FROM MyFlightList INTO @NewFlight
		END; 
END;
Go



/* TEST: 


SELECT * FROM Flights
WHERE FlightID = 1079;

SELECT * FROM dwFlightFacts
WHERE FlightID = 1079;


UPDATE Flights
SET DepartDateTime = '12/31/2021 00:00:000'
WHERE FlightID = 1079;


EXEC updateFlightFact;

SELECT * FROM dwFlightFacts;

EXEC fillFlightFact;

DELETE FROM dwFlightFacts;

*/







/*
Maybe notes: 	DECLARE @PlaneID INT, @AirlineID INT, @DepartCode CHAR(3), @ArriveCode CHAR(3), @DepartDate DATETIME, @ArrivedDate DATETIME, @NewFlight INT;


	SELECT @PlaneID = PlaneID, @AirlineID = AirlineID, @DepartCode = DepartCode, @ArriveCode = ArriveCode, @DepartDate = DepartDateTime, @ArrivedDate = ArriveDateTime
	FROM Flights 
    
    
CREATE FUNCTION UpdateFlightFacts
	(@FlightID INT)
		RETURNS VARCHAR(12)
AS
BEGIN
	DECLARE @UpdatedFlightID INT, @PlaneID INT, @AirlineID INT, @DepartCode CHAR(3), @ArriveCode CHAR(3), @DepartDate DATETIME, @ArrivedDate DATETIME, @NewFlight INT;
	
	DECLARE MyFlightList CURSOR FOR 
	SELECT FlightID FROM dwFlightFacts WHERE ChangeAudit = 'Need Update';
	
	OPEN MyFlightList
		
		FETCH NEXT FROM MyFlightList INTO @NewFlight

		WHILE @@FETCH_STATUS = 0
		BEGIN
			SELECT @UpdatedFlightID = FlightID, @PlaneID = PlaneID, @AirlineID = AirlineID, @DepartCode = DepartCode, @ArriveCode = ArriveCode, @DepartDate = DepartDateTime,
			@ArrivedDate = ArriveDateTime
			FROM Flights;

			UPDATE dwFlightFacts
			SET PlaneID = @PlaneID, AirlineID = @AirlineID, OriginAirport = @DepartCode, DestinationAirport = @ArriveCode, 
			DepartureDateID = dbo.GetDepartArriveDateID(@DepartDate), ArrivalDateID = dbo.GetDepartArriveDateID(@ArrivedDate), DepartureDateTime = @DepartDate, 
			ArrivalDateTime = @ArrivedDate, RecTimestamp = getDate(), ChangeAudit = 'Updated' 
		END; 
END;
GO    
    */

