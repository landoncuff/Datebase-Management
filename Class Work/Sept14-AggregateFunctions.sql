SELECT * FROM Books
GO

SELECT * FROM Authors
GO

SELECT * FROM BookAuthors
GO


-- A query to show the book title, price, number of pages and publisher ID for all books published since January 1, 2005
SELECT BookTitle, BookPrice, NumPages, PubID
FROM Books
WHERE PubDate >= '1/1/2005';
--WHERE YEAR(PubDate) >= 2005;

-- A query to show the ISBN, book title, and the name of the company that published the book
SELECT ISBN, BookTitle, PubName
FROM Books JOIN Publishers
ON Publishers.PubID = Books.PubID;


-- a query to *only*  include books over $25. Show booktitle, price, and publication date
-- put the most expensive book at the top of the results and name of the book price column Cost of the Book
-- Order By should always go last in the SQL
-- Order By is the most expensive call so dont use it if you dont need it
-- AS will change the name of the column for your report
SELECT BookTitle, BookPrice AS 'Cost of the Book', PubDate
FROM Books
WHERE BookPrice > 25
ORDER BY BookPrice DESC;
GO

-- A query to display the name of the author in Last Name, First Name format (in a single column) and the book title for all books. Sort the results alphabetically by author
-- will combine the last name and the first name (concatinate)
--SELECT AuLName +', '+AuFName
--FROM Authors;
-- Better way
-- You can alias your tables so you dont have to write as much
-- Order By 1 allows you to sort by the number of column your information is in
SELECT CONCAT(a.AuLName, ', ', a.AuFName) AS 'Author Name', b.BookTitle
FROM Authors a JOIN BookAuthors ba
ON a.AuID = ba.AuID JOIN Books b 
ON b.ISBN = ba.ISBN
ORDER BY 1;
GO


-- Aggregate Functions: Sum, Count, Taking something at atomic number and breaking it down
-- Functions are pink
-- If you have aggregate function in your select clause you need to group by everything that is not the aggregate function
-- A query to list the name of the publisher and the number of book each has published. Sort from most to least. Label the count "Number of Books"
SELECT p.PubName, COUNT(b.ISBN) AS 'Number of Books'
FROM Publishers p JOIN Books b
ON p.PubID = b.PubID
GROUP BY p.PubName
ORDER BY 2 DESC;

-- Adding an Author with no books and publisher with no books
INSERT INTO Authors
VALUES ('Dr.', 'Seuss');

INSERT INTO Publishers 
VALUES ('Hallmark');