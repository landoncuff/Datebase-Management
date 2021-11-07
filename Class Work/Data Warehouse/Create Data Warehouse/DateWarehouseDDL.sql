--Making our first data warehouse
--Star schema for Book Sales Facts
-- Making the dwDateDim table
CREATE TABLE dwDateDim (
	DateID INT IDENTITY(1,1) PRIMARY KEY,
	RawDate DATE,
	DayOfTheWeek VARCHAR(9),
	MonthOfTheYear VARCHAR(9),
	QuarterOfTheYear VARCHAR(7),
	YearNumber INT,
	RecTimestamp DATETIME
);
GO

--Create dwPubDim table
CREATE TABLE dwPubDim (
	PubID INT PRIMARY KEY,
	PubName VARCHAR(30),
	RecTimestamp DATETIME
);
GO

-- Create dwSellersDim table
CREATE TABLE dwSellersDim (
	SellerID INT PRIMARY KEY,
	SellerName VARCHAR(35),
	RecTimestamp DATETIME
);
GO

-- Creating the dwRevenueAgg aggregate table
CREATE TABLE dwRevenueAgg (
	ISBN CHAR(14) PRIMARY KEY,
	CopiesSold INT,
	TotalSalesPrice MONEY,
	TotalWhslPrice MONEY,
	RecTimestamp DATETIME
);
GO

-- Creating the dwBookDim table
CREATE TABLE dwBooksDim (
	ISBN CHAR(14) PRIMARY KEY,
	BookTitle VARCHAR(100),
	BookPrice MONEY,
	NumPages INT,
	PubDate DATE,
	AuthorList VARCHAR(200),
	RecTimestamp DATETIME
);
GO

-- Create the dwSalesFacts table
CREATE TABLE dwSalesFacts(
	SaleID INT PRIMARY KEY,
	DateID INT REFERENCES dwDateDim(DateID),
	PubID INT REFERENCES dwPubDim(PubID),
	ISBN CHAR(14),
	SellerID INT REFERENCES dwSellersDim(SellerID),
	SalePrice MONEY,
	RecTimestamp DATETIME,
	FOREIGN KEY (ISBN) REFERENCES dwRevenueAgg(ISBN),
	FOREIGN KEY (ISBN) REFERENCES dwBooksDim(ISBN)
);
GO