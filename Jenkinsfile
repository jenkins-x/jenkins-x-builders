pipeline {
    agent any
    environment {
      ORG               = 'jenkins-x'
      DOCKER_ORG        = 'jenkinsxio'
      APP_NAME          = 'jenkins-x-builders'
      GIT_PROVIDER      = 'github.com'
    }
    stages {
      stage('CI Build and push snapshot') {
        when {
          branch 'PR-*'
        }
        environment {
          PREVIEW_VERSION = "0.0.0-SNAPSHOT-$BRANCH_NAME-$BUILD_NUMBER"
          PREVIEW_NAMESPACE = "$APP_NAME-$BRANCH_NAME".toLowerCase()
          HELM_RELEASE = "$PREVIEW_NAMESPACE".toLowerCase()
          PUSH = "true"
        }
        steps {
          checkout scm
          sh 'export VERSION=$PREVIEW_VERSION'
          sh './jx-docker-build.sh $PREVIEW_VERSION pr'
        }
      }
      stage('Build Release') {
        when {
          branch 'master'
        }
        environment {
          PUSH = "true"
		}
        steps {
          git 'https://github.com/jenkins-x/jenkins-x-builders.git'
          sh "git config --global credential.helper store"
          sh "jx step validate --min-jx-version 1.1.73"
          sh "jx step git credentials"
          sh "echo \$(jx-release-version) > VERSION"
          sh 'export VERSION=`cat VERSION`'
          sh "jx step validate --min-jx-version 1.2.36"
          sh './jx-docker-build.sh `cat VERSION` release'
        }
      }
    }
  }
