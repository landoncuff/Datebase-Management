SELECT * FROM Books
GO

SELECT * FROM Authors
GO

SELECT * FROM BookAuthors
GO

SELECT * FROM Publishers
GO


-- Joins 


-- Adding an Author with no books and publisher with no books
INSERT INTO Authors
VALUES ('Dr.', 'Seuss');

INSERT INTO Publishers 
VALUES ('Hallmark');

-- uses these joins when there is a many to not manitory
--FULL is alos another outer join
SELECT p.PubName, b.BookTitle
--this is where the left right matters. Matters in SQL not the ER Diagram 
-- creating it from an inner join and creating an outer join (getting all the records from the left table which is publishers)
-- will get all values even if they do not link to books (Hallmark is not in the books table)
FROM Publishers p LEFT JOIN Books b
ON p.PubID = b.PubID;
--Hallmark is now null


-- A query to display all publishers (even if they dont have any books in our database), all authors (even if they dont have any books in our database),
--and a count of books and average prices 
-- Include all publishers even if they dont have any books (turn the first join into a Left Join but then taken out by other joins)
-- The full join will add Dr. Sesuss and Hallmark because it will give you ALL the authors on the left and ALL the Authors on the right
SELECT p.PubName, CONCAT(a.AuFName, ' ', a.AuLName) AS AuName, COUNT(b.ISBN) as BookCount, AVG(b.BookPrice) AS AveragePrice
FROM Publishers p LEFT JOIN Books b
ON p.PubID = b.PubID LEFT JOIN BookAuthors ba
ON b.ISBN = ba.ISBN FULL JOIN Authors a
ON a.AuID = ba.AuID
GROUP BY p.PubName, a.AuFName, a.AuLName
--ordering by column 3 from least to most
ORDER BY 3;


--  A query that shows the seller's name and the number of titles that they sell but only include sellers that offer at least 10 different book titles

-- Counting the primary key instead of booktile because we know it can not be null
-- Cant use a where clase because we cant have a aggregate funtcion in a where. Use a "Having" that comes after the Group (a group has some condision)
		--this is only used to filter the aggregate function 
SELECT s.SellerName, COUNT(b.ISBN) AS NumberOfBooks
FROM Sellers s JOIN BookSellers bs
ON  s.SellerID = bs.SellerID JOIN Books b
ON bs.ISBN = b.ISBN
GROUP BY s.SellerName
HAVING COUNT(b.ISBN) >= 10;
GO


-- Without using a JOIN, a query to list all book data for books published by Scholastic, Disney, or Tor Science Fiction (We'll call this youth ficiton books)
/*SELECT b.* 
FROM Books b JOIN Publishers p
ON b.PubID = p.PubID
WHERE p.PubName = 'Scholastic' OR p.PubName = 'Disney-Hyperiion' OR p.PubName = 'Tor Science';*/

--WHERE PubID = 1500 OR PubID = 1100 OR PubID = 1000;

SELECT * 
FROM Books
WHERE PubID IN (1500, 1100, 1000);
--Same query for books but NOT published by 
--WHERE PubID NOT IN (1500, 1100, 1000)
--AND BookPrice < 10;


-- common aggregate functions 
SELECT COUNT(ISBN) AS NumberOfBooks,
		AVG(NumPages) AS AverageBookLength,
		MIN(BookPrice) AS LeastExpensiveBook,
		MAX(BookPrice) AS MostExpensiveBook
FROM Books;