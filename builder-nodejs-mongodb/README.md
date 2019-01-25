This is the section to include your `myvalues.yaml` file. Make sure to replace `BUILDER_VERSION` with the proper tag published in the [docker repository](https://cloud.docker.com/repository/docker/lvlstudio/builder-nodejs-mongodb).

```
jenkins:
  Agent:
    PodTemplates:
      NodejsMongodb:
        Name: nodejs-mongodb
        Label: jenkins-nodejs-mongodb
        volumes:
        - type: Secret
          secretName: jenkins-docker-cfg
          mountPath: /home/jenkins/.docker
        EnvVars:
          JENKINS_URL: http://jenkins:8080
          GIT_COMMITTER_EMAIL: jenkins-x@googlegroups.com
          GIT_AUTHOR_EMAIL: jenkins-x@googlegroups.com
          GIT_AUTHOR_NAME: jenkins-x-bot
          GIT_COMMITTER_NAME: jenkins-x-bot
          XDG_CONFIG_HOME: /home/jenkins
          DOCKER_CONFIG: /home/jenkins/.docker/
        ServiceAccount: jenkins
        Containers:
          Jnlp:
            Image: jenkinsci/jnlp-slave:3.26-1-alpine
            RequestCpu: "100m"
            RequestMemory: "128Mi"
            Args: '${computer.jnlpmac} ${computer.name}'
          Nodejs-Mongodb:
            Image: lvlstudio/builder-nodejs-mongodb:0.1.151
            Privileged: true
            RequestCpu: "400m"
            RequestMemory: "512Mi"
            LimitCpu: "2"
            LimitMemory: "2048Mi"

```

Modify your app Jenkinsfile to use pipeline agent label `jenkins-nodejs-mongodb` and container `nodejs-mongodb` (instead of `jenkins-nodejs` and `nodejs`). 
Execute `mongod --smallfiles &` before running your tests in both PR and master branches.
