#!/bin/bash

${params.fastqc} \
    ${inputFastqs[0]} \
    ${inputFastqs[1]} \
    --threads ${task.cpus}
