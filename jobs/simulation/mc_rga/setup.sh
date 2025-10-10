#!/bin/bash

# Got to job directory
cd $SSS_HOME/jobs/simulation/mc_rga

# Loop root files
j=0
for file in $SSS_ROOT_FILES_DIR/*.root;
do
offset=$(($SSS_NFILES * $j))
# Loop number of lund files
i=0
while [ $i -le $SSS_NFILES ];
do
idx=$(($offset + $i))
echo "$idx > $PWD/submit$idx.sh"
echo

# Copy scripts
cp job.sh job$idx.sh
cp submit.sh submit$idx.sh

# Replace variables
sed -i "s;INFILE=\"file.root\";INFILE=$file;g" job$idx.sh
sed -i "s;MCINDEX=0;MCINDEX=$idx;g" job$idx.sh
sed -i "s;job.sh;job$idx.sh;g" submit$idx.sh

# Submit job
sbatch submit$idx.sh
((i++))
done
((j++))
done
