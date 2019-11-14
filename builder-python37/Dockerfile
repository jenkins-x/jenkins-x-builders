FROM gcr.io/jenkinsxio/builder-base:0.0.71

ENV PYTHONVERSION 3.7.1

RUN yum -y install gcc openssl-devel bzip2-devel libffi-devel && yum clean all

RUN cd /usr/src && \
    wget https://www.python.org/ftp/python/${PYTHONVERSION}/Python-${PYTHONVERSION}.tgz && \
    tar xzf Python-${PYTHONVERSION}.tgz && \
    cd Python-${PYTHONVERSION} && \
    ./configure --enable-optimizations && \
    make altinstall && \
    rm /usr/src/Python-${PYTHONVERSION}.tgz && \
    cd ../ && \
    rm -rf /usr/src/Python-${PYTHONVERSION} && \
    ln -fs /usr/local/bin/python3.7 /usr/bin/python3 && \
    yum -y remove gcc openssl-devel bzip2-devel && \
    yum clean all && \
    easy_install-3.7 pip && \
    pip install --upgrade pip && \
    pip install --upgrade awscli && \
    pip install --upgrade awscli-local


# jx
ENV JX_VERSION 2.0.984
RUN curl -f -L https://github.com/jenkins-x/jx/releases/download/v${JX_VERSION}/jx-linux-amd64.tar.gz | tar xzv && \
  mv jx /usr/bin/

CMD ["python3", "--version"]
