#!/bin/bash

# Set variables for this project
export SSS_HOME=$PWD
export SSS_VOL_DIR="/volatile/clas12/users/$USER/rga_string_spinner_simulation" #NOTE: CHANGE AS NEEDED.

# Set variables for rgh_simulation
export SSS_C12_CONFIG_HOME="/work/clas12/users/$USER/clas12-config" #NOTE: CHANGE AS NEEDED. This is a path to your local repo of: https://github.com/mfmceneaney/rgh_simulation for gcard and service yaml files for `gemc` and `recon-util`.

# Set gcard and yaml files for simulation
export SSS_GCARD_RGA_GEMC="$C12_CONFIG_HOME/gemc/5.10/rga_fall2018.gcard" #NOTE: CHANGE AS NEEDED.
export SSS_YAML_RGA_COAT="$C12_CONFIG_HOME/coatjava/11.1.0/rga_fall2018.yaml" #NOTE: CHANGE AS NEEDED.

# Set variables for string spinner simulation
export SSS_ROOT_FILES_DIR="$SSS_VOL_DIR/root_files/mc_rga" #NOTE: CHANGE AS NEEDED.
export SSS_TREE="tree" #NOTE: CHANGE AS NEEDED.
export SSS_NEVENTS=10000000 # Number of events in each file #NOTE: CHANGE AS NEEDED.
export SSS_NMAX=10000 # Maximum number of events allowed in each output lund file
export SSS_NFILES=$(( ($SSS_NEVENTS + $SSS_NMAX - 1) / $SSS_NMAX )) # Calculate number of files needed

# Set beam energies and target lund pids for CLAS12-Analysis #NOTE: CHANGE AS NEEDED
export SSS_BEAM_ENERGY_RGA=10.6 #NOTE: CHANGE AS NEEDED.
export SSS_TPID_RGA=2212 #NOTE: CHANGE AS NEEDED.

# Set project HIPO data paths for CLAS12-Analysis #NOTE: CHANGE AS NEEDED
export SSS_JOBS_SIM_MC_RGA="$SSS_VOL_DIR/jobs/simulation/mc_rga/dst"
export SSS_JOBS_C12A_MC_RGA="$SSS_VOL_DIR/jobs/c12analysis/mc_rga"
