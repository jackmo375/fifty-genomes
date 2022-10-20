#!/bin/bash

trim_galore \
    --basename ${idSample}_trimmed \
    --paired \
    --fastqc \
    --gzip \
    ${inputFastq1} ${inputFastq2}

