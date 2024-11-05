DROP PROCEDURE IF EXISTS DeleteSongFromPlaylist;
GO

/*
This procedure allows users to delete a song from playlist quickly
*/
CREATE PROCEDURE DeleteSongFromPlaylist
    @song_list_id INT,
    @song_id INT
AS
BEGIN
    -- Check if the song exists in the Song table
    IF NOT EXISTS (
        SELECT 1
        FROM Song
        WHERE song_id = @song_id
    )
    BEGIN
        PRINT 'Error: Song does not exist in the database';
        RETURN;
    END
    -- Check if the song is in the playlist, if not print the error 
    IF NOT EXISTS (
        SELECT 1
        FROM contain
        WHERE song_list_id = @song_list_id AND song_id = @song_id
    )
    BEGIN
        PRINT 'Error: Song is not in this playlist';
        RETURN;
    END

    -- Delete the song from the playlist, print the success message
    DELETE FROM contain
    WHERE song_list_id = @song_list_id AND song_id = @song_id;
END;

--  example use
-- case 1 normal delete
EXEC DeleteSongFromPlaylist 
    @song_list_id = 1,
    @song_id = 2;
GO
-- case 2 the song is not in the playlist
EXEC DeleteSongFromPlaylist 
    @song_list_id = 1,
    @song_id = 1;
GO
-- case 3 the song is not in the table 
EXEC DeleteSongFromPlaylist 
    @song_list_id = 1,
    @song_id = 100;
GO