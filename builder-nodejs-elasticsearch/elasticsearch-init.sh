#!/bin/sh -eu

adduser patate
chown -R patate /elasticsearch-6.5.4
sudo -u patate /elasticsearch-6.5.4/bin/elasticsearch -d

i=0
max=60

while [ $i -lt $max ]; do
  if curl "localhost:9200/_cluster/health" > /dev/null 2>&1; then
    break
  fi
  echo "Attempting to connect to elasticsearch"
  sleep 1s
  i=$(( i + 1))
done



