#!/bin/bash

source ./config.sh

sample_id="SCD109"

pre_recal_model="${working_data_dir}/${sample_id}_duplicates-marked.recal.table"
post_recal_model="${working_data_dir}/${sample_id}_bases-recalibrated.recal.table"

$gatk AnalyzeCovariates \
    -before ${pre_recal_model} \
    -after ${post_recal_model} \
    -plots ${reports_dir}/${sample_id}_baserecal.pdf
