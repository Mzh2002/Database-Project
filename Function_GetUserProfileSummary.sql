CREATE FUNCTION dbo.GetUserProfileSummary(@UserID INT)
RETURNS TABLE
AS
RETURN
(
    SELECT 
        u.user_name AS UserName,
        u.email AS Email,
        CAST(u.register_time AS DATE) AS RegisterDate,
        p.favorite_song_category AS FavoriteCategory
    FROM Users u
    LEFT JOIN User_Preference p ON u.user_id = p.user_id
    WHERE u.user_id = @UserID
);
