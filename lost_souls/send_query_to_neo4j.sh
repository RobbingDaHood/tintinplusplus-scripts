#!/bin/bash

exec 3>&1 1>/dev/null 2>/dev/null

container_name="LostSoulNeo4j"
docker start $container_name || docker run \
--publish=7474:7474 --publish=7687:7687 \
--volume=$HOME/neo4j/lost_souls/data:/data \
--env=NEO4J_AUTH=none \
--name=$container_name \
-e NEO4J_apoc_export_file_enabled=true \
-e NEO4J_apoc_import_file_enabled=true \
-e NEO4J_apoc_import_file_use__neo4j__config=true \
-e NEO4J_PLUGINS='["apoc", "graph-data-science"]' \
-d \
neo4j 

CONTAINER_ID=$(docker ps --all --filter name=$container_name --format="{{.ID}}" | head -n 1) 
CONTAINER_STATUS=$(docker inspect --format "{{json .State.Status }}" $CONTAINER_ID)
until [ $CONTAINER_STATUS == '"running"' ]
do
    sleep 2
    CONTAINER_ID=$(docker ps --all --quiet --filter name=$container_name --format="{{.ID}}" | head -n 1)
    CONTAINER_STATUS=$(docker inspect --format "{{json .State.Status }}" $CONTAINER_ID)
done

function join_by {
  local d=${1-} f=${2-}
  if shift 2; then
    printf %s "$f" "${@/#/$d}"
  fi
}

body="$(printf '{"statements":[{"statement":"%s"}]}' "$(join_by '"}, { "statement": "' "$@")")"
# echo $body
start_nanoseconds=$(date +%s%3N)
output="$(curl -X POST -H Accept:application/json -H Content-Type:application/json -u neo4j:testneo4j http://localhost:7474/db/neo4j/tx/commit -d "$body" 2> /dev/null)"
end_nanoseconds=$(date +%s%3N)
diff=$(($end_nanoseconds-$start_nanoseconds))

if [ $diff -ge 500 ]; then 
    date >> logs/timed_send_query.log
    echo $diff >> logs/timed_send_query.log
    echo "$body" >> logs/timed_send_query.log
fi

errorsPresent='"errors":[]'
if [[ $output == *"$errorsPresent"* ]]
then
  echo "SUCCESS" >&3
else
  echo "ERRORS" >&3
  date >> logs/errors.log
  echo "$body" >> logs/errors.log
  echo "$output" >> logs/errors.log
fi

echo "$output" >&3
echo "$body" >&3
