#!/bin/tcsh

#----- DEFAULT VARIABLES -----#

# Set variables for string spinner simulation
setenv SSS_TREE "tree" #NOTE: CHANGE AS NEEDED.
setenv SSS_NEVENTS 10000000 # Number of events in each file #NOTE: CHANGE AS NEEDED.
setenv SSS_NMAX 10000 # Maximum number of events allowed in each output lund file

# Set beam energies and target lund pids for CLAS12-Analysis #NOTE: CHANGE AS NEEDED
setenv SSS_BEAM_ENERGY_RGA 10.6 #NOTE: CHANGE AS NEEDED.
setenv SSS_TPID_RGA 2212 #NOTE: CHANGE AS NEEDED.

# Set variables for clas12-config location
setenv SSS_C12_CONFIG_HOME "/work/clas12/users/$USER/clas12-config"

# Set output directory for slurm job stdout and stderr
setenv SSS_FARM_OUT "/farm_out/$USER"

# Set directory paths
setenv SSS_VOL_DIR "/volatile/clas12/users/$USER/rga_string_spinner_simulation" #NOTE: CHANGE AS NEEDED.

# Set image paths
setenv SSS_GEMC_IMG "gemc_dev-almalinux94/"
setenv SSS_CCFA_IMG "analysis_latest.sif"
setenv SSS_C12A_IMG "clas12-analysis.sif"
setenv SSS_SAGA_IMG "saga.sif"

# Set the HPC partition on which you wish to run
setenv SSS_HPC_PARTITION "production"
setenv SSS_HPC_ACCOUNT "clas12"

# Set gemc variables
setenv SSS_GEMC_VERSION "5.10"
setenv SSS_COATJAVA_VERSION "11.1.0"

#----- LOAD VARIABLES -----#

# Load and overwrite variables from env.txt
if (-e env.txt) then
    foreach line (`grep -v '^#' env.txt`)
        set var = `echo $line | cut -d= -f1`
        set val = `echo $line | cut -d= -f2-`
        setenv $var "$val"
    end
endif

#----- STATIC VARIABLES -----#

# Set variables for this project
setenv SSS_HOME "$PWD"

#----- DEPENDENT VARIABLES -----#

# Set gcard and yaml files for simulation
setenv SSS_GCARD_RGA_GEMC "$SSS_C12_CONFIG_HOME/gemc/$SSS_GEMC_VERSION/rga_fall2018.gcard"
setenv SSS_YAML_RGA_COAT "$SSS_C12_CONFIG_HOME/coatjava/$SSS_COATJAVA_VERSION/rga_fall2018.yaml"
setenv SSS_ROOT_FILES_DIR "$SSS_VOL_DIR/root_files/mc_rga"

# Calculate number of files needed: (SSS_NEVENTS + SSS_NMAX - 1) / SSS_NMAX
@ tmp = ( $SSS_NEVENTS + $SSS_NMAX - 1 )
@ SSS_NFILES = $tmp / $SSS_NMAX
setenv SSS_NFILES $SSS_NFILES

# Set project HIPO data paths for CLAS12-Analysis
setenv SSS_JOBS_SIM_MC_RGA "$SSS_VOL_DIR/jobs/simulation/mc_rga/dst"
setenv SSS_JOBS_C12A_MC_RGA "$SSS_VOL_DIR/jobs/c12analysis/mc_rga"

# Define helper commands as aliases that call sh -c to preserve original bash behavior
alias SSS_GEMC_COMMAND 'sh -c "apptainer exec -B \$SSS_VOL_DIR,\$SSS_HOME,\$SSS_C12_CONFIG_HOME \$SSS_GEMC_IMG bash -c \"module use /cvmfs/oasis.opensciencegrid.org/jlab/geant4/modules; module load gemc/\$SSS_GEMC_VERSION; export GEMC_DATA_DIR=/cvmfs/oasis.opensciencegrid.org/jlab/geant4/almalinux9-gcc11/clas12Tags/\$SSS_GEMC_VERSION; gemc \" \!*"'

alias SSS_RECON_UTIL_COMMAND 'sh -c "apptainer exec -B \$SSS_VOL_DIR,\$SSS_HOME,\$SSS_C12_CONFIG_HOME \$SSS_CCFA_IMG bash -c \"/opt/coatjava/bin/recon-util \" \!*"'

alias SSS_HIPO_UTILS_COMMAND 'sh -c "apptainer exec -B \$SSS_VOL_DIR,\$SSS_HOME,\$SSS_C12_CONFIG_HOME \$SSS_CCFA_IMG bash /opt/coatjava/bin/hipo-utils"'

alias SSS_C12ANALYSIS_COMMAND 'sh -c "apptainer run -B \$SSS_VOL_DIR,\$SSS_HOME \$SSS_C12A_IMG"'

alias SSS_SAGA_COMMAND 'sh -c "apptainer exec -B \$SSS_VOL_DIR,\$SSS_HOME \$SSS_SAGA_IMG bash -c \"\!*\""'

