USE RealEstate_RLC;
GO

CREATE TABLE Realtors (
	RID INT IDENTITY(1,1) PRIMARY KEY,
	RealtorName VARCHAR(25)
);
GO

CREATE TABLE Owners (
	OID INT IDENTITY(100,1) PRIMARY KEY,
	OwnerName VARCHAR(25)
);
GO

CREATE TABLE Homes (
	HID INT IDENTITY(10000,1) PRIMARY KEY,
	HomeAddress VARCHAR(100),
	HomeCity VARCHAR(20),
	HomeState CHAR(2),
	OID INT REFERENCES Owners(OID)
);
GO

CREATE TABLE ForSale (
	ListID INT IDENTITY(100000, 1) PRIMARY KEY,
	HID INT REFERENCES Homes(HID),
	OID INT REFERENCES Owners(OID),
	RID INT REFERENCES Realtors(RID),
	ListDate DATE,
	ListPrice MONEY
);
GO 

INSERT INTO Realtors
VALUES
('Angel Alvarez'),
('Alonzo Webster'),
('Erik Phillips'),
('Alice Schwartz'),
('Vanessa Campbell'),
('Antoinette Newton'),
('Joshua Roberts'),
('Victor Curry');
GO

INSERT INTO Owners
VALUES
('Edna Meyer'),
('Gabriel Weaver'),
('Angela Clark'),
('Rochelle Goodman'),
('Max Wise'),
('Cesar Gomez'),
('Lindsey Webster'),
('Tina Williamson'),
('Darin Palmer'),
('Winifred Jones'),
('Samuel Leitner');
GO

INSERT INTO Homes
VALUES 
('97 Pennsylvania Alley', 'Syracuse', 'NY', 103),
('23 Dapin Lane', 'New Haven', 'CT', 102),
('38 Lotheville Alley', 'Kansas City', 'MO', 100),
('73725 Dahle Parkway', 'Paterson', 'NJ', 110),
('67 Crowley Alley', 'Louisville', 'KY', 102),
('363 Pleasure Avenue', 'Phoenix', 'AZ', 109),
('45 Maple Parkway', 'Richmond', 'VA', 104),
('61 Farwell Place', 'Richmond', 'VA', 105),
('42 Hagan Terrace', 'Cincinnati', 'OH', 110),
('090 Waubesa Lane', 'Santa Clara', 'CA', 106),
('415 Morrow Point', 'Washington', 'DC', 104),
('21 Pennsylvania Crossing', 'Pasadena', 'CA', 103),
('72 Dwight Terrace', 'Bloomington', 'IL', 106),
('147 Kenwood Court', 'Charlotte', 'NC', 108),
('3153 Ruskin Street', 'Columbus', 'OH', 107),
('4877 Hoepker Drive', 'Springfield', 'MA', 106),
('6 Graedel Street', 'Chicago', 'IL', 108),
('4281 Carberry Lane', 'Washington', 'DC', 110),
('15 Coleman Crossing', 'Fort Lauderdale', 'FL', 108),
('769 Monument Pass', 'Huntington', 'WV', 109),
('822 Cherokee Plaza', 'Atlanta', 'GA', 109),
('69 Towne Parkway', 'Garland', 'TX', 102),
('02544 Welch Avenue', 'Los Angeles', 'CA', 109),
('18 Karstens Drive', 'Minneapolis', 'MN', 101),
('9 Stuart Junction', 'Houston', 'TX', 105),
('6 Hansons Trail', 'Greenville', 'SC', 101),
('34986 Cody Place', 'Columbus', 'OH', 103),
('2101 Haas Way', 'Tacoma', 'WA', 102),
('69 Corben Street', 'Pasadena', 'CA', 110),
('969 Heath Street', 'Pueblo', 'CO', 110),
('20587 Gulseth Plaza', 'El Paso', 'TX', 106),
('23365 Twin Pines Alley', 'Washington', 'DC', 103),
('9 Warner Street', 'Jeffersonville', 'IN', 103),
('04371 Mockingbird Circle', 'Lubbock', 'TX', 102),
('29336 Schmedeman Point', 'Columbia', 'SC', 104),
('64 Mesta Alley', 'Columbia', 'SC', 105),
('26 Del Sol Center', 'Washington', 'DC', 109),
('8 Eliot Avenue', 'Oklahoma City', 'OK', 107),
('0 Memorial Point', 'Omaha', 'NE', 110),
('58 Victoria Lane', 'Austin', 'TX', 108),
('8276 Dorton Terrace', 'Saint Louis', 'MO', 106),
('69862 Johnson Point', 'Valdosta', 'GA', 106),
('51373 Marquette Place', 'Zephyrhills', 'FL', 101),
('9598 Merchant Park', 'Atlanta', 'GA', 104),
('2 Vernon Drive', 'Birmingham', 'AL', 110),
('287 Delaware Point', 'Silver Spring', 'MD', 102),
('3145 Vera Trail', 'Glendale', 'CA', 104),
('7 Haas Road', 'Tallahassee', 'FL', 108),
('90619 Pepper Wood Place', 'Spring', 'TX', 100),
('1949 Moland Avenue', 'Raleigh', 'NC', 102),
('95738 Homewood Alley', 'El Paso', 'TX', 105),
('0 Farragut Terrace', 'Syracuse', 'NY', 105),
('2 Lawn Junction', 'San Jose', 'CA', 102),
('87 Oak Valley Crossing', 'Sacramento', 'CA', 110),
('8 Ronald Regan Way', 'Huntsville', 'AL', 107),
('95484 Barnett Hill', 'Washington', 'DC', 105),
('7 Messerschmidt Parkway', 'San Antonio', 'TX', 101),
('22 Alpine Place', 'San Antonio', 'TX', 101),
('330 Marcy Center', 'Austin', 'TX', 106),
('609 Pepper Wood Crossing', 'Montgomery', 'AL', 110),
('74252 Meadow Ridge Center', 'Van Nuys', 'CA', 103),
('62 Pearson Plaza', 'Kansas City', 'KS', 101),
('120 Daystar Road', 'Raleigh', 'NC', 100),
('82739 Grover Circle', 'Young America', 'MN', 103),
('04 Steensland Alley', 'Albuquerque', 'NM', 101),
('2 Raven Court', 'Roanoke', 'VA', 107),
('3004 Duke Pass', 'Santa Barbara', 'CA', 100),
('56 Bartelt Terrace', 'Houston', 'TX', 106),
('06774 Claremont Circle', 'Little Rock', 'AR', 107),
('2 Chinook Drive', 'Salt Lake City', 'UT', 108),
('43079 Dapin Alley', 'New York City', 'NY', 110),
('186 Westerfield Street', 'El Paso', 'TX', 100),
('51 Eagle Crest Way', 'Philadelphia', 'PA', 102),
('571 Iowa Court', 'Fort Worth', 'TX', 101),
('370 Hayes Court', 'Albuquerque', 'NM', 110),
('601 Briar Crest Crossing', 'Fresno', 'CA', 107);
GO

