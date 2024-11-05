CREATE FUNCTION dbo.GetRegisterDate(
    @UserID INT
)
RETURNS DATE
AS
BEGIN
    DECLARE @RegisterDate DATE;

    SELECT @RegisterDate = CAST(register_time AS DATE)
    FROM Users
    WHERE user_id = @UserID;

    RETURN @RegisterDate;
END;

