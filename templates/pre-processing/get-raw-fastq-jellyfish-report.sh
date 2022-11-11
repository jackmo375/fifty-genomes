#!/bin/bash

gunzip -c ${sampleFastqs[0]} \
    | ${params.jellyfish} count \
        -o ${sampleId}_raw-fastq-R1.jf \
        -m ...
${params.jellyfish} histo \
    -o ${sampleId}_raw-fastq-R1_jf.hist \
    -f ${sampleId}_raw-fastq-R1.jf

gunzip -c ${sampleFastqs[1]} \
    | ${params.jellyfish} count \
        -o ${sampleId}_raw-fastq-R2.jf \
        -m ...
${params.jellyfish} histo \
    -o ${sampleId}_raw-fastq-R2_jf.hist \
    -f ${sampleId}_raw-fastq-R2.jf
