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
  echo "pinging elasticsearch..."
  sleep 1s
  i=$(( i + 1 ))
done

echo

if [ $i -lt $max ]; then
  echo "elasticsearch up and running"
else 
  echo "elastic search failed to respond"
  false
fi


