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

   

