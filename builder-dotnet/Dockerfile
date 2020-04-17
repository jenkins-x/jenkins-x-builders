FROM gcr.io/jenkinsxio/builder-base:0.0.80

RUN rpm -Uvh https://packages.microsoft.com/config/rhel/7/packages-microsoft-prod.rpm \
    && yum -y update \
    && yum -y install dotnet-sdk-3.0 \
    && yum clean all

RUN dotnet new --install "Microsoft.DotNet.Web.ProjectTemplates.2.2"

# jx
ENV JX_VERSION 2.0.1286
RUN curl -f -L https://github.com/jenkins-x/jx/releases/download/v${JX_VERSION}/jx-linux-amd64.tar.gz | tar xzv && \
  mv jx /usr/bin/
