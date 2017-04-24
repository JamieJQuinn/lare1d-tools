#!/usr/bin/env bash

# Get directory of script
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}"  )" && pwd  )"

for visc_mode in '-b' '-s' ''; do
  echo "visc_mode: "$visc_mode
  make clean
  for grid_points in 100 200 300; do
    rm -f Data/*
    build_options="-m office $visc_mode -o -p $grid_points"
    echo "building with: "$build_options
    $DIR/build.sh $build_options
    run_options="-m office -o /maths/scratch/lare3d_runs/null_point_study/$grid_points$visc_mode"
    echo "running with: "$run_options
    $DIR/run.sh $run_options
  done
done
