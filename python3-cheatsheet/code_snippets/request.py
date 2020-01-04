import requests

def print_request(r):
    print("-------------------")
    print(r.status_code)
    print("-------------------")
    print(r.headers)
    print("-------------------")
    print(r.text)
    print("-------------------")

url = "http://127.0.0.1:5000/player"


p = {"name": "Nelly", "password": "s3cr3t", "admin": True}
r = requests.post(url, json=p)
print_request(r)


r = requests.get(url)
players = r.json()
# Format: players: [{player1}, {player2},...]
for k, v in players.items():
    for p in v:
        name = p.get("name")
        if name == "Nelly":
            r = requests.delete(url + "/" + p["public_id"])
            print_request(r)
