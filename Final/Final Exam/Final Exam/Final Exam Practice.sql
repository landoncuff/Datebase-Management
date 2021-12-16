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

