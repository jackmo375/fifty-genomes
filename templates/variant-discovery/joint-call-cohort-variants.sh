#!/bin/bash

${params.gatk} --java-options "-Xmx4g" GenotypeGVCFs \
    -R ${referenceFasta[1]} \
    -V ${genomicsdbWorkspace} \
    -O cohort-joint-calls.vcf.gz \
    -L ${intervals}
