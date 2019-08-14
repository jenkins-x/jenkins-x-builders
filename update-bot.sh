#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

jx step create pr chart --name gcr.io/jenkinsxio/builder-ruby --name gcr.io/jenkinsxio/builder-swift \
  --name gcr.io/jenkinsxio/builder-dlang --name gcr.io/jenkinsxio/builder-go --name gcr.io/jenkinsxio/builder-go-maven \
  --name gcr.io/jenkinsxio/builder-gradle --name gcr.io/jenkinsxio/builder-gradle4 --name gcr.io/jenkinsxio/builder-gradle5 \
  --name gcr.io/jenkinsxio/builder-jx --name gcr.io/jenkinsxio/builder-maven --name gcr.io/jenkinsxio/builder-maven-32 \
  --name gcr.io/jenkinsxio/builder-maven-java11 --name gcr.io/jenkinsxio/builder-maven-nodejs --name gcr.io/jenkinsxio/builder-newman \
  --name gcr.io/jenkinsxio/builder-nodejs --name gcr.io/jenkinsxio/builder-nodejs8x --name gcr.io/jenkinsxio/builder-nodejs10x \
  --name gcr.io/jenkinsxio/builder-python --name gcr.io/jenkinsxio/builder-python2 --name gcr.io/jenkinsxio/builder-python37 \
  --name gcr.io/jenkinsxio/builder-rust --name gcr.io/jenkinsxio/builder-scala --name gcr.io/jenkinsxio/builder-terraform \
  --version ${VERSION} --repo https://github.com/jenkins-x/jenkins-x-platform.git

jx step create pr regex --regex "builderTag: (.*)" --version ${VERSION} --files jx-build-templates/values.yaml --repo https://github.com/jenkins-x-charts/jx-build-templates.git
jx step create pr regex --regex "(?m)^\s+repository: gcr.io/jenkinsxio/builder-[\w-_]+\s+tag: (?P<version>.*)$" --version ${VERSION} --files jenkins-x-platform/values.yaml --files values.yaml --repo https://github.com/jenkins-x/jenkins-x-platform.git
jx step create pr regex --regex "(?m)^\s+repository: gcr.io/jenkinsxio/builder-maven\s+tag: (?P<version>.*)" --version ${VERSION} --files prow/values.yaml --files environment-controller/values.yaml --repo https://github.com/jenkins-x-charts/prow.git --repo https://github.com/jenkins-x-charts/environment-controller.git
