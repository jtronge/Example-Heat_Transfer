#!/bin/sh
#SBATCH -n 20

. ~/spack/share/spack/setup-env.sh
spack load stc turbine
srun -n 20 -- turbine -n 16 workflow.tic
