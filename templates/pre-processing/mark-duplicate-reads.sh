#!/bin/bash

source ./config.sh

sample_id="SCD109"
run_id="${sample_id}"

$gatk --java-options "-Xms4000m -Xmx7g" \
    MarkDuplicates \
    --INPUT ${working_data_dir}/${sample_id}_aligned.bam \
    --METRICS_FILE ${reports_dir}/gatk/${sample_id}.bam.metrics \
    --TMP_DIR ${working_data_dir}/tmp \
    --ASSUME_SORT_ORDER coordinate \
    --CREATE_INDEX true \
    --OUTPUT ${working_data_dir}/${sample_id}_duplicates-marked.bam
