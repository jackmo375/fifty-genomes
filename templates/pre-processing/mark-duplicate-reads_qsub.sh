#!/bin/bash
#PBS -l select=1:ncpus=4:mpiprocs=1
#PBS -P CBBI1243
#PBS -N markDup
#PBS -q serial
#PBS -l walltime=3:30:00
#PBS -o /mnt/lustre/users/jmorrice/projects/fifty-genomes/reports/qsub/markDup.out
#PBS -e /mnt/lustre/users/jmorrice/projects/fifty-genomes/reports/qsub/markDup.err
#PBS -m abe
#PBS -M jackmo375@gmail.com

cd /mnt/lustre/users/jmorrice/projects/fifty-genomes
./templates/pre-processing/mark-duplicate-reads.sh || { exit 1; }
