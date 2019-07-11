FROM gcr.io/jenkinsxio/builder-base:0.0.44

# Maven
ENV MAVEN_VERSION 3.5.3
RUN curl -f -L http://central.maven.org/maven2/org/apache/maven/apache-maven/$MAVEN_VERSION/apache-maven-$MAVEN_VERSION-bin.tar.gz | tar -C /opt -xzv
ENV M2_HOME /opt/apache-maven-$MAVEN_VERSION
ENV maven.home $M2_HOME
ENV M2 $M2_HOME/bin
ENV PATH $M2:$PATH

# GraalVM
# https://github.com/quarkusio/quarkus-images/blob/graalvm-1.0.0-rc16/centos-quarkus-maven/Dockerfile
ARG GRAAL_VERSION=1.0.0-rc16

ENV GRAAL_CE_URL=https://github.com/oracle/graal/releases/download/vm-${GRAAL_VERSION}/graalvm-ce-${GRAAL_VERSION}-linux-amd64.tar.gz
ARG INSTALL_PKGS="gzip"

ENV GRAALVM_HOME /opt/graalvm
ENV JAVA_HOME /opt/graalvm

RUN yum install -y ${INSTALL_PKGS} && \
     ### Installation of GraalVM
	 mkdir -p ${GRAALVM_HOME} && \
	 cd ${GRAALVM_HOME} && \
	 curl -fsSL ${GRAAL_CE_URL} | tar -xzC ${GRAALVM_HOME} --strip-components=1  && \
     ### Cleanup     
     yum clean all && \
     rm -f /tmp/graalvm-ce-amd64.tar.gz && \
     rm -rf /var/cache/yum
     ###


# jx
ENV JX_VERSION 2.0.444
RUN curl -f -L https://github.com/jenkins-x/jx/releases/download/v${JX_VERSION}/jx-linux-amd64.tar.gz | tar xzv && \
  mv jx /usr/bin/

CMD ["mvn","-version"]