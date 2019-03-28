FROM gcr.io/jenkinsxio/builder-rubybase:0.0.14

# jx
ENV JX_VERSION 1.3.1048
RUN curl -f -L https://github.com/jenkins-x/jx/releases/download/v${JX_VERSION}/jx-linux-amd64.tar.gz | tar xzv && \
  mv jx /usr/bin/
