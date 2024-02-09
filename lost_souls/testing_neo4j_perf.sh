#!/bin/bash

declare -a delete_all=(
"match (a) -[r] -> () delete a, r"
"match (a) delete a"
)

declare -a setup_first_node=(
"CREATE (a:Room {roomdesc:'testing1', current_room: 'true', certain_hash_location: 'A'})"

"MATCH (a:Room {current_room: 'true'}) WHERE NOT (a)-[:direction {name: 'e'}]->() CREATE (a) -[:direction {name: 'e'}]-> (b:Room {explored:'false'}) -[:direction {name: 'w', unconfirmed: 'true'}]-> (a)"
"MATCH (a:Room {current_room: 'true'}) WHERE NOT (a)-[:direction {name: 'n'}]->() CREATE (a) -[:direction {name: 'n'}]-> (b:Room {explored:'false'}) -[:direction {name: 's', unconfirmed: 'true'}]-> (a)"
"MATCH (a:Room {current_room: 'true'}) -[r:direction {unconfirmed: 'true'}]-> () WHERE r.name in ['e', 'n'] Remove r.unconfirmed" 
"MATCH (a:Room {current_room: 'true'}) -[r:direction]-> () WHERE NOT r.name in ['e', 'n'] SET r.temporary = 'true'" 
)

declare -a move_east_then_explore=(
"MATCH (a:Room {current_room: 'true'}) -[r:direction {name: 'e'}]-> (b:Room) SET a.current_room = 'false', b.current_room = 'true', b.roomdesc = 'testing2', b.certain_hash_location = 'B' REMOVE b.explored"

"MATCH (a:Room {current_room: 'true'}) WHERE NOT (a)-[:direction {name: 'e'}]->() CREATE (a) -[:direction {name: 'e'}]-> (b:Room {explored:'false'}) -[:direction {name: 'w', unconfirmed: 'true'}]-> (a)"
"MATCH (a:Room {current_room: 'true'}) WHERE NOT (a)-[:direction {name: 'n'}]->() CREATE (a) -[:direction {name: 'n'}]-> (b:Room {explored:'false'}) -[:direction {name: 's', unconfirmed: 'true'}]-> (a)"
"MATCH (a:Room {current_room: 'true'}) -[r:direction {unconfirmed: 'true'}]-> () WHERE r.name in ['e', 'n', 'w'] Remove r.unconfirmed" 
"MATCH (a:Room {current_room: 'true'}) -[r:direction]-> () WHERE NOT r.name in ['e', 'n', 'w'] SET r.temporary = 'true'" 
)

docker start LostSoulNeo4j || docker run \
    --publish=7474:7474 --publish=7687:7687 \
    --volume=$HOME/neo4j/data:/data \
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

#curl -X POST -H Accept:application/json -H Content-Type:application/json -u neo4j:testneo4j http://localhost:7474/db/neo4j/tx/commit -d "{\"statements\":[{\"statement\":\"$(join_by "\"}, { \"statement\": \"" "${delete_all[@]}")\"}]}" | jq .
#curl -X POST -H Accept:application/json -H Content-Type:application/json -u neo4j:testneo4j http://localhost:7474/db/neo4j/tx/commit -d "{\"statements\":[{\"statement\":\"$(join_by "\"}, { \"statement\": \"" "${setup_first_node[@]}")\"}]}" | jq .


declare -a move_east_then_explore_1000=()
for i in $(seq 1 100);
do
    move_east_then_explore_1000+=("${move_east_then_explore[@]}")
done

for i in $(seq 1 100000);
do
    curl -X POST -H Accept:application/json -H Content-Type:application/json -u neo4j:testneo4j http://localhost:7474/db/neo4j/tx/commit -d "{\"statements\":[{\"statement\":\"$(join_by "\"}, { \"statement\": \"" "${move_east_then_explore_1000[@]}")\"}]}" 
done




