FROM jenkinsxio/builder-base:0.1.268

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
    rm -rf /usr/src/Python-${PYTHONVERSION}

RUN ln -s /usr/local/bin/python3.7 /usr/bin/python3
RUN yum -y remove gcc openssl-devel bzip2-devel

CMD ["python3", "--version"]
