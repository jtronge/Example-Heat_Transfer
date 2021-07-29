#!/bin/sh
# Test script to run the workflow in a shell

# Data transfer method
RMETHOD=FLEXPATH

# Other variables
HTPROC_X=4
HTPROC_Y=3
HTPROC=`expr $HTPROC_X '*' $HTPROC_Y`
SWPROC=3
DSPROC=1

CONTAINER=jtronge%heat-transfer/

# Launch heat_transfer_adios2
/home/jaket/charliecloud-0.22/bin/ch-run -w $CONTAINER /bin/sh << EOF
. /spack/share/spack/setup-env.sh
spack load adios
cd /Example-Heat_Transfer
mpirun --oversubscribe -n $HTPROC ./heat_transfer_adios2 /tmp/heat $HTPROC_X $HTPROC_Y 40 50 6 500
EOF

/home/jaket/charliecloud-0.22/bin/ch-run -w $CONTAINER /bin/sh << EOF
. /spack/share/spack/setup-env.sh
spack load adios
cd /Example-Heat_Transfer
mpirun -n 3 ./stage_write/stage_write /tmp/heat.bp /tmp/staged.bp BP '' MPI ''
EOF
# TODO: Check exit code
