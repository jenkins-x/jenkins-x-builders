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
  --name gcr.io/jenkinsxio/builder-nodejs12x --name gcr.io/jenkinsxio/builder-php5x --name gcr.io/jenkinsxio/builder-php7x \
  --name gcr.io/jenkinsxio/builder-python --name gcr.io/jenkinsxio/builder-python2 --name gcr.io/jenkinsxio/builder-python37 \
  --name gcr.io/jenkinsxio/builder-rust --name gcr.io/jenkinsxio/builder-scala --name gcr.io/jenkinsxio/builder-terraform \
  --name gcr.io/jenkinsxio/builder-go-nodejs --name gcr.io/jenkinsxio/builder-dotnet \
  --version ${VERSION} --repo https://github.com/jenkins-x/jenkins-x-platform.git

jx step create pr regex --regex "builderTag: (.*)" --version ${VERSION} --files jx-build-templates/values.yaml --repo https://github.com/jenkins-x-charts/jx-build-templates.git
jx step create pr regex --regex "(?m)^\s+repository: gcr.io/jenkinsxio/builder-[\w-_]+\s+tag: (?P<version>.*)$" --version ${VERSION} --files jenkins-x-platform/values.yaml --files values.yaml --repo https://github.com/jenkins-x/jenkins-x-platform.git
jx step create pr regex --regex "(?m)^\s+repository: gcr.io/jenkinsxio/builder-maven\s+tag: (?P<version>.*)" --version ${VERSION} --files prow/values.yaml --files environment-controller/values.yaml --repo https://github.com/jenkins-x-charts/prow.git --repo https://github.com/jenkins-x-charts/environment-controller.git
jx step create pr regex --regex "(?m)^\s+repository: gcr.io/jenkinsxio/builder-[\w-_]+\s+tag: (?P<version>.*)$" --version ${VERSION} --files jxboot-helmfile-resources/values.yaml --repo https://github.com/jenkins-x-charts/jxboot-helmfile-resources.git
jx step create pr regex --regex "(?m)^\s+image: gcr.io/jenkinsxio/builder-[\w-_]+:(?P<version>.*)$" --version ${VERSION} --files jxboot-helmfile-resources/values.yaml --repo https://github.com/jenkins-x-charts/jxboot-helmfile-resources.git

JX_VERSION=$(echo $VERSION|cut -d'-' -f1)
jx step create pr chart --name jx --version $JX_VERSION  --repo https://github.com/jenkins-x/jenkins-x-platform.git --src-repo https://github.com/jenkins-x/jx.git
jx step create pr regex --regex "\s*jxTag:\s*(.*)" --version $JX_VERSION --files prow/values.yaml --repo https://github.com/jenkins-x-charts/prow.git --src-repo https://github.com/jenkins-x/jx.git

# arcalos
export GOPROXY=""
jx step create pr go --name github.com/jenkins-x/jx --version $JX_VERSION --build "make mod" --repo https://github.com/cloudbees/jx-tenant-service.git
jx step create pr regex --regex "(?m)^FROM gcr.io/jenkinsxio/builder-go:(?P<version>.*)$" --version ${VERSION} --files Dockerfile --repo https://github.com/cloudbees/jx-tenant-service.git
jx step create pr regex --regex "(?m)^\s+image: gcr.io/jenkinsxio/builder-go:(?P<version>.*)$" --version ${VERSION} --files jenkins-x-prod.yml --files jenkins-x.yml --files templates/update.tmpl.yaml --files templates/cloudbees-poc/service.yaml --files templates/yaml/bdd-test-job.yaml --repo https://github.com/cloudbees/arcalos.git
jx step create pr regex --regex "(?m)^FROM gcr.io/jenkinsxio/builder-go:(?P<version>.*)$" --version ${VERSION} --files Dockerfile --repo https://github.com/cloudbees/lighthouse-githubapp.git


