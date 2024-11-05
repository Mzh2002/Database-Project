-- index on email in Users table
CREATE NONCLUSTERED INDEX idx_users_email ON Users (email);

-- index on song name in Song table
CREATE NONCLUSTERED INDEX idx_song_song_name ON Song (song_name);

-- index on album_id in include table 
CREATE NONCLUSTERED INDEX idx_include_album_id ON include (album_id);