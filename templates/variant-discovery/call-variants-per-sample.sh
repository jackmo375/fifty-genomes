#!/bin/bash

${params.gatk} --java-options "-Xmx4g" HaplotypeCaller  \
  -R ${referenceFasta[1]} \
  -I ${baiAndBam[1]} \
  -O ${sampleId}_raw-calls.g.vcf.gz \
  -ERC GVCF \
  -L ${intervals}
