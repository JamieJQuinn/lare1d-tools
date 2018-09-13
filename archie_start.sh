#!/usr/bin/env bash

set -e

for folder in "$@"
do
  cd $folder
  cp ~/lare3d/tools/start-lare3d.sh .
  qsub -N $folder start-lare3d.sh
  cd ..
done
