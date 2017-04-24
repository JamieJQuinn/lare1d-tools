#!/usr/bin/env bash
start_script=start-lare3d.sh

# Number of nodes
echo "N_NODES: $(grep -oP 'mpi-verbose \K([0-9]*)' $start_script)"
# Runtime
echo "RUNTIME: $(grep -oP 'h_rt=\K(.*)' $start_script)"

# Build state
echo "Build state:"
cat build_state
