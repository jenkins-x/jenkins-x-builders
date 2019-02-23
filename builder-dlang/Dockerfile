FROM jenkinsxio/builder-base:0.1.249

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

CMD ["dmd"]
