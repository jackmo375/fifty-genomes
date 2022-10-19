#!/bin/bash

# note, you need R installed, and packages available:
# gplots, gsalib
# On this computer I have them installed for R v4.1
# so I need to make sure I load this R version.
#
# This script takes seconds, so does not need to be
# qsubbed.
#
# Jack Morrice
# 2022-10-19

source ./config.sh

sample_id="SCD109"

pre_recal_model="${working_data_dir}/${sample_id}_duplicates-marked.recal.table"
post_recal_model="${working_data_dir}/${sample_id}_bases-recalibrated.recal.table"

$gatk AnalyzeCovariates \
    -before ${pre_recal_model} \
    -after ${post_recal_model} \
    -plots ${reports_dir}/${sample_id}_baserecal.pdf
