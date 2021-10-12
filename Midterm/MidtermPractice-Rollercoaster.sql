
SELECT * FROM Coasters;

SELECT * FROM CoasterType;

SELECT * FROM Parks;

-- Write a query that displays the number of coaster for each park
/*SELECT c.CoasterName, COUNT(t.CoasterTypeID)
FROM Coasters c JOIN CoasterType t
ON c.CoasterTypeID = t.CoasterTypeID
GROUP BY c.CoasterName;*/


-- The number of coasters or each park
SELECT p.ParkName, COUNT(c.CoasterID) AS 'Number of Coasters'
FROM Parks p JOIN Coasters c
ON c.ParkID = p.ParkID
GROUP BY p.ParkName, p.ParkID;

-- 
SELECT CoasterTypeName, RetiredDate 
FROM CoasterType
WHERE RetiredDate = '08/22/2007'

-- Update all Retired Dates with a single query
UPDATE CoasterType
SET RetiredDate = 
	CASE
		WHEN CoasterTypeName = 'Wooden' THEN '3/23/2021'
		WHEN CoasterTypeName = 'Steel' THEN '12/4/2021'
		WHEN CoasterTypeName = 'Inverted' THEN '2/17/2022'
		WHEN CoasterTypeName = 'Launched' THEN '10/13/2021'
		WHEN CoasterTypeName = 'Stand-Up' THEN '8/22/2007'
		WHEN CoasterTypeName = 'Suspended' THEN '4/16/2012'
	END;


-- Display Coasters in their parks location
SELECT c.CoasterName, p.ParkLocation
FROM Coasters c JOIN Parks p
ON c.ParkID = p.ParkID;

-- Remove all the Safety Status where it is good and replace it with Great 
UPDATE Coasters
SET SafetyStatus = REPLACE(SafetyStatus, 'Good', 'Great');
GO

-- Select the parks that have poor safety Status on their coasters
SELECT p.ParkName, COUNT(p.ParkID) AS 'Great Coastes'
FROM Parks p JOIN Coasters c
ON c.ParkID = p.ParkID
WHERE c.SafetyStatus = 'Poor'
GROUP BY p.ParkName;
GO

SELECT CONCAT(DATENAME(MONTH, RetiredDate), ' ', DAY(RetiredDate), ', ', YEAR(RetiredDate))
FROM CoasterType;

SELECT ct.CoasterTypeName, c.SafetyStatus
FROM Coasters c JOIN CoasterType ct
ON c.CoasterTypeID = ct.CoasterTypeID
WHERE c.SafetyStatus = 'Poor';