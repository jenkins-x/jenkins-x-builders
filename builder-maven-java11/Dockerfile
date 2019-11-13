ENV UPDATEBOT_VERSION 1.1.41
RUN curl -f  -o ./updatebot -L https://repo1.maven.org/maven2/io/jenkins/updatebot/updatebot/${UPDATEBOT_VERSION}/updatebot-${UPDATEBOT_VERSION}.jar && \
  chmod +x updatebot && \	
  cp updatebot /usr/bin/ && \	
  rm -rf updatebot


# jx
ENV JX_VERSION 2.0.981
RUN curl -f -L https://github.com/jenkins-x/jx/releases/download/v${JX_VERSION}/jx-linux-amd64.tar.gz | tar xzv && \
  mv jx /usr/bin/

CMD ["mvn","-version"]
