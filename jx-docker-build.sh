#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

VERSION=$1
#ORG=$2
#RELEASE=$3

export DOCKER_REGISTRY=docker.io
export DOCKER_ORG=garethjevans
export VERSION=$1
export PUSH=true
export PUSH_LATEST=false
#export CACHE=--no-cache
export CACHE=""
export RELEASE="pr"

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
  echo "building builder-$i"
  pushd builder-$i
    sed -i.bak -e "s/FROM .*/FROM ${DOCKER_ORG}\/builder-base:${VERSION}/" Dockerfile
    rm Dockerfile.bak
    head -n 1 Dockerfile
    docker build ${CACHE} -t ${DOCKER_REGISTRY}/${DOCKER_ORG}/builder-$i:${VERSION} -f Dockerfile .
  popd
done

if [ "release" == "${RELEASE}" ]; then
  jx step tag --version ${VERSION}
fi

# run the tests against the maven release
#if [ "pr" == "${RELEASE}" ]; then
#  echo "Running test pack..."
  #jx create post preview job --name owasp --image owasp/zap2docker-stable:latest -c "zap-baseline.py" -c "-t" -c "\$(JX_PREVIEW_URL)" 
  #docker run --rm \
  #  -v $PWD/Jenkinsfile-test:/workspace/Jenkinsfile \
  #  -v /var/run:/var/run \
  #  -v /etc/resolv.conf:/etc/resolv.conf \
  #  $ORG/jenkins-maven:$VERSION
  #-e DOCKER_CONFIG=$DOCKER_CONFIG \
  #-e DOCKER_REGISTRY=$DOCKER_REGISTRY \
#fi

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
