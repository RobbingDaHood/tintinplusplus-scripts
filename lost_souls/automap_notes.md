# use cases

The western exit from the LH sewers sends you through a room whose name is only shown if you look during the brief time you're in it
It also drops you in one of five randomly-chosen rooms in the Shrieking Siren, some of which have the same description and exits as each other
Hypospatiality removes one axis of directions
The rivers in Gardagh change name and description based on weather
The Exoma and the Aumbrie use rooms generated on the fly when you take an exit
Gezuun and Wamnock's Lair regenerate (changing their layout) on a timer, with a message if you're inside in Gezuun's case at least (never seen it happen in Wamnock's Lair so can't say)
The Crypt of Key-Atemi has no "obvious exits"
Leaving the Temple of Ganesha is an exit with a variable destination
The gold mirror in Camille's town hall has three possible destinations
Leaving the Windship passes you through a temporary room, and has a variable destination
The mirror in Terrace is a random teleport
The delocalization challenge from Ganesha will randomport you without any action of your own

# neo4j

## Start

```
docker run \
    --publish=7474:7474 --publish=7687:7687 \
    --volume=$HOME/neo4j/data:/data \
    --name=LostSoulNeo4j \
    -d \
    neo4j
```

``` 
docker exec LostSoulNeo4j cypher-shell -h
```

```
docker exec LostSoulNeo4j cypher-shell --format plain 'MATCH (tom:Person {name: "Tom Hanks"}) RETURN tom'
``` 

``` 
match (a) -[r] -> () delete a, r;
match (a) delete a;

CREATE (room_1:Room {roomdesc:'testing1'});
CREATE (room_2:Room {roomdesc:'testing2'});
CREATE (room_3:Room {roomdesc:'testing3'});

CREATE 
(room_1) -[:e]-> (room_2),
(room_2) -[:e]-> (room_3),
(room_3) -[:teleport]-> (room_1);
``` 

``` 
curl -X POST -H Accept:application/json -H Content-Type:application/json -u neo4j:testneo4j http://localhost:7474/db/neo4j/tx/commit -d "{\"statements\":[{\"statement\":\"MATCH (n) RETURN n\"}]}"
``` 





