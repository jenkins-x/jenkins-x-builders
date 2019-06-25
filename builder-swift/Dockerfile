FROM gcr.io/jenkinsxio/builder-swiftbase:0.0.40

# jx
ENV JX_VERSION 2.0.328
RUN curl -f -L https://github.com/jenkins-x/jx/releases/download/v${JX_VERSION}/jx-linux-amd64.tar.gz | tar xzv && \
  mv jx /usr/bin/
