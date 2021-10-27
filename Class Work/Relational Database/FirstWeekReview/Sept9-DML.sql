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
--VALUES ('Tour Science Fiction'),
VALUES ('Disney-Hyperion'),
('Wiley'),
('O''Reilly'),
('Murach & Associates'),
('Scholastic'),
('Infinte Publishing');
GO


--if we didnt know the authors name
--telling the database that you only have the last name of the author and it will figure out the first name
--you can spesifiy which values you want to enter
--INSERT INTO Authors (AuLNAME)
--VALUES ('Jones');

--populating the Authors table
--Inserting the first name and last name
INSERT INTO Authors
VALUES
('Orson Scott', 'Card'),
('Rick', 'Riordan'),
('Ralph', 'Kimball'),
('Margy', 'Ross'),
('Sayed M. M.', 'Tahaghoghi'),
('Hugh', 'Williams'),
('Brayn', 'Syverson'),
('Joel', 'Murach'),
('J.K.', 'Rowling'),
('Paul', 'DuBois'),
('Aaron', 'Johnston'),
('Mathew', 'North'),
('Laura', 'Reeves'),
('Warren', 'Thornthwaite');
GO

--populating the sellers table
INSERT INTO Sellers
VALUES 
('Amazon'),
('Barnes & Noble'),
('Sam Weller''s');


--populating the books table
INSERT INTO Books
VALUES 
('978-0812550702', 'Ender''s Game',	 5.99, 	'7/15/1994', 352, 1200),
('978-0786838653',	'The Lightning Thief (Percy Jackson and the Olympians, Book 1)', 5.29, 	'3/21/2006', 416, 1300),
('978-0812550757',	'Speaker for the Dead',	 7.99, 	'8/15/1994',	382,	1200),
('978-1118530801',	'The Data Warehouse Toolkit',	 48.14, 	'7/1/2013',	600, 1400),
('978-0596008642',	'Learning MySQL: Get a Handle on Your Data',	 29.93, 	'11/24/2006', 618, 1500),
('978-1890774691',	'Murach''s SQL Server 2012 for Developers',	 40.70, 	'8/20/2012', 814, 1600),
('978-0439708180',	'Harry Potter and the Sorcerer''s Stone',	 6.85, 	'9/8/1999',	309, 1700),
('978-0439136365',	'Harry Potter and the Prisoner of Azkaban',	 6.75, 	'9/11/2001', 448, 1700),
('978-1449374020',	'MySQL Cookbook',	 51.80, 	'8/18/2014', 866, 1500),
('978-0439064873',	'Harry Potter and the Chamber of Secrets',	 6.85, 	'8/15/2000', 341, 1700),
('978-0765375629',	'The Swarm: The Second Formic War (Volume 1)', 12.99, 	'8/2/2016',	464, 1200),
('978-1523321438',	'Data Mining for the Masses',	 44.99, '1/8/2016',	312, 1800),
('978-0471255475',	'The Data Warehouse Lifecycle Toolkit',	 40.92, '8/13/1998', 800, 1400);
GO


--Populating the BookAuthors table
INSERT INTO BookAuthors
VALUES 
('978-0812550702', 1),
('978-0786838653', 2),
('978-0812550757', 1),
('978-1118530801', 3),
('978-1118530801', 4),
('978-0596008642', 5),
('978-0596008642', 6),
('978-1890774691', 7),
('978-1890774691', 8),
('978-0439708180', 9),
('978-0439136365', 9),
('978-1449374020', 10),
('978-0439064873', 9),
('978-0765375629', 1),
('978-0765375629', 11),
('978-1523321438', 12),
('978-0471255475', 13),
('978-0471255475', 4),
('978-0471255475', 14);

GO

--Populating the book sellers
INSERT INTO BookSellers
VALUES
('978-0812550702', 100),
('978-0812550702', 110),
('978-0786838653', 100),
('978-0786838653', 110),
('978-0786838653', 120),
('978-0812550757', 100),
('978-0812550757', 110),
('978-1118530801', 100),
('978-1118530801', 110),
('978-0596008642', 100),
('978-0596008642', 110),
('978-1890774691', 100),
('978-1890774691', 110),
('978-0439708180', 100),
('978-0439708180', 110),
('978-0439708180', 120),
('978-0439136365', 100),
('978-0439136365', 110),
('978-0439136365', 120),
('978-1449374020', 100),
('978-1449374020', 110),
('978-1449374020', 120),
('978-0439064873', 100),
('978-0439064873', 110),
('978-0439064873', 120),
('978-0765375629', 100),
('978-0765375629', 110),
('978-1523321438', 100),
('978-0471255475', 100);


SQL:

--Practicing SQL
SELECT * FROM Books
--A query to show the book title, price, number of pages and publisher ID for all books published since January 1, 2005
SELECT BookTitle, BookPrice, NumPages, PubID FROM Books
WHERE PubDate >= '1/1/2005';
--WHERE YEAR(PubDate) >= 2005;

--SELECT BookTitle, BookPrice, NumPages, PubID FROM Books
--WHERE PubDate BETWEEN '1/1/2005' AND '9/9/2021';


-- A query to show the ISBN, BookTitle, and the name of the company that published the book
-- Think of the tables as sets. 
SELECT ISBN, BookTitle, PubName 
FROM Books JOIN Publishers 
--wouldnt know which one is primary if we dont put the table in front of it
ON Publishers.PubID = Books.PubID;
