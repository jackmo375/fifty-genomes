#!/bin/bash

${params.gatk} --java-options -Xmx2g \
    ApplyBQSR \
    -R ${referenceFasta[1]} \
    --input ${baiAndBam[1]} \
    --output ${sampleId}_bases-recalibrated.bam \
    -L ${genomeIntervals} \
    --bqsr-recal-file ${recalibrationModel}

