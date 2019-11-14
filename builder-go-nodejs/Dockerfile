# jx
RUN yum install -y gcc-c++ make bzip2 GConf2 gtk2 chromedriver chromium xorg-x11-server-Xvfb && \
	curl -f --silent --location https://rpm.nodesource.com/setup_11.x | bash -  && \
	yum install -y nodejs  && \
	yum clean all
RUN npm i -g watch-cli vsce typescript aws-cdk

# Yarn
ENV YARN_VERSION 1.3.2
RUN curl -f -L -o /tmp/yarn.tgz https://github.com/yarnpkg/yarn/releases/download/v${YARN_VERSION}/yarn-v${YARN_VERSION}.tar.gz && \
	tar xf /tmp/yarn.tgz && \
	mv yarn-v${YARN_VERSION} /opt/yarn && \
	ln -s /opt/yarn/bin/yarn /usr/local/bin/yarn

ENV JX_VERSION 2.0.987
RUN curl -f -L https://github.com/jenkins-x/jx/releases/download/v${JX_VERSION}/jx-linux-amd64.tar.gz | tar xzv && \
  mv jx /usr/bin/

CMD ["go","version"]
