#!/bin/bash

source ./config.sh

# global variables
#input_data_dir="/mnt/lustre/users/jmorrice/projects/fifty-genomes/input-data"
data_dir="/mnt/lustre/groups/CBBI1243/Data"
cases_dir_1="${data_dir}/SCD_WGS_samples_022to595"
cases_dir_2="${data_dir}/SCD_WGS_samples_033to526"
controls_dir="${data_dir}/SCD_controls_Trypanogen1"

sample_ids_cases_dir_1=(SCD109  SCD-22  SCD376  SCD461  SCD512  SCD595
SCD132  SCD351  SCD-41  SCD47   SCD515)

echo "" > ${input_data_dir}/sample_ids.txt

create_links() {
    local samples_dir=$1; shift
    local sample_ids=("$@")

    #echo ${samples_dir}
    #echo "${sample_ids[@]}"

    for id in "${sample_ids[@]}"
    do
        forward=$(find "${samples_dir}/${id}/read" -name "*R1_001*")
        backward=$(find "${samples_dir}/${id}/read" -name "*R2_001*")
        echo $forward
        echo $backward
        ln -sf $forward "${input_data_dir}/$(basename $forward)"
        ln -sf $backward "${input_data_dir}/$(basename $backward)"
        echo "${id}    $(basename $forward)    $(basename $backward)" >> ${input_data_dir}/sample_ids.txt
    done
}

create_links ${cases_dir_1} "${sample_ids_cases_dir_1[@]}"

