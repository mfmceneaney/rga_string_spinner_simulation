#!/bin/bash

#SBATCH --job-name=sss_mc_rga
#SBATCH --output=/farm_out/%u/%x-%j-%N.out
#SBATCH --error=/farm_out/%u/%x-%j-%N.err
#SBATCH --partition=production
#SBATCH --account=clas12
#SBATCH -c 1
#SBATCH --mem-per-cpu=2000
#SBATCH --gres=disk:5000
#SBATCH --time=48:00:00

$SSS_HOME/jobs/simulation/mc_rga/job.sh
