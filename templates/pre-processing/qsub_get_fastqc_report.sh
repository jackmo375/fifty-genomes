#!/bin/bash
#PBS -l select=1:ncpus=1:mpiprocs=1
#PBS -P CBBI1243
#PBS -N fastqc
#PBS -q serial
#PBS -l walltime=2:00:00
#PBS -o /mnt/lustre/users/jmorrice/projects/fifty-genomes/reports/qsub/fastqc.out
#PBS -e /mnt/lustre/users/jmorrice/projects/fifty-genomes/reports/qsub/fastqc.err
#PBS -m abe
#PBS -M jackmo375@gmail.com

cd /mnt/lustre/users/jmorrice/projects/fifty-genomes
./templates/pre-processing/get_fastqc_report.sh || { exit 1; }
