CREATE TABLE dwCustomerDim (
    CustomerID INT PRIMARY KEY,
    CustFName VARCHAR(15),
    CustLName VARCHAR(15),
    CustAddress VARCHAR(50),
    RecTimestamp DATETIME
)

CREATE TABLE dwProductDim (
    ProductID INT PRIMARY KEY,
    ProdName VARCHAR(30),
    QuantityPerProduct INT,
    ProductPrice MONEY,
    RecTimestamp DATETIME
)

CREATE TABLE dwDateDim (
    DateID INT IDENTITY(1,1) PRIMARY KEY,
    RawDate DATETIME,
    DayOfTheWeek VARCHAR(9),
    MonthOfTheYear VARCHAR(9),
    QuarterOfTheYear CHAR(7),
    YaerOfOrder INT,
    RecTimestamp DATETIME
)

CREATE TABLE dwSupplierDim (
    SupplierID INT PRIMARY KEY,
    CompanyName VARCHAR(20),
    RecTimestamp DATETIME
)

CREATE TABLE dwEmployeesDim (
    EmployeeID INT PRIMARY KEY,
    EmpLName VARCHAR(15),
    EmpFName VARCHAR(15),
    RecTimestamp DATETIME
)

CREATE TABLE dwOrderFact (
    OrderID INT PRIMARY KEY,
    OrderDate DATETIME,
    FOREIGN KEY (CustomerID) REFERENCES dwCustomerDim(CustomerID),
    FOREIGN KEY (ProductID) REFERENCES dwProductDim(ProductID),
    FOREIGN KEY (SupplierID) REFERENCES dwSupplierDim(SupplierID),
    FOREIGN KEY (EmployeeID) REFERENCES dwEmployeesDim(EmployeeID),
    RecTimestamp DATETIME
)