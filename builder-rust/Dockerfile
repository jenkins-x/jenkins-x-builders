FROM gcr.io/jenkinsxio/builder-base:0.0.71

ENV PATH=$PATH:/root/.cargo/bin

RUN yum install -y gcc && yum clean all

RUN wget https://static.rust-lang.org/rustup/dist/x86_64-unknown-linux-gnu/rustup-init && \
  chmod +x rustup-init && \
  ./rustup-init -y && \
  rm -rf rustup-init && \
  rustup override set nightly

# jx
ENV JX_VERSION 2.0.987
RUN curl -f -L https://github.com/jenkins-x/jx/releases/download/v${JX_VERSION}/jx-linux-amd64.tar.gz | tar xzv && \
  mv jx /usr/bin/
