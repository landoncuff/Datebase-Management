-- October 5th Class

-- Drived Tables and Subquires

-- We want to see book info for "High volumne" publishers (multiple titles(2 or more titles))
-- We want book level data, but we cant JOIN the tables

--IF we join the tables:
/*SELECT b.ISBN, b.BookTitle, b.BookPrice, b.PubDate, b.NumPages, p.PubName 
FROM Books b JOIN Publishers p
ON b.PubID = p.PubID;*/
-- Doesnt get what we want

--Doesnt work
SELECT b.ISBN, b.BookTitle, b.BookPrice, b.PubDate, b.NumPages, COUNT(p.PubID) AS NumTitles 
FROM Books b JOIN Publishers p
ON b.PubID = p.PubID
-- we need to group by everything but the aggragte function
GROUP BY  b.ISBN, b.BookTitle, b.BookPrice, b.PubDate, b.NumPages;

--We need to figure out which publishers have multiple titles first. Then, we need to retrieve the book level data for those publishers
-- First, find pubID for publishers with more than one book.

SELECT p.PubID
FROM Publishers p JOIN Books b
ON p.PubID = b.PubID
GROUP BY p.PubID
-- Not returning the count. You can just put it in the HAVING Clause 
HAVING COUNT(b.ISBN) > 1;
GO

-- you can use PBC all the information all you want. You can use aggrate data with row level data 
SELECT b.ISBN, b.BookTitle, b.BookPrice, b.PubDate, b.NumPages, pbc.NumTitle
FROM Books b JOIN (
			SELECT p.PubID, p.PubName, COUNT(b.ISBN) AS NumTitle
			FROM Publishers p JOIN Books b
			ON p.PubID = b.PubID
			GROUP BY p.PubID, p.PubName
			-- Not returning the count. You can just put it in the HAVING Clause 
			--HAVING COUNT(b.ISBN) > 1
) AS pbc
ON b.PubID = pbc.PubID
-- we can now use the WHERE instead of the HAVING clause in the drived table
WHERE pbc.NumTitle > 1;

-- new query 

-- SELECT all book columns for books sold by Sam Weller's without using a JOIN 

-- Fist Identify Sam Weller's Seller ID
SELECT SellerID FROM Sellers
WHERE SellerName = 'Sam Weller''s';
-- use this a subquery to find ISBN sold at Sam Weller's
-- you want to get the books id to know which books
SELECT ISBN FROM BookSellers
-- we can use IN or =. the equal will be for more than one 
WHERE SellerID IN (
	SELECT SellerID FROM Sellers
	WHERE SellerName = 'Sam Weller''s');

-- Finally, get the book data for the ISBN in the subqueries
SELECT * From Books
-- is checking to see if the ISBN is inside the list of ISBN returned from the second subquery
WHERE ISBN IN (
	SELECT ISBN FROM BookSellers
-- we can use IN or =. the equal will be for more than one 
	WHERE SellerID IN (
		SELECT SellerID FROM Sellers
		WHERE SellerName = 'Sam Weller''s'));



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



Flight number 1001 flew from Las Vegas, NV (LAS), on Friday, March 19, 2021 at 18:50. Southwest  airlines' Embraer RJ-45, which was last serviced on Jan 17, 2021, was the aircraft used for the flight. The flight will arrive in Orlando, FL (MCO), on Friday, March 19, 2021 at 22:23.

Flight number 1000 flew from Pittsburgh, PA (PIT), on Sunday, August 1, 2021 at 06:28. American airlines' Airbus A330, which was last serviced on Jan 23, 2021, was the aircraft used for the flight. The flight will arrive in Dallas-Fort Worth, TX (DFW), on Sunday, August 1, 2021 at 09:45.

Flight number 1000 flew from Pittsburgh, PA (PIT), on Sunday, August 1, 2021 at 06:28. American airlines' Airbus A330, which was last serviced on Jan 23, 2021, was the aircraft used for the flight. The flight will arrive in Dallas-Fort Worth, TX (DFW), on Aug  1 2021  9:45AM

Flight number 1000 flew from Pittsburgh, PA (PIT), on Sunday, August 1, 2021 at 06:28. American airlines' Airbus A330, which was last serviced on Jan 23, 2021Dallas-Fort Worth, TXDFWAug  1 2021  9:45AM

Flight number 1000 flew from Pittsburgh, PA (PIT), on Sunday, August 1, 2021 at 06:28. American airlines' Airbus A3302021-01-23Dallas-Fort Worth, TXDFWAug  1 2021  9:45AM

Flight number 1000 flew from Pittsburgh, PA (PIT), on Sunday, August 1, 2021 at 06:28AmericanAirbus A3302021-01-23Dallas-Fort Worth, TXDFWAug  1 2021  9:45AM


Flight number 1000 flew from Pittsburgh, PA (PIT), on Sunday, August 1, 2021AmericanAirbus A3302021-01-23Dallas-Fort Worth, TXDFWAug  1 2021  9:45AM

Flight number 1000 flew from Pittsburgh, PA (PIT), on Sunday, August 1AmericanAirbus A3302021-01-23Dallas-Fort Worth, TXDFWAug  1 2021  9:45AM

Flight number 1000 flew from Pittsburgh, PA (PIT), on Sunday, AugustAmericanAirbus A3302021-01-23Dallas-Fort Worth, TXDFWAug  1 2021  9:45AM

Flight number 1000 flew from Pittsburgh, PA (PIT), on SundayAmericanAirbus A3302021-01-23Dallas-Fort Worth, TXDFWAug  1 2021  9:45AM

Flight number 1000 flew from Pittsburgh, PA (PIT), on Aug  1 2021  6:28AMAmericanAirbus A3302021-01-23Dallas-Fort Worth, TXDFWAug  1 2021  9:45AM



Flight number 1000 flew from Pittsburgh, PA (PIT), onAug  1 2021  6:28AMAmericanAirbus A3302021-01-23Dallas-Fort Worth, TXDFWAug  1 2021  9:45AM



Flight number 1000 flew from Pittsburgh, PA (PIT)Aug  1 2021  6:28AMAmericanAirbus A3302021-01-23Dallas-Fort Worth, TXDFWAug  1 2021  9:45AM