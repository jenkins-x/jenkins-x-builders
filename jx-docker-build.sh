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

export VERSION=$1
export RELEASE=$2

export PUSH_LATEST=true
export CACHE=""

export DOCKER_REGISTRY=docker.io

pushd builder-base
  ./build.sh
popd

## newman depends on nodejs, so order is important
BUILDERS="dlang go go-maven gradle gradle4 gradle5 maven maven-java11 maven-nodejs maven-32 nodejs nodejs8x nodejs10x newman aws-cdk python python2 python37 rust scala terraform"
BROKEN="dotnet"
## now loop through the above array
for i in $BUILDERS
do
  echo "updating builder-${i}"
  pushd builder-${i}
    sed -i.bak -e "s/FROM \(.*\)\/builder-\(.*\):\(.*\)/FROM ${DOCKER_ORG}\/builder-\2:${VERSION}/" Dockerfile
    rm Dockerfile.bak
    head -n 1 Dockerfile
  popd
done

if [ "release" == "${RELEASE}" ]; then
  jx step tag --version ${VERSION}
fi

for i in $BUILDERS
do
  echo "building builder-${i}"
  pushd builder-${i}
    head -n 1 Dockerfile
    echo "Building ${DOCKER_REGISTRY}/${DOCKER_ORG}/builder-${i}:${VERSION}"
    retry 3 skaffold build -p kaniko -f skaffold.yaml
  popd
done

if [ "release" == "${RELEASE}" ]; then
  updatebot push-version --kind helm \
    jenkinsxio/builder-aws-cdk ${VERSION} \
    jenkinsxio/builder-base ${VERSION} \
    jenkinsxio/builder-ruby ${VERSION} \
    jenkinsxio/builder-swift ${VERSION} \
    jenkinsxio/builder-dlang ${VERSION} \
    jenkinsxio/builder-go ${VERSION} \
    jenkinsxio/builder-go-maven ${VERSION} \
    jenkinsxio/builder-gradle ${VERSION} \
    jenkinsxio/builder-gradle4 ${VERSION} \
    jenkinsxio/builder-gradle5 ${VERSION} \
    jenkinsxio/builder-maven ${VERSION} \
    jenkinsxio/builder-maven-32 ${VERSION} \
    jenkinsxio/builder-maven-java11 ${VERSION} \
    jenkinsxio/builder-maven-nodejs ${VERSION} \
    jenkinsxio/builder-newman ${VERSION} \
    jenkinsxio/builder-nodejs ${VERSION} \
    jenkinsxio/builder-nodejs8x ${VERSION} \
    jenkinsxio/builder-nodejs10x ${VERSION} \
    jenkinsxio/builder-python ${VERSION} \
    jenkinsxio/builder-python2 ${VERSION} \
    jenkinsxio/builder-python37 ${VERSION} \
    jenkinsxio/builder-rust ${VERSION} \
    jenkinsxio/builder-scala ${VERSION} \
    jenkinsxio/builder-terraform ${VERSION}
  updatebot push-regex -r "builderTag: (.*)" -v ${VERSION} jx-build-templates/values.yaml
  updatebot push-regex -r "\s+tag: (.*)" -v ${VERSION} --previous-line "\s+repository: jenkinsxio/builder-go" values.yaml
fi
