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
    album_name VARCHAR(50) NOT NULL,
    album_type VARCHAR(10),
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

--3 constraint
-- Check constraint to ensure email contains '@'
ALTER TABLE Users
ADD CONSTRAINT chk_email_format
CHECK (CHARINDEX('@', email) > 0);

-- Check constraint to ensure song duration is positive
ALTER TABLE Song
ADD CONSTRAINT chk_song_duration
CHECK (duration > 0);

-- Check constraint to ensure listener listen_num is non-negative
ALTER TABLE Listener
ADD CONSTRAINT chk_listen_num
CHECK (listen_num >= 0);

-- Insert data into Users table 
INSERT INTO Users (register_date, email) 
VALUES (1630454400, 'user1@example.com'), 
       (1630540800, 'user2@example.com'),
       (1630627200, 'user3@example.com'),
       (1630713600, 'user4@example.com'),
       (1630800000, 'user5@example.com'),
       (1630886400, 'user6@example.com'),
       (1630972800, 'user7@example.com'),
       (1631059200, 'user8@example.com'),
       (1631145600, 'user9@example.com'),
       (1631232000, 'user10@example.com'),
       (1631318400, 'user11@example.com'),
       (1631404800, 'user12@example.com'),
       (1631491200, 'user13@example.com'),
       (1631577600, 'user14@example.com'),
       (1631664000, 'user15@example.com'),
       (1631750400, 'user16@example.com'),
       (1631836800, 'user17@example.com'),
       (1631923200, 'user18@example.com'),
       (1632009600, 'user19@example.com'),
       (1632096000, 'user20@example.com'),
       (1632182400, 'user21@example.com'),
       (1632268800, 'user22@example.com'),
       (1632355200, 'user23@example.com'),
       (1632441600, 'user24@example.com'),
       (1632528000, 'user25@example.com'),
       (1632614400, 'user26@example.com'),
       (1632700800, 'user27@example.com'),
       (1632787200, 'user28@example.com'),
       (1632873600, 'user29@example.com'),
       (1632960000, 'user30@example.com');


-- Insert data into User_Preference table (30 rows)
INSERT INTO User_Preference (user_id, favorite_song_category)
VALUES (1, 'Pop'), 
       (2, 'Rock'), 
       (3, 'Jazz'), 
       (4, 'Classical'), 
       (5, 'Hip-hop'),
       (6, 'Reggae'),
       (7, 'Folk'),
       (8, 'Metal'),
       (9, 'Blues'),
       (10, 'R&B'),
       (11, 'Country'),
       (12, 'Electronic'),
       (13, 'Latin'),
       (14, 'Jazz'),
       (15, 'Punk'),
       (16, 'Indie'),
       (17, 'Disco'),
       (18, 'Funk'),
       (19, 'Rock'),
       (20, 'Alternative'),
       (21, 'Rock'),
       (22, 'Pop'),
       (23, 'Techno'),
       (24, 'Trap'),
       (25, 'House'),
       (26, 'Trance'),
       (27, 'Dubstep'),
       (28, 'Synthwave'),
       (29, 'Jazz'),
       (30, 'Country');

-- Insert data into Creator table
INSERT INTO Creator (user_id, [level])
VALUES (1, 5),
       (2, 3),
       (3, 7),
       (4, 2),
       (5, 4),
       (6, 6),
       (7, 8),
       (8, 1),
       (9, 5),
       (10, 3),
       (11, 4),
       (12, 1),
       (13, 2),
       (14, 6),
       (15, 9),
       (16, 10),
       (17, 4),
       (18, 7),
       (19, 6),
       (20, 1),
       (21, 8),
       (22, 9),
       (23, 10),
       (24, 2),
       (25, 5),
       (26, 3),
       (27, 1),
       (28, 6),
       (29, 1),
       (30, 7);

-- Insert data into Listener table
INSERT INTO Listener (user_id, listen_time, listen_num)
VALUES (1, 2000, 100),
       (2, 3500, 150),
       (3, 2500, 120),
       (4, 5000, 300),
       (5, 1500, 80),
       (6, 1200, 60),
       (7, 2800, 180),
       (8, 4000, 250),
       (9, 1700, 90),
       (10, 2100, 110),
       (11, 2600, 160),
       (12, 2900, 200),
       (13, 3400, 190),
       (14, 3700, 220),
       (15, 4200, 240),
       (16, 2300, 130),
       (17, 2400, 140),
       (18, 3300, 180),
       (19, 5000, 300),
       (20, 3100, 170),
       (21, 4100, 210),
       (22, 1200, 50),
       (23, 2900, 190),
       (24, 2800, 180),
       (25, 4600, 260),
       (26, 3200, 160),
       (27, 2500, 150),
       (28, 3900, 200),
       (29, 2100, 120),
       (30, 3400, 170);

