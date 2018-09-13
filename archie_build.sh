#!/usr/bin/env bash

set -e

for folder in "$@"
do
  cd $folder
  if [[ $folder =~ "-isotropic" ]]; then
    ~/lare3d/tools/build.sh -m archie
  elif [[ $folder =~ "-switching" ]]; then
    ~/lare3d/tools/build.sh -os -m archie
  else
    echo "No option for input folder"
  fi
  cd ..
done
