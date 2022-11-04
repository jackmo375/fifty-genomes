#!/bin/bash

bwamem2="./software/bwa-mem2-2.2.1_x64-linux/bwa-mem2"

fasta="./reference-data/gatk-resource-bundle-hg38/Homo_sapiens_assembly38.fasta"

${bwamem2} index ${fasta}
