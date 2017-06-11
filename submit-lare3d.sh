#!/usr/bin/env bash

lare3d_folder=~/lare3d

# THIS IS TO BE RUN INSIDE THE OUTPUT DATA FOLDER

skip_checks="false"
while getopts "y" flag; do
  case "${flag}" in
    # Skip any checks
    y) skip_checks="true" ;;
  esac
done

if [ "$skip_checks" == "false" ]; then
  $lare3d_folder/check-lare3d-options.sh

  echo "Is this OK?"
  read answer
  if [ "$answer" != "y" ]; then
    echo "Exiting"
    exit -1
  fi

  echo "Are you inside the output folder? "
  read answer
  if [ "$answer" != "y" ]; then
    echo "Exiting"
    exit -1
  fi
fi

qsub start-lare3d.sh
