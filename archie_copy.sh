#!/usr/bin/env bash

set -e

for n in 3 4
do
  for m in 4
  do
    for visc in '-isotropic' '-switching'
    do
      folder=v-${n}r-$m$visc
      cp -rv ~/lare3d/code $folder
      cd $folder
      sed -i -e 's/\(visc3 = 1.0e-\)[0-9]*/\1'$n'/' src/control.f90
      sed -i -e 's/\(eta_background = 1.0e-\)[0-9]*/\1'$m'/' src/control.f90
      cd ..
    done
  done
done
