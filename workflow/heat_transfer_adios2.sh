#!/bin/sh
# Set up the environment for the heat_transfer_adios2 binary and execute it with passed parameters.

HTPROC_X=4
HTPROC_Y=3
HTPROC=`expr $HTPROC_X \* $HTPROC_Y`
. /spack/share/spack/setup-env.sh
spack load adios
cd /Example-Heat_Transfer
# mpirun --allow-run-as-root --oversubscribe -n $HTPROC ./heat_transfer_adios2 $@
# mpirun --allow-run-as-root --oversubscribe -n $HTPROC ./heat_transfer_adios2 /tmp/heat $HTPROC_X $HTPROC_Y 40 50 6 500

OUTPUT_PREFIX=$1
HTPROC_X=$2
HTPROC_Y=$3
# Local array x and y dimensions
ADIM_X=$4
ADIM_Y=$5
# Number of steps
STEPS=$6
# Result for varying results
RESULT_VAR=$7
# exec ./heat_transfer_adios2 $OUTPUT_PREFIX $HTPROC_X $HTPROC_Y 40 50 6 500
exec ./heat_transfer_adios2 $OUTPUT_PREFIX $HTPROC_X $HTPROC_Y \
	$ADIM_X $ADIM_Y $STEPS $RESULT_VAR
