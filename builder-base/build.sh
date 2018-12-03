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

echo "Building ${DOCKER_REGISTRY}/${DOCKER_ORG}/builder-base:${VERSION}"
retry 5 docker build ${CACHE} -t ${DOCKER_REGISTRY}/${DOCKER_ORG}/builder-base:${VERSION} -f Dockerfile .

echo "FROM centos:7" > Dockerfile.slim
echo "" >> Dockerfile.slim
cat ../Dockerfile.common >> Dockerfile.slim
cat Dockerfile.slim.commands >> Dockerfile.slim

echo "Building ${DOCKER_REGISTRY}/${DOCKER_ORG}/builder-slim:${VERSION}"
retry 5 docker build ${CACHE} -t ${DOCKER_REGISTRY}/${DOCKER_ORG}/builder-slim:${VERSION} -f Dockerfile.slim .

if [ "$PUSH" = "true" ]; then
  echo "Pushing the docker image"
  retry 5 docker push ${DOCKER_REGISTRY}/${DOCKER_ORG}/builder-base:${VERSION}
  retry 5 docker push ${DOCKER_REGISTRY}/${DOCKER_ORG}/builder-slim:${VERSION}

  if [ "$PUSH_LATEST" = "true" ]; then
    retry 5 docker tag ${DOCKER_REGISTRY}/${DOCKER_ORG}/builder-base:${VERSION} ${DOCKER_REGISTRY}/${DOCKER_ORG}/builder-base:latest
    retry 5 docker push ${DOCKER_REGISTRY}/${DOCKER_ORG}/builder-base:latest
    retry 5 docker tag ${DOCKER_REGISTRY}/${DOCKER_ORG}/builder-slim:${VERSION} ${DOCKER_REGISTRY}/${DOCKER_ORG}/builder-slim:latest
    retry 5 docker push ${DOCKER_REGISTRY}/${DOCKER_ORG}/builder-slim:latest
  else
    echo "Not pushing the latest docker image as PUSH_LATEST=$PUSH_LATEST"
  fi
else
  echo "Not pushing the docker image as PUSH=$PUSH"
fi

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

  retry 5 docker build -t ${DOCKER_REGISTRY}/${DOCKER_ORG}/builder-$name:${VERSION} -f Dockerfile.$name . > /dev/null 2>&1

  if [ "$PUSH" = "true" ]; then
    echo "Pushing the docker image"
    retry 5 docker push ${DOCKER_REGISTRY}/${DOCKER_ORG}/builder-$name:${VERSION}

    if [ "$PUSH_LATEST" = "true" ]; then
      retry 5 docker tag ${DOCKER_REGISTRY}/${DOCKER_ORG}/builder-$name:${VERSION} ${DOCKER_REGISTRY}/${DOCKER_ORG}/builder-$name:latest
      retry 5 docker push ${DOCKER_REGISTRY}/${DOCKER_ORG}/builder-$name:latest
    else
      echo "Not pushing the latest docker image as PUSH_LATEST=$PUSH_LATEST"
    fi
  else
    echo "Not pushing the docker image as PUSH=$PUSH"
  fi
}  

#PHP_IMAGE="php:7.2.5"
build_image "ruby" "ruby:2.5.1"
build_image "swift" "swift:4.0.3"
