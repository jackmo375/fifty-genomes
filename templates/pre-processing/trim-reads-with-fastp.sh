#!/bin/bash

fastp \
    -i ${inputFastq1} \
    -I ${inputFastq2} \
    -o ${sampleId}_trimmed_fastp.R1.fq.gz \
    -O ${sampleId}_trimmed_fastp.R2.fq.gz \
    --dedup \
    --cut_front \
    --cut_tail \
    --qualified_quality_phred=25 \
    --unqualified_percent_limit=30 \
    --length_required=20 \
    --json=${sampleId}_fastp.json \
    --html=${sampleId}_fastp.html \
    --thread=${task.cpus}
