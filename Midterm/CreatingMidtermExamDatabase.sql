CREATE DATABASE RollerCoasters_XX;
GO

USE RollerCoasters_XX;
GO

CREATE TABLE CoasterType (
CoasterTypeID		INT		IDENTITY(1,1)	PRIMARY KEY,
CoasterTypeName		VARCHAR(15),
RetiredDate			DATE
);
GO

CREATE TABLE Parks (
ParkID	INT		IDENTITY(101,1)	PRIMARY KEY,
ParkName		VARCHAR(30),
ParkLocation	VARCHAR(25)
);
GO

CREATE TABLE Coasters (
CoasterID		VARCHAR(4)	PRIMARY KEY,
CoasterName		VARCHAR(30),
CoasterTypeID	INT		REFERENCES CoasterType(CoasterTypeID),
ParkID			INT		REFERENCES Parks(ParkID),
SafetyStatus	VARCHAR(10),
InspectionDate	DATE
);
GO

INSERT INTO CoasterType
VALUES
('Wooden', NULL),
('Steel', NULL), 
('Inverted', NULL),
('Launched', NULL),
('Stand-up', '8-22-2007'),
('Suspended', '4-16-2012')
;
GO

INSERT INTO Parks
VALUES
('Fairpark Kingdom', 'London, UK'),
('Discovery Cove', 'Rio de Janeiro, Brazil'), 
('Adventure Park', 'Hong Kong, China'),
('Boomtown Village', 'Las Vegas, USA'),
('Oasis', 'Dubai, UAE'),
('Carousel Carnival', 'Miami, USA'),
('Euphoria', 'Paris, France')
;

INSERT INTO Coasters
VALUES
('2A21', 'Striker', 6, 107, 'Acceptable', '6/15/2020'),
('2Q54', 'Jump and Jolt', 1, 101, 'Acceptable', '3/5/2020'),
('6N87', 'Island Voyager', 3, 101, 'Good', '7/8/2020'),
('4Q75', 'Exhileration', 5, 105, 'Acceptable', '8/3/2019'),
('4Z33', 'Flight of Fury', 6, 102, 'Poor', '3/15/2020'),
('7A39', 'Commander', 3, 102, 'Good', '3/25/2020'),
('1X16', 'Mother Lode', 1, 101, 'Poor', '6/26/2020'),
('3E89', 'Monster Rally', 2, 102, 'Poor', '3/30/2020'),
('8T12', 'Sidewinder', 4, 102, 'Acceptable', '7/10/2020'),
('1S63', 'Mach 3', 1, 101, 'Good', '9/14/2019'),
('2Z12', 'Mantis', 2, 102, 'Acceptable', '2/9/2020'),
('6Z88', 'Runaway Train', 5, 107, 'Good', '7/9/2020'),
('2W68', 'Time Warp', 4, 101, 'Poor', '4/22/2020'),
('8T52', 'Silver Spur', 4, 105, 'Good', '1/16/2020'),
('4M12', 'Power Play', 6, 102, 'Poor', '6/22/2019'),
('5R58', 'Red Smoke', 2, 103, 'Poor', '4/23/2020'),
('6H45', 'Payday', 1, 101, 'Acceptable', '2/25/2020'),
('4K90', 'Piranha', 1, 101, 'Good', '2/18/2020'),
('9D47', 'Wild Rover', 6, 107, 'Good', '1/11/2020'),
('2K31', 'Silver Dollar Roller', 5, 107, 'Acceptable', '7/5/2020'),
('9E29', 'Top Fuel Dragtime', 1, 101, 'Poor', '7/15/2020'),
('4V50', 'Thunderhead', 4, 103, 'Good', '6/13/2020'),
('4D21', 'Mighty Mountain', 5, 102, 'Good', '6/21/2020'),
('3S60', 'The Lazer', 6, 102, 'Acceptable', '6/12/2020'),
('9S49', 'Sky Diver', 6, 107, 'Acceptable', '4/1/2020'),
('8V42', 'Tomb Raider', 2, 103, 'Poor', '4/29/2020'),
('3G44', 'Wisecrack', 3, 102, 'Good', '9/3/2019'),
('2N82', 'Python', 5, 102, 'Acceptable', '7/23/2020'),
('5Y64', 'Swamp Monster', 3, 101, 'Poor', '4/26/2020'),
('5H57', 'Out of Bounds', 6, 102, 'Poor', '4/9/2020'),
('4E17', 'Yeti', 5, 105, 'Poor', '7/29/2020'),
('3C51', 'Lava Mountain', 2, 102, 'Poor', '6/26/2020'),
('8H98', 'Inner Space', 5, 106, 'Poor', '3/24/2020'),
('4U59', 'Dragon''s Lair', 3, 101, 'Acceptable', '4/24/2020'),
('4E88', 'Fire and Ice', 5, 106, 'Poor', '9/29/2019'),
('8H43', 'Night Fury', 2, 102, 'Poor', '6/2/2020'),
('4H79', 'El Toro', 3, 102, 'Good', '3/27/2020'),
('9V57', 'Speedracer', 2, 102, 'Acceptable', '7/21/2019'),
('3P47', 'White Lightning', 3, 104, 'Acceptable', '5/30/2020'),
('6T33', 'Samurai Warrior', 2, 103, 'Poor', '5/25/2020'),
('8Y77', 'Jackalope', 2, 102, 'Good', '2/27/2020'),
('1A39', 'Flaming Sword', 4, 101, 'Acceptable', '8/30/2019'),
('1T11', 'Indomitable Racer', 5, 105, 'Acceptable', '4/17/2020'),
('2W19', 'Fastball Flyer', 6, 102, 'Poor', '9/8/2019'),
('4E73', 'Game Time', 1, 101, 'Poor', '3/10/2020'),
('7L60', 'Magneto', 3, 102, 'Acceptable', '5/3/2020'),
('5P27', 'Superslider', 1, 101, 'Poor', '4/6/2020'),
('3O51', 'Screamtime', 3, 104, 'Poor', '9/6/2020'),
('5L41', 'Loch Ness Monster', 2, 103, 'Poor', '6/18/2020'),
('8X42', 'Screaming Eagle', 2, 103, 'Acceptable', '1/19/2020'),
('6F41', 'The Rocket', 3, 102, 'Good', '7/9/2020')
;