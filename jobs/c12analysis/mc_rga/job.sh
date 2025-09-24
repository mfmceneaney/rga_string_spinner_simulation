#!/bin/bash                                                  

export INFILE='/path/test.hipo'
export OUTDIR="$SSS_VOL_DIR/jobs/c12analysis/mc_rga"
export name=`echo $INFILE | xargs -n 1 basename`
mkdir -p $OUTDIR
cd $OUTDIR

# Get proton pion skim for lambda
$C12ANALYSIS/bin/run.sh $INFILE -ch 2212,-211 -be $SSS_BEAM_ENERGY_RGA -tpid $SSS_TPID_RGA -rn -en -ang -vtx -ik -lk -ma -f -out $OUTDIR/skim_ppim_${name}.root

echo DONE
