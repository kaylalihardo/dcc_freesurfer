#!/bin/bash

data_dir=/hpc/group/labarlab/Teach_DCC/rawdata
work_dir=/work/$(whoami)/dcc_practice
log_dir=${work_dir}/logs

time=$(date '+%Y%m%d_%H%M')
out_dir=${log_dir}/freesurfer_$time
mkdir -p $out_dir

subj=sub-ER0009
sbatch \
    -o ${out_dir}/out_${subj#*-}.txt \
    -e ${out_dir}/err_${subj#*-}.txt \
    fs_job.sh $subj $data_dir $work_dir
