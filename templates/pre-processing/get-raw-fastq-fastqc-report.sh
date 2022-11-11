#!/bin/bash

${params.fastqc} \
    ${sampleFastqs[0]} \
    ${sampleFastqs[1]} \
    --threads ${task.cpus}

ls

# now need to rename output files to match the process declarations
