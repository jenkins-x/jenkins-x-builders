FROM jenkinsxio/builder-base:1

CMD ["gradle"]

ENV GRADLE_HOME /opt/gradle
ENV GRADLE_VERSION 4.6
ARG GRADLE_DOWNLOAD_SHA256=98bd5fd2b30e070517e03c51cbb32beee3e2ee1a84003a5a5d748996d4b1b915
RUN wget -O gradle.zip "https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip"

RUN echo "${GRADLE_DOWNLOAD_SHA256} *gradle.zip" | sha256sum -c - \
	&& unzip gradle.zip \
	&& rm gradle.zip \
	&& mkdir -p /opt \
	&& mv "gradle-${GRADLE_VERSION}" "${GRADLE_HOME}/" \
	&& ln -s "${GRADLE_HOME}/bin/gradle" /usr/bin/gradle

ENV ANDROID_VERSION 4333796
ENV ANDROID_HOME /opt/android-sdk-linux
RUN wget https://dl.google.com/android/repository/sdk-tools-linux-${ANDROID_VERSION}.zip
RUN unzip sdk-tools-linux-${ANDROID_VERSION}.zip -d android-sdk-linux
RUN mv android-sdk-linux /opt/
ENV PATH ${PATH}:${ANDROID_HOME}/tools:${ANDROID_HOME}/tools/bin:${ANDROID_HOME}/platform-tools
RUN yes | sdkmanager --licenses
RUN sdkmanager "platform-tools"
RUN yes | sdkmanager \
    "platforms;android-28" \
    "build-tools;28.0.0"
	
RUN gradle --version
