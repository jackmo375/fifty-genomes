#!/bin/bash

${params.gatk} --java-options -Xmx2g \
    BaseRecalibrator \
    -I ${bamAndBai[0]} \
    -O "${bamAndBai[0].getSimpleName()}.recal.table" \
    -R ${referenceFasta[0]} \
    -L ${genomeIntervals} \
    ${variantDatabases[@]/#/--known-sites } \
    --verbosity INFO
