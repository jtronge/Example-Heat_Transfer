FROM debian:11

RUN apt-get -y update && \
    apt-get -y install tmux vim git curl gfortran bison flex \
               environment-modules zlib* zsh xz-utils python3 \
               python3-dev python3-pip build-essential cmake hdf5-tools \
               libhdf5-dev openmpi-common libopenmpi-dev

# Install Spack
# Setting this parameter so I don't have to create an unprivileged user
ENV FORCE_UNSAFE_CONFIGURE=1
# RUN git clone https://github.com/CODARcode/spack && \
RUN git clone https://github.com/spack/spack && \
    . spack/share/spack/setup-env.sh && \
    spack compilers

# Install ADIOS with pmix-enabled openmpi and fortran
RUN . spack/share/spack/setup-env.sh && \
    spack install adios+fortran ^openmpi+pmix schedulers=slurm

# Install extras
RUN . spack/share/spack/setup-env.sh && \
    spack install stc turbine mpich dataspaces

# Copy over a script for setting up the environment
COPY setup-env.sh /

# Now try to run the program
# Now copy over everything and install the program
RUN mkdir /heat-transfer
COPY ./* /heat-transfer/*
RUN cd /heat-transfer && \
    . ./setup-env.sh && \
    make clean && \
    make && \
    make -C stage_write clean && \
    make -C stage_write

RUN . /setup-env.sh && \
    git clone https://github.com/CODARcode/Example-Heat_Transfer.git && \
    cd Example-Heat_Transfer && \
    sed -i -e 's/CC=cc/CC=mpicc/g' Makefile stage_write/Makefile && \
    sed -i -e 's/FC=ftn/FC=mpif90/g' Makefile stage_write/Makefile && \
    sed -i -e 's/use adios_write_mod//g' *.F90 && \
    sed -i -e 's/^FFLAGS.*$/FFLAGS=-g -O3 -Wall -fcheck=bounds -fallow-argument-mismatch/g' Makefile && \
    make && \
    cd stage_write && \
    make

# Copy over the workflow files
# COPY workflow/heat_transfer_adios2.sh /
# COPY workflow/stage_write.sh /
# COPY heat_transfer.xml /Example-Heat_Transfer/

#RUN apt-get -y update && \
#    apt-get -y install tmux vim

## spack install adios+fortran ^openmpi+pmix schedulers=slurm
