#!/bin/bash

${params.gatk} --java-options "-Xmx4g -Xms4g" GenomicsDBImport \
    --sample-name-map ${sampleGVCFsMap} \
    --genomicsdb-workspace-path genomicsdb-workspace \
    --tmp-dir=${params.tmpDir} \
    -L ${intervals}
