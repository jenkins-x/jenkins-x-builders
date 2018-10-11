#!/usr/bin/env bash
#
# Usage: jx-docker-build.sh VERSION release|do-not-release
#
# This script relies on these environment variables:
#   DOCKER_ORG - docker organization
#   PUSH       - true|false

set -o errexit
set -o nounset
set -o pipefail

export VERSION=$1
export RELEASE=$2

export PUSH_LATEST=false
#export CACHE=--no-cache
export CACHE=""

export DOCKER_REGISTRY=docker.io

pushd builder-base
  ./build.sh
popd

## newman depends on nodejs, so order is important
BUILDERS="dlang go go-maven gradle maven nodejs newman python python2 rust scala terraform"
BROKEN="dotnet"
## now loop through the above array
for i in $BUILDERS
do
  echo "building builder-${i}"
  pushd builder-${i}
    sed -i.bak -e "s/FROM \(.*\)\/builder-\(.*\):\(.*\)/FROM ${DOCKER_ORG}\/builder-\2:${VERSION}/" Dockerfile
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

if [ "release" == "${RELEASE}" ]; then
  updatebot push-version --kind helm \
    jenkinsxio/builder-base ${VERSION} \
    jenkinsxio/builder-slim ${VERSION} \
    jenkinsxio/builder-ruby ${VERSION} \
    jenkinsxio/builder-swift ${VERSION} \
    jenkinsxio/builder-dlang ${VERSION} \
    jenkinsxio/builder-go ${VERSION} \
    jenkinsxio/builder-go-maven ${VERSION} \
    jenkinsxio/builder-gradle ${VERSION} \
    jenkinsxio/builder-maven ${VERSION} \
    jenkinsxio/builder-newman ${VERSION} \
    jenkinsxio/builder-nodejs ${VERSION} \
    jenkinsxio/builder-python ${VERSION} \
    jenkinsxio/builder-python2 ${VERSION} \
    jenkinsxio/builder-rust ${VERSION} \
    jenkinsxio/builder-scala ${VERSION} \
    jenkinsxio/builder-terraform ${VERSION}
fi