-- Insert data into Song table
INSERT INTO Song (song_name, release_date, duration)
VALUES ('Song A', 1614556800, 240), 
       ('Song B', 1614643200, 300),
       ('Song C', 1614729600, 180),
       ('Song D', 1614816000, 220),
       ('Song E', 1614902400, 210),
       ('Song F', 1614988800, 260),
       ('Song G', 1615075200, 200),
       ('Song H', 1615161600, 240),
       ('Song I', 1615248000, 245),
       ('Song J', 1615334400, 270),
       ('Song K', 1615420800, 280),
       ('Song L', 1615507200, 290),
       ('Song M', 1615593600, 210),
       ('Song N', 1615680000, 230),
       ('Song O', 1615766400, 250),
       ('Song P', 1615852800, 240),
       ('Song Q', 1615939200, 180),
       ('Song R', 1616025600, 220),
       ('Song S', 1616112000, 200),
       ('Song T', 1616198400, 190),
       ('Song U', 1616284800, 230),
       ('Song V', 1616371200, 280),
       ('Song W', 1616457600, 270),
       ('Song X', 1616544000, 190),
       ('Song Y', 1616630400, 210),
       ('Song Z', 1616716800, 220),
       ('Song AA', 1616803200, 230),
       ('Song BB', 1616889600, 240),
       ('Song CC', 1616976000, 200),
       ('Song DD', 1617062400, 210);

-- Insert data into Singer table 
INSERT INTO Singer (singer_name, country)
VALUES ('Singer A', 'US'),
       ('Singer B', 'UK'),
       ('Singer C', 'CA'),
       ('Singer D', 'AU'),
       ('Singer E', 'IN'),
       ('Singer F', 'FR'),
       ('Singer G', 'UK'),
       ('Singer H', 'JP'),
       ('Singer I', 'KR'),
       ('Singer J', 'BR'),
       ('Singer K', 'IT'),
       ('Singer L', 'UK'),
       ('Singer M', 'CN'),
       ('Singer N', 'ES'),
       ('Singer O', 'US'),
       ('Singer P', 'UK'),
       ('Singer Q', 'ZA'),
       ('Singer R', 'NG'),
       ('Singer S', 'MX'),
       ('Singer T', 'JP'),
       ('Singer U', 'JP'),
       ('Singer V', 'US'),
       ('Singer W', 'US'),
       ('Singer X', 'US'),
       ('Singer Y', 'CH'),
       ('Singer Z', 'US'),
       ('Singer AA', 'US'),
       ('Singer BB', 'US'),
       ('Singer CC', 'CA'),
       ('Singer DD', 'GR');

-- Insert data into Song_List table
INSERT INTO Song_List (user_id, list_name)
VALUES (1, 'Playlist A'),
       (2, 'Playlist B'),
       (3, 'Playlist C'),
       (4, 'Playlist D'),
       (5, 'Playlist E'),
       (6, 'Playlist F'),
       (7, 'Playlist G'),
       (8, 'Playlist H'),
       (9, 'Playlist I'),
       (10, 'Playlist J'),
       (11, 'Playlist K'),
       (12, 'Playlist L'),
       (13, 'Playlist M'),
       (14, 'Playlist N'),
       (15, 'Playlist O'),
       (16, 'Playlist P'),
       (17, 'Playlist Q'),
       (18, 'Playlist R'),
       (19, 'Playlist S'),
       (20, 'Playlist T'),
       (21, 'Playlist U'),
       (22, 'Playlist V'),
       (23, 'Playlist W'),
       (24, 'Playlist X'),
       (25, 'Playlist Y'),
       (26, 'Playlist Z'),
       (27, 'Playlist AA'),
       (28, 'Playlist BB'),
       (29, 'Playlist CC'),
       (30, 'Playlist DD');

