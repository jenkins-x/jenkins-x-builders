#!/usr/bin/env bash
set -e
set -u 

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
cat Dockerfile.common >> Dockerfile

docker build ${CACHE} -t ${DOCKER_REGISTRY}/${DOCKER_ORG}/builder-base:${VERSION} -f Dockerfile .
docker build ${CACHE} -t ${DOCKER_REGISTRY}/${DOCKER_ORG}/builder-slim:${VERSION} -f Dockerfile.slim .

if [ "$PUSH" = "true" ]; then
  echo "Pushing the docker image"
  docker push ${DOCKER_REGISTRY}/${DOCKER_ORG}/builder-base:${VERSION}
  docker push ${DOCKER_REGISTRY}/${DOCKER_ORG}/builder-slim:${VERSION}

  if [ "$PUSH_LATEST" = "true" ]; then
    docker tag ${DOCKER_REGISTRY}/${DOCKER_ORG}/builder-base:${VERSION} ${DOCKER_REGISTRY}/${DOCKER_ORG}/builder-base:latest
    docker push ${DOCKER_REGISTRY}/${DOCKER_ORG}/builder-base:latest
    docker tag ${DOCKER_REGISTRY}/${DOCKER_ORG}/builder-slim:${VERSION} ${DOCKER_REGISTRY}/${DOCKER_ORG}/builder-slim:latest
    docker push ${DOCKER_REGISTRY}/${DOCKER_ORG}/builder-slim:latest
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
  cat Dockerfile.common >> Dockerfile.$name

  docker build -t ${DOCKER_REGISTRY}/${DOCKER_ORG}/builder-$name:${VERSION} -f Dockerfile.$name .

  if [ "$PUSH" = "true" ]; then
    echo "Pushing the docker image"
    docker push ${DOCKER_REGISTRY}/${DOCKER_ORG}/builder-$name:${VERSION}

    if [ "$PUSH_LATEST" = "true" ]; then
      docker tag ${DOCKER_REGISTRY}/${DOCKER_ORG}/builder-$name:${VERSION} ${DOCKER_REGISTRY}/${DOCKER_ORG}/builder-$name:latest
      docker push ${DOCKER_REGISTRY}/${DOCKER_ORG}/builder-$name:latest
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
