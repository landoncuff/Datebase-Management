--We are creating new table inside the database with the primary key and an attribute
CREATE TABLE Publishers 
(PubID INT IDENTITY(1000,100) PRIMARY KEY, PubName VARCHAR(20));
GO


--creating another table
CREATE TABLE Authors 
	(AuID INT IDENTITY(1,1) PRIMARY KEY, AuFName VARCHAR(15), AuLNAME VARCHAR(20));
	GO
	

--Creating the sellers table
CREATE TABLE Sellers
	(SellerID INT IDENTITY(100,10) PRIMARY KEY, SellerName VARCHAR(25));
	GO
	

--Functionally Indepened tables. Two are functionally dependant upon the other table.
--Publishers is dependant upon books so we are the other new tables we are creating
--using force refereancal entegarty for the FK. If you dont use it then you will create an orfin record. Keeps the records up to date and that nothing is left alone
--REFERENCES will inforce refereancal entergerty
CREATE TABLE Books
	(ISBN CHAR(14) PRIMARY KEY, BookTitle VARCHAR(100), BookPrice MONEY, PubDate DATE, NumPages INT, PubID INT REFERENCES Publishers(PubID));
	GO
	
	
--creating bookAuthors to split up the many to many
--they both are the primary key and foregn key
CREATE TABLE BookAuthors
	(ISBN CHAR(14) REFERENCES Books(ISBN), AuID INT REFERENCES Authors(AuID), PRIMARY KEY (ISBN, AuID));
	GO

--creating BookSellers to split up the many to many
--they both are the primary key and foregn key
CREATE TABLE BookSellers
	(ISBN CHAR(14) REFERENCES Books(ISBN), SellerID INT REFERENCES Sellers(SellerID), PRIMARY KEY (ISBN, SellerID));
	GO