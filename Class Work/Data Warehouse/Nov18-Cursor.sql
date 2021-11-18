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
GO
-- a funciton to take in a BookTitle return a comma delimited list of all author names for that book
ALTER FUNCTION BookToAuthors
	(@Title VARCHAR(100))
		-- Max is 8,000 characters
		--RETURNS VARCHAR(MAX)
		RETURNS VARCHAR(200)
AS
BEGIN

	-- puting ISBN for book title in the function's argument into a variable 
	DECLARE @ISBN CHAR(14), @AuID INT, @AuName VARCHAR(36), @AuList VARCHAR(200);
	-- getting the book ISBN from the title that is selected 
	-- can use a select count to make sure there are not the same title in the database
	SELECT @ISBN = ISBN FROM Books WHERE BookTitle = @Title;

	-- an AuID can to be unique
	-- cursor is like an array that can hold both columns and rows
	-- you can not put two values into a variable. A variable can only hold one value (will hold the last one ran)
	-- Declare a cursor to hold all AuID for ISBN found in the query above (FOR is the query below)
	DECLARE MyAuthorList CURSOR FOR 
	-- this query defiens the records to be stored in memory in the cursor
	SELECT AuID FROM BookAuthors WHERE ISBN = @ISBN;

	-- getting the name of the first author from the cursor
	-- open the cursor to access the records in it (You have to open in order to get the records)
	OPEN MyAuthorList
		-- now get the next author name which you will need to use a while loop (based on rows in the cursor so it will stop when it has hit every author)
		FETCH NEXT FROM MyAuthorList INTO @AuID
		-- will check the status of the cursor
		-- global variables need two @@
		-- 0 means that there are still values in the cursor that have not been touched
		WHILE @@FETCH_STATUS = 0
		BEGIN
			-- now you have the AuID so you now need to get the author name for that AuID
			-- putting the name of the authors name into a new variable (Declared at the top)
			SELECT @AuName = CONCAT(AuFName, ' ', AuLName) FROM Authors WHERE AuID = @AuID;

			-- putting the Name into a list to make sure the next name does not override the value already inside
			-- putting the name into the @AuList variable
			-- be careful not to display only one author when there are more than one
			-- Putting the name(s) into the @AuList variable 

			-- will be blank the first time through the loop
			IF @AuList IS NULL
				SET @AuList = @AuName;
			ELSE 
			-- if not null then will concat the new name to the one already inside
				SET @AuList = CONCAT(@AuList, ', ', @AuName);
			
			-- using the fetch next command to retrieve the first AuID in the cursor and putting the AuID into a variable
			FETCH NEXT FROM MyAuthorList INTO @AuID
		END;
		-- return the list to the client
		RETURN @AuList;
END;
GO

-- Testing BookToAuthors Function
SELECT *,  dbo.BookToAuthors(BookTitle)
FROM Books;



-- Updating FillBooks with the Authors names from the function we just created

ALTER PROC fillBooks
AS 
BEGIN
	
	ALTER TABLE dwSalesFacts
	NOCHECK CONSTRAINT FK__dwSalesFac__ISBN__4AB81AF0;


	DELETE FROM dwBooksDim;

	INSERT INTO dwBooksDim

	SELECT ISBN, BookTitle, BookPrice, NumPages, PubDate, dbo.BookToAuthors(BookTitle), getDate()
	FROM Books;


	ALTER TABLE dwSalesFacts
	CHECK CONSTRAINT FK__dwSalesFac__ISBN__4AB81AF0;

END;
GO

EXEC fillBooks;

SELECT * FROM dwBooksDim;



-- A couple of queries to use the data in the star schema 
SELECT b.*, f.*
FROM dwBooksDim b JOIN dwSalesFacts f
ON b.ISBN = f.ISBN;


-- book sales by day of the week
SELECT d.DayOfTheWeek, SUM(f.SalePrice) AS TotalRevenue, AVG(f.SalePrice) AS AverageRevenue
FROM dwDateDim d JOIN dwSalesFacts f
ON d.DateID = f.DateID
WHERE d.MonthOfTheYear = 'October' AND d.YearNumber = 2021
GROUP BY d.DayOfTheWeek
ORDER BY 3 DESC;

-- Cursor without Pseudo


SELECT BookTitle FROM Books;
GO

ALTER FUNCTION BookToAuthors
	(@Title VARCHAR(100))
		RETURNS VARCHAR(200)
AS
BEGIN

	DECLARE @ISBN CHAR(14), @AuID INT, @AuName VARCHAR(36), @AuList VARCHAR(200);

	SELECT @ISBN = ISBN FROM Books WHERE BookTitle = @Title;

	
	DECLARE MyAuthorList CURSOR FOR 
	
	SELECT AuID FROM BookAuthors WHERE ISBN = @ISBN;


	OPEN MyAuthorList
		
		FETCH NEXT FROM MyAuthorList INTO @AuID
	
		WHILE @@FETCH_STATUS = 0
		BEGIN
			SELECT @AuName = CONCAT(AuFName, ' ', AuLName) FROM Authors WHERE AuID = @AuID;

			IF @AuList IS NULL
				SET @AuList = @AuName;
			ELSE 
			
				SET @AuList = CONCAT(@AuList, ', ', @AuName);
			
			
			FETCH NEXT FROM MyAuthorList INTO @AuID
		END;
		
		RETURN @AuList;
END;
GO
