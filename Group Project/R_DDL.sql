CREATE TABLE Suppliers (
    SuppliersID INT IDENTITY(1,1) PRIMARY KEY,
    CompanyName VARCHAR(25),
    SupplContactName VARCHAR(25),
    SuppContactTitle VARCHAR(15), 
    CompanyPhone CHAR(12),
    CompanyAddress VARCHAR(50)
)

CREATE TABLE Categories (
    CategoryID INT IDENTITY(1,1) PRIMARY KEY,
    CategoryName VARCHAR(20),
    CategoryDescription VARCHAR(50)
)

CREATE TABLE Employees (
    EmpID INT IDENTITY(1,1) PRIMARY KEY,
    EmpLName VARCHAR(15),
    EmpFName VARCHAR(15),
    EmpBirthDate DATE, 
    EmpPhoneNum CHAR(12),
    EmpAddress VARCHAR(50)
)

CREATE TABLE Shippers (
    ShippersID INT IDENTITY(1,1) PRIMARY KEY,
    ShipCompName VARCHAR(20),
    ShipperPhone CHAR(12),
)

CREATE TABLE Products (
    ProductID INT IDENTITY(1,1) PRIMARY KEY,
    ProdName VARCHAR(30),
    SuppliersID INT REFERENCES Suppliers (SuppliersID),
    CategoryID INT REFERENCES Categories (CategoryID),
    QuantityPerProduct INT,
    ProductPrice MONEY,
    ProductDiscontinued BIT
)

CREATE TABLE Customers (
    CustomerID INT IDENTITY(1,1) PRIMARY KEY,
    CustFName VARCHAR(15),
    CustLName VARCHAR(15),
    CustAddress VARCHAR(20),
    CustState CHAR(2),
    CustPhone CHAR(14)
)

CREATE TABLE Orders (
    OrderID INT IDENTITY(1,1) PRIMARY KEY,
    CustomerID INT REFERENCES customers (CustomerID)
    EmpID INT REFERENCES Employees (EmpID),
    OrderDate DATETIME,
    OrderShippedBy INT REFERENCES Shippers (ShippersID)

)

CREATE TABLE ProductOrder (
    OrderID INT REFERENCES Orders (OrderID),
    ProductID INT REFERENCES Products (ProductID),
    PRIMARY KEY (OrderID, ProductID),
    ProductQuantity INT
)