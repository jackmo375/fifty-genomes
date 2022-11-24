#!/bin/bash

echo "interval ${interval}"
echo "sampleId ${sampleId}"
echo "reference ${referenceFasta[1]}"
echo "bam ${baiAndBam[1]}"

touch "${interval}_${sampleId}.g.vcf.gz"
