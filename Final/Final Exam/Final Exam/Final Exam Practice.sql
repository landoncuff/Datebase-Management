-- Checking out the data

SELECT * FROM Actors;
SELECT * FROM Directors;
SELECT * FROM Genres;
SELECT * FROM MovieActors;
SELECT * FROM Movies;
SELECT * FROM Ratings;

-- Counting the number of moives per actor and Director
SELECT * FROM Actors;
SELECT * FROM MovieActors;
SELECT * FROM Movies;

SELECT COUNT(m.MovieID) AS NumberOfMovies, a.ActorName
FROM Actors a JOIN MovieActors ma
ON a.ActorID = ma.ActorID JOIN Movies m
ON ma.MovieID = m.MovieID
GROUP BY a.ActorName
HAVING COUNT(m.MovieID) >= 3;

SELECT * FROM Directors;
SELECT * FROM Movies;

SELECT COUNT(m.MovieID) AS NumberOfMovies, d.DirectorName, IIF(COUNT(m.MovieID) >= 3, 'Many', 'Few')
FROM Movies m JOIN Directors d
ON m.DirectorID = d.DirectorID
GROUP BY d.DirectorName;

SELECT COUNT(ActorID)
FROM Actors;
GO

-- Creating a function to get Director Name from Moive ID
ALTER FUNCTION MovieIDtoDirectorName
	(@movieID INT)
		RETURNS VARCHAR(35)
AS
BEGIN
	DECLARE @DirectorName VARCHAR(35);
	SELECT @DirectorName = DirectorName
	FROM Directors
	WHERE DirectorID = @movieID;

	RETURN @DirectorName
END;
GO

SELECT MovieID, MovieTitle, dbo.MovieIDtoDirectorName(DirectorID) AS Director
FROM Movies;


-- SELECT all Movies that do not have the rating of PG without using a JOIN
SELECT MovieTitle
FROM Movies
WHERE RatingID NOT IN (
	SELECT RatingID
	FROM Ratings
	WHERE RatingCode = 'PG'
);

SELECT m.MovieTitle, r.RatingCode 
FROM Movies m JOIN Ratings r
ON m.RatingID = r.RatingID
WHERE m.MovieTitle = 'City of God';


-- Creating a cursor to get a list of actors for each movie
ALTER TABLE Movies
ADD ActorList VARCHAR(200);

SELECT * FROM Movies;
SELECT * FROM Actors;
GO

-- passing in a movie to get an actor
				-- we are not passing in an actor to get a movie
CREATE FUNCTION ActorListMovie
	(@MovieID INT)
		RETURNS VARCHAR(200)
AS
BEGIN
	DECLARE @ActorList VARCHAR(200), @ActorName VARCHAR(35), @ActID INT, @ActorID INT;

	SELECT @MovieID = MovieID
	FROM Movies
	WHERE MovieID = @MovieID;

	DECLARE actorMovieList CURSOR FOR
	SELECT ActorID FROM MovieActors WHERE MovieID = @MovieID

	OPEN actorMovieList

	-- getting the IDs of the movie
	FETCH NEXT FROM actorMovieList INTO @ActorID
		WHILE @@FETCH_STATUS = 0
		BEGIN
			SELECT @ActorName = ActorName
			FROM Actors
			WHERE ActorID = @ActorID;

			IF @ActorList IS NULL
				SET @ActorList = @ActorName
			ELSE 
				SET @ActorList = CONCAT(@ActorList, ', ', @ActorName)
-- Fetching the next ID
			FETCH NEXT FROM actorMovieList INTO @ActorID
		END;

		RETURN @ActorList
END;
GO

SELECT *, dbo.ActorListMovie(MovieID)
FROM Movies;

UPDATE Movies
SET ActorList = dbo.ActorListMovie(MovieID);

SELECT * FROM Movies;

