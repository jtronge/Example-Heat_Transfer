#!/bin/sh
# Set up the environment and execute the stage_write binary.

. /spack/share/spack/setup-env.sh
spack load adios
cd /Example-Heat_Transfer
# TODO: Take `-n` parameter option as input on command line
# mpirun --allow-run-as-root -n 3 ./stage_write/stage_write "$@"
# mpirun --allow-run-as-root -n 3 ./stage_write/stage_write /tmp/heat.bp /tmp/staged.bp BP '' MPI ''
# exec ./stage_write/stage_write /tmp/heat.bp /tmp/staged.bp BP '' MPI ''

INFILE=$1
OUTFILE=$2
READ_METHOD=$3
READ_PARAMS=$4
WRITE_METHOD=$5
WRITE_PARAMS=$6

exec ./stage_write/stage_write $INFILE $OUTFILE $READ_METHOD "$READ_PARAMS" \
	$WRITE_METHOD "$WRITE_PARAMS"
