#!/bin/bash
cd $SSS_HOME/jobs/c12analysis/mc_rga
i=1
for file in $SSS_JOBS_SIM_MC_RGA/*.hipo;
do
echo "$i > $file"
echo
cp job.sh job$i.sh
cp submit.sh submit$i.sh
sed -i "s;/path/test.hipo;$file;g" job$i.sh
sed -i "s;job.sh;job$i.sh;g" submit$i.sh
sbatch submit$i.sh
((i++))
done
