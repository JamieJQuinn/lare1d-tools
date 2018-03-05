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
  n_proc=$(($(nproc)/2))
  mpi_opts+="-np $n_proc --mca pml ob1"
elif [ "$machine" == "euclid-torque" ]; then
  export PATH=/home/pgrad2/1101974q/prog/openmpi-euclid/open-mpi-build/bin:$PATH
  export LD_LIBRARY_PATH=/home/pgrad2/1101974q/prog/openmpi-euclid/open-mpi-build/lib:$LD_LIBRARY_PATH
  mpi_opts+="-np $n_proc_arg --mca btl_tcp_if_exclude virbr0,lo"
elif [ "$machine" == "euclid-torque-intel" ]; then
  . /maths/intel/bin/compilervars.sh intel64
  . /opt/intel/compilers_and_libraries/linux/mpi/intel64/bin/mpivars.sh
  mpi_opts+="-n $n_proc_arg -ppn 12 --mca btl_tcp_if_exclude virbr0,lo"
elif [ "$machine" == "office" ]; then
  mpi_opts+="-np 4"
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
exe="mpirun $mpi_opts bin/lare3d"

(time $exe) 2>&1
