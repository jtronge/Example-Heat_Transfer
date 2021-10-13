#!/bin/sh
# Set up the environment for compilation

. /spack/share/spack/setup-env.sh
spack load stc turbine adios+fortran ^openmpi+pmix schedulers=slurm
MPI=`spack find -p openmpi | grep openmpi | awk '{ print $2 }'`
export CFLAGS=-I$MPI/include
