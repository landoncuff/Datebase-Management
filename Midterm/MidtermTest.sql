SELECT * FROM Coasters;

SELECT * FROM CoasterType;

SELECT * FROM Parks;


INSERT INTO CoasterType
VALUES('Jones'' Lapbar', '3/1/1948');

SELECT r.CoasterTypeName, COUNT(c.CoasterID) AS 'Number of Coasters', IIF(COUNT(c.CoasterID) > 8, 'Many Coasters', 'Few Coasters') AS 'Coaster Def'
FROM Coasters c RIGHT JOIN CoasterType r 
ON c.CoasterTypeID = r.CoasterTypeID
GROUP BY r.CoasterTypeName
ORDER BY 2 DESC;

/*SELECT p.ParkName, COUNT(c.CoasterID)
Coasters c JOIN Parks p
ON c.ParkID =*/

SELECT p.ParkName
FROM Coasters c JOIN Parks p
ON c.ParkID = p.ParkID
GROUP BY p.ParkName
HAVING COUNT(c.CoasterID) > 5;

/*SELECT ParkName

FROM Parks

WHERE ParkID IN (

SELECT ParkID 

FROM Coasters

WHERE 
)*/


SELECT ParkName 
FROM Parks
WHERE ParkID NOT IN (
	SELECT ParkID
	FROM Coasters
	WHERE SafetyStatus = 'Acceptable' OR SafetyStatus = 'Poor');


-- Same as code above but using a JOIN when the test said not to

-- SELECT p.ParkName, c.SafetyStatus
-- FROM Parks p JOIN Coasters c
-- ON p.ParkID = c.ParkID
-- WHERE c.SafetyStatus = 'Acceptable' OR c.SafetyStatus = 'Poor';

SELECT ct.CoasterTypeName, COUNT(c.CoasterID) AS 'Amount of Coasters'
FROM CoasterType ct LEFT JOIN Coasters c
ON ct.CoasterTypeID = c.CoasterTypeID
WHERE DATEDIFF(YEAR, ct.RetiredDate, getDate()) > 10
GROUP BY ct.CoasterTypeName;


-- YEAR(ct.RetiredDate), DATEDIFF(YEAR, ct.RetiredDate, getDate())
--Stand-up
--Suspended