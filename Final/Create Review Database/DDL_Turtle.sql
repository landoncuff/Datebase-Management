CREATE DATABASE Turtles_RLC;
GO

USE Turtles_RLC;
GO

CREATE TABLE Species (
SpeciesID		INT		IDENTITY(1,1)	PRIMARY KEY,
SpeciesName		VARCHAR(15) NOT NULL,
Endangered		VARCHAR(1),
EndangeredDate	DATE
);
GO

CREATE TABLE Habitats (
HabitatID	INT		IDENTITY(1,1)	PRIMARY KEY,
Location	VARCHAR(25) NOT NULL
);
GO

CREATE TABLE Turtles (
TurtleID		VARCHAR(4)	PRIMARY KEY,
SpeciesID		INT		REFERENCES Species(SpeciesID),
HabitatID		INT		REFERENCES Habitats(HabitatID),
Health			VARCHAR(10),
SampleDate		DATE
);
GO

INSERT INTO Species
VALUES
('Flatback', NULL, NULL),
('Olive Ridley', NULL, '1967'), 
('Hawksbill', NULL, '1970'),
('Leatherback', NULL, '1970'),
('Loggerhead', NULL, '1978'),
('Green', NULL, '1978')
;

INSERT INTO Habitats
VALUES
('Great Barrier Reef'),
('Central America'), 
('Indian Ocean'),
('Red Sea'),
('Mexico'),
('East Asia'),
('Florida')
;

INSERT INTO Turtles
VALUES
('2A21', 6, 7, 'Acceptable', '6/15/2017'),
('2Q54', 1, 1, 'Acceptable', '3/5/2017'),
('6N87', 3, 1, 'Good', '7/8/2017'),
('4Q75', 5, 5, 'Acceptable', '8/3/2017'),
('4Z33', 6, 2, 'Poor', '3/15/2017'),
('7A39', 3, 2, 'Good', '3/25/2017'),
('1X16', 1, 1, 'Poor', '6/26/2017'),
('3E89', 2, 2, 'Poor', '3/30/2017'),
('8T12', 4, 2, 'Acceptable', '7/10/2017'),
('1S63', 1, 1, 'Good', '9/14/2017'),
('2Z12', 2, 2, 'Acceptable', '2/9/2017'),
('6Z88', 5, 7, 'Good', '7/9/2017'),
('2W68', 4, 1, 'Poor', '4/22/2017'),
('8T52', 4, 5, 'Good', '1/16/2017'),
('4M12', 6, 2, 'Poor', '6/22/2017'),
('5R58', 2, 3, 'Poor', '4/23/2017'),
('6H45', 1, 1, 'Acceptable', '2/25/2017'),
('4K90', 1, 1, 'Good', '2/18/2017'),
('9D47', 6, 7, 'Good', '1/11/2017'),
('2K31', 5, 7, 'Acceptable', '7/5/2017'),
('9E29', 1, 1, 'Poor', '7/15/2017'),
('4V50', 4, 3, 'Good', '6/13/2017'),
('4D21', 5, 2, 'Good', '6/21/2017'),
('3S60', 6, 2, 'Acceptable', '6/12/2017'),
('9S49', 6, 7, 'Acceptable', '4/1/2017'),
('8V42', 2, 3, 'Poor', '4/29/2017'),
('3G44', 3, 2, 'Good', '9/3/2017'),
('2N82', 5, 2, 'Acceptable', '7/23/2017'),
('5Y64', 3, 1, 'Poor', '4/26/2017'),
('5H57', 6, 2, 'Poor', '4/9/2017'),
('4E17', 5, 5, 'Poor', '7/29/2017'),
('3C51', 2, 2, 'Poor', '6/26/2017'),
('8H98', 5, 6, 'Poor', '3/24/2017'),
('4U59', 3, 1, 'Acceptable', '4/24/2017'),
('4E88', 5, 6, 'Poor', '9/29/2017'),
('8H43', 2, 2, 'Poor', '6/2/2017'),
('4H79', 3, 2, 'Good', '3/27/2017'),
('9V57', 2, 2, 'Acceptable', '7/21/2017'),
('3P47', 3, 4, 'Acceptable', '5/30/2017'),
('6T33', 2, 3, 'Poor', '5/25/2017'),
('8Y77', 2, 2, 'Good', '2/27/2017'),
('1A39', 4, 1, 'Acceptable', '8/30/2017'),
('1T11', 5, 5, 'Acceptable', '4/17/2017'),
('2W19', 6, 2, 'Poor', '9/8/2017'),
('4E73', 1, 1, 'Poor', '3/10/2017'),
('7L60', 3, 2, 'Acceptable', '5/3/2017'),
('5P27', 1, 1, 'Poor', '4/6/2017'),
('3O51', 3, 4, 'Poor', '9/6/2017'),
('5L41', 2, 3, 'Poor', '6/18/2017'),
('8X42', 2, 3, 'Acceptable', '1/19/2017'),
('6F41', 3, 2, 'Good', '7/9/2017')
;
