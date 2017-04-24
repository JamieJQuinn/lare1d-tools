#!/usr/bin/env bash

# Get directory of script
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}"  )" && pwd  )"

for visc_mode in '-b' '-s' ''; do
  cd ~/lare3d
  grid_points=400
  output_dir=~/lustre-folder/lare3d-runs/null-point-study/$grid_points$visc_mode
  mkdir -p $output_dir
  echo "visc_mode: "$visc_mode

  cd lare3d-code
  make clean
  build_options="-m archie $visc_mode -o -p $grid_points"
  echo "building with: "$build_options
  $DIR/build.sh $build_options

  cd $output_dir
  $DIR/submit-lare3d.sh -y
done
