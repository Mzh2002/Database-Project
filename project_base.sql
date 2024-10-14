CREATE DATABASE Database_Project
GO
Use Database_Project
GO

CREATE TABLE Users (
    user_id INT IDENTITY(1,1) PRIMARY KEY,
    register_date BIGINT, 
    email VARCHAR(50),
);

CREATE TABLE User_Preference(
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    favorite_song_category VARCHAR(30),
);

CREATE TABLE Creator (
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    [level] INT
);

CREATE TABLE Listener (
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    listen_time BIGINT,
    listen_num INT,
);

CREATE TABLE Song (
    song_id INT IDENTITY(1,1) PRIMARY KEY,
    song_name VARCHAR(30),
    release_date BIGINT,
    duration INT,
);

CREATE TABLE Singer (
    singer_id INT IDENTITY(1,1) PRIMARY KEY,
    singer_name VARCHAR(30),
    country VARCHAR(10),
);

CREATE TABLE Song_List (
    song_list_id INT IDENTITY(1,1) PRIMARY KEY,
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    list_name VARCHAR(30),
);

CREATE TABLE Album (
    album_id INT IDENTITY(1,1) PRIMARY KEY,
    [type] VARCHAR(10),
);