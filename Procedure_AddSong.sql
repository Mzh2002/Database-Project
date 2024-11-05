DROP PROCEDURE IF EXISTS AddSongToPlaylist;
GO
/*
This procedure allows user to add song to play list quickly
*/
CREATE PROCEDURE AddSongToPlaylist
    @song_list_id INT,
    @song_id INT
AS
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Song WHERE song_id = @song_id)
    BEGIN
        PRINT 'Error: Song does not exist';
        RETURN;
    END
    IF NOT EXISTS (SELECT 1 FROM Song_List WHERE song_list_id = @song_list_id)
    BEGIN
        PRINT 'Error: Song List does not exist';
        RETURN;
    END
    INSERT INTO contain (song_list_id, song_id)
    VALUES (@song_list_id, @song_id);
END;

--example
--case 1: normal add
EXEC AddSongToPlaylist
    @song_list_id = 1,
    @song_id = 3;
GO
--case 2: add a not existing song
EXEC AddSongToPlaylist
    @song_list_id = 1,
    @song_id = 100;
GO

--case 2: add to a not existing song list
EXEC AddSongToPlaylist
    @song_list_id = 100,
    @song_id = 1;
GO