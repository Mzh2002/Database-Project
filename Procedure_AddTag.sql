DROP PROCEDURE IF EXISTS AddTagToSong;
GO

CREATE PROCEDURE AddTagToSong
    @song_id INT,
    @speed FLOAT,
    @genre VARCHAR(50),
    @emotion VARCHAR(50)
AS
BEGIN
    -- Check if the song exists in the Song table
    IF NOT EXISTS (
        SELECT 1 
        FROM Song 
        WHERE song_id = @song_id
    )
    BEGIN
        PRINT 'Error: The song does not exist';
        RETURN;
    END

    -- Check if a tag already exists for the song
    IF EXISTS (
        SELECT 1 
        FROM add_tag 
        WHERE song_id = @song_id
    )
    BEGIN
        UPDATE add_tag
        SET speed = @speed,
            genre = @genre,
            emotion = @emotion
        WHERE song_id = @song_id;

        PRINT 'Tag updated for the song';
    END
    ELSE
    BEGIN
        -- if the song does not have the tag, directly add the tag
        INSERT INTO add_tag (song_id, speed, genre, emotion)
        VALUES (@song_id, @speed, @genre, @emotion);

        PRINT 'Tag added to the song';
    END
END;
