#!/bin/bash

source ./config.sh

sample_id=""

input_fastq_1="${input_data_dir}/H7YWLCCXX-3_S0_L003_R1_001.fastq.gz"
input_fastq_2="${input_data_dir}/H7YWLCCXX-3_S0_L003_R2_001.fastq.gz"

$trimgalore \
    --cores 4 \
    --paired \
    --fastqc \
    --gzip \
    ${input_fastq_1} ${input_fastq_2}
