CREATE TABLE dwCustomerDim (
    CustomerID INT PRIMARY KEY,
    CustFName VARCHAR(15),
    CustLName VARCHAR(15),
    CustAddress VARCHAR(50),
    RecTimestamp DATETIME
)

CREATE TABLE dwOrderProductDim (
    OrderID INT REFERENCES Orders (OrderID),
    ProductID INT REFERENCES Products (ProductID),
    PRIMARY KEY (OrderID, ProductID),
    ProdName VARCHAR(50),
    QuantityPerProduct INT,
    ProductPrice MONEY,
    ProductDiscontinued BIT,
    RecTimestamp DATETIME
)

CREATE TABLE dwDateDim (
    DateID INT IDENTITY(1,1) PRIMARY KEY,
    RawDate DATETIME,
    DayOfTheWeek VARCHAR(9),
    MonthOfTheYear VARCHAR(9),
    QuarterOfTheYear CHAR(7),
    YearOfOrder INT,
    RecTimestamp DATETIME
)

CREATE TABLE dwSupplierDim (
    SuppliersID INT PRIMARY KEY,
    CompanyName VARCHAR(20),
    CompanyAddress VARCHAR(50),
    RecTimestamp DATETIME
)

CREATE TABLE dwEmployeesDim (
    EmpID INT PRIMARY KEY,
    EmpLName VARCHAR(15),
    EmpFName VARCHAR(15),
    RecTimestamp DATETIME
)

CREATE TABLE dwOrderFact (
    OrderID INT PRIMARY KEY,
    FOREIGN KEY (DateID) REFERENCES dwDateDim(DateID),
    FOREIGN KEY (CustomerID) REFERENCES dwCustomerDim(CustomerID),
    FOREIGN KEY (ProductID) REFERENCES dwProductDim(ProductID),
    FOREIGN KEY (SuppliersID) REFERENCES dwSupplierDim(SuppliersID),
    FOREIGN KEY (EmpID) REFERENCES dwEmployeesDim(EmpID),
    OrderDate DATETIME,
    RecTimestamp DATETIME
)