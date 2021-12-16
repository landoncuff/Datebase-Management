SELECT * FROM Actors;
SELECT * FROM Directors;
SELECT * FROM Genres;
SELECT * FROM MovieActors;
SELECT * FROM Movies;
SELECT * FROM Ratings;

/*Only actors whose total box office is more than $600 Million are included.

The highest box office producers are at the top, going down to the lowest (but still over $600M total) at the bottom.

The third column accurately labels each actor as a “Movie Millionaire” or “Movie Billionaire” based on each actor’s TotalBoxOffice.

Your query must be written to always include actors’ whose movies have earned over $600M at the US Box Office, even as time moves on and additional movies are added.
*/

SELECT a.ActorName, m.USBoxOffice, IIF(USBoxOffice > 100000000, 'Movie Billionaire', 'Movie Millionaire') AS TotalBoxOffice
FROM Actors a JOIN MovieActors ma
ON a.ActorID = ma.ActorID JOIN Movies m 
ON ma.MovieID = m.MovieID
WHERE m.USBoxOffice > 60000000
ORDER BY 2 DESC;


-- Question 2

/*“Great for kids!” if the new movie is rated ‘G’
“Great for Families!” if the new movie is rated ‘PG’
“Good for families with teens” if the new movie is rated ‘PG-13’
“Adults only!” if the new movie is rated ‘R’
“Use caution, non-standard rating” if the movie is not rated one of the above */

/* Write a program in procedural SQL such that whenever a new movie is added to the Movies table, 
the FamilyCategory column will be set to the appropriate label as follows: */
ALTER TABLE Movies
ADD FamilyCategory VARCHAR(40);
GO

CREATE FUNCTION RatingIDtoRating
	(@RatingID INT)
		RETURNS VARCHAR(5)
AS
BEGIN
	DECLARE @Rating VARCHAR(5)
	SELECT @Rating = RatingCode
	FROM Ratings
	WHERE RatingID = @RatingID;

	RETURN @Rating
END;
GO

SELECT *, dbo.RatingIDtoRating(RatingID) 
FROM Movies

SELECT * FROM Ratings
GO

ALTER TRIGGER NewMovie ON Movies
AFTER INSERT
AS
BEGIN
	UPDATE Movies
	SET FamilyCategory = 
	 CASE
        WHEN (SELECT dbo.RatingIDtoRating(RatingID) FROM INSERTED) = 'G' THEN 'Great for kids!'
        WHEN (SELECT dbo.RatingIDtoRating(RatingID) FROM INSERTED) = 'PG' THEN 'Great for Families!'
        WHEN (SELECT dbo.RatingIDtoRating(RatingID) FROM INSERTED) = 'PG-13' THEN 'Good for families with teens'
        WHEN (SELECT dbo.RatingIDtoRating(RatingID) FROM INSERTED) = 'R' THEN 'Adults only!'
        ELSE 'Use caution, non-standard rating'
    END 
	WHERE MovieID = (SELECT MovieID FROM INSERTED)
END;
GO






CASE
		WHEN (SELECT RatingID FROM INSERTED) = '1' THEN 'Great for kids!'
		WHEN (SELECT RatingID FROM INSERTED) = '2' THEN 'Great for Families!'
		WHEN (SELECT RatingID FROM INSERTED) = '3' THEN 'Good for families with teens'
		WHEN (SELECT RatingID FROM INSERTED) = '4' THEN 'Adults only!'
		ELSE 'Use caution, non-standard rating'
	END


ALter FUNCTION ActorIdToActorNam
	(@ActorID INT)
		RETURNS VARCHAR(35)
AS
BEGIN
	DECLARE @ActorName VARCHAR(35)
	SELECT @ActorName = a.ActorName
	FROM Actors a JOIN MovieActors ma
	ON a.ActorID = ma.ActorID
	WHERE a.ActorID = @ActorID

	RETURN @ActorName
END;
GO

SELECT * FROM Directors;
GO

CREATE FUNCTION DirectorIDToDirectorName
	(@DirectorID INT)
		RETURNS VARCHAR(35)
AS
BEGIN
	DECLARE @DirectorName VARCHAR(35)
	SELECT @DirectorName = DirectorName
	FROM Directors
	WHERE DirectorID = @DirectorID;

	RETURN @DirectorName
END;
GO

SELECT * FROM Movies;
-- title, Actor, ReleaseYear
SELECT CONCAT(MovieTitle, ' was directed by ', dbo.DirectorIDToDirectorName(DirectorID), ' in the year ', ReleaseYear)
FROM Movies;
GO



CREATE PROC fillMoviesDim
AS
BEGIN
	DECLARE @MovieID INT, @dwBoxOffice MONEY, @rBoxOffice MONEY, @MovieDimID INT

	DECLARE movieTable CURSOR FOR
	SELECT MovieID, USBoxOffice FROM Movies

	OPEN movieTable

	FETCH NEXT FROM movieTable INTO @MovieID
		WHILE @@FETCH_STATUS = 0
			SELECT @rBoxOffice = USBoxOffice
			FROM Movies
			WHERE MovieID = @MovieID

			SELECT @dwBoxOffice = USBoxOffice, @MovieDimID = MovieID
			FROM dwMoviesDim
			WHERE MovieID = @MovieID

		IF @dwBoxOffice NOT LIKE @rBoxOffice
			UPDATE dwMovieDim
				SET @dwBoxOffice = @rBoxOffice
				WHERE MovieID = @MovieID

		IF @MovieDimID IS NULL
			INSERT INTO dwMovieDim
			SELECT MovieID, MovieTitle, IMDbRank, IMDbRating, GenreID, DirectorID, RatingID, @rBoxOffice, FamilyCategory, getDate()
			FROM Movies
			WHERE MovieID = @MovieID

		FETCH NEXT FROM movieTable INTO @MovieID

		END;
END;
GO

SELECT * FROM Movies;

SELECT * FROM Ratings;

INSERT INTO Ratings
VALUES(7, 'NP');
GO

ALTER TRIGGER newRating ON Movies
AFTER INSERT
AS
BEGIN
	DECLARE @RatingID INT
	SELECT @RatingID = RatingID FROM INSERTED

	IF @RatingID IS NULL
		UPDATE Movies
			SET RatingID = 7
			WHERE MovieID = (SELECT MovieID FROM INSERTED) 
END;
GO

SELECT * FROM Movies

SELECT * FROM Ratings

INSERT INTO Movies
VALUES(105, 'Iron Man', 6, 6.8, 2012, 3, 51, 3, 220000, NULL)