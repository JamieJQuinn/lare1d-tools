#!/usr/bin/env python3

import sys
import re

def save_fig(data_fname, fig_fname, varname):
  OpenDatabase("localhost:"+data_fname)

  DeleteAllPlots()

  AddPlot("Pseudocolor", varname, 1, 0)

  AddOperator("Slice", 0)

  DrawPlots()

  swatts = SaveWindowAttributes()
  swatts.family = 0
  swatts.format = swatts.PNG
  swatts.width = 1024
  swatts.height = 1024
  swatts.fileName = fig_fname
  SetSaveWindowAttributes(swatts)

  SaveWindow()

# Get files to generate figs from
with open("filename_list", 'r') as fp:
  filenames = fp.read().split()

variables = [
  "Bmag",
  "Vmag",
  "Fluid/Rho",
  "Fluid/Energy",
]

for filename in filenames:
  for variable in variables:
    # scrape info from filenames
    print filename
    visc_exp, resist_exp, visc_mode = re.search('v-(\d)r-(\d)-(switching|isotropic)/', filename).groups()
    t_step = re.search('/(\d+).sdf', filename).groups()[0]

    # Form output filenames
    if visc_mode == "switching":
      fig_fname = variable.split("/")[-1] + "_v-" + visc_exp + "r-" + resist_exp + "_switching_" + "_" + t_step
    else:
      fig_fname = variable.split("/")[-1] + "_v-" + visc_exp + "r-" + resist_exp + "_isotropic_" + "_" + t_step

    if not os.path.isfile(fig_fname+".png"):
        print("missing " + fig_fname)
        save_fig(filename, fig_fname, variable)


sys.exit()
