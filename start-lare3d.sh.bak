#

export PROCS_ON_EACH_NODE=12

# ************* SGE qsub options ****************
#Export env variables and keep current working directory
#$ -V -cwd
#Specify project
#$ -P mactaggart-aMHD.prj
#Select parallel environment and number of parallel queue slots (nodes)
#$ -pe mpi-verbose 4
#Send to parallel queue
#$ -q parallel-low.q
#Combine STDOUT/STDERR
#$ -j y
#Specify output file
#$ -o out.$JOB_ID
#Request resource reservation (reserve slots on each scheduler run until enough have been gathered to run the job
#$ -R y
#Runtime
#$ -l h_rt=48:00:00
#Mail Options
#$ -m bea
#$ -M j.quinn.1@research.gla.ac.uk

# Add runtime indication
#$ -ac runtime=""
# ************** END SGE qsub options ************

export NCORES=`expr $PROCS_ON_EACH_NODE \* $NSLOTS`
export OMPI_MCA_btl=openib,self

BINARY=bin/lare3d
module load $MPI_LIB_MODULE
mpirun -np $NCORES $BINARY
