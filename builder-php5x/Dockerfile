FROM gcr.io/jenkinsxio/builder-base:0.0.71

RUN yum install -y http://rpms.remirepo.net/enterprise/remi-release-7.rpm && \
  yum install -y yum-utils && \
  yum-config-manager --enable remi-php56 && \
  yum install -y php php-mcrypt php-cli php-gd php-curl php-mysql php-ldap php-zip php-fileinfo && \
  yum clean all

# jx
ENV JX_VERSION 2.0.987
RUN curl -f -L https://github.com/jenkins-x/jx/releases/download/v${JX_VERSION}/jx-linux-amd64.tar.gz | tar xzv && \
  mv jx /usr/bin/

CMD ["php", "-v"]
