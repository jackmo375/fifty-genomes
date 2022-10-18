#!/bin/bash
#PBS -l select=1:ncpus=18:mpiprocs=1
#PBS -P CBBI1243
#PBS -N bwamem
#PBS -q serial
#PBS -l walltime=10:00:00
#PBS -o /mnt/lustre/users/jmorrice/projects/fifty-genomes/reports/qsub/bwamem.out
#PBS -e /mnt/lustre/users/jmorrice/projects/fifty-genomes/reports/qsub/bwamem.err
#PBS -m abe
#PBS -M jackmo375@gmail.com

cd /mnt/lustre/users/jmorrice/projects/fifty-genomes
./templates/pre-processing/align-sample-reads-to-reference.sh || { exit 1; }
