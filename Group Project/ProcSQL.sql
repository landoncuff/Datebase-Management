

SELECT * FROM dwOrderProductDim;
SELECT * FROM dwSupplierDim;
SELECT * FROM Products;
SELECT * FROM Suppliers;
GO

CREATE PROC fillOrderProducts
AS
BEGIN
	DELETE FROM dwOrderProductDim;
	INSERT INTO dwOrderProductDim	
	SELECT o.OrderID, p.ProductID, p.ProdName, p.QuantityPerProduct, p.ProductPrice, p.ProductDiscontinued, getDate()
	FROM Products p JOIN ProductOrder o
	ON p.ProductID = o.ProductID;
END;
GO

EXEC fillOrderProducts;
GO



CREATE PROC fillSuppliers
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