INSERT INTO ForSale
VALUES 
(10003, 103, 8, '6/26/2019', 860780),
(10022, 102, 7, '8/25/2019', 178971),
(10001, 109, 4, '8/8/2019', 1032684),
(10006, 104, 4, '7/7/2019', 817752),
(10019, 103, 3, '9/13/2019', 891856),
(10074, 101, 4, '5/18/2019', 517359),
(10021, 109, 2, '7/21/2019', 170080),
(10007, 105, 7, '8/1/2019', 527230),
(10009, 107, 1, '7/6/2019', 310922),
(10057, 101, 6, '6/3/2019', 1127649),
(10064, 102, 2, '5/31/2019', 364199),
(10020, 109, 8, '4/17/2019', 546047),
(10055, 110, 7, '6/15/2019', 1082923),
(10056, 106, 1, '5/20/2019', 320854),
(10073, 101, 6, '5/7/2019', 622660),
(10004, 104, 8, '3/21/2019', 533634),
(10012, 105, 3, '12/30/2018', 121684),
(10044, 110, 3, '3/14/2019', 412097),
(10037, 103, 6, '5/8/2019', 583886),
(10030, 109, 3, '4/9/2019', 201332),
(10058, 107, 3, '5/1/2019', 524201),
(10075, 110, 5, '3/10/2019', 483939),
(10059, 102, 2, '6/7/2019', 870549),
(10058, 108, 6, '12/30/2018', 412425),
(10039, 110, 4, '1/25/2019', 969756),
(10074, 104, 4, '3/26/2019', 968657),
(10046, 106, 5, '3/17/2019', 897689),
(10074, 102, 2, '2/21/2019', 330686),
(10020, 106, 8, '1/18/2019', 750456),
(10039, 109, 4, '3/21/2019', 1036650),
(10021, 108, 3, '2/24/2019', 137073),
(10068, 100, 5, '3/9/2019', 1063458),
(10063, 109, 2, '5/30/2019', 828727),
(10019, 107, 1, '4/28/2019', 734936),
(10048, 100, 1, '2/10/2019', 537541),
(10024, 109, 5, '12/22/2018', 123012),
(10000, 105, 8, '6/11/2019', 1050107),
(10054, 109, 8, '3/4/2019', 493868),
(10032, 108, 1, '3/31/2019', 693146),
(10067, 108, 8, '4/12/2019', 211091),
(10067, 103, 7, '5/26/2019', 458451),
(10032, 110, 7, '2/11/2019', 239493),
(10068, 104, 4, '6/5/2019', 584042),
(10033, 106, 5, '1/2/2019', 307763),
(10072, 110, 6, '1/9/2019', 315559),
(10030, 107, 6, '6/1/2019', 1174082),
(10067, 106, 6, '1/15/2019', 614610),
(10060, 106, 8, '3/3/2019', 783768),
(10060, 102, 1, '6/1/2019', 222491),
(10052, 110, 6, '3/6/2019', 908658),
(10046, 106, 3, '2/7/2019', 852001),
(10012, 104, 2, '12/28/2018', 597860),
(10045, 104, 8, '6/4/2019', 613979),
(10041, 100, 3, '4/14/2019', 1154069),
(10063, 100, 8, '3/26/2019', 1005390),
(10003, 104, 5, '6/15/2019', 799155),
(10000, 108, 6, '1/14/2019', 630346),
(10058, 108, 3, '6/9/2019', 206147),
(10049, 104, 4, '5/18/2019', 506917),
(10014, 106, 2, '5/5/2019', 125336),
(10005, 106, 5, '5/13/2019', 406609),
(10044, 104, 6, '6/6/2019', 1017958),
(10016, 104, 7, '1/22/2019', 172752),
(10062, 109, 5, '2/12/2019', 798973),
(10072, 108, 8, '1/25/2019', 379803),
(10051, 101, 8, '4/28/2019', 129427),
(10029, 101, 6, '5/21/2019', 127511),
(10066, 105, 7, '4/6/2019', 715767),
(10068, 110, 8, '1/18/2019', 579158),
(10056, 108, 1, '5/11/2019', 846841),
(10013, 106, 2, '4/28/2019', 851697),
(10018, 100, 5, '4/10/2019', 670679),
(10025, 104, 5, '1/30/2019', 1106831),
(10019, 106, 2, '4/24/2019', 793125),
(10064, 104, 6, '1/27/2019', 871318),
(10014, 106, 1, '1/19/2019', 1077948),
(10056, 100, 8, '12/26/2018', 926906),
(10049, 108, 2, '3/17/2019', 265324),
(10033, 106, 7, '1/20/2019', 1042360),
(10000, 100, 1, '5/13/2019', 839200),
(10065, 101, 3, '1/12/2019', 731451),
(10045, 107, 3, '1/31/2019', 117200),
(10026, 107, 4, '1/25/2019', 296245),
(10036, 108, 7, '2/6/2019', 785293),
(10022, 104, 8, '1/29/2019', 187581),
(10069, 105, 8, '4/26/2019', 1028895),
(10044, 102, 6, '1/31/2019', 1181449),
(10035, 110, 4, '6/3/2019', 948004),
(10022, 102, 5, '4/27/2019', 179955),
(10064, 101, 6, '2/24/2019', 484477),
(10054, 108, 8, '2/19/2019', 829820),
(10069, 102, 1, '6/4/2019', 348371),
(10019, 102, 4, '2/7/2019', 680731);
GO

