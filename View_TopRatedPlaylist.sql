CREATE VIEW TopRatedPlaylists AS
SELECT 
    sl.song_list_id AS PlaylistID,
    sl.list_name AS PlaylistName,
    u.user_name AS CreatorName,
    AVG(ll.rating), 0 AS AverageRating,
    COUNT(ll.user_id) AS TotalRatings
FROM Song_List sl
JOIN create_list cl ON sl.song_list_id = cl.song_list_id
JOIN Users u ON cl.user_id = u.user_id
JOIN like_list ll ON sl.song_list_id = ll.song_list_id
GROUP BY sl.song_list_id
HAVING COUNT(ll.user_id) > 0;