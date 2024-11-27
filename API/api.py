from flask import Flask, request, jsonify
from flask_sqlalchemy import SQLAlchemy
import datetime

app = Flask(__name__)

# Database Configuration
app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///music_service.db'  # Change to your database URI
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False

db = SQLAlchemy(app)

# Models
class Users(db.Model):
    __tablename__ = 'Users'
    user_id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    register_time = db.Column(db.DateTime)
    email = db.Column(db.String(50), unique=True, nullable=False)
    user_name = db.Column(db.String(50), nullable=False)

    preferences = db.relationship('UserPreference', backref='user', uselist=False)

class UserPreference(db.Model):
    __tablename__ = 'User_Preference'
    user_id = db.Column(db.Integer, db.ForeignKey('Users.user_id'), primary_key=True)
    favorite_song_category = db.Column(db.String(30))

class Song(db.Model):
    __tablename__ = 'Song'
    song_id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    song_name = db.Column(db.String(30), nullable=False)
    release_date = db.Column(db.Date)
    duration = db.Column(db.Integer)

class SongList(db.Model):
    __tablename__ = 'Song_List'
    song_list_id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    list_name = db.Column(db.String(30), nullable=False)

class Contain(db.Model):
    __tablename__ = 'contain'
    song_list_id = db.Column(db.Integer, db.ForeignKey('Song_List.song_list_id'), primary_key=True)
    song_id = db.Column(db.Integer, db.ForeignKey('Song.song_id'), primary_key=True)


# Routes
@app.route('/users', methods=['POST'])
def create_user():
    data = request.json
    new_user = Users(
        register_time=datetime.datetime.now(),
        email=data.get('email'),
        user_name=data.get('user_name')
    )
    db.session.add(new_user)
    db.session.commit()
    return jsonify({'message': 'User created successfully', 'user_id': new_user.user_id}), 201

@app.route('/users/<int:user_id>', methods=['GET'])
def get_user(user_id):
    user = Users.query.get(user_id)
    if user:
        return jsonify({
            'user_id': user.user_id,
            'register_time': user.register_time,
            'email': user.email,
            'user_name': user.user_name,
            'preferences': {
                'favorite_song_category': user.preferences.favorite_song_category if user.preferences else None
            }
        })
    else:
        return jsonify({'error': 'User not found'}), 404

@app.route('/songs', methods=['POST'])
def create_song():
    data = request.json
    new_song = Song(
        song_name=data.get('song_name'),
        release_date=data.get('release_date'),
        duration=data.get('duration')
    )
    db.session.add(new_song)
    db.session.commit()
    return jsonify({'message': 'Song created successfully', 'song_id': new_song.song_id}), 201

@app.route('/songs/<int:song_id>', methods=['GET'])
def get_song(song_id):
    song = Song.query.get(song_id)
    if song:
        return jsonify({
            'song_id': song.song_id,
            'song_name': song.song_name,
            'release_date': song.release_date,
            'duration': song.duration
        })
    else:
        return jsonify({'error': 'Song not found'}), 404

@app.route('/song-lists', methods=['POST'])
def create_song_list():
    data = request.json
    new_song_list = SongList(
        list_name=data.get('list_name')
    )
    db.session.add(new_song_list)
    db.session.commit()
    return jsonify({'message': 'Song list created successfully', 'song_list_id': new_song_list.song_list_id}), 201

@app.route('/song-lists/<int:song_list_id>/songs', methods=['POST'])
def add_song_to_list(song_list_id):
    data = request.json
    song_id = data.get('song_id')
    song_list = SongList.query.get(song_list_id)
    song = Song.query.get(song_id)
    if not song_list or not song:
        return jsonify({'error': 'Song or Song List not found'}), 404
    contain = Contain(song_list_id=song_list_id, song_id=song_id)
    db.session.add(contain)
    db.session.commit()
    return jsonify({'message': 'Song added to list successfully'}), 201

# Initialize Database
with app.app_context():
    db.create_all()

if __name__ == '__main__':
    app.run(debug=True)