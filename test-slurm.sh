#!/bin/bash
#SBATCH -n 16

# source $MODULESHOME/init/bash

# NOTE: as of 10/26/17, this adios does not support SZ
# module load adios/1.12.0 flexpath/1.12

# If using spack, uncomment this and comment out the module load
# spack load adios sz flexpath

# cd "$PBS_O_WORKDIR"
. ~/spack/share/spack/setup-env.sh
# spack load adios

cat > /tmp/task0.sh <<EOF
#!/bin/bash
spack load adios+fortran ^openmpi+pmix schedulers=slurm
./heat_transfer_adios2 heat  4 3  40 50  6 500 &
EOF
chmod 750 /tmp/task0.sh
cat > /tmp/task1.sh <<EOF
#!/bin/bash
spack load adios+fortran ^openmpi+pmix schedulers=slurm
./stage_write/stage_write heat.bp staged.bp FLEXPATH "" MPI ""
EOF
chmod 750 /tmp/task1.sh

srun -n 12 --mpi=pmix /tmp/task0.sh &
srun -n 2 --mpi=pmix /tmp/task1.sh
#srun -n 12 --mpi=pmix ./heat_transfer_adios2 heat  4 3  40 50  6 500 &
#srun -n 2 --mpi=pmix ./stage_write/stage_write heat.bp staged.bp FLEXPATH "" MPI ""
