-- Subqueries 
-- get all information from books table but are part of only three publishers
SELECT * 
FROM Books
WHERE PubID IN
--fetching a set of data (declare a small array)
-- code executes from the inside out
-- does the subquery first
	(SELECT PubID FROM Publishers
	WHERE PubName IN ('Tor Science Fiction', 'Scholastic', 'Disney-Hyperion')
	);

-- Same query from above but using a join
SELECT b.* 
FROM Books b JOIN Publishers p
ON p.PubID = b.PubID
WHERE p.PubName IN ('Tor Science Fiction', 'Scholastic', 'Disney-Hyperion');

-- write a query that does not use any joins that displays the BookTile and BookPrice written by Margy Ross
SELECT * FROM Authors
SELECT * FROM BookAuthors
SELECT * FROM Books

SELECT BookTitle, BookPrice
FROM Books
WHERE ISBN IN
	(SELECT ISBN FROM BookAuthors 
	-- the = sign will be used if displaying only one value
		WHERE AuID IN
			(SELECT AuID FROM Authors 
				WHERE (AuFName = 'Margy' AND AuLName = 'Ross') OR 
				(AuFName = 'Warren' AND AuFName = 'Thornthwaite') OR
				(AuFName = 'Paul' AND AuLName = 'DuBois') OR
				(AuFName = 'Joel' AND AuLName = 'Murach')));

-- Self joins 
-- where a table has a primary key and the foregin key 
-- Create a table of employees for our book stores 
CREATE TABLE Employees (
	EmpID INT IDENTITY(1,1) PRIMARY KEY,
	EmpName VARCHAR (25),
	HireDate DATE,
	ExitDate DATE,
	SupID INT REFERENCES Employees(EmpID),
	SellerID INT REFERENCES Sellers(SellerID)
);
GO

-- adding some employees for Sam Weller's Bookstore
INSERT INTO Employees
VALUES
('Sam Weller', '1/1/1992', NULL, 1, 120),
('Cam Weller', '5/15/1998', NULL, 1, 120),
('Pam Weller', '6/4/1998', NULL, 1, 120),
('Joe Jones', '8/2/2020', NULL, 2, 120),
('Sally Smith', '12/4/2018', NULL, 2, 120),
('Bob Black', '2/15/2019', NULL, 3, 120),
('Dan Davis', '6/17/2021', '8/2/2021', 3, 120);
GO

SELECT * FROM Employees
--WHERE ExitDate IS NULL
--WHERE ExitDate IS NOT NULL