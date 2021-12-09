-- Review on ProcSQL assignment 3

-- STEP 1
-- add a ChangeAudit column to the DW fact table

ALTER TABLE dwFlightFacts
ADD ChangeAudit VARCHAR(11);


-- STEP 2:

-- dont forget the WHERE clause

-- write the sql code to make sure 
UPDATE dwFlightFacts SET ChangeAudit = null;

-- add a trigger so that if a flight record in the relational database is ever changed, the corresponding record 
-- in the dwFlightFacts table is flagged in ChangeAudit as 'Need Update'

CREATE TRIGGER FlagFlightUpdates ON Flights
AFTER UPDATE 
AS 
BEGIN
    UPDATE dwFlightFacts 
    SET ChangeAudit = 'Need Update'
    -- a little table that lives in memory during a statement
    -- will get the information from the Flights table
    WHERE FlightID IN (SELECT FlightID FROM INSERTED);
END;
GO

-- cause the trigger to fire on multiple flights 
UPDATE Flights
SET ArriveCode = 'SLC'
WHERE FlightID IN (1073, 1349, 1555, 1782, 1888);
-- find what needs to be updated
SELECT * FROM dwFlightFacts;


-- STEP 3

-- make a function that returns the correct DateID from a DATETIME such as DepartureDateTime and ArrivalDateTime
CREATE FUNCTION DTtoDateID
    (@TheDateTime DATETIME)
    RETURNS INT
AS
BEGIN
    DECLARE @DateID INT;
    SELECT @DateID = DateID
    FROM dwDateDim
    -- you can also use convert
    WHERE RawDate = CAST(@TheDateTime AS DATE) AND HourOfTheDay = DATEPART(HOUR, @TheDateTime);

    RETURN @DateID;
END;
GO

-- Modify the PROC SQL assignment 1 snapshot that left the DateID fields in the fact table null, to use the new 
-- function, to fill in the those fields

ALTER PROC fillFlightFact
AS
BEGIN
	INSERT INTO dwFlightFacts
	
	SELECT FlightID, PlaneID, AirlineID, DepartCode, ArriveCode, dbo.DTtoDateID(DepartDateTime), dbo.DTtoDateID(ArriveDateTime), 
    -- null is the value of the ChangeAudit and the default value is null
	DepartDateTime, ArriveDateTime, getDate(), NULL
	FROM Flights
END;
GO

-- Clean out the fact table
DELETE FROM dwFlightFacts;

-- put data back into the table
EXEC fillFlightFact;
GO


-- STEP 4

-- make a cursor to loop through all flights in the DW fact table that Need Update, and individually set each 
-- them equal to the their corresponding records in Flights

-- stroing it inside a procedure instead of function
CREATE PROC UpdateDWFlights
AS
BEGIN
    -- 1. get the list of all the flightids from dwFlightFacts table that need an update
    -- 2. put these in a cursor to update
    -- 3. get the first flightid from the cursor and put it in a variable =
    -- 4. synchronize the fact table with the flight table for the first flightid that is in a variable 
    -- 5. get the next flightid from the cursor and replace the value in the variable
    -- 6. repeat step 4 and 5 
    -- 7. Exit the cursor when no more flightid are found

    -- creating variables at the top
    DECLARE @UpFlightID INT;

    -- 1 & 2.
    -- holds the values in memeory
    DECLARE NeedUpdateFlights CURSOR FOR
      SELECT FlightID FROM dwFlightFacts WHERE ChangeAudit = 'Need Update';

    
    OPEN NeedUpdateFlights
    -- 3.
        FETCH NEXT FROM NeedUpdateFlights INT @UpFlightID
        WHILE @@FETCH_STATUS = 0
        BEGIN
            -- 4. 
            -- removing the values from the table
            DELETE FROM dwFlightFacts WHERE FlightID = @UpFlightID;
            -- putting values back into the table
            INSERT INTO dwFlightFacts
            SELECT FlightID, PlaneID, AirlineID, DepartCode, ArriveCode, dbo.DTtoDateID(DepartDateTime), 
            dbo.DTtoDateID(ArriveDateTime), DepartDateTime, ArriveDateTime, getDate(), 'Updated'
            FROM Flights 
            WHERE FlightID = @UpFlightID;
            -- 5.
            FETCH NEXT FROM NeedUpdateFlights INTO @UpFlightID;
        END;

END;
GO