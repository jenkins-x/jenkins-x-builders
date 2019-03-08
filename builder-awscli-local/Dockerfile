FROM gcr.io/jenkinsxio/builder-python37:1

RUN easy_install-3.7 pip

RUN pip install --upgrade pip
RUN pip install --upgrade awscli-local

CMD ["awslocal", "--version"]
