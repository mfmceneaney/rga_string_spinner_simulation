# RGA String Spinner Simulations

This is a storage repository for macros and scripts used to create to simulate and process [string spinner] generated events in CLAS12.

# Prerequisites
* Assumedly, you are working on ifarm and can use slurm to submit jobs
* [gemc](https://gemc.jlab.org/gemc/html/index.html) (use `module load gemc` on ifarm)
* [coatjava](https://github.com/JeffersonLab/coatjava) (use `module load coatjava` on ifarm)
* [clas12-config](https://github.com/JeffersonLab/clas12-config.git) (`git clone` this and set the path manually in the environment script)
* [CLAS12-Analysis](https://github.com/mfmceneaney/CLAS12-Analysis.git)

# Installation

Begin by cloning the repository:
```bash
git clone https://github.com/mfmceneaney/string_spinner_simulation.git
```

Set all the paths in the environment script&mdash;[bin/env.sh](bin/env.sh) or [bin/env.csh](bin/env.csh)&mdash;to the appropriate values for you.
In particular, you will need to manually set these variables in the environment script depending on your local installation paths:
`SSS_HOME`, `SSS_VOL_DIR`, `SSS_JOBS_SIM_MC_RGA`, `SSS_JOBS_C12A_MC_RGA`.

After configuring your environment script, add the following to your (bash) startup script:
```bash
# Set up RGA String Spinner Simulation https://github.com/mfmceneaney/string_spinner_simulation.git
pushd /path/to/rga_string_spinner_simulation>> /dev/null
source bin/env.sh
popd >> /dev/null
```

To run the python download scripts you will also need to create a virtual environment and install the dependencies.
```bash
python3 -m venv /path/to/new/venv
source /path/to/new/venv/bin/activate
pip install -r $SSS_HOME/requirements.txt
/path/to/new/venv/bin/playwright install
```

# Overview

First, you must produce simulation HIPO files.
You will need a set of ROOT file containing a tree of ordered, flattened events.
Each entry in the tree should include the following entries:
- `iEvent` : event index \[0,inf\]
- `iPos` : event position index : \[1,inf\]
- `status` : Lund particle status
- `id` : Lund particle PID
- `mother` : mother particle Lund index : \[1,inf\]
- `daughter` : first daughter particle Lund index : \[1,inf\]
- `Px` : x-momentum \[GeV\]
- `Py` : y-momentum \[GeV\]
- `Pz` : z-momentum \[GeV\]
- `E` : energy \[GeV\]

Note that the mass will be set automatically using energy conservation, and the charge will also be set automatically based on the PID.

:red_circle: The first three entries (`iPos`$\in[1,2,3,4]$) of each event should be the incoming electron, the target proton, the virtual photon, and the outgoing electron.

The Lund particle status of the first three will be set to `21` so that they are not considered by gemc, while the remaining particles, including the scattered electron, will be assumed to all be final state particles.  Hence, their Lund particle status will be set to `1`.

To download individual ROOT files containing the String Spinner events, run:
```bash
$SSS_HOME/bin/download_root_file.sh <DONWLOAD_URL> <FILENAME>
```

To download a set of ROOT files from a regular expression and cernbox url use the python script instead, assuming your python virtual environment is active.  To see the usage, run:
```bash
python3 $SSS_HOME/py/cernbox_downloader.py --help
```

Put all the downloaded files in a convenient directory, e.g., `$SSS_VOL_DIR/root_files/mc_rga`, and make `$SSS_ROOT_FILES_DIR` point to this in the environment script.

Then, run the simulation jobs.
```bash
cd $SSS_HOME/jobs/simulation/mc_rga
touch jobs.txt
./setup.sh >> jobs.txt
cd -
```
These may take a while.

Once the simulation jobs have finished, you must submit jobs to produce channel-specific event-level ROOT files with CLAS12-Analysis.
```bash
$SSS_HOME/jobs/c12analysis/mc_rga
touch jobs.txt
./setup.sh >> jobs.txt
cd -
```

Once these jobs finish, the root files will now be accessible in the directory `$SSS_JOBS_C12A_MC_RGA`.

#

Contact: matthew.mceneaney@duke.edu
