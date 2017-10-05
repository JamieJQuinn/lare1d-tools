#!/usr/bin/env bash
machine=''
mpi_opts=''
n_proc_arg=''
output_dir=''
lare_dir='.'
skip_checks="false"

while getopts "n:m:o:i:y" flag; do
  case "${flag}" in
    # Set number of processes to launch
    n) n_proc_arg="${OPTARG}" ;;
    # Set machine
    m) machine="${OPTARG}" ;;
    # Output directory
    o) output_dir="${OPTARG}" ;;
    # lare3d folder location
    i) lare_dir="${OPTARG}" ;;
    # skip checks
    y) skip_checks="true" ;;
  esac
done

n_proc=''
if [ "$machine" == "euclid" ]; then
  export PATH=/home/pgrad2/1101974q/prog/openmpi-euclid/open-mpi-build/bin:$PATH
  export LD_LIBRARY_PATH=/home/pgrad2/1101974q/prog/openmpi-euclid/open-mpi-build/lib:$LD_LIBRARY_PATH
  mpi_opts+='--mca pml ob1'
  n_proc=$(($(nproc)/2))
elif [ "$machine" == "euclid-torque" ]; then
  export PATH=/home/pgrad2/1101974q/prog/openmpi-euclid/open-mpi-build/bin:$PATH
  export LD_LIBRARY_PATH=/home/pgrad2/1101974q/prog/openmpi-euclid/open-mpi-build/lib:$LD_LIBRARY_PATH
  mpi_opts+="--mca btl_tcp_if_exclude virbr0,lo"
elif [ "$machine" == "office" ]; then
  n_proc=4
fi

if [ "$n_proc_arg" != '' ]; then
  n_proc=$n_proc_arg
fi

if [ "$n_proc" == '' ]; then
  echo "No processor number provided"
  exit
fi

data_dir=$(sed -n "s/data_dir = '\(.*\)'/\1/p" $lare_dir/bin/build_state)

if [ "$skip_checks" == "false" ]; then
  echo "Are you inside the lare folder?"
  read answer
  if [ "$answer" != "y" ]; then
    echo "Answer not 'y'. Exiting."
    exit -1
  fi
fi

mkdir -p Data
exe="mpirun -np $n_proc $mpi_opts bin/lare3d"

time $exe
