-- Sept 30 Class

-- review on Having and Where Clause

-- only getting publishers that have multiple books (more than 1)
-- why cant we just use where instead of having?
	-- you cant because the parsing engine. Parsing engine looks at from clause fisrt
	-- then looks at the join
	-- then looks at the select clause
	-- then will look at the where (if we have an agrement function we have to use a having because the agrement hasnt happen when the where executes)
SELECT p.PubName, COUNT(b.ISBN) AS BooksPublished
FROM Publishers p JOIN Books b
ON p.PubID = b.PubID
GROUP BY p.PubName
HAVING COUNT(b.ISBN) > 1;


-- will help on homework for sql 3

--functions that allow us to work with dates and strings
-- examples of text (CHAR or VCHAR) built-in functions 
SELECT BookTitle, 
	-- first five characters of the title. Will include spaces
	-- read from left to right
	LEFT(BookTitle, 5) AS FristFive,
	-- getting the last 5 from the string
	RIGHT(BookTitle, 5) AS LastFive,
	-- I only want one letter
	-- you are starting at 7 and then grabbing 4 after it
	SUBSTRING(BookTitle, 7, 4) AS MidFour,
	-- replace in a string. Replacing all the R with T
	REPLACE(BookTitle, 'r', 't') AS RReplacement,
	-- find the word and and replace with & 
	REPLACE(BookTitle, 'and', '&') AS AnotherReplace,
	-- you can reverse the wording of the title 
	REVERSE(BookTitle) AS BackwardsTitle,
	-- changing the data type example: string to int (usually defaults to VARCHAR)
	-- know the date the book was published
	CAST(PubDate AS VARCHAR(10)) AS StringDate,
	-- another way as code above
	-- look at WD3 schools to see the the formats
	CONVERT(VARCHAR(10), PubDate, 100) AS ConvertedDate,
	-- format does not change the data type
	FORMAT(BookPrice, 'C') AS CurrentPrice
FROM Books;
GO

-- Dates built in functions

SELECT BookTitle,
		-- will get the actual month from the date field and return INT. Will never display more than 12
		MONTH(PubDate) AS PubMonth, -- data type returned is INT
		-- will get the year the book was published
		YEAR(PubDate) AS PubYear,  -- data type returned is INT
		-- will compair how long ago from the current year we are in. (Example year 2000 will display a 21)
		YEAR(getDate()) - YEAR(PubDate) AS BookAgeInYears,
		-- how old are these books from the fraction of the year
		-- make sure it gets to the actual date. (birthday hasnet happend)
		DATEDIFF(MONTH, PubDate, getDate())/12 AS CalcAge,
		-- how old is it today?
		DATEDIFF(DAY, PubDate, getDate())/365.25 AS CalcAgeDays,
		-- getting the day the book was published (getting the day from the data type)
		DAY(PubDate) AS PubDay,
		-- gett which day of the year it was published on (out of 365)
		DATEPART(DAYOFYEAR, PubDate) AS PubDayOfYear,
		-- wanting the quarter of the year and will start on January first and format the year at the end and a Q at the start
		CONCAT('Q', DATEPART(QUARTER, PubDate), '-', YEAR(PubDate)) AS QuarterPudd,
		-- adding 10 years to the books
		-- use for bonds or due dates
		-- you can use year, month, day, week, etc
		DATEADD(YEAR, 10, PubDate) AS PubDatePlus10
		
FROM Books;

-- getDate
-- will display as the current year. What if your birthday still hasnet happened
SELECT DATEDIFF(DAY, '04/23/1996', getDate());

-- you can go back in time 
		-- what was the date 6 months from toda
SELECT DATEADD(MONTH, -6, getDate());

-- write a query to show book title and whether it is an old book or a new book, based on whether it was published on or after this minus 11.
--SELECT BookTitle,
	--IIF(DAY(PubDate) = getDate() ? AS New : AS Old)
--FROM Books;

SELECT BookTitle, IIF(DATEDIFF(YEAR, PubDate, getDate()) > 11, 'Old Book', 'New Book') AS BookAge
FROM Books;

-- will be fixed
SELECT BookTitle, IIF(DATEADD(YEAR, -11, getDate()) > DATEADD(YEAR, -11, PubDate), 'Old Book', 'New Book') AS BookAge
FROM Books;