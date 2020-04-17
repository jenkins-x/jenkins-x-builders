FROM gcr.io/jenkinsxio/builder-base:0.0.80

RUN curl -f --silent --location https://rpm.nodesource.com/setup_10.x | bash - && \
    yum install -y nodejs && \
    yum install -y gcc-c++ make bzip2 GConf2 gtk2 chromedriver chromium xorg-x11-server-Xvfb && \
    yum clean all

# added force after a v0.0.35 released of jenkins-x-builders-base-image
RUN npm i -g watch-cli vsce typescript --force

# Yarn
ENV YARN_VERSION 1.3.2
RUN curl -f -L -o /tmp/yarn.tgz https://github.com/yarnpkg/yarn/releases/download/v${YARN_VERSION}/yarn-v${YARN_VERSION}.tar.gz && \	
	tar xf /tmp/yarn.tgz && \
	mv yarn-v${YARN_VERSION} /opt/yarn && \
	ln -s /opt/yarn/bin/yarn /usr/local/bin/yarn

# jx
ENV JX_VERSION 2.0.1286
RUN curl -f -L https://github.com/jenkins-x/jx/releases/download/v${JX_VERSION}/jx-linux-amd64.tar.gz | tar xzv && \
  mv jx /usr/bin/
