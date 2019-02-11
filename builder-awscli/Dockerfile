FROM jenkinsxio/builder-go:0.1.232

RUN curl "https://s3.amazonaws.com/aws-cli/awscli-bundle.zip" -o "awscli-bundle.zip" && \
  unzip awscli-bundle.zip && \
	./awscli-bundle/install -b /bin/aws
