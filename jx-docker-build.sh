#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

TAG_NUM=$1
#ORG=$2
#RELEASE=$3
TAG=dev_$TAG_NUM

export DOCKER_REGISTRY=docker.io
export DOCKER_ORG=garethjevans
export VERSION=${TAG}
export PUSH=false
export PUSH_LATEST=false
#export CACHE=--no-cache
export CACHE=""

pushd builder-base
	./build.sh
popd

BUILDERS="dlang go-maven gradle maven nodejs python python2 rust scala terraform"
BROKEN="dotnet go"
## now loop through the above array
for i in $BUILDERS
do
    echo "building builder-$i"
	pushd builder-$i
		sed -i.bak -e "s/FROM .*/FROM ${DOCKER_ORG}\/builder-base:${TAG}/" Dockerfile
		rm Dockerfile.bak
		head -n 1 Dockerfile
    	docker build ${CACHE} -t ${DOCKER_REGISTRY}/${DOCKER_ORG}/builder-$i:${TAG} -f Dockerfile .
	popd
done

#if [ "release" == "${RELEASE}" ]; then
#    jx step tag --version $TAG_NUM
#fi

# run the tests against the maven release
#if [ "pr" == "${RELEASE}" ]; then
#	echo "Running test pack..."
    #jx create post preview job --name owasp --image owasp/zap2docker-stable:latest -c "zap-baseline.py" -c "-t" -c "\$(JX_PREVIEW_URL)" 
	#docker run --rm \
    #    -v $PWD/Jenkinsfile-test:/workspace/Jenkinsfile \
    #    -v /var/run:/var/run \
    #    -v /etc/resolv.conf:/etc/resolv.conf \
	#	$ORG/jenkins-maven:$TAG
	#-e DOCKER_CONFIG=$DOCKER_CONFIG \
	#-e DOCKER_REGISTRY=$DOCKER_REGISTRY \
#fi

#for i in "${arr[@]}"
#do
#   	echo "pushing builder-$i to ${DOCKER_REGISTRY}"
#   	docker push ${DOCKER_REGISTRY}/${DOCKER_ORG}/builder-$i:$TAG
#done
