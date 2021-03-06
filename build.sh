#!/usr/bin/env bash
build_state_file='bin/build_state'
machine=''
n_grid_points='false'
braginskii='false'
switching='false'
output='true'
mode=''
defines=''

while getopts "bsdoli:m:p:" flag; do
  case "${flag}" in
    # Enable braginskii visc
    b) defines+=' -DBRAGINSKII_VISCOSITY' ;;
    # Enable Switching visc
    s) defines+=' -DSWITCHING_VISCOSITY' ;;
    # Output continuous viscous heating
    o) defines+=' -DOUTPUT_CONTINUOUS_VISC_HEATING' ;;
    # Output density change due to limiter
    l) defines+=' -DLIMIT_DENSITY' ;;
    # Enable debug
    d) mode='debug' ;;
    # Set machine
    m) machine="${OPTARG}" ;;
    # Set num grid points
    p) n_grid_points="${OPTARG}" ;;
    # Specify lare3d directory
    i) cd ${OPTARG} ;;
  esac
done

# Sort out machine specific settings
compiler=''
mpif90='mpif90'
if [ "$machine" == "euclid" ]; then
  # GCC
  export PATH=/home/pgrad2/1101974q/prog/gcc-euclid/gcc-6.3.0-build/bin:$PATH
  export LD_LIBRARY_PATH=/home/pgrad2/1101974q/prog/gcc-euclid/gcc-6.3.0-build/lib:$LD_LIBRARY_PATH
  # OPENMPI
  export PATH=/home/pgrad2/1101974q/prog/openmpi-euclid/open-mpi-build/bin:$PATH
  export LD_LIBRARY_PATH=/home/pgrad2/1101974q/prog/openmpi-euclid/open-mpi-build/lib:$LD_LIBRARY_PATH
  compiler='gfortran'
elif [ "$machine" == "euclid-torque" ]; then
  # GCC
  export PATH=/home/pgrad2/1101974q/prog/gcc-euclid/gcc-6.3.0-build/bin:$PATH
  export LD_LIBRARY_PATH=/home/pgrad2/1101974q/prog/gcc-euclid/gcc-6.3.0-build/lib:$LD_LIBRARY_PATH
  # OPENMPI
  export PATH=/home/pgrad2/1101974q/prog/openmpi-euclid/open-mpi-build/bin:$PATH
  export LD_LIBRARY_PATH=/home/pgrad2/1101974q/prog/openmpi-euclid/open-mpi-build/lib:$LD_LIBRARY_PATH
  compiler='gfortran'
elif [ "$machine" == "euclid-torque-intel" ]; then
  . /maths/intel/bin/compilervars.sh intel64
  . /opt/intel/compilers_and_libraries/linux/mpi/intel64/bin/mpivars.sh
  mpif90='mpiifort'
  compiler='intel'
elif [ "$machine" == "archie" ]; then
  module load $MPI_LIB_MODULE
  module load $COMPILER_MODULE
  compiler='gfortran'
elif [ "$machine" != "" ]; then
  compiler='gfortran'
  echo "Machine specified but no special conditions, using gfortran"
else
  compiler='gfortran'
  echo "Error: No machine specified, building with gfortran"
fi

# Replace grid points in control with inputs
if [ "$n_grid_points" != 'false' ]; then
  sed -i -e 's/\(n[xyz]_global = \)[0-9]*/\1'${n_grid_points}'/' src/control.f90
fi

# Clean
make clean

# Build
make MPIF90=$mpif90 COMPILER=$compiler DEFINE="$defines" MODE="$mode"

# Create state file and print some relevant build facts
echo "" > $build_state_file
echo "$defines" >> $build_state_file
echo "$mode" >> $build_state_file
echo "built for $machine" >> $build_state_file
echo "GRID POINTS:" >> $build_state_file
echo "$(grep 'n[xyz]_global' src/control.f90)" >> $build_state_file
echo "$(grep -o 'dt_snapshots = .*' src/control.f90)" >> $build_state_file
echo "$(grep -o 'nsteps = .*' src/control.f90)" >> $build_state_file
echo "$(grep -o 't_end = .*' src/control.f90)" >> $build_state_file
echo "$(grep -o 'data_dir = .*' src/control.f90)" >> $build_state_file
if grep -q 'dump_mask(20)' src/control.f90 ; then
  echo "ISO: YES" >> $build_state_file
fi
if grep -q 'dump_mask(21)' src/control.f90 ; then
  echo "ANISO: YES" >> $build_state_file
fi
echo "$(grep 'dump_mask([0-9]*\:[0-9]*) =' src/control.f90)" >> $build_state_file
