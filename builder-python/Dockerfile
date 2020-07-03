FROM gcr.io/jenkinsxio/builder-base:0.0.83

RUN yum install -y https://repo.ius.io/ius-release-el7.rpm && \
    yum install -y python36u python36u-libs python36u-devel python36u-pip && yum clean all && \
    ln -fs /usr/bin/python3.6 /usr/bin/python3

# jx
ENV JX_VERSION 2.1.97
RUN curl -f -L https://github.com/jenkins-x/jx/releases/download/v${JX_VERSION}/jx-linux-amd64.tar.gz | tar xzv && \
  mv jx /usr/bin/

CMD ["python3", "--version"]
