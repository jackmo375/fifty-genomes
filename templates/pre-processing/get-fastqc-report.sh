#!/bin/bash

mkdir -p ${params.reportsDir}/fastqc

${params.fastqc} \
    $inputFastq1 \
    $inputFastq2 \
    -o ${params.reportsDir}/fastqc