-- Insert data into Album table
INSERT INTO Album (album_name, album_type)
VALUES ('Album A', 'Studio'),
       ('Album B', 'Live'),
       ('Album C', 'EP'),
       ('Album D', 'Remix'),
       ('Album E', 'LP'),
       ('Album F', 'Studio'),
       ('Album G', 'Live'),
       ('Album H', 'EP'),
       ('Album I', 'Remix'),
       ('Album J', 'LP'),
       ('Album K', 'Studio'),
       ('Album L', 'Live'),
       ('Album M', 'EP'),
       ('Album N', 'Remix'),
       ('Album O', 'LP'),
       ('Album P', 'Studio'),
       ('Album Q', 'Live'),
       ('Album R', 'EP'),
       ('Album S', 'Remix'),
       ('Album T', 'LP'),
       ('Album U', 'Studio'),
       ('Album V', 'Live'),
       ('Album W', 'EP'),
       ('Album X', 'Remix'),
       ('Album Y', 'LP'),
       ('Album Z', 'Studio'),
       ('Album AA', 'Live'),
       ('Album BB', 'EP'),
       ('Album CC', 'Remix'),
       ('Album DD', 'LP');

-- Insert data into add_tag table 
INSERT INTO add_tag (song_id, speed, genre, emotion)
VALUES (1, 120.5, 'Pop', 'Happy'),
       (2, 130.0, 'Rock', 'Energetic'),
       (3, 110.5, 'Jazz', 'Relaxed'),
       (4, 140.0, 'Classical', 'Calm'),
       (5, 115.2, 'Hip-hop', 'Excited'),
       (6, 120.0, 'Pop', 'Uplifting'),
       (7, 135.5, 'Metal', 'Angry'),
       (8, 112.3, 'Blues', 'Sad'),
       (9, 140.2, 'Electronic', 'Energetic'),
       (10, 128.4, 'Reggae', 'Chill'),
       (11, 121.5, 'Country', 'Mellow'),
       (12, 129.0, 'Folk', 'Peaceful'),
       (13, 125.5, 'Soul', 'Smooth'),
       (14, 115.6, 'R&B', 'Loving'),
       (15, 138.9, 'Techno', 'Pumped'),
       (16, 131.5, 'House', 'Uplifted'),
       (17, 135.0, 'Trance', 'Energetic'),
       (18, 145.2, 'Dubstep', 'Excited'),
       (19, 127.8, 'Jazz', 'Mellow'),
       (20, 110.0, 'Opera', 'Dramatic'),
       (21, 140.5, 'Trap', 'Gritty'),
       (22, 135.4, 'Funk', 'Groovy'),
       (23, 126.7, 'Gospel', 'Uplifting'),
       (24, 122.9, 'Indie', 'Chill'),
       (25, 136.6, 'Disco', 'Excited'),
       (26, 129.7, 'Alternative', 'Chill'),
       (27, 140.1, 'Latin', 'Energetic'),
       (28, 145.8, 'Synthwave', 'Retro'),
       (29, 130.2, 'Ska', 'Upbeat'),
       (30, 133.0, 'Punk', 'Aggressive');

-- Insert data into create_list table
INSERT INTO create_list (song_list_id, user_id, tag, description)
VALUES (1, 1, 'Workout', 'A list of songs for workout'),
       (2, 2, 'Chill', 'Relaxing and soothing songs'),
       (3, 3, 'Party', 'Songs for a party mood'),
       (4, 4, 'Study', 'Songs to concentrate while studying'),
       (5, 5, 'Driving', 'Songs to listen to while driving'),
       (6, 6, 'Sleep', 'Songs to help you sleep'),
       (7, 7, 'Focus', 'Songs for intense focus'),
       (8, 8, 'Running', 'High-energy running tracks'),
       (9, 9, 'Yoga', 'Relaxing music for yoga'),
       (10, 10, 'Roadtrip', 'Songs for a long drive'),
       (11, 11, 'Morning', 'Uplifting songs to start your day'),
       (12, 12, 'Evening', 'Chill vibes for winding down'),
       (13, 13, 'Late Night', 'Quiet songs for late hours'),
       (14, 14, 'Dance', 'Upbeat songs to dance to'),
       (15, 15, 'Relaxation', 'Calming and peaceful tracks'),
       (16, 16, 'Motivation', 'Songs to boost your motivation'),
       (17, 17, 'Mood Boost', 'Uplifting and happy songs'),
       (18, 18, 'Workout 2', 'More songs for the gym'),
       (19, 19, 'Chill 2', 'Relaxed vibes for unwinding'),
       (20, 20, 'Party 2', 'More tracks for a party mood'),
       (21, 21, 'Study 2', 'Additional songs for studying'),
       (22, 22, 'Roadtrip 2', 'More tracks for long drives'),
       (23, 23, 'Focus 2', 'More songs for concentration'),
       (24, 24, 'Running 2', 'High-energy running tracks'),
       (25, 25, 'Sleep 2', 'More tracks to help you sleep'),
       (26, 26, 'Yoga 2', 'More relaxing music for yoga'),
       (27, 27, 'Driving 2', 'Additional tracks for driving'),
       (28, 28, 'Late Night 2', 'More quiet songs for late hours'),
       (29, 29, 'Morning 2', 'Uplifting songs for the morning'),
       (30, 30, 'Dance 2', 'More upbeat songs to dance to');

