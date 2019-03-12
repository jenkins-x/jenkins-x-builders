#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

updatebot push-version --kind helm \
    jenkinsxio/builder-aws-cdk ${VERSION} \
    jenkinsxio/builder-ruby ${VERSION} \
    jenkinsxio/builder-swift ${VERSION} \
    jenkinsxio/builder-dlang ${VERSION} \
    jenkinsxio/builder-go ${VERSION} \
    jenkinsxio/builder-go-maven ${VERSION} \
    jenkinsxio/builder-gradle ${VERSION} \
    jenkinsxio/builder-gradle4 ${VERSION} \
    jenkinsxio/builder-gradle5 ${VERSION} \
    jenkinsxio/builder-jx ${VERSION} \
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
updatebot push-regex -r "\s+tag: (.*)" -v ${VERSION} --previous-line "\s+repository: jenkinsxio/builder-maven" prow/values.yaml
