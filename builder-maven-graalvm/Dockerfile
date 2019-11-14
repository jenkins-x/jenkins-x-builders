FROM gcr.io/jenkinsxio/builder-base:0.0.71

# Maven
ENV MAVEN_VERSION 3.6.2
RUN curl -f -L http://central.maven.org/maven2/org/apache/maven/apache-maven/$MAVEN_VERSION/apache-maven-$MAVEN_VERSION-bin.tar.gz | tar -C /opt -xzv
ENV M2_HOME /opt/apache-maven-$MAVEN_VERSION
ENV maven.home $M2_HOME
ENV M2 $M2_HOME/bin
ENV PATH $M2:$PATH

# GraalVM
ARG GRAAL_VERSION=19.2.1

ENV GRAAL_CE_URL=https://github.com/oracle/graal/releases/download/vm-${GRAAL_VERSION}/graalvm-ce-linux-amd64-${GRAAL_VERSION}.tar.gz
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

ENV PATH $GRAALVM_HOME/bin:$PATH
RUN gu install native-image

# jx
ENV JX_VERSION 2.0.987
RUN curl -f -L https://github.com/jenkins-x/jx/releases/download/v${JX_VERSION}/jx-linux-amd64.tar.gz | tar xzv && \
  mv jx /usr/bin/

CMD ["mvn","-version"]