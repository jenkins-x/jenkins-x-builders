RUN yum remove -y java-1.8.0-openjdk-devel java-1.8.0-openjdk-headless && \
    yum install -y java-1.8.0-openjdk-devel.i686 && \
    yum clean all

ENV UPDATEBOT_VERSION 1.1.41
RUN curl -f  -o ./updatebot -L https://repo1.maven.org/maven2/io/jenkins/updatebot/updatebot/${UPDATEBOT_VERSION}/updatebot-${UPDATEBOT_VERSION}.jar && \
  chmod +x updatebot && \	
  cp updatebot /usr/bin/ && \	
  rm -rf updatebot

# Maven
ENV MAVEN_VERSION 3.6.2
RUN curl -f -L http://central.maven.org/maven2/org/apache/maven/apache-maven/$MAVEN_VERSION/apache-maven-$MAVEN_VERSION-bin.tar.gz | tar -C /opt -xzv
ENV M2_HOME /opt/apache-maven-$MAVEN_VERSION
ENV maven.home $M2_HOME
ENV M2 $M2_HOME/bin
ENV PATH $M2:$PATH

# Set JDK to be 32bit
COPY set_java $M2
RUN $M2/set_java && rm $M2/set_java

# jx
ENV JX_VERSION 2.0.981
RUN curl -f -L https://github.com/jenkins-x/jx/releases/download/v${JX_VERSION}/jx-linux-amd64.tar.gz | tar xzv && \
  mv jx /usr/bin/

CMD ["mvn","-version"]
