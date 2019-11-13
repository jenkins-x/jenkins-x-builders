FROM gcr.io/jenkinsxio/builder-base:0.0.71

ENV ANACONDAVERSION 3-2019.03
RUN curl -fLo anaconda.sh https://repo.anaconda.com/archive/Anaconda${ANACONDAVERSION}-Linux-x86_64.sh && \
sh ./anaconda.sh -b && \
eval "$(/root/anaconda3/bin/conda shell.bash hook)" && \
conda init && \
conda install -c conda-forge -c pytorch onnx=1.4.1 flake8=3.7.7 hypothesis=4.10.0 pytorch=1.0.1 -y && \
rm anaconda.sh

# Latest Git large file store support
RUN mkdir git-lfs && \
curl "https://api.github.com/repos/git-lfs/git-lfs/releases/latest" | \
    grep '"tag_name":' | \
    sed -E 's/.*"([^"]+)".*/\1/' | \
    xargs -I {} curl -fL 'https://github.com/git-lfs/git-lfs/releases/download/'{}'/git-lfs-linux-amd64-'{}'.tar.gz' | tar xzvC git-lfs && \
git-lfs/install.sh && \
rm -rf git-lfs

# jx
ENV JX_VERSION 2.0.981
RUN curl -f -L https://github.com/jenkins-x/jx/releases/download/v${JX_VERSION}/jx-linux-amd64.tar.gz | tar xzv && \
  mv jx /usr/bin/

RUN cp /root/.bash_profile /etc/profile.d/bash_profile.sh
RUN mkdir -p /usr/src/app

CMD ["conda", "--version"]