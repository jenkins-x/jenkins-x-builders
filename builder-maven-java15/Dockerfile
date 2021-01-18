FROM gcr.io/jenkinsxio/builder-base:0.0.87

RUN curl -O https://download.java.net/java/GA/jdk15.0.1/51f4f36ad4ef43e39d0dfdbaf6549e32/9/GPL/openjdk-15.0.1_linux-x64_bin.tar.gz
RUN   tar xvf openjdk-15.0.1_linux-x64_bin.tar.gz
RUN mv jdk-15.0.1 /opt/
RUN  yum clean all

ENV UPDATEBOT_VERSION 1.1.41
RUN curl -f  -o ./updatebot -L https://repo1.maven.org/maven2/io/jenkins/updatebot/updatebot/${UPDATEBOT_VERSION}/updatebot-${UPDATEBOT_VERSION}.jar && \
  chmod +x updatebot && \
  cp updatebot /usr/bin/ && \
  rm -rf updatebot

# Maven
ENV MAVEN_VERSION 3.6.3
RUN curl -f -L https://repo1.maven.org/maven2/org/apache/maven/apache-maven/$MAVEN_VERSION/apache-maven-$MAVEN_VERSION-bin.tar.gz | tar -C /opt -xzv
ENV M2_HOME /opt/apache-maven-$MAVEN_VERSION
ENV maven.home $M2_HOME
ENV M2 $M2_HOME/bin
ENV PATH $M2:$PATH
ENV JAVA_HOME /opt/jdk-15.0.1

# openapi generator
ENV OPENAPI_VERSION 4.0.0
ENV OPENAPI_GHREPO openapitools/openapi-generator
ENV OPENAPI_GROUPID org.openapitools
ENV OPENAPI_ARTIFACTID openapi-generator-cli
ENV OPENAPI_JAR $OPENAPI_ARTIFACTID-$OPENAPI_VERSION.jar
ENV OPENAPI_REPO central::default::https://repo1.maven.org/maven2/
ENV OPENAPI_DIR /usr/openapi
ENV OPENAPI_CODEGEN_BIN $OPENAPI_DIR/$OPENAPI_JAR
RUN mkdir -p $OPENAPI_DIR
RUN mvn --no-transfer-progress org.apache.maven.plugins:maven-dependency-plugin:2.9:get -DremoteRepositories=$OPENAPI_REPO -Dartifact=$OPENAPI_GROUPID:$OPENAPI_ARTIFACTID:$OPENAPI_VERSION -Dtransitive=false -Ddest=$OPENAPI_CODEGEN_BIN

# jx
ENV JX_VERSION 2.1.155
RUN curl -f -L https://github.com/jenkins-x/jx/releases/download/v${JX_VERSION}/jx-linux-amd64.tar.gz | tar xzv && \
  mv jx /usr/bin/

CMD ["mvn","-version"]
