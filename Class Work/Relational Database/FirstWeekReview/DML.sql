--Practicing and reviewing DML SQL
--Looking at the contents of all six tables in the in class book database
SELECT * FROM Publishers;
SELECT * FROM Authors;
SELECT * FROM Sellers;
SELECT * FROM Books;
SELECT * FROM BookAuthors;
SELECT * FROM BookSellers;
GO

--putting stuff in our tables
--called populating the tables
--Populate Publishers table
--when working with data is DDL
--four primary keys to know for DML Insert, Update, Delete, Select
INSERT INTO Publishers
VALUES ('Tour Science Fiction');
GO


--populating Books
--have to put values in order of the attributes for the table
INSERT INTO Books
VALUES ('abc123', 'Oh the places you''ll go', 12.99, '9/2/2021', 61, 1200);
GO

--never update a table without a where!!!!!!
--If you dont have a where it will update the whole database
UPDATE Books
SET BookPrice = 9.99
--you can do this but it will update every book with the same name
--WHERE BookTitle = 'Oh the places you''ll go';
--this will only update the item with this primary key
WHERE ISBN = 'abc123';
GO

DELETE FROM Books
WHERE ISBN = 'abc123';
GO