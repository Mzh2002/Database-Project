DROP PROCEDURE IF EXISTS DeleteSongFromPlaylist;
GO

CREATE PROCEDURE DeleteSongFromPlaylist
    @song_list_id INT,
    @song_id INT
AS
BEGIN
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
    PRINT 'Song deleted from playlist successfully';
END;

--  example use
EXEC DeleteSongFromPlaylist 
    @song_list_id = 1,
    @song_id = 2;
GO

EXEC DeleteSongFromPlaylist 
    @song_list_id = 1,
    @song_id = 1;
GO