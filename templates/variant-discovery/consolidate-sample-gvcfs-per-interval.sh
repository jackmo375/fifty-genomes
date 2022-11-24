#!/bin/bash

${params.gatk} --java-options "-Xmx4g -Xms4g" GenomicsDBImport \
    --sample-name-map ${sampleMap} \
    --genomicsdb-workspace-path ${outputWorkspace} \
    --tmp-dir ${params.tmpDir} \
    -L ${interval}
