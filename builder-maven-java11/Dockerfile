FROM gcr.io/jenkinsxio/builder-base:0.0.44

# Maven
ENV MAVEN_VERSION 3.5.3
RUN curl -f -L http://central.maven.org/maven2/org/apache/maven/apache-maven/$MAVEN_VERSION/apache-maven-$MAVEN_VERSION-bin.tar.gz | tar -C /opt -xzv
ENV M2_HOME /opt/apache-maven-$MAVEN_VERSION
ENV maven.home $M2_HOME
ENV M2 $M2_HOME/bin
ENV PATH $M2:$PATH

RUN curl https://download.java.net/java/GA/jdk11/9/GPL/openjdk-11.0.2_linux-x64_bin.tar.gz | tar -xz
RUN mv /home/jenkins/jdk-11.0.2 /usr/java
RUN rm /usr/bin/java /usr/bin/javac /usr/bin/javadoc
RUN ln -s /usr/java/bin/java /usr/bin/java
RUN ln -s /usr/java/bin/javac /usr/bin/javac
RUN ln -s /usr/java/bin/javadoc /usr/bin/javadoc
ENV JAVA_HOME /usr/java

# jx
ENV JX_VERSION 2.0.444
RUN curl -f -L https://github.com/jenkins-x/jx/releases/download/v${JX_VERSION}/jx-linux-amd64.tar.gz | tar xzv && \
  mv jx /usr/bin/

CMD ["mvn","-version"]