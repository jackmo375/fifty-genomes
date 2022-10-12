#!/bin/bash

# includes
source ./config.sh

# global variables
data_dir="/mnt/lustre/groups/CBBI1243/Data"
cases_dir_1="${data_dir}/SCD_WGS_samples_022to595"
cases_dir_2="${data_dir}/SCD_WGS_samples_033to526"
controls_dir="${data_dir}/SCD_controls_Trypanogen1"


main() {

    echo "" > ${input_data_dir}/sample_ids.txt

    sample_ids_cases_dir_1=(SCD109  SCD-22  SCD376  SCD461  SCD512  SCD595  SCD132  SCD351  SCD-41  SCD47   SCD515)
    sample_ids_cases_dir_2=(SCD-225  SCD-33  SCD-337  SCD-348  SCD-356  SCD-363  SCD-369  SCD-398  SCD-421  SCD-425  SCD-436  SCD-479  SCD-526)
    sample_ids_controls=(\
        CB12  CB15  CB17  CB29  CB32  CB7   CF25  CF27  CF37  \
        CF49  CP28  CP38  CP48  CB14  CB16  CB24  CB31  CB33  \
        CF24  CF26  CF30  CF46  CP17  CP36  CP40) # CP9 removed because raw reads were not available

    create_links ${cases_dir_1} "${sample_ids_cases_dir_1[@]}"
    create_links ${cases_dir_2} "${sample_ids_cases_dir_2[@]}"
    create_links ${controls_dir} "${sample_ids_controls[@]}"
}


# methods
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


# run main
main
