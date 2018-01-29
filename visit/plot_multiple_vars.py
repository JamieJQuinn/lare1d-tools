#!/usr/bin/env python3

import sys
import re

def save_fig(data_fname, fig_fname, varname):
  OpenDatabase("localhost:"+data_fname)

  DeleteAllPlots()

  AddPlot("Pseudocolor", varname, 1, 0)

  AddOperator("Slice", 0)

  SliceAtts = SliceAttributes()
  SliceAtts.originType = SliceAtts.Intercept  # Point, Intercept, Percent, Zone, Node
  SliceAtts.originPoint = (0, 0, 0)
  SliceAtts.originIntercept = 0
  SliceAtts.originPercent = 0
  SliceAtts.originZone = 0
  SliceAtts.originNode = 0
  SliceAtts.normal = (0, 0, 1)
  SliceAtts.axisType = SliceAtts.ZAxis  # XAxis, YAxis, ZAxis, Arbitrary, ThetaPhi
  SliceAtts.upAxis = (0, 1, 0)
  SliceAtts.project2d = 1
  SliceAtts.interactive = 1
  SliceAtts.flip = 0
  SliceAtts.originZoneDomain = 0
  SliceAtts.originNodeDomain = 0
  SliceAtts.meshName = "Grid/Grid"
  SliceAtts.theta = 0
  SliceAtts.phi = 90
  SetOperatorOptions(SliceAtts, 0)

  DrawPlots()

  swatts = SaveWindowAttributes()
  swatts.family = 0
  swatts.format = swatts.PNG
  swatts.width = 2048
  swatts.height = 2048
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
  "Fluid/Anisotropic_Viscous_Heating",
  "Fluid/Isotropic_Viscous_Heating"
]

for filename in filenames:
  for variable in variables:
    # scrape info from filenames
    print filename
    visc_exp, resist_exp, visc_mode = re.search('v-(\d)r-(\d)-(switching|isotropic)/', filename).groups()
    t_step = re.search('/(\d+).sdf', filename).groups()[0]

    # Form output filenames
    if visc_mode == "switching":
      fig_fname = variable.split("/")[-1] + "_v-" + visc_exp + "r-" + resist_exp + "_switching_" + t_step
    else:
      fig_fname = variable.split("/")[-1] + "_v-" + visc_exp + "r-" + resist_exp + "_isotropic_" + t_step

    print fig_fname

    save_fig(filename, fig_fname, variable)

sys.exit()
