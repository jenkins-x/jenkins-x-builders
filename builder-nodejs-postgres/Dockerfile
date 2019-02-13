FROM jenkinsxio/builder-base:0.1.232

COPY ./pg-init.sh /

RUN curl -f --silent --location https://rpm.nodesource.com/setup_10.x | bash - && \
  yum install -y nodejs gcc-c++ make bzip2 GConf2 gtk2 chromedriver chromium xorg-x11-server-Xvfb sudo

# Yarn
ENV YARN_VERSION 1.3.2
RUN curl -f -L -o /tmp/yarn.tgz https://github.com/yarnpkg/yarn/releases/download/v${YARN_VERSION}/yarn-v${YARN_VERSION}.tar.gz && \	
	tar xf /tmp/yarn.tgz && \
	mv yarn-v${YARN_VERSION} /opt/yarn && \
	ln -s /opt/yarn/bin/yarn /usr/local/bin/yarn

ENV PGDATA /var/lib/pgsql/10/data/

# Install Postgres 9.6
RUN rpm -Uvh https://download.postgresql.org/pub/repos/yum/10/redhat/rhel-7-x86_64/pgdg-centos10-10-2.noarch.rpm && \
    yum install -y postgresql10-server postgresql10

