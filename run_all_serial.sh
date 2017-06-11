#!/usr/bin/env bash

# Get directory of script
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}"  )" && pwd  )"
PWD="$(pwd)"

for visc_mode in '-b' '-s' ''; do
  echo "visc_mode: "$visc_mode
  cd $PWD
  make clean
  rm -f Data/*
  build_options="-m euclid $visc_mode -o"
  echo "building with: "$build_options
  $DIR/build.sh $build_options
  run_options="-m euclid -n 12 -o ~/prog/lare3d-data/kink_instability/mid_res/v-3r-4$visc_mode"
  echo "running with: "$run_options
  $DIR/run.sh $run_options
done
