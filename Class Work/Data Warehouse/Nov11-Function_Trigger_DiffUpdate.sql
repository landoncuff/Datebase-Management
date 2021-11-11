-- Creating a new function:

-- we give you an ISBN and we will give you back a title of the book
-- custom scalar function that will receive an ISBN and return the book title for that ISBN

CREATE FUNCTION ISBNToTitle 
	-- we have to provide the arguments for the functions. Function will always have agruments
	-- variable that can hold an ISBN
	-- the arugment must be the correct data type and value.
	-- The agrument needs a returns value or data type (BookTitle in the books table has a VARCHAR(100) that is what we are wanting to return)
	-- this is the input
	(@ISBN CHAR(14))
		-- the return value will go from a char to a varchar
		RETURNS VARCHAR(100)
AS 
BEGIN
	-- declaring a variable to pass back to the head
	DECLARE @BookTitle VARCHAR(100);
	-- tells us what to do in order to get the desired output
	-- we are passing the value of BookTitle to a variable @BookTitle
	SELECT @BookTitle = BookTitle
	FROM Books
	-- the ISBN from the database comparing to the variable
	WHERE ISBN = @ISBN;

	-- returning the BookTitle variable for the function
	RETURN @BookTitle
END;
GO

-- testing the ISBNToTitle function 

-- you dont exec a function but you use it inside the query
-- using a table that has a ISBN
SELECT * FROM BookAuthors;

-- you have to run a function using the dbo because it is custom
-- passing the ISBN as a parameter that will pass into the function 
-- we need to pass in the ISBN to make it dynmaic and to get the correct ISBN for all the books and it will pass all back to the function param
SELECT DISTINCT ISBN, dbo.ISBNToTitle(ISBN)
FROM BookAuthors;
GO



-- CREATE OUR OWN FUNCTION 

-- write a function that will convert an AuID into the authoers name, first name, last name format

CREATE FUNCTION AuIDToName
	(@AuID INT)
		RETURNS VARCHAR(36)
AS
BEGIN
	--DECLARE @FirstName VARCHAR(15);
	--DECLARE @LastName VARCHAR(20);
	DECLARE @FullName VARCHAR(36);
	SELECT @FullName = CONCAT(AuFName, ' ', AuLName)
	FROM Authors
	WHERE AuID = @AuID;

	RETURN @FullName;
END;
GO

-- Testing the function 
SELECT DISTINCT ISBN, dbo.ISBNToTitle(ISBN) AS BookTitle, AuID, dbo.AuIDToName(AuID) AS AuthorName
FROM BookAuthors;
GO


-- TRIGGERS (Event-Handlers) 

-- Only Triggers in SQL (Update, Delete, Insert)

-- creating Async data betweeb relationship database and warehouse

-- rembering what the relationship database and data warehouse looking relative to book sales
SELECT * FROM BookSales;
SELECT * FROM dwSalesFacts;
GO


-- Make one sales record out of sync between relational database and data warehouse
UPDATE BookSales
SET BookPrice = 31.50
WHERE SaleID = 1000000;

-- adding a column to BookSales (relational database) to flag any row that gets updated 
ALTER TABLE BookSales
ADD ChangeFlag CHAR(1);
GO

-- trigger lives on the table where the fire starts
-- if a Delete, Update, or Insert happen, let us know (we can have it trigger after the event or instead of the event)
-- have to assign the trigger to the table where the firing event will happen

-- this will help with differencal update so you dont have to go every single row to see what has changed
-- creating a trigger to set ChangeFlag to Y if a record is updated
CREATE TRIGGER FlagSaleChanges ON BookSales
-- you can trigger it off all of them at once or you can create different triggers
--AFTER UPDATE, INSERT, DELETE
AFTER UPDATE
AS
BEGIN
	-- update the booksales column
	UPDATE BookSales
	SET ChangeFlag = 'Y'
	-- will update the whole table if you dont have a where clause
	-- inserted table lives in memory and holds memory of all items that are being Updated, Inserted, or Deleted
	WHERE SaleID IN (SELECT SaleID FROM INSERTED);
END;
GO

-- make one more BookSales out of sync
UPDATE BookSales
SET ISBN ='978-1890774691', BookPrice = 25.47, SellerID = 110
WHERE SaleID = 1000004;

INSERT INTO BookSales
VALUES('abc123', 4.53, getDate(), 120, NULL);
GO

-- Make a stored procedure to apply differential updates to dwSalesFacts to synchronize both updated records and add any new ones
ALTER PROC syncSalesFacts
AS 
BEGIN
	-- we dont have to worry about comparing if you delete from the warehouse and insert it again
	DELETE FROM dwSalesFacts WHERE SaleID IN 
		(SELECT SaleID FROM BookSales WHERE ChangeFlag = 'Y')

		-- incremental update to the Sales Facts
		INSERT INTO dwSalesFacts
		SELECT s.SaleID, NULL, b.PubID, s.ISBN, s.SellerID, s.BookPrice, getDate()
		FROM BookSales s JOIN Books b
		ON s.ISBN = b.ISBN
		-- we dont want to insert data that already exists inside the sales fact table
		WHERE SaleID NOT IN (SELECT SaleID FROM dwSalesFacts);
		-- removing the Y changeflag after sync. if we didnt then it would update the same values everytime
		-- we need to disable the trigger or it will run and turn everything to Y
		DISABLE TRIGGER FlagSaleChanges ON BookSales
		UPDATE BookSales
		SET ChangeFlag = NULL
		WHERE ChangeFlag = 'Y';
		ENABLE TRIGGER FlagSaleChanges ON BookSales;
		
END;
GO

-- execute the sync stored procedure to both update changed records and copy any new ones over from the relational database
EXEC syncSalesFacts;
GO