#!/bin/bash

#----- DEFAULT VARIABLES -----#

# Set variables for string spinner simulation
export SSS_TREE="tree" #NOTE: CHANGE AS NEEDED.
export SSS_NEVENTS=10000000 # Number of events in each file #NOTE: CHANGE AS NEEDED.
export SSS_NMAX=10000 # Maximum number of events allowed in each output lund file

# Set beam energies and target lund pids for CLAS12-Analysis #NOTE: CHANGE AS NEEDED
export SSS_BEAM_ENERGY_RGA=10.6 #NOTE: CHANGE AS NEEDED.
export SSS_TPID_RGA=2212 #NOTE: CHANGE AS NEEDED.

# Set variables for clas12-config location
export SSS_C12_CONFIG_HOME="/work/clas12/users/$USER/clas12-config"

# Set output directory for slurm job stdout and stderr
export SSS_FARM_OUT="/farm_out/$USER"

# Set directory paths
export SSS_VOL_DIR="/volatile/clas12/users/$USER/rga_string_spinner_simulation" #NOTE: CHANGE AS NEEDED.

# Set image paths
export SSS_GEMC_IMG="gemc_dev-almalinux94/"
export SSS_CCFA_IMG="analysis_latest.sif"
export SSS_C12A_IMG="clas12-analysis.sif"
export SSS_SAGA_IMG="saga.sif"

# Set the HPC partition on which you wish to run
export SSS_HPC_PARTITION="production"
export SSS_HPC_ACCOUNT="clas12"

# Set gemc variables
export SSS_GEMC_VERSION="5.10"
export SSS_COATJAVA_VERSION="11.1.0"

#----- LOAD VARIABLES -----#

# Load and overwrite variables from env.txt
if [ -f env.txt ]; then
    # ignore lines starting with # and blank lines
    export $(grep -v '^#' env.txt | xargs)
fi

#----- STATIC VARIABLES -----#

# Set variables for this project
export SSS_HOME="$PWD"

#----- DEPENDENT VARIABLES -----#

# Set gcard and yaml files for simulation
export SSS_GCARD_RGA_GEMC="$SSS_C12_CONFIG_HOME/gemc/$SSS_GEMC_VERSION/rga_fall2018.gcard"
export SSS_YAML_RGA_COAT="$SSS_C12_CONFIG_HOME/coatjava/$SSS_COATJAVA_VERSION/rga_fall2018.yaml"
export SSS_ROOT_FILES_DIR="$SSS_VOL_DIR/root_files/mc_rga"
export SSS_NFILES=$(( ($SSS_NEVENTS + $SSS_NMAX - 1) / $SSS_NMAX )) # Calculate number of files needed

# Set project HIPO data paths for CLAS12-Analysis
export SSS_JOBS_SIM_MC_RGA="$SSS_VOL_DIR/jobs/simulation/mc_rga/dst"
export SSS_JOBS_C12A_MC_RGA="$SSS_VOL_DIR/jobs/c12analysis/mc_rga"

# Set command for gemc
SSS_GEMC_COMMAND() {
    apptainer exec -B $SSS_VOL_DIR,$SSS_HOME,$SSS_C12_CONFIG_HOME $SSS_GEMC_IMG \
    bash -c "module use /cvmfs/oasis.opensciencegrid.org/jlab/geant4/modules; \
    module load gemc/$SSS_GEMC_VERSION; \
    export GEMC_DATA_DIR=/cvmfs/oasis.opensciencegrid.org/jlab/geant4/almalinux9-gcc11/clas12Tags/$SSS_GEMC_VERSION; \
    gemc $@"
}
export -f SSS_GEMC_COMMAND

# Set variables for clas12 container forge analysis image
SSS_RECON_UTIL_COMMAND() {
    apptainer exec -B $SSS_VOL_DIR,$SSS_HOME,$SSS_C12_CONFIG_HOME $SSS_CCFA_IMG \
    bash -c "/opt/coatjava/bin/recon-util $@"
}
export -f SSS_RECON_UTIL_COMMAND
export SSS_HIPO_UTILS_COMMAND="apptainer exec -B \
$SSS_VOL_DIR,$SSS_HOME,$SSS_C12_CONFIG_HOME $SSS_CCFA_IMG \
bash /opt/coatjava/bin/hipo-utils"

# Set variables for clas12-analysis
export SSS_C12ANALYSIS_COMMAND="apptainer run -B \
$SSS_VOL_DIR,$SSS_HOME $SSS_C12A_IMG"

# Set variables for saga
SSS_SAGA_COMMAND() {
    apptainer exec -B \
    $SSS_VOL_DIR,$SSS_HOME $SSS_SAGA_IMG \
    bash -c "$@"
}
export -f SSS_SAGA_COMMAND
