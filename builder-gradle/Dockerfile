FROM gcr.io/jenkinsxio/builder-base:0.0.71

CMD ["gradle"]

ENV ANDROID_VERSION 4333796
ENV ANDROID_HOME /opt/android-sdk-linux
ENV PATH ${PATH}:${ANDROID_HOME}/tools:${ANDROID_HOME}/tools/bin:${ANDROID_HOME}/platform-tools

RUN yum install -y java-1.8.0-openjdk-devel && \
    yum -y groupinstall 'Development Tools' && \
    yum clean all && \
    wget https://dl.google.com/android/repository/sdk-tools-linux-${ANDROID_VERSION}.zip && \
    unzip sdk-tools-linux-${ANDROID_VERSION}.zip -d android-sdk-linux && \
    rm sdk-tools-linux-${ANDROID_VERSION}.zip && mv android-sdk-linux /opt/ && \
    yes | sdkmanager --licenses && \
    sdkmanager "platform-tools" && \
    yes | sdkmanager \
    "platforms;android-28" \
    "build-tools;28.0.0"

ENV GRADLE_HOME /opt/gradle
ENV GRADLE_VERSION 4.6

ARG GRADLE_DOWNLOAD_SHA256=98bd5fd2b30e070517e03c51cbb32beee3e2ee1a84003a5a5d748996d4b1b915
RUN set -o errexit -o nounset \
	&& echo "Downloading Gradle" \
	&& wget -O gradle.zip "https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip" \
	\
	&& echo "Checking download hash" \
	&& echo "${GRADLE_DOWNLOAD_SHA256} *gradle.zip" | sha256sum -c - \
	\
	&& echo "Installing Gradle" \
	&& unzip gradle.zip \
	&& rm gradle.zip \
	&& mkdir -p /opt \
	&& mv "gradle-${GRADLE_VERSION}" "${GRADLE_HOME}/" \
	&& ln -s "${GRADLE_HOME}/bin/gradle" /usr/bin/gradle

# jx
ENV JX_VERSION 2.0.984
RUN curl -f -L https://github.com/jenkins-x/jx/releases/download/v${JX_VERSION}/jx-linux-amd64.tar.gz | tar xzv && \
  mv jx /usr/bin/

RUN gradle --version
