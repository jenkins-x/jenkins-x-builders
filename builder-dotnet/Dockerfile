FROM garethjevans/builder-base:dev_1

RUN rpm -Uvh https://packages.microsoft.com/config/rhel/7/packages-microsoft-prod.rpm \
    && yum update \
    && yum -y install dotnet-sdk-2.1
