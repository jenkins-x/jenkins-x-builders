FROM jenkinsxio/builder-base:0.1.188

CMD ["gradle"]

ENV GRADLE_HOME /opt/gradle
ENV GRADLE_VERSION 5.1

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


ENV ANDROID_VERSION 4333796
ENV ANDROID_HOME /opt/android-sdk-linux
RUN wget https://dl.google.com/android/repository/sdk-tools-linux-${ANDROID_VERSION}.zip && \
  unzip sdk-tools-linux-${ANDROID_VERSION}.zip -d android-sdk-linux && mv android-sdk-linux /opt/
ENV PATH ${PATH}:${ANDROID_HOME}/tools:${ANDROID_HOME}/tools/bin:${ANDROID_HOME}/platform-tools
RUN yes | sdkmanager --licenses
RUN sdkmanager "platform-tools"
RUN yes | sdkmanager \
    "platforms;android-28" \
    "build-tools;28.0.0"
	
#	&& echo "Adding gradle user and group" \
#	&& addgroup -S -g 1000 gradle \
#	&& adduser -D -S -G gradle -u 1000 -s /bin/ash gradle \
#	&& mkdir /home/gradle/.gradle \
#	&& chown -R gradle:gradle /home/gradle \
#	\
#	&& echo "Symlinking root Gradle cache to gradle Gradle cache" \
#	&& ln -s /home/gradle/.gradle /root/.gradle

# Create Gradle volume
#USER gradle
#VOLUME "/home/gradle/.gradle"
#WORKDIR /home/gradle

#RUN set -o errexit -o nounset \
#	&& echo "Testing Gradle installation" \
#	&& gradle --version
