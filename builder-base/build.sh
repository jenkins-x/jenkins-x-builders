#!/usr/bin/env bash
set -e
set -u 

# Retries a command on failure.
# $1 - the max number of attempts
# $2... - the command to run
retry() {
    local -r -i max_attempts="$1"; shift
    local -r cmd="$@"
    local -i attempt_num=1

    until $cmd
    do
        if (( attempt_num == max_attempts ))
        then
            echo "Attempt $attempt_num failed and there are no more attempts left!"
            return 1
        else
            echo "Attempt $attempt_num failed! Trying again in $attempt_num seconds..."
            sleep $(( attempt_num++ ))
        fi
    done
}

if [ "$VERSION" = "" ]
then
  echo "No VERSION env var so assuming a snapshot!"
  VERSION="SNAPSHOT-$BRANCH_NAME-$BUILD_NUMBER"
fi

if [ "$PUSH_LATEST" = "" ]
then
  echo "No PUSH_LATEST env var !"
  PUSH_LATEST="false"
fi

echo "Building images with version ${VERSION}"

echo "FROM centos:7" > Dockerfile
echo "" >> Dockerfile
cat Dockerfile.yum >> Dockerfile
cat ../Dockerfile.common >> Dockerfile
cat Dockerfile.common >> Dockerfile

echo "FROM centos:7" > Dockerfile.slim
echo "" >> Dockerfile.slim
cat ../Dockerfile.common >> Dockerfile.slim
cat Dockerfile.slim.commands >> Dockerfile.slim

function build_image {
  name=$1
  image=$2
  echo "pack $name uses image: $image"

  # generate a docker image
  echo "FROM $image" > Dockerfile.$name
  echo "" >> Dockerfile.$name
  cat Dockerfile.apt >> Dockerfile.$name
  cat ../Dockerfile.common >> Dockerfile.$name
  cat Dockerfile.common >> Dockerfile.$name
}  

build_image "ruby" "ruby:2.5.1"
build_image "swift" "swift:4.0.3"

retry 3 skaffold build -f skaffold.yaml
