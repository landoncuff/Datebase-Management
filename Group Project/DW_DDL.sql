CREATE TABLE dwCustomerDim (
    CustomerID INT PRIMARY KEY,
    CustFName VARCHAR(15),
    CustLName VARCHAR(15),
    CustCity VARCHAR(25),
    CustState CHAR(2),
    CustZip CHAR(5),
    RecTimestamp DATETIME
)

CREATE TABLE dwOrderProductDim (
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
    CompanyCity VARCHAR(25),
    CompanyState CHAR(2),
    CompanyZip CHAR(5),
    RecTimestamp DATETIME
)

CREATE TABLE dwEmployeesDim (
    EmpID INT PRIMARY KEY,
    EmpLName VARCHAR(15),
    EmpFName VARCHAR(15),
    RecTimestamp DATETIME
)

CREATE TABLE dwProductTotalAgg (
    StateID CHAR(2) PRIMARY KEY,
    TotalProducts INT,
    RecTimestamp DATETIME
)

CREATE TABLE dwOrderFact (
    OrderID INT PRIMARY KEY,
	DateID INT,
	CustomerID INT,
	StateName CHAR(2),
	SuppliersID INT,
	EmpID INT,
    OrderDate DATETIME,
    RecTimestamp DATETIME,
	FOREIGN KEY (DateID) REFERENCES dwDateDim(DateID),
    FOREIGN KEY (CustomerID) REFERENCES dwCustomerDim(CustomerID),
    FOREIGN KEY (StateName) REFERENCES dwProductTotalAgg(StateID),
    FOREIGN KEY (SuppliersID) REFERENCES dwSupplierDim(SuppliersID),
    FOREIGN KEY (EmpID) REFERENCES dwEmployeesDim(EmpID)
)