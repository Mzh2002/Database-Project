/*
Trigger will automatically update the rating in the like_list table 
to a default value of 3 if no rating is provided when a listener likes a song list.
*/
CREATE TRIGGER trg_set_default_rating
ON like_list
AFTER INSERT
AS
BEGIN
    UPDATE like_list
    SET rating = 3
    FROM like_list l
    JOIN inserted i 
    ON l.user_id = i.user_id AND l.song_list_id = i.song_list_id
    WHERE l.rating IS NULL;
END;
GO