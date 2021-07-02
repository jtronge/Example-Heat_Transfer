FROM ubuntu

RUN apt-get -y install git && \
    apt-get -y install curl && \
    apt-get -y install gfortran && \
    apt-get -y install bison && \
    apt-get -y install flex && \
    apt-get -y install environment-modules && \
    apt-get -y install zlib* && \
    apt-get -y install zsh

# TODO: Install Spack and then set up the application code based on the README
