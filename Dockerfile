FROM debian:10

RUN apt-get -y update && \
    apt-get -y install git && \
    apt-get -y install curl && \
    apt-get -y install gfortran && \
    apt-get -y install bison && \
    apt-get -y install flex && \
    apt-get -y install environment-modules && \
    apt-get -y install zlib* && \
    apt-get -y install zsh && \
    apt-get -y install xz-utils && \
    apt-get -y install python3 && \
    apt-get -y install python3-dev && \
    apt-get -y install python3-pip && \
    apt-get -y install build-essential && \
    apt-get -y install cmake && \
    apt-get -y install hdf5-tools && \
    apt-get -y install libhdf5-dev && \
    apt-get -y install openmpi-common && \
    apt-get -y install libopenmpi-dev

# Install Spack
# Setting this parameter so I don't have to create an unprivileged user
ENV FORCE_UNSAFE_CONFIGURE=1
# RUN git clone https://github.com/CODARcode/spack && \
RUN git clone https://github.com/spack/spack && \
    . spack/share/spack/setup-env.sh && \
    spack compilers

# Install ADIOS
RUN . spack/share/spack/setup-env.sh && \
    spack install adios +fortran

# Install extras
RUN . spack/share/spack/setup-env.sh && \
    spack install stc turbine mpich dataspaces

# Copy over a script for setting up the environment
COPY setup-env.sh /

# Now try to run the program
RUN . /setup-env.sh && \
    git clone https://github.com/CODARcode/Example-Heat_Transfer.git && \
    cd Example-Heat_Transfer && \
    sed -i -e 's/CC=cc/CC=mpicc/g' Makefile stage_write/Makefile && \
    sed -i -e 's/FC=ftn/FC=mpif90/g' Makefile stage_write/Makefile && \
    # sed -i -e 's/adios_config -l -f/adios_config -l/g' Makefile && \
    sed -i -e 's/use adios_write_mod//g' *.F90 && \
    # sed -i -e 's/include "mpi.h"/include <mpi.h>/g' */*.c && \
    make && \
    cd stage_write && \
    make

COPY heat_transfer_adios2.sh /
COPY stage_write.sh /
COPY heat_transfer.xml /Example-Heat_Transfer/

# TODO: Create a launch script for each binary
