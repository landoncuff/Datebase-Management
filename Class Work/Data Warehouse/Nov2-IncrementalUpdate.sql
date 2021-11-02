


-- Class November 2nd 

-- Full replacement (step 1 of the homework)

-- A program that will snapshot books data from the realtional database to the data warehouse, with full replacement
-- every night we are going to dump our dwBooks data in the warehouse and copy over
ALTER PROC fillBooks
AS 
BEGIN
	-- temporarily suspend refential integrity on ISBN in the fact table
	-- do this because it will throw an error because we are making orphan rows in the Fact table by removing the ISBN
	-- do it off the foreign keys which are only in the fact table
	ALTER TABLE dwSalesFacts
	NOCHECK CONSTRAINT FK__dwSalesFac__ISBN__4AB81AF0;


	-- dumping/Empty the data from the data warehouse before inserting the new information from the realtional database
	DELETE FROM dwBooksDim;

-- if you have the select statement is the correct to the result set then you dont have to have a values clause
	-- wanting to insert into the warehouse
	INSERT INTO dwBooksDim
	-- getting the book data from the realtional database
	SELECT ISBN, BookTitle, BookPrice, NumPages, PubDate, NULL, getDate()
	FROM Books;

	-- Re-enforce refential integrity on ISBN in the fact table (turn back on)
	-- fill back up
	ALTER TABLE dwSalesFacts
	CHECK CONSTRAINT FK__dwSalesFac__ISBN__4AB81AF0;

END;
GO
-- run the fillBooks program
EXEC fillBooks;
GO

SELECT * FROM Books;

SELECT * FROM dwBooksDim;

-- Adding a new book to the inventory in the relational database
INSERT INTO Books
VALUES('abc123', 'My ABC Book', 12.99, '11/2/2021', 68, 1500);


-- Incremental Update

-- Checking what is inside the sellerdim inside the database warehouse
SELECT * FROM dwSellersDim;
GO

-- do we have any seller since the last snapshot
-- a procedure to warehouse seller data with incremental updates
--CREATE PROC fillSellers
ALTER PROC fillSellers
AS 
BEGIN
	INSERT INTO dwSellersDim
	SELECT SellerID, SellerName, getDate()
	FROM Sellers
	-- checking to make sure they have not been created in the data warehouse
	-- checking the data warehouse to make sure the new values from the relational datebase is inserted into the data warehouse
	WHERE SellerID NOT IN (SELECT SellerID FROM dwSellersDim);

END;
GO

-- filling up the sellers dimension
EXEC fillSellers;

SELECT * FROM Sellers;

SELECT * FROM dwSellersDim;

INSERT INTO Sellers
VALUES('Walmart');