#FROM ornladios/adios2

#RUN sudo apt-get -y update && \
#    sudo apt-get -y install openmpi-common && \
#    sudo apt-get -y install libopenmpi-dev

#RUN spack env activate adios2 && \
#    git clone https://github.com/CODARcode/Example-Heat_Transfer.git && \
#    cd Example-Heat_Transfer && \
#    sed -i -e 's/CC=cc/CC=mpicc/g' Makefile && \
#    sed -i -e 's/FC=ftn/FC=mpif90/g' Makefile && \
#    make && \
#    cd stage_write && \
#    make

#FROM fedora
#
#RUN dnf -y update && \
#    dnf -y install git && \
#    dnf -y install gcc-gfortran && \
#    dnf -y install bison && \
#    dnf -y install zsh && \
#    dnf -y install flex && \
#    dnf -y install zlib && \
#    dnf -y install patch

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

#RUN . spack/share/spack/setup-env.sh && \
#    spack install adios +fortran

# Copy over a script for setting up the environment
COPY setup-env.sh /

# Now try to run the program
#RUN . spack/share/spack/setup-env.sh && \
#    # spack env activate adios && \
#    spack load stc adios mpich sz dataspaces && \
RUN . /setup-env.sh && \
    git clone https://github.com/CODARcode/Example-Heat_Transfer.git && \
    cd Example-Heat_Transfer && \
    sed -i -e 's/CC=cc/CC=mpicc/g' Makefile && \
    sed -i -e 's/FC=ftn/FC=mpif90/g' Makefile && \
    # sed -i -e 's/adios_config -l -f/adios_config -l/g' Makefile && \
    sed -i -e 's/use adios_write_mod//g' *.F90 && \
    # sed -i -e 's/include "mpi.h"/include <mpi.h>/g' */*.c && \
    make && \
    cd stage_write && \
    make

# Install ADIOS 2 manually
#RUN git clone https://github.com/ornladios/ADIOS2.git ADIOS2 && \
#    mkdir adios2-build && \
#    cd adios2-build && \
#    cmake ../ADIOS2 && \
#    make -j 16 && \
#    make install

# Install Spack
#RUN git clone https://github.com/CODARcode/spack && \
#    . spack/share/spack/setup-env.sh && \
#    spack compilers

# RUN dnf -y install xz gdbm

# Now install Savanna with spack and all required extras
#ENV FORCE_UNSAFE_CONFIGURE=1
#RUN cd spack && \
#    . ./share/spack/setup-env.sh && \
#    spack -k install savanna@develop
    #git checkout -t origin/codar && \
    # spack install savanna@develop # && \
    # spack load stc turbine adios2 mpich sz dataspaces
    # spack load stc turbine adios mpich sz dataspaces

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
