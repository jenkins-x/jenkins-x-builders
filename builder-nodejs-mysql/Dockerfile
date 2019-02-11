FROM jenkinsxio/builder-base:0.1.232

RUN curl -f --silent --location https://rpm.nodesource.com/setup_10.x | bash - && \
  yum install -y nodejs gcc-c++ make bzip2 GConf2 gtk2 chromedriver chromium xorg-x11-server-Xvfb

COPY ./mysql-init.sh /

# Yarn
ENV YARN_VERSION 1.3.2
RUN curl -f -L -o /tmp/yarn.tgz https://github.com/yarnpkg/yarn/releases/download/v${YARN_VERSION}/yarn-v${YARN_VERSION}.tar.gz && \	
	tar xf /tmp/yarn.tgz && \
	mv yarn-v${YARN_VERSION} /opt/yarn && \
	ln -s /opt/yarn/bin/yarn /usr/local/bin/yarn

ENV YUM_REPO_URL="https://dev.mysql.com/get/mysql57-community-release-el7-10.noarch.rpm "

RUN \
	yum -y install epel-release && \
	rpm -ivh ${YUM_REPO_URL} && \
	yum-config-manager --disable mysql55-community && \
	yum-config-manager --disable mysql56-community && \
	yum-config-manager --enable mysql57-community && \
	yum-config-manager --disable mysql80-community && \
	yum clean all
	
RUN yum -y update && yum -y install \
	mysql-community-server