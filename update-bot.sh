#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

updatebot push-version --kind helm \
    gcr.io/jenkinsxio/builder-ruby ${VERSION} \
    gcr.io/jenkinsxio/builder-swift ${VERSION} \
    gcr.io/jenkinsxio/builder-dlang ${VERSION} \
    gcr.io/jenkinsxio/builder-go ${VERSION} \
    gcr.io/jenkinsxio/builder-go-maven ${VERSION} \
    gcr.io/jenkinsxio/builder-gradle ${VERSION} \
    gcr.io/jenkinsxio/builder-gradle4 ${VERSION} \
    gcr.io/jenkinsxio/builder-gradle5 ${VERSION} \
    gcr.io/jenkinsxio/builder-jx ${VERSION} \
    gcr.io/jenkinsxio/builder-machine-learning ${VERSION} \
    gcr.io/jenkinsxio/builder-maven ${VERSION} \
    gcr.io/jenkinsxio/builder-maven-32 ${VERSION} \
    gcr.io/jenkinsxio/builder-maven-java11 ${VERSION} \
    gcr.io/jenkinsxio/builder-maven-nodejs ${VERSION} \
    gcr.io/jenkinsxio/builder-newman ${VERSION} \
    gcr.io/jenkinsxio/builder-nodejs ${VERSION} \
    gcr.io/jenkinsxio/builder-nodejs8x ${VERSION} \
    gcr.io/jenkinsxio/builder-nodejs10x ${VERSION} \
    gcr.io/jenkinsxio/builder-python ${VERSION} \
    gcr.io/jenkinsxio/builder-python2 ${VERSION} \
    gcr.io/jenkinsxio/builder-python37 ${VERSION} \
    gcr.io/jenkinsxio/builder-rust ${VERSION} \
    gcr.io/jenkinsxio/builder-scala ${VERSION} \
    gcr.io/jenkinsxio/builder-terraform ${VERSION}
updatebot push-regex -r "builderTag: (.*)" -v ${VERSION} jx-build-templates/values.yaml
updatebot push-regex -r "\s+tag: (.*)" -v ${VERSION} --previous-line "\s+repository: gcr.io/jenkinsxio/builder-go" jenkins-x-platform/values.yaml
updatebot push-regex -r "\s+tag: (.*)" -v ${VERSION} --previous-line "\s+repository: gcr.io/jenkinsxio/builder-go" values.yaml
updatebot push-regex -r "\s+tag: (.*)" -v ${VERSION} --previous-line "\s+repository: gcr.io/jenkinsxio/builder-maven" prow/values.yaml
