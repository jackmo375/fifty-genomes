#!/bin/bash

${params.gatk} --java-options "-Xms4000m -Xmx7g" \
    MarkDuplicates \
    --INPUT ${sampleBamAndBai[0]} \
    --METRICS_FILE ${sampleId}.bam.metrics \
    --TMP_DIR ${params.tmpDir} \
    --ASSUME_SORT_ORDER coordinate \
    --CREATE_INDEX true \
    --OUTPUT ${sampleId}_duplicates-marked.bam