-- Review October 7 in class 

SELECT * FROM Owners;
-- Write SQL statement that will add a new homeowner to the Owners table. 
INSERT INTO Owners
VALUES('Landon Cuff');
GO

SELECT * FROM Homes;

-- Write a SQL statement to add a new home to the Home table, where the owner is unknonw at this time
INSERT INTO Homes
VALUES('94 West Valley', 'West Valley', 'UT', NULL);

-- Write a query to display each home owner name, the home address, city and state. Ensure the new homeowner you just addes is included in the results. Sort alph by home owner name
SELECT o.OwnerName, h.HomeAddress, h.HomeCity, h.HomeState
FROM Homes h RIGHT JOIN Owners o
ON o.OID = h.OID
ORDER BY 1;

-- Modify the query above to also show the home with no owner (will join EVERYTHING)
SELECT o.OwnerName, h.HomeAddress, h.HomeCity, h.HomeState
FROM Homes h FULL JOIN Owners o
ON o.OID = h.OID
ORDER BY 1;

-- Write a query to list the realtor name, the name of the month( as SaleMonth), the year (as SaleYear) and the number
-- of listings that each realtor had for that month and year. REstrict the results to not show months when a realtor only had one home listed. O
-- Only include homes listed for sale in the year 2019. Sort alph be realtor name and put each realtor's best month (most listings) at the top of the their list
SELECT r.RealtorName, DATENAME(MONTH, f.ListDate) AS SaleMonth, YEAR(f.ListDate) AS SaleYear, COUNT(f.ListID) AS NumberOfListings
FROM Realtors r JOIN ForSale f
ON r.RID = f.RID
WHERE YEAR(f.ListDate) = 2019
GROUP BY r.RealtorName, f.ListDate, f.ListDate
HAVING COUNT(f.ListID) > 1
ORDER BY 1;