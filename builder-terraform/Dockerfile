ENV TERRAFORM 0.14.2
RUN wget https://releases.hashicorp.com/terraform/${TERRAFORM}/terraform_${TERRAFORM}_linux_amd64.zip && \
  unzip terraform_${TERRAFORM}_linux_amd64.zip && \
  chmod +x terraform && mv terraform /usr/bin/terraform && rm terraform_${TERRAFORM}_linux_amd64.zip

ENV PATH $PATH:/usr/local/

# jx
ENV JX_VERSION 2.1.155
RUN curl -f -L https://github.com/jenkins-x/jx/releases/download/v${JX_VERSION}/jx-linux-amd64.tar.gz | tar xzv && \
  mv jx /usr/bin/

CMD ["go","version"]
