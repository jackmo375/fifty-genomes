#!/bin/bash

source ./config.sh

sample_id="SCD109"

input_bam="${working_data_dir}/${sample_id}_duplicates-marked.bam"
input_recal_table="${working_data_dir}/${sample_id}_duplicates-marked.recal.table"

$gatk --java-options -Xmx2g \
    ApplyBQSR \
    -R ${reference_fasta} \
    --input ${input_bam} \
    --output ${output_data_dir}/${sample_id}_bases-recalibrated.bam \
    -L ${intervals} \
    --bqsr-recal-file ${input_recal_table}
