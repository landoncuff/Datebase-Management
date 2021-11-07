-- fix a proc

/*ALTER TABLE dwDateDim
ADD RecTimestmap DATETIME*/


-- check the state of our data warehouse tables

SELECT * FROM dwDateDim;
SELECT * FROM dwBooksDim;
SELECT * FROM dwSellersDim;
SELECT * FROM dwPubDim;
SELECT * FROM dwRevenueAgg;
SELECT * FROM dwSalesFacts;
GO

-- publishers dim

CREATE PROC fillPub
AS 
BEGIN
	INSERT INTO dwPubDim
	SELECT PubID, PubName, getDate()
	FROM Publishers
	-- checking to make sure they have not been created in the data warehouse
	-- checking the data warehouse to make sure the new values from the relational datebase is inserted into the data warehouse
	WHERE PubID NOT IN (SELECT PubID FROM dwPubDim);
END;
GO

-- filling up the pub dim 
EXEC fillPub;

SELECT * FROM dwPubDim;

-- A stored procedure to add Revenue Agg by book to the data warehouse

SELECT * FROM dwRevenueAgg;

-- using a left join to get the books that have never been sold
-- broke this down one step at a time and then move it over to the a procedure to insert into the data warehouse
SELECT b.ISBN, COUNT(s.SaleID), SUM(s.BookPrice), SUM(b.BookPrice), getDate()
FROM Books b LEFT JOIN BookSales s
ON b.ISBN = s.ISBN
GROUP BY b.ISBN;
GO

-- create

-- using a full replacement to keep the table up to date
ALTER PROC fillRevenue
AS 
BEGIN
	-- deleting from the table in order to update the table the next day with new values
	DELETE FROM dwRevenueAgg
	-- using an insert to move into the data warehouse
	INSERT INTO dwRevenueAgg
	-- if the book price is empty, set it to 0 or display the book price
	-- if the count of the saleID is 0 (does not exist) then set to 0 or display the book price
	SELECT b.ISBN, COUNT(s.SaleID), IIF(SUM(s.BookPrice) IS NULL, 0, SUM(s.BookPrice)), IIF(COUNT(s.SaleID)= 0, 0, SUM(b.BookPrice)), getDate()
	FROM Books b LEFT JOIN BookSales s
	ON b.ISBN = s.ISBN
	GROUP BY b.ISBN;
END;
GO

-- run fillRevenue to update book sale totals
EXEC fillRevenue;



-- Stored Procdure to fill up the sales facts table, with no updates (for now)
-- write the SQL first
-- leaving the date null
-- b.PubID is in the books table
SELECT s.SaleID, NULL, b.PubID, s.ISBN, s.SellerID, s.BookPrice, getDate()
FROM BookSales s JOIN Books b
ON s.ISBN = b.ISBN;
GO


-- create fillSaleFacts
-- create
ALTER PROC fillSalesFacts
AS
BEGIN
	-- add the salesfacts to the data warehouse
	-- will cause problems with the forgein keys and need to remmeber updating 
	INSERT INTO dwSalesFacts
	SELECT s.SaleID, NULL, b.PubID, s.ISBN, s.SellerID, s.BookPrice, getDate()
	FROM BookSales s JOIN Books b
	ON s.ISBN = b.ISBN;
END;
GO

EXEC fillSalesFacts;
GO
