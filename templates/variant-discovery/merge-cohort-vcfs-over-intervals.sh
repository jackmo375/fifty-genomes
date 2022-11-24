#!/bin/bash

${params.bcftools} concat *.vcf.gz | ${params.bcftools} sort -Oz -o cohort-genotyped.vcf.gz
${params.bcftools} index -t cohort-genotyped.vcf.gz


