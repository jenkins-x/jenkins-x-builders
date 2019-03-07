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
  base=$2
  echo "pack $name uses base image: $base"

  # generate a docker image
  cat Dockerfile.$base > Dockerfile.$name
  cat ../Dockerfile.common >> Dockerfile.$name
  cat Dockerfile.common >> Dockerfile.$name
}

build_image "ruby" "rubybase"
build_image "swift" "swiftbase"

retry 3 skaffold build -p kaniko -f skaffold.yaml --skip-tests

IMAGE_NAME="${DOCKER_ORG}/builder-base:${VERSION}"
docker pull ${IMAGE_NAME}

echo "Testing ${IMAGE_NAME}"     
container-structure-test test \
  --image ${IMAGE_NAME} \
  --config test-base/container-test.yaml

IMAGE_NAME="${DOCKER_ORG}/builder-ruby:${VERSION}"
docker pull ${IMAGE_NAME}

echo "Testing ${IMAGE_NAME}"     
container-structure-test test \
  --image ${IMAGE_NAME} \
  --config test-ruby/container-test.yaml
