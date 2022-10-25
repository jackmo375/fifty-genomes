#!/bin/bash

${params.fastqc} \
    $inputFastq1 \
    $inputFastq2

mv ${fastqcOutput_1[0]} ${sampleId}_1_fastqc.${fastqcOutput_1[0].getExtension()}
mv ${fastqcOutput_1[1]} ${sampleId}_1_fastqc.${fastqcOutput_1[1].getExtension()}
mv ${fastqcOutput_2[0]} ${sampleId}_2_fastqc.${fastqcOutput_2[0].getExtension()}
mv ${fastqcOutput_2[1]} ${sampleId}_2_fastqc.${fastqcOutput_2[1].getExtension()}

