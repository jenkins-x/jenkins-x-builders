FROM jenkinsxio/builder-maven:0.1.160

RUN curl https://download.java.net/java/ga/jdk11/openjdk-11_linux-x64_bin.tar.gz | tar -xz
RUN mv /home/jenkins/jdk-11 /usr/java
RUN rm /usr/bin/java /usr/bin/javac
RUN ln -s /usr/java/bin/java /usr/bin/java
RUN ln -s /usr/java/bin/javac /usr/bin/javac
ENV JAVA_HOME /usr/java

CMD ["mvn","-version"]
