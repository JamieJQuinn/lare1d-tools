#!/usr/bin/env bash

set -e

# Get directory of script
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}"  )" && pwd  )"

for eta_background in '1.0e-3_num'; do
  for visc_mode in '-b' '-s' ''; do
    cd ~/lare3d
    output_dir=~/lustre-folder/lare3d-runs/kink_instability/high_res/$eta_background$visc_mode
    mkdir -p $output_dir
    echo "visc_mode: "$visc_mode
    echo "eta_background: "$eta_background

    cp -r code/* $output_dir
    cd $output_dir

    sed -i -e 's/\(eta_background = \).*/\1'${eta_background}'/' src/control.f90

    make clean
    build_options="-m archie $visc_mode -o"
    echo "building with: "$build_options
    $DIR/build.sh $build_options

    cp $DIR/start-lare3d.sh .

    qsub start-lare3d.sh
  done
done
