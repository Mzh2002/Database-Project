CREATE FUNCTION dbo.GetNumSongInList(
    @SongListID INT
)
RETURNS INT
AS
BEGIN
    DECLARE @NumSong INT;

    SELECT @NumSong = COUNT(song_id)
    FROM contain
    WHERE song_list_id = @SongListID;

    RETURN @NumSong;
END;