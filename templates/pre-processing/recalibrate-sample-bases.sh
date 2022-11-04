#!/bin/bash

${params.gatk} --java-options -Xmx2g \
    ApplyBQSR \
    -R ${referenceFasta[0]} \
    --input ${bamAndBai[0]} \
    --output "${sampleId}_bases-recalibrated.bam" "${sampleId}_bases-recalibrated.bai" \
    -L ${genomeIntervals} \
    --bqsr-recal-file ${recalibrationModel}

