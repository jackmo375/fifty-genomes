#!/bin/bash

source ./config.sh

sample_id="SCD109"
input_fastq_1="${input_data_dir}/H7YWLCCXX-3_S0_L003_R1_001.fastq.gz"
input_fastq_2="${input_data_dir}/H7YWLCCXX-3_S0_L003_R2_001.fastq.gz"

reference_fasta="${reference_data_dir}/Homo_sapiens_assembly38.fasta"
run_id="${sample_id}"
CN=""
readGroup="@RG\\tID:${run_id}\\t${CN}PU:${run_id}\\tSM:${sample_id}\\tLB:${sample_id}\\tPL:illumina"

$bwa mem \
    -K 100000000 \
    -R ${readGroup} \
    -t 16 \
    -M ${reference_fasta} \
    ${input_fastq_1} ${input_fastq_2} | \
    samtools sort \
        --threads 16 \
        -m 2G - > ${working_data_dir}/${sample_id}_aligned.bam

$samtools index ${working_data_dir}/${sample_id}_aligned.bam
