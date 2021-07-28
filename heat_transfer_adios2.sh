#!/bin/sh
# Set up the environment for the heat_transfer_adios2 binary and execute it with passed parameters.

HTPROC=`expr $2 \* $3`
. /spack/share/spack/setup-env.sh
spack load adios
cd /Example-Heat_Transfer
mpirun --allow-run-as-root --oversubscribe -n $HTPROC ./heat_transfer_adios2 $@
