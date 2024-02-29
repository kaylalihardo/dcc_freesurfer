#!/bin/bash

#SBATCH --job-name=freesurfer
#SBATCH --time=20:00:00
#SBATCH --mem=16G
#SBATCH -c 8

# Check for args
if [ "$#" -ne 3 ]; then
    echo "Error: fs_job.sh requires 3 positional arguments."
    exit 1
fi

# Capture args
subj=$1
data_dir=$2
work_dir=$3

# Load required software
module load FreeSurfer/7.2.0

# Configure software
export SUBJECTS_DIR=${work_dir}/freesurfer
export FS_LICENSE=/hpc/group/labarlab/research_bin/license.txt
mkdir -p $SUBJECTS_DIR
source ${FREESURFER_HOME}/SetUpFreeSurfer.sh

# Prep freesurfer file structure
subj_work=${SUBJECTS_DIR}/${subj}/mri/orig
mkdir -p $subj_work
mri_convert \
    ${data_dir}/${subj}/ses-day2/anat/${subj}_ses-day2_T1w.nii.gz \
    ${subj_work}/001.mgz

[ ! -f ${subj_work}/001.mgz ] &&
    echo "mri_convert failed" >&2 &&
    exit 1

# Run recon-all
recon-all \
    -subjid $subj \
    -all \
    -sd $SUBJECTS_DIR \
    -parallel \
    -openmp 6
