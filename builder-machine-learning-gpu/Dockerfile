FROM gcr.io/jenkinsxio/builder-base:0.0.71

# CUDA 10.0
RUN echo $'[cudarepo]\n\
name=Cuda Repository\n\
baseurl=https://developer.download.nvidia.com/compute/cuda/repos/rhel7/x86_64/\n\
enabled=1\n\
gpgcheck=1\n\
gpgkey=https://developer.download.nvidia.com/compute/cuda/repos/rhel7/x86_64/7fa2af80.pub\n'\
>/etc/yum.repos.d/cuda.repo

RUN yum clean all && \
yum -y install cuda-toolkit-10-0

RUN echo "/usr/local/nvidia/lib" >> /etc/ld.so.conf.d/nvidia.conf && \
    echo "/usr/local/nvidia/lib64" >> /etc/ld.so.conf.d/nvidia.conf

ENV PATH /usr/local/nvidia/bin:/usr/local/cuda/bin:${PATH}
ENV LD_LIBRARY_PATH /usr/local/nvidia/lib:/usr/local/nvidia/lib64

# nvidia-container-runtime
ENV NVIDIA_VISIBLE_DEVICES all
ENV NVIDIA_DRIVER_CAPABILITIES compute,utility
ENV NVIDIA_REQUIRE_CUDA "cuda>=10.0 brand=tesla,driver>=384,driver<385 brand=tesla,driver>=410,driver<411"

# Anaconda
ENV ANACONDAVERSION 3-2019.03
RUN curl -fLo anaconda.sh https://repo.anaconda.com/archive/Anaconda${ANACONDAVERSION}-Linux-x86_64.sh && \
sh ./anaconda.sh -b && \
eval "$(/root/anaconda3/bin/conda shell.bash hook)" && \
conda init && \
conda install -c conda-forge -c pytorch onnx=1.5.0 flake8=3.7.7 hypothesis=4.10.0 pytorch=1.1.0 -y && \
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
ENV JX_VERSION 2.0.987
RUN curl -f -L https://github.com/jenkins-x/jx/releases/download/v${JX_VERSION}/jx-linux-amd64.tar.gz | tar xzv && \
  mv jx /usr/bin/

RUN cp /root/.bash_profile /etc/profile.d/bash_profile.sh
RUN mkdir -p /usr/src/app

# work around circular error
RUN rm /etc/profile.d/bash_profile.sh

CMD ["conda", "--version"]