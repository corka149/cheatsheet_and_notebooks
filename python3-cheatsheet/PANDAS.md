# Pandas

```
# players.csv
# Name,Age,Gender,Fav_game
# Bob,21,Male, Zelda: Breath of the wild
# Jordan,30, Female, Kniffel
# Roy, 29, Male, GTA V

import pandas as pd
players = pd.read_csv("players.csv")
players.head()
len(players)
print(players["Name"])
players.sort_values("Name")

# filter by "older than 25"
old_players = players[players["Age"] > 25]

# only the last two columns
second_player = players.iloc[1,-2:]
print(second_player["Gender"])
```