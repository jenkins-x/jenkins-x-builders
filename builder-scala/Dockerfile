FROM gcr.io/jenkinsxio/builder-base:0.0.44

ENV SCALA_VERSION 2.12.5
ENV SBT_VERSION 1.1.2

RUN \
  curl -fsL https://downloads.typesafe.com/scala/$SCALA_VERSION/scala-$SCALA_VERSION.tgz | tar xfz - -C /root/ && \
  echo >> /root/.bashrc && \
  echo "export PATH=~/scala-$SCALA_VERSION/bin:$PATH" >> /root/.bashrc

RUN \
  curl -f https://bintray.com/sbt/rpm/rpm | tee /etc/yum.repos.d/bintray-sbt-rpm.repo && \
  yum install -y sbt-$SBT_VERSION && \
  sbt sbtVersion && \
  yum clean all

# jx
ENV JX_VERSION 2.0.444
RUN curl -f -L https://github.com/jenkins-x/jx/releases/download/v${JX_VERSION}/jx-linux-amd64.tar.gz | tar xzv && \
  mv jx /usr/bin/