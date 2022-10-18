#!/bin/bash

source ./config.sh

chromosome_label="chr21"

intervals="${reference_data_dir}/wgs_calling_regions.hg38.interval_list"

awk '!/^@/ {print}' \
    ${intervals} \
    | awk \
        -F "\t" \
        -v label="${chromosome_label}" \
        '{if ($1==label) {print} }' \
        > ${working_data_dir}/${chromosome_label}.interval_list
