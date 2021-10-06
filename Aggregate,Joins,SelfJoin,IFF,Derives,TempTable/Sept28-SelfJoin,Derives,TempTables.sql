-- Sept 28 Class

-- Self joins (need primary key and foreign key in the same table)

-- show a list of employee's names and their immediate supervisor's name
-- break in into two differnt tables to understand what is going on. S is a table and E is a table
SELECT e.EmpName, e.EmpID, s.EmpName
FROM Employees e JOIN Employees s
ON s.EmpID = e.SupID;
GO

-- Creation of a view for employees and the sellers they work for
-- stayes in the database until you drop it
-- you can join it other tables if wanted
-- they are auto updated when something is added or taken away from the database
-- use views to hide data from peoples view
CREATE VIEW SellerEmployees AS 
SELECT e.EmpID, e.EmpName, s.SellerName
FROM Employees e JOIN Sellers s
ON s.SellerID = e.SellerID;
GO


-- Derived Tables
-- resolts of a query that is stored in memory
-- only there during run time
-- 
SELECT e.EmpID, e.EmpName, dt.EmpName
FROM Employees e JOIN 
	(SELECT EmpID, EmpName
	FROM Employees) dt
ON dt.EmpID = e.SupID;

-- add your self to the employees table as an amazon employee
INSERT INTO Employees
VALUES('Landon Cuff', '6/23/2020', null, 8, 100);
GO

-- Temp Tables in SQL Server
-- table of book information and authors name
-- is there during your session but then will end when you kill it
-- inbetween a derived table and a view
CREATE TABLE #BooksAndTheirAuthors (
	ISBN CHAR(14), 
	BookTitle VARCHAR(100),
	PubDate DATE,
	-- combinin the first and last name
	AuthorName VARCHAR(36),
	-- combining the ISBN primary key and the Authors primary key
	PRIMARY KEY (ISBN, AuthorName)
);
GO

-- populate the #BooksAndTheirAuthors temp table
INSERT INTO #BooksAndTheirAuthors
SELECT b.ISBN, b.BookTitle, b.PubDate, 
	CONCAT(a.AuFName, ' ', a.AuLName)
FROM Books b JOIN BookAuthors ba 
ON b.ISBN = ba.ISBN JOIN Authors a
ON a.AuID = ba.AuID;

-- now I can use this as a table until I end my session 
SELECT * FROM #BooksAndTheirAuthors;

-- Write a query to list the empid, empName, supName, using a temp table
CREATE TABLE #EmployeeSup (
	EmpID INT,
	EmpName VARCHAR(36),
	SupID INT
);
GO

INSERT INTO #EmployeeSup
SELECT e.EmpName, s.EmpName, e.EmpID
FROM Employees e JOIN Employees s
ON s.EmpID = e.SupID;
GO

SELECT * FROM #EmployeeSup

-- Professors work
CREATE TABLE #SupData (
	EmpID INTEGER PRIMARY KEY,
	EmpName VARCHAR(25)
);
GO

INSERT INTO #SupData
SELECT EmpID, EmpName
FROM Employees
-- only getting supervisors
-- can find all the unique values using the DISTINCT
WHERE EmpID IN (SELECT SupID FROM Employees);

SELECT * FROM #SupData;

SELECT e.EmpID, e.EmpName, s.EmpName
FROM Employees e JOIN #SupData s
ON e.SupID = s.EmpID;