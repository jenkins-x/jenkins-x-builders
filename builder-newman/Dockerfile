FROM jenkinsxio/builder-base:0.0.0-SNAPSHOT-PR-183-12

RUN curl -f --silent --location https://rpm.nodesource.com/setup_9.x | bash - && \
  yum install -y nodejs && \
  yum clean all

RUN npm install -g newman

CMD ["newman", "--version"]
