#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

jx step create pr chart --name gcr.io/jenkinsxio/builder-ruby --version ${VERSION} --repo https://github.com/jenkins-x/jenkins-x-platform.git
jx step create pr chart --name gcr.io/jenkinsxio/builder-swift --version ${VERSION} --repo https://github.com/jenkins-x/jenkins-x-platform.git
jx step create pr chart --name gcr.io/jenkinsxio/builder-dlang --version ${VERSION} --repo https://github.com/jenkins-x/jenkins-x-platform.git
jx step create pr chart --name gcr.io/jenkinsxio/builder-go --version ${VERSION} --repo https://github.com/jenkins-x/jenkins-x-platform.git
jx step create pr chart --name gcr.io/jenkinsxio/builder-go-maven --version ${VERSION} --repo https://github.com/jenkins-x/jenkins-x-platform.git
jx step create pr chart --name gcr.io/jenkinsxio/builder-gradle --version ${VERSION} --repo https://github.com/jenkins-x/jenkins-x-platform.git
jx step create pr chart --name gcr.io/jenkinsxio/builder-gradle4 --version ${VERSION} --repo https://github.com/jenkins-x/jenkins-x-platform.git
jx step create pr chart --name gcr.io/jenkinsxio/builder-gradle5 --version ${VERSION} --repo https://github.com/jenkins-x/jenkins-x-platform.git
jx step create pr chart --name gcr.io/jenkinsxio/builder-jx --version ${VERSION} --repo https://github.com/jenkins-x/jenkins-x-platform.git
jx step create pr chart --name gcr.io/jenkinsxio/builder-machine-learning --version ${VERSION} --repo https://github.com/jenkins-x/jenkins-x-platform.git
jx step create pr chart --name gcr.io/jenkinsxio/builder-machine-learning-gpu --version ${VERSION} --repo https://github.com/jenkins-x/jenkins-x-platform.git
jx step create pr chart --name gcr.io/jenkinsxio/builder-maven --version ${VERSION} --repo https://github.com/jenkins-x/jenkins-x-platform.git --repo https://github.com/jenkins-x-charts/environment-controller.git --repo https://github.com/jenkins-x-charts/prow.git
jx step create pr chart --name gcr.io/jenkinsxio/builder-maven-32 --version ${VERSION} --repo https://github.com/jenkins-x/jenkins-x-platform.git
jx step create pr chart --name gcr.io/jenkinsxio/builder-maven-java11 --version ${VERSION} --repo https://github.com/jenkins-x/jenkins-x-platform.git
jx step create pr chart --name gcr.io/jenkinsxio/builder-maven-nodejs --version ${VERSION} --repo https://github.com/jenkins-x/jenkins-x-platform.git
jx step create pr chart --name gcr.io/jenkinsxio/builder-newman --version ${VERSION} --repo https://github.com/jenkins-x/jenkins-x-platform.git
jx step create pr chart --name gcr.io/jenkinsxio/builder-nodejs --version ${VERSION} --repo https://github.com/jenkins-x/jenkins-x-platform.git
jx step create pr chart --name gcr.io/jenkinsxio/builder-nodejs8x --version ${VERSION} --repo https://github.com/jenkins-x/jenkins-x-platform.git
jx step create pr chart --name gcr.io/jenkinsxio/builder-nodejs10x --version ${VERSION} --repo https://github.com/jenkins-x/jenkins-x-platform.git
jx step create pr chart --name gcr.io/jenkinsxio/builder-python --version ${VERSION} --repo https://github.com/jenkins-x/jenkins-x-platform.git
jx step create pr chart --name gcr.io/jenkinsxio/builder-python2 --version ${VERSION} --repo https://github.com/jenkins-x/jenkins-x-platform.git
jx step create pr chart --name gcr.io/jenkinsxio/builder-python37 --version ${VERSION} --repo https://github.com/jenkins-x/jenkins-x-platform.git
jx step create pr chart --name gcr.io/jenkinsxio/builder-rust --version ${VERSION} --repo https://github.com/jenkins-x/jenkins-x-platform.git
jx step create pr chart --name gcr.io/jenkinsxio/builder-scala --version ${VERSION} --repo https://github.com/jenkins-x/jenkins-x-platform.git
jx step create pr chart --name gcr.io/jenkinsxio/builder-terraform --version ${VERSION} --repo https://github.com/jenkins-x/jenkins-x-platform.git

jx step create pr regex --regex "builderTag: (.*)" --version ${VERSION} --files jx-build-templates/values.yaml --repo https://github.com/jenkins-x-charts/jx-build-templates.git

# TODO need --previous line support
updatebot push-regex -r "\s+tag: (.*)" -v ${VERSION} --previous-line "\s+repository: gcr.io/jenkinsxio/builder-go" jenkins-x-platform/values.yaml
updatebot push-regex -r "\s+tag: (.*)" -v ${VERSION} --previous-line "\s+repository: gcr.io/jenkinsxio/builder-go" values.yaml
updatebot push-regex -r "\s+tag: (.*)" -v ${VERSION} --previous-line "\s+repository: gcr.io/jenkinsxio/builder-maven" prow/values.yaml
updatebot push-regex -r "\s+tag: (.*)" -v ${VERSION} --previous-line "\s+repository: gcr.io/jenkinsxio/builder-maven" environment-controller/values.yaml
