#!/bin/bash

declare -a arr=(

"match (a) -[r] -> () delete a, r"
"match (a) delete a"

"CREATE (a:Room {roomdesc:'testing1', explored:'true', current_room: 'true'})"

"MATCH (a:Room {current_room: 'true'}) CREATE (a) -[:e]-> (b:Room {explored:'false'}), (b) -[:w]-> (a)"
"MATCH (a:Room {current_room: 'true'}) CREATE (a) -[:n]-> (b:Room {explored:'false'}), (b) -[:s]-> (a)"

# "Match (n)-[r]->(m) Return n,r,m"
)

docker start LostSoulNeo4j || docker run \
    --publish=7474:7474 --publish=7687:7687 \
    --volume=$HOME/neo4j/data:/data \
    --env=NEO4J_AUTH=none \
    --name=LostSoulNeo4j \
    -d \
    neo4j

function join_by {
  local d=${1-} f=${2-}
  if shift 2; then
    printf %s "$f" "${@/#/$d}"
  fi
}

asdasd=$(join_by "\"}, { \"statement\": \"" "${arr[@]}")
body="{\"statements\":[{\"statement\":\"$asdasd\"}]}"
echo $body
curl -X POST -H Accept:application/json -H Content-Type:application/json -u neo4j:testneo4j http://localhost:7474/db/neo4j/tx/commit -d "$body" | jq .




