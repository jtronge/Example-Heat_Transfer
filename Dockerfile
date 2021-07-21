FROM fedora

RUN dnf -y update && \
    dnf -y install git && \
    dnf -y install gcc-gfortran && \
    dnf -y install bison && \
    dnf -y install zsh && \
    dnf -y install flex && \
    dnf -y install zlib

# Install Spack
RUN git clone https://github.com/CODARcode/spack && \
    . spack/share/spack/setup-env.sh && \
    spack compilers

#RUN apt-get update && \
#    apt-get -y install git && \
#    apt-get -y install curl && \
#    apt-get -y install gfortran && \
#    apt-get -y install bison && \
#    apt-get -y install flex && \
#    apt-get -y install environment-modules && \
#    apt-get -y install zlib* && \
#    apt-get -y install zsh

# TODO: Install Spack and then set up the application code based on the README
