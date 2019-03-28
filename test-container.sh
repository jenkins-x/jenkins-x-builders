#!/bin/bash

set -e
set -u
set -o pipefail

IMAGE=$1
CONFIG=$2

echo "Testing $IMAGE..."
docker pull $IMAGE
container-structure-test test --pull --config $CONFIG --image $IMAGE 

