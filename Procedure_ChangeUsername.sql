DROP PROCEDURE IF EXISTS ChangeUsername;
GO
/*
The procedure allow the user to change/update its user name
*/
CREATE PROCEDURE ChangeUsername
    @user_id INT,
    @new_username VARCHAR(50)
AS
BEGIN
    -- Check if the user exists
    IF NOT EXISTS (
        SELECT 1 
        FROM Users 
        WHERE user_id = @user_id
    )
    BEGIN
        PRINT 'Error: User does not exist';
        RETURN;
    END

    -- Update the username
    UPDATE Users
    SET user_name = @new_username
    WHERE user_id = @user_id;

    PRINT 'Successfully update the username';
END;

--  example use
--update an already exists user name
EXEC ChangeUsername 
    @user_id = 1,
    @new_username = 'newuser1';
GO
-- case no user find
EXEC ChangeUsername 
    @user_id = 31,
    @new_username = 'newuser31';
GO
