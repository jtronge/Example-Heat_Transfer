#!/bin/sh
# Set up the environment for the heat_transfer_adios2 binary and execute it with passed parameters.

HTPROC_X=4
HTPROC_Y=3
HTPROC=`expr $HTPROC_X \* $HTPROC_Y`
. /spack/share/spack/setup-env.sh
spack load adios
cd /Example-Heat_Transfer
# mpirun --allow-run-as-root --oversubscribe -n $HTPROC ./heat_transfer_adios2 $@
mpirun --allow-run-as-root --oversubscribe -n $HTPROC ./heat_transfer_adios2 /tmp/heat $HTPROC_X $HTPROC_Y 40 50 6 500
