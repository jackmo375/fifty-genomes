#!/bin/bash

${params.gatk} --java-options "-Xmx4g" GenotypeGVCFs \
    -R ${referenceFasta[1]} \
    -V gendb://${intervalWorkspace} \
    -O ${outputVCF} \
    -L ${interval}
