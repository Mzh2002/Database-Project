CREATE VIEW PlaylistDetails AS
SELECT 
    sl.song_list_id AS PlaylistID,
    sl.list_name AS PlaylistName,
    u.user_name AS CreatorName,
    COUNT(c.song_id) AS SongCount,
    ISNULL(SUM(s.duration), 0) AS TotalSongDuration
FROM Song_List sl
JOIN create_list cl ON sl.song_list_id = cl.song_list_id
JOIN Users u ON cl.user_id = u.user_id
LEFT JOIN contain c ON sl.song_list_id = c.song_list_id
LEFT JOIN Song s ON c.song_id = s.song_id
GROUP BY sl.song_list_id, sl.list_name, u.user_name;
