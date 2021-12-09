

SELECT * FROM dwOrderProductDim;
SELECT * FROM dwSupplierDim;
SELECT * FROM Products;
SELECT * FROM Suppliers;
GO


--TRIGGER:

ALTER TRIGGER CustomerUpdate ON Customers
AFTER UPDATE
AS
BEGIN
	UPDATE Customers
	SET ChangeFlag = 'Updated'
	WHERE CustomerID IN (SELECT CustomerID FROM INSERTED);

END;
GO


ALTER PROC syncOrderFact 
AS
BEGIN

	ALTER TABLE dwOrderFact
	NOCHECK CONSTRAINT FK__dwOrderFa__State__48CFD27E, FK__dwOrderFa__Custo__47DBAE45;
	
	DELETE FROM dwCustomerDim WHERE CustomerID IN 
	(SELECT CustomerID FROM Customers WHERE ChangeFlag = 'Updated');

	DELETE FROM dwOrderFact WHERE CustomerID IN 
	(SELECT CustomerID FROM Customers WHERE ChangeFlag = 'Updated');

	INSERT INTO dwCustomerDim
	 SELECT CustomerID, CustFName, CustLName, CustCity, CustState, CustZip, GETDATE()
        FROM Customers
	WHERE CustomerID NOT IN (SELECT CustomerID FROM dwCustomerDim);


	INSERT INTO dwOrderFact
	select DISTINCT o.OrderID, dbo.DateToID(o.OrderDate) AS DateID, o.CustomerID, c.CustState, null, o.EmpID, o.OrderDate, getdate()
	from Orders as o join Customers as c
	on o.CustomerID = c.CustomerID
	JOIN ProductOrder p 
	ON p.OrderID = o.OrderID
	JOIN Products pr 
	ON pr.ProductID = p.ProductID
	JOIN Suppliers s 
	ON s.SuppliersID = pr.SuppliersID
	WHERE o.CustomerID NOT IN (SELECT CustomerID FROM dwOrderFact);

	
	
	DISABLE TRIGGER CustomerUpdate ON Customers
	UPDATE Customers
	SET ChangeFlag = NULL
	WHERE ChangeFlag = 'Updated';
	ENABLE TRIGGER CustomerUpdate ON Customers;

	
	ALTER TABLE dwOrderFact
	CHECK CONSTRAINT FK__dwOrderFa__State__48CFD27E, FK__dwOrderFa__Custo__47DBAE45
	
END;
GO


-- Functions:

CREATE FUNCTION ProdIDToProdName
	(@ProductID INT)
		RETURNS VARCHAR(25)
AS
BEGIN
	DECLARE @ProdName VARCHAR(25);
	SELECT @ProdName = ProdName FROM Products WHERE ProductID = @ProductID

	RETURN @ProdName;
END;
GO

SELECT OrderID, dbo.ProdIDToProdName(ProductID) AS 'Product', QuantityPerProduct, ProductPrice, ProductDiscontinued
FROM dwOrderProductDim;
GO



CREATE FUNCTION CustIDToCustName
	(@CustID INT)
		RETURNS VARCHAR(36)
AS
BEGIN
	DECLARE @CustName VARCHAR(36);
	SELECT @CustName = CONCAT(CustFName, ' ', CustLName)
	FROM Customers
	WHERE CustomerID = @CustID;

	RETURN @CustName;
END;
GO

SELECT OrderID, dbo.ProdIDToProdName(ProductID), QuantityPerProduct, ProductPrice, dbo.CustIDToCustName(OrderID) AS 'Customer Name' 
FROM dwOrderProductDim;

ALTER function DateToID
(@OrderDate datetime)
returns int
as
begin
	DECLARE @OrderDateID int;
	SELECT @OrderDateID = DateID
	FROM dwDateDim
	WHERE RawDate = CONVERT(date, @OrderDate, 101)
	RETURN @OrderDateID;
end;
GO




-- Stored Proc

    -- Fill dwCustomerDim will all of our customers with a full replacement update each time the procedure is run.
ALTER PROC fillCustomerDim
AS
BEGIN
-- Disable ref keys from fact table
    ALTER TABLE dwOrderFact
    NOCHECK CONSTRAINT FK__dwOrderFa__Custo__47DBAE45
        -- The key that it refs
    DELETE FROM dwCustomerDim
        INSERT INTO dwCustomerDim
        SELECT CustomerID, CustFName, CustLName, CustCity, CustState,CustZip, GETDATE()
        FROM Customers
    -- Enable ref key from fact table
	ALTER TABLE dwOrderFact
    CHECK CONSTRAINT FK__dwOrderFa__Custo__47DBAE45
	    -- The key that it refs
