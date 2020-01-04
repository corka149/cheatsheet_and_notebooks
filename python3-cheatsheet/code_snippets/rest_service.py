# $ python3
# >>> from rest_service.py import db
# >>> db.create_all()
# $ python3 rest_service.py

from flask import Flask, request, jsonify
from flask_sqlalchemy import SQLAlchemy
import uuid
from werkzeug.security import generate_password_hash

sql_conn = "sqlite:////home/corka/workspace/test_area/player.db"

app = Flask(__name__)
app.config["SECRET_KEY"] = "thisissecret"
app.config["SQLALCHEMY_DATABASE_URI"] = sql_conn

db = SQLAlchemy(app)


class Player(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    public_id = db.Column(db.String(50), unique=True)
    name = db.Column(db.String(50))
    password = db.Column(db.String(80))
    admin = db.Column(db.Boolean)


@app.route("/player", methods=["GET"])
def get_all_players():
    players = Player.query.all()

    output = []

    for player in players:
        player_data = {}
        player_data["public_id"] = player.public_id
        player_data["name"] = player.name
        player_data["password"] = player.password
        player_data["admin"] = player.admin
        output.append(player_data)

    return jsonify({"players": output})


@app.route("/player/<public_id>", methods=["GET"])
def get_one_player(public_id):
    player = Player.query.filter_by(public_id=public_id).first()

    if not player:
        return jsonify({"message": "No player found!"})

    player_data = {}
    player_data["public_id"] = player.public_id
    player_data["name"] = player.name
    player_data["password"] = player.password
    player_data["admin"] = player.admin

    return jsonify({"player": player_data})


@app.route("/player", methods=["POST"])
def create_player():
    data = request.get_json()

    hashed_password = generate_password_hash(data["password"], method="sha256")

    new_player = Player(public_id=str(uuid.uuid4()), name=data["name"], password=hashed_password, admin=bool(data["admin"]))
    db.session.add(new_player)
    db.session.commit()

    return jsonify({"message": "New player created!"})


@app.route("/player/<public_id>", methods=["PUT"])
def update_player(public_id):
    data = request.get_json()
    player = Player.query.filter_by(public_id=public_id).first()

    if not player:
        return jsonify({"message": "No player found!"})

    player.name = data["name"]
    player.password = generate_password_hash(data["password"], method="sha256")
    player.admin = bool(data["admin"])
    db.session.commit()

    return jsonify({"message": "The player has been update!"})


@app.route("/player/<public_id>", methods=["DELETE"])
def delete_player(public_id):
    player = Player.query.filter_by(public_id=public_id).first()

    if not player:
        return jsonify({"message": "No player found!"})

    db.session.delete(player)
    db.session.commit()

    return jsonify({"message": "The player has been deleted!"})


if __name__ == "__main__":
    app.run(debug=True, port=5000)
