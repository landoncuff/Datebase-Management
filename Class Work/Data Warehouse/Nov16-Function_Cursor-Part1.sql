
-- Remind ourselves what is missing in the data warehouse so that we can add those missing values
SELECT * FROM dwBooksDim;
SELECT * FROM dwSalesFacts;

SELECT * FROM BookSales;
GO



-- Cursors:

-- getting the dateID 
-- Function to convert a date into a date id
CREATE FUNCTION DateToID
	(@SaleDate DATE)
		RETURNS INT
AS
BEGIN
	DECLARE @SaleDateID INT;
	SELECT @SaleDateID = DateID
	FROM dwDateDim
	-- no matter what date is selected, it will get the correct date
	WHERE RawDate = @SaleDate

	RETURN @SaleDateID
	
END;
GO

-- Testing the function:
-- getting the id of the date inside the datedim table of the warehouse. We only started at April 1st of 2021 so everything before that will be null
SELECT dbo.DateToID(getDate());

SELECT *, dbo.DateToID(SaleDate)
FROM BookSales;
GO


-- Altering the fillFacts Stored procedure to include the DateID using the new function we just wrote:
ALTER PROC fillSalesFacts
AS
BEGIN
	-- add the salesfacts to the data warehouse
	-- will cause problems with the forgein keys and need to remmeber updating 
	INSERT INTO dwSalesFacts
	SELECT s.SaleID, dbo.DateToID(SaleDate), b.PubID, s.ISBN, s.SellerID, s.BookPrice, getDate()
	FROM BookSales s JOIN Books b
	ON s.ISBN = b.ISBN;
END;
GO

-- Manually doing a full replacement update on the fact table
DELETE FROM dwSalesFacts;
EXEC fillSalesFacts

SELECT * FROM dwSalesFacts;



-- How to create a cursor:
-- a cursor will always remain
-- like an inserted table that is in memeory and can have multiple values 
-- like an array

-- fetching the names of authors and creating multiple value depedancy

-- Pseudo code for a cursor to build a list of authors for any given book
-- 1. Given a book title, first find the ISBN (Books table because they are both in the Books table)
-- 2. Having found the ISBN, get the list of AuIDs (BookAuthors table) SELECT AuID FROM BookAuthors WHERE ISBN = ''
-- 3. Having the list of AuID, get the Author name for the first author in the AuID list which is BookAuthors (Authors Table)
-- 4. Check for a next AuID (book that has more than one author). IF one exist, get the author name for that AuID (Authors Table)
-- 5. Repeat step 4, until no more AuIDs are found (Loop to repeat an action until it is no longer true(while Loop))
-- 6. Return the list of author names to the client
SELECT BookTitle FROM Books;