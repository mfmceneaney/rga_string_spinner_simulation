#!/bin/bash

# Got to job directory
cd $SSS_HOME/jobs/simulation/mc_rga

# Loop files
i=1
for file in $SSS_ROOT_FILES_DIR/*.root;
do
echo "$i > $PWD/submit$i.sh"
echo

# Copy scripts
cp job.sh job$i.sh
cp submit.sh submit$i.sh

# Replace variables
sed -i "s;MCINDEX=0;MCINDEX=$i;g" job$i.sh
sed -i "s;INFILE=\"\$SSS_ROOT_FILES/tree\.root\";INFILE=$file;g" job$i.sh
sed -i "s;job.sh;job$i.sh;g" submit$i.sh

# Submit job
sbatch submit$i.sh
((i++))
done
