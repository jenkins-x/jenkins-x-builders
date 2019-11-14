FROM gcr.io/jenkinsxio/builder-base:0.0.71

ENV \
    DMD_PATH=/opt/dlang

RUN yum install -y gcc openssl-devel \
    && yum clean all

RUN curl -fsS https://dlang.org/install.sh | bash -s dmd install -p /opt \
    && export DMD_VERSION=$(ls /opt | grep dmd) \
    && mv /opt/${DMD_VERSION} ${DMD_PATH}

ENV \
  PATH=${DMD_PATH}/linux/bin64:${PATH} \
  LD_LIBRARY_PATH=${DMD_PATH}/linux/lib64 \
  LIBRARY_PATH=${DMD_PATH}/linux/lib64 \
  PS1="(dmd}) \\u@\\h:\\w\$"

# jx
ENV JX_VERSION 2.0.984
RUN curl -f -L https://github.com/jenkins-x/jx/releases/download/v${JX_VERSION}/jx-linux-amd64.tar.gz | tar xzv && \
  mv jx /usr/bin/

CMD ["dmd"]