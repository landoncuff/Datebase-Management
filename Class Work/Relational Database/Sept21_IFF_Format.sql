
-- common aggregate functions 
SELECT COUNT(ISBN) AS NumberOfBooks,
		AVG(NumPages) AS AverageBookLength,
		MIN(BookPrice) AS LeastExpensiveBook,
		MAX(BookPrice) AS MostExpensiveBook,
		--can use the same function over and over again (could use min and max for pages ) 
		--standard Deviation - how far something wonders from the norm (find different values where they are different from the norm)
		STDEV(BookPrice) AS BookPriceDeviation,
		--formating functions
		--dont want the extra fraction of a cent
		--first argument is What you want to round
		--second needs to know how many decimal places 
		ROUND(AVG(BookPrice), 2) AS RoundedBookPrice,
		--adding the dollar sign for the book price money
		-- the 'C' means currency and will round two decimal places
		FORMAT(AVG(BookPrice), 'C') AS CurrencyAvgBookPrice
FROM Books;

--builtin functions:
-- Relational Algebra - treat columns as variables
-- how many sales tax amount we need
-- Calculate the sales tax and the price plus tax
SELECT *, FORMAT(BookPrice, 'C') AS TheBookPrice, 
	FORMAT(BookPrice*0.0685, 'C') AS SalesTaxAmount,
	--works from the inside out
	--FORMAT(BookPrice, 'C') + FORMAT(BookPrice*0.0685, 'C')
	--Calculating the price the bad way
	FORMAT(BookPrice + (BookPrice*0.0685), 'C') AS TotalPrice,
	--Better way to do the amount
	--calculating the price the good way
	FORMAT(BookPrice*1.0685, 'C') AS AltTotalPrice,
	--push decimal values in a direction that they dont want to go
	-- dont want change, just whole dollars
	-- if any decimal at all, go up to the whole number
	CEILING(BookPrice*1.0685) AS RaisedPrice,
	--throw the decemial away
	FLOOR(BookPrice*1.0685) AS LoweredPrice
FROM Books;
GO

--airplane
--100 Seats and 80 Occupied
-- 99 Seats 
	--SELECT 99*.8
	-- CELING(99 * .8) will give you 80 seats

-- conditional Logic
-- when you query results baised on a condition
-- If and Only IF
-- first value in the statement is the true and the second is the false
SELECT BookTitle, NumPages, 
	IIF(NumPages >= 500, 'Long Book', 'Short Book') AS BLen
FROM Books;

--Nested IIF example
SELECT BookTitle, NumPages, 
	IIF(NumPages >= 600, 'Long Book', IIF(NumPages >= 400, 'Medium Book', 'Short Book')) AS BLen
FROM Books;


--Start of class on 9/23/2021
-- More conditional Logic
-- using a conditional logic CASE statement to classify books into 5 categories 1-200, 201-400, 401-600, 601-800, 801+ (you can add to a case later more categories)
-- need to classify every book

-- you can create variables in SQL. They are only in memory when the code is being run = Non presistent attribute
--DECLARE @VSB INT = 200;
SELECT BookTitle, NumPages,
	CASE
		--WHEN NumPages <= @VSB THEN 'Very Short Book'
		WHEN NumPages <= 200 THEN 'Very Short Book'
		WHEN NumPages <= 400 THEN 'Short Book'
		WHEN NumPages <= 600 THEN 'Medium Book'
		WHEN NumPages <= 800 THEN 'Long Book'
		ELSE 'Very Long Book'
	END AS 'Book Length'
FROM Books;


-- write a query using a CASE statement such that books under $10 are "Inexpensive", books that are $10 - $19.99 are "Affordable", Books that are $20 - $39.99 are "more expensive", books that are $40 or more are "Very Expensive"
-- You can do it in reverse order but they must stay in the correct format of following which number actually comes next
SELECT BookTitle, BookPrice,
	CASE
		WHEN BookPrice <= 10 THEN 'Inexpensive'
		WHEN BookPrice <= 20 THEN 'Affordable'
		WHEN BookPrice <= 40 THEN 'More Expensive'
		ELSE 'Very Expensive'
	END AS 'Price Category'
FROM Books;