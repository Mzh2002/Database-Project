-- Drop the database if it exists (to start over)
IF DB_ID('Database_Project') IS NOT NULL
BEGIN
    DROP DATABASE Database_Project;
END
GO


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
    user_id INT PRIMARY KEY,
    favorite_song_category VARCHAR(30),
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
);

CREATE TABLE Creator (
    user_id INT PRIMARY KEY,
    [level] INT,
    FOREIGN KEY (user_id) REFERENCES Users(user_id),  
);

CREATE TABLE Listener (
    user_id INT PRIMARY KEY,
    listen_time BIGINT,
    listen_num INT,
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
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
    user_id INT,
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    list_name VARCHAR(30),
);

CREATE TABLE Album (
    album_id INT IDENTITY(1,1) PRIMARY KEY,
    [type] VARCHAR(10),
);


CREATE TABLE add_tag (
    song_id INT,
    speed FLOAT,
    genre VARCHAR(50),
    emotion VARCHAR(50),
    PRIMARY KEY (song_id),
    FOREIGN KEY (song_id) REFERENCES Song(song_id)
);

CREATE TABLE create_list (
    song_list_id INT,
    user_id INT,
    tag VARCHAR(50),
    description TEXT,
    PRIMARY KEY (song_list_id, user_id),
    FOREIGN KEY (song_list_id) REFERENCES Song_List(song_list_id),
    FOREIGN KEY (user_id) REFERENCES Creator(user_id)
);

CREATE TABLE like_list (
    user_id INT,
    song_list_id INT,
    rating INT CHECK (rating >= 0 AND rating <= 5),
    PRIMARY KEY (user_id, song_list_id),
    FOREIGN KEY (user_id) REFERENCES Listener(user_id),
    FOREIGN KEY (song_list_id) REFERENCES Song_List(song_list_id)
);

CREATE TABLE sing (
    song_id INT,
    singer_id INT,
    PRIMARY KEY (song_id, singer_id),
    FOREIGN KEY (song_id) REFERENCES Song(song_id),
    FOREIGN KEY (singer_id) REFERENCES Singer(singer_id)
);

CREATE TABLE contain (
    song_list_id INT,
    song_id INT,
    PRIMARY KEY (song_list_id, song_id),
    FOREIGN KEY (song_list_id) REFERENCES Song_List(song_list_id),
    FOREIGN KEY (song_id) REFERENCES Song(song_id)
);

CREATE TABLE release (
    singer_id INT,
    album_id INT,
    release_date DATE,
    PRIMARY KEY (singer_id, album_id),
    FOREIGN KEY (singer_id) REFERENCES Singer(singer_id),
    FOREIGN KEY (album_id) REFERENCES Album(album_id)
);

CREATE TABLE include (
    song_id INT,
    album_id INT,
    PRIMARY KEY (song_id, album_id),
    FOREIGN KEY (song_id) REFERENCES Song(song_id),
    FOREIGN KEY (album_id) REFERENCES Album(album_id)
);