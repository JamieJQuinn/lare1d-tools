#!/usr/bin/env bash
machine=''
mpi_opts=''
n_proc_arg=''
output_dir=''
lare_dir='.'
clean=false
exe='mpirun -np $n_proc $mpi_opts lare3d'

while getopts "n:m:o:i:" flag; do
  case "${flag}" in
    # Set number of processes to launch
    n) n_proc_arg="${OPTARG}" ;;
    # Set machine
    m) machine="${OPTARG}" ;;
    # Output directory
    o) output_dir="${OPTARG}" ;;
    # lare3d folder location
    i) lare_dir="${OPTARG}" ;;
  esac
done

n_proc=''
if [ "$machine" == "euclid" ]; then
  export PATH=/home/pgrad2/1101974q/prog/openmpi-euclid/open-mpi-build/bin:$PATH
  export LD_LIBRARY_PATH=/home/pgrad2/1101974q/prog/openmpi-euclid/open-mpi-build/lib:$LD_LIBRARY_PATH
  mpi_opts+='--mca pml ob1'
elif [ "$machine" == "euclid-torque" ]; then
  export PATH=/home/pgrad2/1101974q/prog/openmpi-euclid/open-mpi-build/bin:$PATH
  export LD_LIBRARY_PATH=/home/pgrad2/1101974q/prog/openmpi-euclid/open-mpi-build/lib:$LD_LIBRARY_PATH
  #mpi_opts+="--mca btl_base_verbose 30 --mca btl_tcp_if_exclude virbr0,lo"
  mpi_opts+="--mca btl_tcp_if_exclude virbr0,lo"
elif [ "$machine" == "euclid-torque-intel" ]; then
  . /opt/intel/compilers_and_libraries/linux/mpi/intel64/bin/mpivars.sh
  n_proc=0 # Just need to define variable
  exe='mpirun ./lare3d'
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

if [ "$data_dir" == '' ] || [ "$output_dir" == '' ]; then
  echo "No output dir or data dir supplied"
  exit
fi

# Run
if [ "$output_dir" != '' ]; then
  mkdir -p $output_dir/$data_dir
  cp $lare_dir/bin/* $output_dir
  cd $output_dir
  time eval $exe
  if [ "$data_dir" != '.' ]; then
    mv $data_dir/* $output_dir
    rmdir $data_dir
  fi
else
  echo "No output directory given"
fi
