#!/bin/bash

source ./config.sh

sample_id="SCD109"
input_bam="${working_data_dir}/${sample_id}_duplicates-marked.bam"

$gatk --java-options -Xmx2g \
    BaseRecalibrator \
    -I ${input_bam} \
    -O ${working_data_dir}/${sample_id}_duplicates-marked.recal.table \
    -R ${reference_fasta} \
    -L ${intervals} \
    ${variant_databases[@]/#/--known-sites } \
    --verbosity INFO
