CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'StrongPassword123!';

CREATE CERTIFICATE UserEmailCert
WITH SUBJECT = 'Certificate for User Email Encryption';

CREATE SYMMETRIC KEY UserEmailKey
WITH ALGORITHM = AES_256
ENCRYPTION BY CERTIFICATE UserEmailCert;

ALTER TABLE Users
ADD EncryptedEmail VARBINARY(256);


-- Open the symmetric key to decrypt data
OPEN SYMMETRIC KEY UserEmailKey
DECRYPTION BY CERTIFICATE UserEmailCert;

-- Query to retrieve user data with decrypted email
SELECT 
    user_id,
    user_name,
    register_time,
    CONVERT(VARCHAR(50), DecryptByKey(EncryptedEmail)) AS DecryptedEmail
FROM Users;

-- Close the symmetric key
CLOSE SYMMETRIC KEY UserEmailKey;