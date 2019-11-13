FROM gcr.io/jenkinsxio/builder-base:0.0.71

CMD ["gradle"]

ENV GRADLE_HOME /opt/gradle
ENV GRADLE_VERSION 5.6.3

RUN set -o errexit -o nounset \
    && echo "Set URLS" \
    && GRADLE_URL="https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip" \
    && SHA256_URL="${GRADLE_URL}.sha256" \
    \
    && echo "Determine sha256sum" \
    && GRADLE_DOWNLOAD_SHA256=$(curl -sLf "${SHA256_URL}") \
    \
	&& echo "Downloading Gradle" \
	&& wget -q -O gradle.zip "${GRADLE_URL}" \
	\
	&& echo "Checking download hash" \
	&& echo "${GRADLE_DOWNLOAD_SHA256} *gradle.zip" | sha256sum -c - \
	\
	&& echo "Installing Gradle" \
	&& unzip -q gradle.zip \
	&& rm gradle.zip \
	&& mkdir -p /opt \
	&& mv "gradle-${GRADLE_VERSION}" "${GRADLE_HOME}/" \
	&& ln -s "${GRADLE_HOME}/bin/gradle" /usr/bin/gradle

# JDK 11
# /home/jenkins/jdk-11.0.2 seems to still be present in final images so let's just force a rm.
RUN curl https://download.java.net/java/GA/jdk11/9/GPL/openjdk-11.0.2_linux-x64_bin.tar.gz | tar -xz && \
   mv /home/jenkins/jdk-11.0.2 /usr/java && \
   rm -rf /home/jenkins/jdk-11.0.2
RUN ln -s /usr/java/bin/java /usr/bin/java
RUN ln -s /usr/java/bin/javac /usr/bin/javac
RUN ln -s /usr/java/bin/javadoc /usr/bin/javadoc
ENV JAVA_HOME /usr/java	
	
RUN gradle --version

# jx
ENV JX_VERSION 2.0.981
RUN curl -f -L https://github.com/jenkins-x/jx/releases/download/v${JX_VERSION}/jx-linux-amd64.tar.gz | tar xzv && \
  mv jx /usr/bin/
