FROM jenkinsxio/builder-maven:0.1.216

RUN curl https://download.java.net/java/GA/jdk11/9/GPL/openjdk-11.0.2_linux-x64_bin.tar.gz | tar -xz
RUN mv /home/jenkins/jdk-11.0.2 /usr/java
RUN rm /usr/bin/java /usr/bin/javac
RUN ln -s /usr/java/bin/java /usr/bin/java
RUN ln -s /usr/java/bin/javac /usr/bin/javac
ENV JAVA_HOME /usr/java

CMD ["mvn","-version"]
