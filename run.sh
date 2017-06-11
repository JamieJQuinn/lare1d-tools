#!/usr/bin/env bash
machine=''
mpi_opts=''
n_proc_arg=''
output_dir=''
clean=false

while getopts "cn:m:o:i:" flag; do
  case "${flag}" in
    # Set number of processes to launch
    n) n_proc_arg="${OPTARG}" ;;
    # Set machine
    m) machine="${OPTARG}" ;;
    # Output directory
    o) output_dir="${OPTARG}" ;;
    # lare3d folder location
    i) cd "${OPTARG}" ;;
    # Don't actually do anything if -c supplied
    c) clean=true ;;
  esac
done

n_proc=''
if [ "$machine" == "euclid" ]; then
  n_proc=15
  mpi_opts+='--mca pml ob1'
elif [ "$machine" == "euclid-torque" ]; then
  export PATH=/home/pgrad2/1101974q/prog/openmpi-euclid/open-mpi-build/bin:$PATH
  export LD_LIBRARY_PATH=/home/pgrad2/1101974q/prog/openmpi-euclid/open-mpi-build/lib:$LD_LIBRARY_PATH
  #mpi_opts+="--mca btl_base_verbose 30 --mca btl_tcp_if_exclude virbr0,lo"
  mpi_opts+="--mca btl_tcp_if_exclude virbr0,lo"
elif [ "$machine" == "office" ]; then
  n_proc=4
fi

if [ "$n_proc_arg" != '' ]; then
  n_proc=$n_proc_arg
fi

# Move binary
cp bin/* Data

# Run
if [ "$clean" = false ]; then
  time mpirun -np $n_proc $mpi_opts Data/lare3d
fi

# Copy data
if [ "$output_dir" != '' ]; then
  mkdir -p $output_dir
  rm $output_dir/*
  cp Data/* $output_dir
fi
