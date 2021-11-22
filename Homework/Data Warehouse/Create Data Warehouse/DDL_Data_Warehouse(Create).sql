CREATE TABLE dwAirlinesDim (
	AirlineID		INT		PRIMARY KEY,
	AirlineName		VARCHAR(20),
	RecTimestamp	DATETIME
	);
GO

CREATE TABLE dwPlanesDim (
	PlaneID			INT PRIMARY KEY,
	Manufacturer	VARCHAR(10),
	ModelNum		VARCHAR(20),
	OrigPurchDate	DATE,
	NumSeats		INT,
	LastService		DATE,
	ServiceStatus	VARCHAR(25),
	RecTimestamp	DATETIME
	);
GO

CREATE TABLE dwDateDim (
	DateID		INT IDENTITY(1,1) PRIMARY KEY,
	RawDate			DATE,
	HourOfTheDay	INT,
	DayOfTheWeek	VARCHAR(9),
	MonthOfTheYear	VARCHAR(9),
	QtrOfTheYear	VARCHAR(7),
	YearOfFlight	INT,
	RecTimestamp	DATETIME
	);
GO

CREATE TABLE dwAirportsAgg (
	AirportCode VARCHAR(3) PRIMARY KEY,
	TotalFlightsDeparting INT,
	TotalFlightsArriving INT,
	RecTimestamp DATETIME
	);
GO

CREATE TABLE dwFlightFacts (
	 FlightID			INT PRIMARY KEY,
	 PlaneID			INT,
	 AirlineID			INT,
	 OriginAirport		VARCHAR(3),
	 DestinationAirport	VARCHAR(3),
	 DepartureDateID	INT,
	 ArrivalDateID		INT,
	 DepartureDateTime	DATETIME,
	 ArrivalDateTime	DATETIME,
	 RecTimestamp		DATETIME,
	 FOREIGN KEY (AirlineID) REFERENCES dwAirlinesDim(AirlineID),
	 FOREIGN KEY (PlaneID) REFERENCES dwPlanesDim(PlaneID),
	 FOREIGN KEY (ArrivalDateID) REFERENCES dwDateDim(DateID),
	 FOREIGN KEY (DepartureDateID) REFERENCES dwDateDim(DateID),
	 FOREIGN KEY (OriginAirport) REFERENCES dwAirportsAgg(AirportCode),
	 FOREIGN KEY (DestinationAirport) REFERENCES dwAirportsAgg(AirportCode)
	);
GO