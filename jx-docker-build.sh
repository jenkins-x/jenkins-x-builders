#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

export VERSION=$1
export RELEASE=$2

export PUSH=false
export PUSH_LATEST=false
#export CACHE=--no-cache
export CACHE=""

pushd builder-base
  ./build.sh
popd

if [ "release" == "${RELEASE}" ]; then
  export DOCKER_REGISTRY=docker.io
fi

BUILDERS="dlang go-maven gradle maven nodejs python python2 rust scala terraform"
BROKEN="dotnet go"
## now loop through the above array
for i in $BUILDERS
do
  echo "building builder-${i}"
  pushd builder-${i}
    sed -i.bak -e "s/FROM .*/FROM ${DOCKER_ORG}\/builder-base:${VERSION}/" Dockerfile
    rm Dockerfile.bak
    head -n 1 Dockerfile
    echo "Building ${DOCKER_REGISTRY}/${DOCKER_ORG}/builder-${i}:${VERSION}"
    docker build ${CACHE} -t ${DOCKER_REGISTRY}/${DOCKER_ORG}/builder-${i}:${VERSION} -f Dockerfile . > /dev/null
  popd
done

if [ "release" == "${RELEASE}" ]; then
  jx step tag --version ${VERSION}
fi

for i in ${BUILDERS}
do
  if [ "${PUSH}" = "true" ]; then
    echo "Pushing builder-${i}:${VERSION} to ${DOCKER_REGISTRY}"
    docker push ${DOCKER_REGISTRY}/${DOCKER_ORG}/builder-${i}:${VERSION}

    if [ "${PUSH_LATEST}" = "true" ]; then
      echo "Pushing builder-${i}:latest to ${DOCKER_REGISTRY}"
      docker tag ${DOCKER_REGISTRY}/${DOCKER_ORG}/builder-${i}:${VERSION} ${DOCKER_REGISTRY}/${DOCKER_ORG}/builder-${i}:latest
      docker push ${DOCKER_REGISTRY}/${DOCKER_ORG}/builder-${i}:latest
    else
      echo "Not pushing the latest docker image as PUSH_LATEST=${PUSH_LATEST}"
    fi
  else
    echo "Not pushing the docker image as PUSH=${PUSH}"
  fi
done
