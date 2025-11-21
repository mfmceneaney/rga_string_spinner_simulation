#!/bin/bash

# Modify submit scripts with farm out and partition info
for file in $SSS_HOME/jobs/*/*/*submit.sh; do
    sed -i.bak "s;/farm_out/%u;$SSS_FARM_OUT;g" $file
    sed -i.bak "s;partition=production;partition=$SSS_HPC_PARTITION;g" $file
    if [ -z "$SSS_HPC_ACCOUNT" ]; then
        sed -i.bak "s;#SBATCH --account=;##SBATCH --account=;g" $file
    else
        sed -i.bak "s;#SBATCH --account=.*;#SBATCH --account=$SSS_HPC_ACCOUNT;" $file
    fi
done

# Create output directories
mkdir -p $SSS_FARM_OUT
mkdir -p $SSS_VOL_DIR