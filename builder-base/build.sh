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

cat Dockerfile > Dockerfile.base
cat ../Dockerfile.common >> Dockerfile.base
cat Dockerfile.common >> Dockerfile.base

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

retry 3 skaffold build -p kaniko -f skaffold.yaml --skip-tests

IMAGE_NAME="${DOCKER_REGISTRY}/${DOCKER_ORG}/builder-base:${VERSION}"
IMAGE_NAME_LOWERCASE=$(echo $IMAGE_NAME | tr '[:upper:]' '[:lower:]')
docker pull ${IMAGE_NAME}
     
container-structure-test test \
  --image ${IMAGE_NAME_LOWERCASE} \
  --config test-base/container-test.yaml

IMAGE_NAME="${DOCKER_REGISTRY}/${DOCKER_ORG}/builder-ruby:${VERSION}"
IMAGE_NAME_LOWERCASE=$(echo $IMAGE_NAME | tr '[:upper:]' '[:lower:]')
docker pull ${IMAGE_NAME}

container-structure-test test \
  --image ${IMAGE_NAME_LOWERCASE} \
  --config test-ruby/container-test.yaml
