CREATE VIEW UserSummary AS
SELECT 
    u.user_id AS UserID,
    u.user_name AS UserName,
    u.email AS Email,
    CAST(u.register_time AS DATE) AS RegisterDate,
    ISNULL(p.favorite_song_category, 'Unknown') AS FavoriteCategory,
    ISNULL(l.listen_time, 0) AS TotalListeningTime,
    ISNULL(l.listen_num, 0) AS TotalListeningSessions,
    COUNT(cl.song_list_id) AS TotalPlaylists
FROM Users u
LEFT JOIN User_Preference p ON u.user_id = p.user_id
LEFT JOIN Listener l ON u.user_id = l.user_id
LEFT JOIN create_list cl ON u.user_id = cl.user_id
GROUP BY u.user_id, u.user_name, u.email, u.register_time;