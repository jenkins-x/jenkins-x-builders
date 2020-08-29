FROM gcr.io/jenkinsxio/builder-base:0.0.83

RUN curl -f --silent --location https://rpm.nodesource.com/setup_10.x | bash - && \
  yum install -y nodejs && \
  yum clean all

RUN npm install -g newman

# jx
ENV JX_VERSION 2.1.138
RUN curl -f -L https://github.com/jenkins-x/jx/releases/download/v${JX_VERSION}/jx-linux-amd64.tar.gz | tar xzv && \
  mv jx /usr/bin/

CMD ["newman", "--version"]
