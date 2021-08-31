#!/bin/sh
# Set up the environment and execute the stage_write binary.

. /spack/share/spack/setup-env.sh
spack load adios
cd /Example-Heat_Transfer
# TODO: Take `-n` parameter option as input on command line
# mpirun --allow-run-as-root -n 3 ./stage_write/stage_write "$@"
mpirun --allow-run-as-root -n 3 ./stage_write/stage_write /tmp/heat.bp /tmp/staged.bp BP '' MPI ''
