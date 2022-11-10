#!/bin/bash

${params.gatk} --java-options -Xmx2g \
    BaseRecalibrator \
    -I ${baiAndBam[1]} \
    -O ${baiAndBam[0].getSimpleName()}.recal.table \
    -R ${referenceFasta[1]} \
    -L ${genomeIntervals} \
    ${variantDatabaseGatkOptions} \
    --verbosity INFO
