#!/bin/bash

${params.bwa} mem \
    -K 100000000 \
    -R "@RG\\tID:${sampleId}\\tPU:${sampleId}\\tSM:${sampleId}\\tLB:${sampleId}\\tPL:illumina" \
    -t ${task.cpus} \
    -M ${referenceFastaBundle[0]} \
    ${inputFastqs[0]} ${inputFastqs[1]} | \
    ${params.samtools} sort \
        --threads ${task.cpus} \
        -m 2G - > ${sampleId}_aligned.bam

${params.samtools} index ${sampleId}_aligned.bam