-- Insert data into like_list table 
INSERT INTO like_list (user_id, song_list_id, rating)
VALUES (1, 1, 4),
       (2, 2, 5),
       (3, 3, 3),
       (4, 4, 5),
       (5, 5, 4),
       (6, 6, 5),
       (7, 7, 3),
       (8, 8, 4),
       (9, 9, 5),
       (10, 10, 4),
       (11, 11, 5),
       (12, 12, 3),
       (13, 13, 5),
       (14, 14, 4),
       (15, 15, 4),
       (16, 16, 5),
       (17, 17, 3),
       (18, 18, 5),
       (19, 19, 4),
       (20, 20, 4),
       (21, 21, 5),
       (22, 22, 3),
       (23, 23, 5),
       (24, 24, 4),
       (25, 25, 5),
       (26, 26, 4),
       (27, 27, 5),
       (28, 28, 3),
       (29, 29, 5),
       (30, 30, 4);

-- Insert data into sing table 
INSERT INTO sing (song_id, singer_id)
VALUES (1, 1),
       (2, 2),
       (3, 3),
       (4, 4),
       (5, 5),
       (6, 6),
       (7, 7),
       (8, 8),
       (9, 9),
       (10, 10),
       (11, 11),
       (12, 12),
       (13, 13),
       (14, 14),
       (15, 15),
       (16, 16),
       (17, 17),
       (18, 18),
       (19, 19),
       (20, 20),
       (21, 21),
       (22, 22),
       (23, 23),
       (24, 24),
       (25, 25),
       (26, 26),
       (27, 27),
       (28, 28),
       (29, 29),
       (30, 30);

-- Insert data into contain table
INSERT INTO contain (song_list_id, song_id)
VALUES (1, 1),
       (2, 2),
       (3, 3),
       (4, 4),
       (5, 5),
       (6, 6),
       (7, 7),
       (8, 8),
       (9, 9),
       (10, 10),
       (11, 11),
       (12, 12),
       (13, 13),
       (14, 14),
       (15, 15),
       (16, 16),
       (17, 17),
       (18, 18),
       (19, 19),
       (20, 20),
       (21, 21),
       (22, 22),
       (23, 23),
       (24, 24),
       (25, 25),
       (26, 26),
       (27, 27),
       (28, 28),
       (29, 29),
       (30, 30);


-- Insert data into release table 
INSERT INTO release (singer_id, album_id, release_date)
VALUES (1, 1, '2021-03-01'),
       (2, 2, '2021-03-02'),
       (3, 3, '2021-03-03'),
       (4, 4, '2021-03-04'),
       (5, 5, '2021-03-05'),
       (6, 6, '2021-03-06'),
       (7, 7, '2021-03-07'),
       (8, 8, '2021-03-08'),
       (9, 9, '2021-03-09'),
       (10, 10, '2021-03-10'),
       (11, 11, '2021-03-11'),
       (12, 12, '2021-03-12'),
       (13, 13, '2021-03-13'),
       (14, 14, '2021-03-14'),
       (15, 15, '2021-03-15'),
       (16, 16, '2021-03-16'),
       (17, 17, '2021-03-17'),
       (18, 18, '2021-03-18'),
       (19, 19, '2021-03-19'),
       (20, 20, '2021-03-20'),
       (21, 21, '2021-03-21'),
       (22, 22, '2021-03-22'),
       (23, 23, '2021-03-23'),
       (24, 24, '2021-03-24'),
       (25, 25, '2021-03-25'),
       (26, 26, '2021-03-26'),
       (27, 27, '2021-03-27'),
       (28, 28, '2021-03-28'),
       (29, 29, '2021-03-29'),
       (30, 30, '2021-03-30');


-- Insert data into include table 
INSERT INTO include (song_id, album_id)
VALUES (1, 1),
       (2, 2),
       (3, 3),
       (4, 4),
       (5, 5),
       (6, 6),
       (7, 7),
       (8, 8),
       (9, 9),
       (10, 10),
       (11, 11),
       (12, 12),
       (13, 13),
       (14, 14),
       (15, 15),
       (16, 16),
       (17, 17),
       (18, 18),
       (19, 19),
       (20, 20),
       (21, 21),
       (22, 22),
       (23, 23),
       (24, 24),
       (25, 25),
       (26, 26),
       (27, 27),
       (28, 28),
       (29, 29),
       (30, 30);


