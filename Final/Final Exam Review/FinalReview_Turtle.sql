

-- counting turtles by species
-- using a left join to get Matt's turtles
-- you will use a full join if you want all the information from species and turtles
-- if wanting all information from one table you would use either left or right join
SELECT s.SpeciesName, COUNT(t.TurtleID) AS NumTurtles
FROM Species s LEFT JOIN Turtles t
ON s.SpeciesID = t.SpeciesID
GROUP BY s.SpeciesName
ORDER BY 2 DESC;

INSERT INTO Species	
VALUES ('Matt''s Turtles', NULL, NULL);


-- count turtles by species but only show species where at least 8 were found
-- you use a having clause when you are using an agg
SELECT s.SpeciesName, COUNT(t.TurtleID) AS NumTurtles
FROM Species s LEFT JOIN Turtles t
ON s.SpeciesID = t.SpeciesID
GROUP BY s.SpeciesName
HAVING COUNT(t.TurtleID) >= 8
ORDER BY 2 DESC;


-- count turtles by species but only show species where at least 8 were found, with a third column labeling 10 or more as "Large Sample", 
-- otherwise "Small Sample"
SELECT s.SpeciesName, COUNT(t.TurtleID) AS NumTurtles, 
	IIF(COUNT(t.TurtleID) >= 10, 'Large Sample', 'Small Sample')
FROM Species s LEFT JOIN Turtles t
ON s.SpeciesID = t.SpeciesID
GROUP BY s.SpeciesName
HAVING COUNT(t.TurtleID) >= 8
ORDER BY 2 DESC;




-- Functions, Stored Proc, Triggers


-- DDL to create dwSpeciesHealthAgg
CREATE TABLE dwSpeciesHealthAgg (
	SpeciesID INT,
	Health VARCHAR(10),
	TurtleCount INT,
	RecTimestamp DATETIME,
	PRIMARY KEY (SpeciesID, Health)
);
GO

-- Stored procedure that will populate the dwSpeciesHealthAgg table in the Turtles Data Warehouse, with full replacement snapshot program
ALTER PROC fillTurtleHealthAgg
AS
BEGIN
	-- when we create the Fact table we will need to not check for the foregin key
	--ALTER TABLE dwTurtleFacts
	--NOCHECK CONSTRAINT FK__dwTurtleF__Speci__30F848ED;

	-- full replacement we need to delete from the table
	DELETE FROM dwSpeciesHealthAgg

	INSERT INTO dwSpeciesHealthAgg
	-- get the values to get the values for the columns in the table
	SELECT SpeciesID, Health, COUNT(TurtleID) AS TurtleCount, getDate()
	FROM Turtles
	GROUP BY SpeciesID, Health;

	--ALTER TABLE dwTurtleFacts
	--CHECK CONSTRAINT FK__dwTurtleF__Speci__30F848ED;
END;
GO

-- checking the results of executing the procedure above
EXEC fillTurtleHealthAgg;

SELECT * FROM dwSpeciesHealthAgg;



-- Create the dwTurtleFacts DW table
CREATE TABLE dwTurtleFacts (
	TurtleID INT PRIMARY KEY,
	SpeciesID INT, -- REFERENCES dwSpeciesHealthAgg(SpeciesID),
	DateID INT,
	HabitatID INT,
	Health VARCHAR(10),
	RecTimestamp DATETIME
);
GO

DROP TABLE dwTurtleFacts;
GO


-- A function to get the species name from any species ID
CREATE FUNCTION SpeciesIDToName
	(@SpeciesID INT)
	RETURNS VARCHAR(15)
AS
BEGIN
	DECLARE @SpeciesName VARCHAR(15);
	SELECT @SpeciesName = SpeciesName
	FROM Species
	WHERE SpeciesID = @SpeciesID;


	RETURN @SpeciesName;
END;
GO

-- testing the function 
SELECT dbo.SpeciesIDToName(SpeciesID) AS Species, * 
FROM Turtles;
GO


-- A trigger to set the Endangered Column in Species to Y if the Endagered Date is updated to have a value
ALTER TRIGGER SetEndagered ON Species
AFTER UPDATE, INSERT
AS
BEGIN
	UPDATE Species
	SET Endangered = 'Y'
	-- using a where clause to make sure you are not updating all the values that dont have an endangered date
	WHERE SpeciesID IN (SELECT SpeciesID FROM INSERTED WHERE EndangeredDate IS NOT NULL);
END;
GO;

-- Making the trigger fire

SELECT * FROM Species;

UPDATE Species
SET EndangeredDate = getDate()
WHERE SpeciesName = 'Flatback';

DELETE FROM Species WHERE SpeciesName = 'Matt''s Turtles';