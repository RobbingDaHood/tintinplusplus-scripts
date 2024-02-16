#!/bin/bash

container_name="LostSoulNeo4j"
while [ "$( docker container inspect -f '{{.State.Running}}' $container_name )" = "false" ]
do
    docker start $container_name || docker run \
    --publish=7474:7474 --publish=7687:7687 \
    --volume=$HOME/neo4j/data:/data \
    --env=NEO4J_AUTH=none \
    --name=$container_name \
    -e NEO4J_apoc_export_file_enabled=true \
    -e NEO4J_apoc_import_file_enabled=true \
    -e NEO4J_apoc_import_file_use__neo4j__config=true \
    -e NEO4J_PLUGINS=\[\"apoc\"\] \
    -d \
    neo4j \
    2> /dev/null \
    1> /dev/null 
    sleep 2
done

function join_by {
  local d=${1-} f=${2-}
  if shift 2; then
    printf %s "$f" "${@/#/$d}"
  fi
}

body="$(printf '{"statements":[{"statement":"%s"}]}' "$(join_by '"}, { "statement": "' "$@")")"
# echo $body
output="$(curl -X POST -H Accept:application/json -H Content-Type:application/json -u neo4j:testneo4j http://localhost:7474/db/neo4j/tx/commit -d "$body" 2> /dev/null)"

errorsPresent='"errors":[]'
if [[ $output == *"$errorsPresent"* ]]
then
  echo "SUCCESS"
else
  echo "ERRORS"
fi

echo "$output"
echo "$body"
