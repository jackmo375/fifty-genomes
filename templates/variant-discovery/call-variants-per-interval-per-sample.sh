#!/bin/bash

${params.gatk} --java-options "-Xmx4g" HaplotypeCaller  \
  -R ${referenceFasta[1]} \
  -I ${baiAndBam[1]} \
  -O ${outputGVCF} \
  -ERC GVCF \
  -L ${interval}
