FROM gcr.io/jenkinsxio/builder-base:0.0.71

RUN yum install -y python python-libs python-devel python-pip && yum clean all

# jx
ENV JX_VERSION 2.0.987
RUN curl -f -L https://github.com/jenkins-x/jx/releases/download/v${JX_VERSION}/jx-linux-amd64.tar.gz | tar xzv && \
  mv jx /usr/bin/

CMD ["python", "--version"]