from flask import Flask, request, jsonify
from flask_sqlalchemy import SQLAlchemy
import datetime
from datetime import datetime
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
# ---------------------------------------- API for users ---------------------------------------- 
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
    
@app.route('/users/<int:user_id>', methods=['PUT'])
def update_user(user_id):
    data = request.json
    user = Users.query.get(user_id)
    if user:
        user.email = data.get('email', user.email)
        user.user_name = data.get('user_name', user.user_name)
        db.session.commit()
        return jsonify({'message': 'User updated successfully'})
    return jsonify({'error': 'User not found'}), 404

@app.route('/users/<int:user_id>', methods=['DELETE'])
def delete_user(user_id):
    user = Users.query.get(user_id)
    if not user:
        return jsonify({'error': 'User not found'}), 404

    # Delete associated UserPreference first
    if user.preferences:
        db.session.delete(user.preferences)
    
    # Delete the user
    db.session.delete(user)
    db.session.commit()
    return jsonify({'message': 'User and associated preference deleted successfully'}), 200

# ---------------------------------------- API for songs ---------------------------------------- 

@app.route('/songs', methods=['POST'])
def create_song():
    data = request.json
    release_date = datetime.strptime(data.get('release_date'), "%Y-%m-%d").date()
    new_song = Song(
        song_name=data.get('song_name'),
        release_date= release_date,
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
    
@app.route('/songs/<int:song_id>', methods=['PUT'])
def update_song(song_id):
    data = request.json
    song = Song.query.get(song_id)
    if song:
        song.song_name = data.get('song_name', song.song_name)
        song.release_date = datetime.strptime(data['release_date'], "%Y-%m-%d").date()
        song.duration = data.get('duration', song.duration)
        db.session.commit()
        return jsonify({'message': 'Song updated successfully'})
    return jsonify({'error': 'Song not found'}), 404

@app.route('/songs/<int:song_id>', methods=['DELETE'])
def delete_song(song_id):
    song = Song.query.get(song_id)
    if not song:
        return jsonify({'error': 'Song not found'}), 404

    # delete the song in the contain table
    Contain.query.filter_by(song_id=song_id).delete()

    db.session.delete(song)
    db.session.commit()
    return jsonify({'message': 'Song deleted successfully'})

# ---------------------------------------- API for songlists ---------------------------------------- 

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

@app.route('/song-lists/<int:song_list_id>', methods=['PUT'])
def update_song_list(song_list_id):
    data = request.json
    song_list = SongList.query.get(song_list_id)
    if song_list:
        song_list.list_name = data.get('list_name', song_list.list_name)
        db.session.commit()
        return jsonify({'message': 'Song list updated successfully'})
    return jsonify({'error': 'Song list not found'}), 404


@app.route('/song-lists/<int:song_list_id>', methods=['DELETE'])
def delete_song_list(song_list_id):
    song_list = SongList.query.get(song_list_id)
    if song_list:
        db.session.delete(song_list)
        db.session.commit()
        return jsonify({'message': 'Song list deleted successfully'})
    return jsonify({'error': 'Song list not found'}), 404

# ---------------------------------------- API for user contain table ---------------------------------------- 

@app.route('/song-lists/<int:song_list_id>/songs', methods=['POST'])
def insert_song_to_list(song_list_id):
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


@app.route('/song-lists/<int:song_list_id>/songs', methods=['GET'])
def get_songs_in_list(song_list_id):
    song_list = SongList.query.get(song_list_id)
    if not song_list:
        return jsonify({'error': 'Song list not found'}), 404

    songs_in_list = Contain.query.filter_by(song_list_id=song_list_id).all()
    songs = [{'song_id': contain.song_id} for contain in songs_in_list]

    return jsonify({
        'song_list_id': song_list_id,
        'songs': songs
    })


@app.route('/song-lists/<int:song_list_id>/songs/<int:song_id>', methods=['PUT'])
def update_song_in_list(song_list_id, song_id):
    data = request.json
    new_song_id = data.get('new_song_id')

    contain = Contain.query.filter_by(song_list_id=song_list_id, song_id=song_id).first()
    if not contain:
        return jsonify({'error': 'Association not found'}), 404

    # Ensure the new song exists
    new_song = Song.query.get(new_song_id)
    if not new_song:
        return jsonify({'error': 'New song not found'}), 404

    contain.song_id = new_song_id
    db.session.commit()
    return jsonify({'message': 'Song in list updated successfully'})


@app.route('/song-lists/<int:song_list_id>/songs/<int:song_id>', methods=['DELETE'])
def remove_song_from_list(song_list_id, song_id):
    contain = Contain.query.filter_by(song_list_id=song_list_id, song_id=song_id).first()
    if not contain:
        return jsonify({'error': 'Association not found'}), 404

    db.session.delete(contain)
    db.session.commit()
    return jsonify({'message': 'Song removed from list successfully'})

# ---------------------------------------- API for user preference ---------------------------------------- 

@app.route('/users/<int:user_id>/preferences', methods=['POST'])
def create_preference(user_id):
    user = Users.query.get(user_id)
    if not user:
        return jsonify({'error': 'User not found'}), 404

    data = request.json
    # Check if the user already has a preference
    if user.preferences:
        return jsonify({'error': 'User already has a preference'}), 400

    new_preference = UserPreference(
        user_id=user_id,
        favorite_song_category=data.get('favorite_song_category')
    )
    db.session.add(new_preference)
    user.preferences = new_preference 
    db.session.commit()

    return jsonify({
        'message': 'Preference created and user updated successfully',
        'user_id': user.user_id,
        'favorite_song_category': new_preference.favorite_song_category
    }), 201

@app.route('/users/<int:user_id>/preferences', methods=['GET'])
def get_user_preference(user_id):
    user = Users.query.get(user_id)
    if not user:
        return jsonify({'error': 'User not found'}), 404

    if user.preferences:
        return jsonify({
            'user_id': user.user_id,
            'favorite_song_category': user.preferences.favorite_song_category
        })
    return jsonify({'message': 'User has no preferences'}), 200

@app.route('/users/<int:user_id>/preferences', methods=['PUT'])
def update_preference(user_id):
    user = Users.query.get(user_id)
    if not user:
        return jsonify({'error': 'User not found'}), 404

    if not user.preferences:
        return jsonify({'error': 'User has no preferences to update'}), 400

    data = request.json
    user.preferences.favorite_song_category = data.get('favorite_song_category', user.preferences.favorite_song_category)
    db.session.commit()

    return jsonify({
        'message': 'Preference updated successfully',
        'user_id': user.user_id,
        'favorite_song_category': user.preferences.favorite_song_category
    }), 200

@app.route('/users/<int:user_id>/preferences', methods=['DELETE'])
def delete_preference(user_id):
    user = Users.query.get(user_id)
    if not user:
        return jsonify({'error': 'User not found'}), 404

    if not user.preferences:
        return jsonify({'error': 'User has no preferences to delete'}), 400

    db.session.delete(user.preferences)
    user.preferences = None  
    db.session.commit()

    return jsonify({'message': 'Preference deleted successfully'}), 200


# Initialize Database
with app.app_context():
    db.create_all()

if __name__ == '__main__':
    app.run(debug=True)