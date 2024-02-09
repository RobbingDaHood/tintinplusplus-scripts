#!/bin/bash

declare -a arr=(

# DELETE database
"match (a) -[r] -> () delete a, r"
"match (a) delete a"

# Setup indexes: Connot be done over the HTTP API 
# "CREATE INDEX room_certain_hash_location_index FOR (a:Room) on (a.certain_hash_location)"

# Setup first room with two exits
"CREATE (a:Player)"

"MATCH (b:Player) CREATE (a:Room {certain_hash_location: 'A', area: 'Losthaven', coordinate_x: 1, coordinate_y: 2, coordinate_z: 3, updated_time: dateTime()}) <-[:located_at {updated_time: dateTime()}]-(b), (a)-[:roomdescription {desc:'testing1', updated_time: dateTime()}]->(a) "

"MATCH (c:Player)-[located_at]->(a:Room) WHERE NOT (a)-[:direction {name: 'e'}]->() CREATE (a) -[:direction {name: 'e', updated_time: dateTime()}]-> (b:Room {explored:'false', updated_time: dateTime()}) -[:direction {name: 'w', unconfirmed: 'true', updated_time: dateTime()}]-> (a)"
"MATCH (c:Player)-[located_at]->(a:Room) WHERE NOT (a)-[:direction {name: 'n'}]->() CREATE (a) -[:direction {name: 'n', updated_time: dateTime()}]-> (b:Room {explored:'false', updated_time: dateTime()}) -[:direction {name: 's', unconfirmed: 'true', updated_time: dateTime()}]-> (a)"
"MATCH (c:Player)-[located_at]->(a:Room) -[r:direction {unconfirmed: 'true'}]-> () WHERE r.name in ['e', 'n'] Remove r.unconfirmed SET r.updated_time = dateTime()" 
"MATCH (c:Player)-[located_at]->(a:Room) -[r:direction]-> () WHERE NOT r.name in ['e', 'n'] SET r.temporary = 'true', r.updated_time = dateTime()" 
# 
# Move to one room and setup two new exits
"MATCH (a:Player)-[r:located_at]->(b:Room)-[r2:direction {name: 'e'}]->(c:Room) \
    SET c.certain_hash_location = 'B', c.updated_time = dateTime() \
    CREATE (a)-[:located_at {updated_time: dateTime()}]->(c), (c)-[:roomdescription {desc:'testing2', updated_time: dateTime()}]->(c) \
    REMOVE c.explored \
    DELETE r"


"MATCH (:Player)-[:located_at]->(a:Room) WHERE NOT (a)-[:direction {name: 'e'}]->() CREATE (a) -[:direction {name: 'e', updated_time: dateTime()}]-> (b:Room {explored:'false', updated_time: dateTime()}) -[:direction {name: 'w', unconfirmed: 'true', updated_time: dateTime()}]-> (a)"
"MATCH (:Player)-[:located_at]->(a:Room) WHERE NOT (a)-[:direction {name: 'n'}]->() CREATE (a) -[:direction {name: 'n', updated_time: dateTime()}]-> (b:Room {explored:'false', updated_time: dateTime()}) -[:direction {name: 's', unconfirmed: 'true', updated_time: dateTime()}]-> (a)"
"MATCH (:Player)-[:located_at]->(a:Room) -[r:direction {unconfirmed: 'true'}]-> () WHERE r.name in ['e', 'n', 'w'] Remove r.unconfirmed"
"MATCH (:Player)-[:located_at]->(a:Room) -[r:direction]-> () WHERE NOT r.name in ['e', 'n', 'w'] SET r.temporary = 'true', r.updated_time = dateTime()"
 
# Do it again 
"MATCH (a:Player)-[r:located_at]->(b:Room)-[r2:direction {name: 'n'}]->(c:Room) \
    SET c.certain_hash_location = 'A', c.updated_time = dateTime() \
    CREATE (a)-[:located_at {updated_time: dateTime()}]->(c), (c)-[:roomdescription {desc:'testing3', updated_time: dateTime()}]->(c) \
    REMOVE c.explored \
    DELETE r"

"MATCH (:Player)-[:located_at]->(a:Room) WHERE NOT (a)-[:direction {name: 'e'}]->() CREATE (a) -[:direction {name: 'e', updated_time: dateTime()}]-> (b:Room {explored:'false', updated_time: dateTime()}) -[:direction {name: 'w', unconfirmed: 'true', updated_time: dateTime()}]-> (a)"
"MATCH (:Player)-[:located_at]->(a:Room) WHERE NOT (a)-[:direction {name: 'n'}]->() CREATE (a) -[:direction {name: 'n', updated_time: dateTime()}]-> (b:Room {explored:'false', updated_time: dateTime()}) -[:direction {name: 's', unconfirmed: 'true', updated_time: dateTime()}]-> (a)"
"MATCH (:Player)-[:located_at]->(a:Room) -[r:direction {unconfirmed: 'true'}]-> () WHERE r.name in ['e', 'n', 'w'] Remove r.unconfirmed"
"MATCH (:Player)-[:located_at]->(a:Room) -[r:direction]-> () WHERE NOT r.name in ['e', 'n', 'w'] SET r.temporary = 'true', r.updated_time = dateTime()"

# Do it again without certain_hash
"MATCH (a:Player)-[r:located_at]->(b:Room)-[r2:direction {name: 'e'}]->(c:Room) \
    SET c.updated_time = dateTime() \
    CREATE (a)-[:located_at {updated_time: dateTime()}]->(c), (c)-[:roomdescription {desc:'testing4', updated_time: dateTime()}]->(c) \
    REMOVE c.explored \
    DELETE r"

"MATCH (:Player)-[:located_at]->(a:Room) WHERE NOT (a)-[:direction {name: 'e'}]->() CREATE (a) -[:direction {name: 'e', updated_time: dateTime()}]-> (b:Room {explored:'false', updated_time: dateTime()}) -[:direction {name: 'w', unconfirmed: 'true', updated_time: dateTime()}]-> (a)"
"MATCH (:Player)-[:located_at]->(a:Room) WHERE NOT (a)-[:direction {name: 'n'}]->() CREATE (a) -[:direction {name: 'n', updated_time: dateTime()}]-> (b:Room {explored:'false', updated_time: dateTime()}) -[:direction {name: 's', unconfirmed: 'true', updated_time: dateTime()}]-> (a)"
"MATCH (:Player)-[:located_at]->(a:Room) -[r:direction {unconfirmed: 'true'}]-> () WHERE r.name in ['e', 'n', 'w'] Remove r.unconfirmed"
"MATCH (:Player)-[:located_at]->(a:Room) -[r:direction]-> () WHERE NOT r.name in ['e', 'n', 'w'] SET r.temporary = 'true', r.updated_time = dateTime()"

# Do it again 
"MATCH (a:Player)-[r:located_at]->(b:Room)-[r2:direction {name: 'e'}]->(c:Room) \
    SET c.certain_hash_location = 'B', c.updated_time = dateTime() \
    CREATE (a)-[:located_at {updated_time: dateTime()}]->(c), (c)-[:roomdescription {desc:'testing5', updated_time: dateTime()}]->(c) \
    REMOVE c.explored \
    DELETE r"

# Merge all equal certain_hash_location
# REMEMBER: That the current room does not have any exits yet! 
"MATCH (:Player)-[:located_at]->(a:Room)-[r:direction]->() DELETE r" #Need to delete the one precreated exit direction that were unconfirmed
"MATCH (:Player)-[:located_at]->(a:Room) \
    WITH a \
    MATCH (b:Room) \
    WHERE a.certain_hash_location = b.certain_hash_location \
    CALL apoc.refactor.mergeNodes([a,b],{properties:{current_room: 'discard', \`.*\`: 'combine'} , mergeRels:true}) \
    yield node  \
    return node"

"MATCH (:Player)-[:located_at]->(a:Room) -[r:direction {unconfirmed: 'true'}]-> () WHERE r.name in ['e', 'n', 'w'] Remove r.unconfirmed"
"MATCH (:Player)-[:located_at]->(a:Room) -[r:direction]-> () WHERE NOT r.name in ['e', 'n', 'w'] SET r.temporary = 'true', r.updated_time = dateTime()"

# The below is not needed because certain hast rooms with current_room true does not have any edges. They will just be merged. 
## If there are two edges same name and one is confirmed and the other is not: Then remove the one that is not. 
# Delete all unexplored rooms but leave one room left if they are all unexplored. 
# "MATCH (a:Room {current_room: 'true'}) -[r:direction]-> (b:Room {explored: 'false'}) WITH a, r, b MATCH (a) -[rc:direction]->(c:Room) WHERE ID(b) < ID(c) AND r.name = rc.name DETACH DELETE b"
# Then delete edges that overlap
# "MATCH (a:Room {current_room: 'true'}) -[r:direction]-> (b:Room) WITH a, r, b MATCH (a) -[rc:direction]->(c:Room) WHERE a.certain_hash_location IS NOT NULL AND b.certain_hash_location IS NOT NULL AND ID(b) < ID(c) AND r.name = rc.name DETACH DELETE b"
# "MATCH (:Room {current_room: 'true'}) -[r:direction {unconfirmed: 'true'}]-> () WITH r MATCH (:Room {current_room: 'true'}) -[rc:direction]-> () WHERE r.name == rc.name AND rc.unconfirmed IS NULL REMOVE r"


# "Match (n)-[r]->(m) Return n,r,m"
)

# TODO 
# https://neo4j.com/docs/operations-manual/current/docker/configuration/

docker start LostSoulNeo4j || docker run \
    --publish=7474:7474 --publish=7687:7687 \
    --volume=$HOME/neo4j/data:/data \
    --volume=$HOME/neo4j/logs:/logs \
    --volume=$HOME/neo4j/conf:/conf \
    --env=NEO4J_AUTH=none \
    --name=LostSoulNeo4j \
    -e NEO4J_apoc_export_file_enabled=true \
    -e NEO4J_apoc_import_file_enabled=true \
    -e NEO4J_apoc_import_file_use__neo4j__config=true \
    -e NEO4J_PLUGINS=\[\"apoc\"\] \
    -d \
    neo4j

function join_by {
  local d=${1-} f=${2-}
  if shift 2; then
    printf %s "$f" "${@/#/$d}"
  fi
}

curl -X POST -H Accept:application/json -H Content-Type:application/json -u neo4j:testneo4j http://localhost:7474/db/neo4j/tx/commit -d "{\"statements\":[{\"statement\":\"$(join_by "\"}, { \"statement\": \"" "${arr[@]}")\"}]}" | jq .




