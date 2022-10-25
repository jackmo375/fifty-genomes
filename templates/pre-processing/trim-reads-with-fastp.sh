#!/bin/bash

fastp \
    -i ${inputFastq1} \
    -I ${inputFastq2} \
    -o ${sampleId}_trimmed_fastp.R1.fq.gz \
    -O ${sampleId}_trimmed_fastp.R2.fq.gz

    mv fastp.html ${sampleId}_fastp.html
    mv fastp.json ${sampleId}_fastp.json

