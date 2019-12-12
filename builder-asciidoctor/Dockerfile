FROM gcr.io/jenkinsxio/builder-base:0.0.75

# asciidoctor

RUN yum -y update \
    && yum install -y asciidoctor \
    && yum clean all

CMD ["asciidoctor", "--version"]
