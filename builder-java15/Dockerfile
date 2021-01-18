FROM gcr.io/jenkinsxio/builder-base:0.0.83

# JDK 15
# /home/jenkins/jdk-11.0.2 seems to still be present in final images so let's just force a rm.
RUN curl -L https://github.com/AdoptOpenJDK/openjdk15-binaries/releases/download/jdk-15%2B36_openj9-0.22.0/OpenJDK15U-jdk_x64_linux_openj9_15_36_openj9-0.22.0.tar.gz | tar -xz && \
   mv /home/jenkins/jdk-* /usr/java && \
   rm -rf /home/jenkins/jdk-*
RUN ln -s /usr/java/bin/java /usr/bin/java
RUN ln -s /usr/java/bin/javac /usr/bin/javac
RUN ln -s /usr/java/bin/javadoc /usr/bin/javadoc
ENV JAVA_HOME /usr/java

# jx
ENV JX_VERSION 2.1.150
RUN curl -f -L https://github.com/jenkins-x/jx/releases/download/v${JX_VERSION}/jx-linux-amd64.tar.gz | tar xzv && \
  mv jx /usr/bin/