END;
GO

EXEC fillCustomerDim;
GO


ALTER procedure filldwEmployeesDim
as
Begin
	ALTER TABLE dwOrderFact
    NOCHECK CONSTRAINT FK__dwOrderFa__EmpID__4AB81AF0
	INSERT INTO dwEmployeesDim
	SELECT EmpID, EmpLName, EmpFName, getdate()
	FROM Employees

	ALTER TABLE dwOrderFact
    CHECK CONSTRAINT FK__dwOrderFa__EmpID__4AB81AF0
End;
go



-- Filling dwProductTotalAgg with a full replacement update each time the procedure is run.
ALTER PROC fillTotalAgg
AS
BEGIN
	-- Disable the ref keys
	ALTER TABLE dwOrderFact
	NOCHECK CONSTRAINT FK__dwOrderFa__State__48CFD27E
		-- Fk of the fact table
		
	DELETE FROM dwProductTotalAgg;
	INSERT INTO dwProductTotalAgg
		SELECT c.CustState, COUNT(p.OrderID) AS 'Number of Orders', getDate()
		FROM Customers c JOIN Orders o 
		ON c.CustomerID = o.CustomerID
		JOIN ProductOrder p 
		ON o.OrderID = p.OrderID
		GROUP BY c.CustState
		ORDER BY 2 DESC;
		-- Enable ref key
		ALTER TABLE dwOrderFact
		CHECK CONSTRAINT FK__dwOrderFa__State__48CFD27E
			-- Fk of the fact table
END;
GO

EXEC fillTotalAgg;
GO
SELECT * FROM dwDateDim;
GO

-- Fill dates in the dwDateDim by the day starting from this year until the end of 2022
-- This will be run once
ALTER PROC fillDateDim--(@StartTime DATETIME, @EndTime DATETIME)
AS
BEGIN
	
    DECLARE @StartTime DATE = '1/1/18', @EndTime DATE = '12/31/20'
	WHILE @StartTime <= @EndTime
	BEGIN
		INSERT INTO dwDateDim
		VALUES (
			@StartTime, -- RawDate
			DATENAME(WEEKDAY, @StartTime), -- Day
			DATENAME(MONTH, @StartTime), -- Month
			CONCAT('Q', DATEPART(QUARTER, @StartTime),'-',YEAR(@StartTime)), -- Quarter
			YEAR(@StartTime), -- Year
			GETDATE() -- TimeStamp
			);
		SET @StartTime = DATEADD(day, 1, @StartTime);
	END;
END;
GO


EXEC fillDateDim;
GO




ALTER PROC fillOrderProducts
AS
BEGIN
	
	INSERT INTO dwOrderProductDim	
	SELECT o.OrderID, p.ProductID, p.ProdName, p.QuantityPerProduct, p.ProductPrice, p.ProductDiscontinued, getDate()
	FROM Products p JOIN ProductOrder o
	ON p.ProductID = o.ProductID
	WHERE o.OrderID NOT IN (SELECT OrderID FROM dwOrderProductDim);
END;
GO

EXEC fillOrderProducts;
GO





ALTER PROC fillSuppliers
AS
BEGIN
	INSERT INTO dwSupplierDim
	SELECT SuppliersID, CompanyName, CompanyCity, CompanyState, CompanyZip, getDate()
	FROM Suppliers
	WHERE SuppliersID NOT IN (SELECT SuppliersID FROM dwSupplierDim);
END;
GO

EXEC fillSuppliers;
GO



ALTER procedure fillOrderFact
as
Begin
	
	INSERT INTO dwOrderFact
	SELECT DISTINCT p.OrderID, dbo.DateToID(o.OrderDate) AS DateID, o.CustomerID, c.CustState, s.SuppliersID, o.EmpID, o.OrderDate, getdate()
	FROM Orders AS o JOIN Customers AS c
	ON o.CustomerID = c.CustomerID
	JOIN ProductOrder p 
	ON p.OrderID = o.OrderID
	JOIN Products pr 
	ON pr.ProductID = p.ProductID
	JOIN Suppliers s 
	ON s.SuppliersID = pr.SuppliersID;
End;
GO

EXEC fillOrderFact;
GO



