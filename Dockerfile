FROM debian:11

RUN apt-get -y update && \
    apt-get -y install tmux vim git curl gfortran bison flex \
               environment-modules zlib* zsh xz-utils python3 \
               python3-dev python3-pip build-essential cmake hdf5-tools \
               libhdf5-dev openmpi-common libopenmpi-dev

# Install Spack
# Setting this parameter so I don't have to create an unprivileged user
ENV FORCE_UNSAFE_CONFIGURE=1
RUN git clone https://github.com/spack/spack && \
    . spack/share/spack/setup-env.sh && \
    spack compilers

RUN mkdir /spack-env
COPY spack.yaml /spack-env/
# Set up spack environment and install it (see https://spack.readthedocs.io/en/latest/containers.html)
RUN cd /spack-env && \
    . /spack/share/spack/setup-env.sh && \
    spack env activate . && \
    spack install && \
    spack env activate --sh -d . > /etc/profile.d/spack_env.sh

RUN git clone https://github.com/jtronge/Example-Heat_Transfer.git && \
    cd Example-Heat_Transfer && \
    . ./setup-env.sh && \
    make clean && \
    make && \
    make -C stage_write clean && \
    make -C stage_write
