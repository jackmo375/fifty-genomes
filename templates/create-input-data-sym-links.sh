#!/bin/bash

source ./config.sh

main() {

    printf "" > ${input_data_dir}/sample_ids.tsv

    create_links_for_fifty_genomes
    #create_links_for_test_cohort
}


# methods

create_links_for_fifty_genomes() {

    data_dir="/mnt/lustre/groups/CBBI1243/Data"
    cases_dir_1="${data_dir}/SCD_WGS_samples_022to595"
    cases_dir_2="${data_dir}/SCD_WGS_samples_033to526"
    controls_dir="${data_dir}/SCD_controls_Trypanogen1"

    sample_ids_cases_dir_1=(SCD109  SCD-22  SCD376  SCD461  SCD512  SCD595  SCD132  SCD351  SCD-41  SCD47   SCD515)
    sample_ids_cases_dir_2=(SCD-225  SCD-33  SCD-337  SCD-348  SCD-356  SCD-363  SCD-369  SCD-398  SCD-421  SCD-425  SCD-436  SCD-479  SCD-526)
    sample_ids_controls=(\
        CB12  CB15  CB17  CB29  CB32  CB7   CF25  CF27  CF37  \
        CF49  CP28  CP38  CB16  CB24  CB31  CB33  \
        CF24  CF26  CF30  CF46  CP17  CP36  CP40)
    # CP9 removed because raw reads were not available
    # CB14 removed because one of the read files was corrupted
    # CP48 removed: a read file was corrupted

    forward_fastq_pattern="*_R1_*"
    backward_fastq_pattern="*_R2_*"

    create_links \
        ${cases_dir_1} \
        "${forward_fastq_pattern=}" \
        "${backward_fastq_pattern=}" \
        "${sample_ids_cases_dir_1[@]}"
    create_links \
        ${cases_dir_2} \
        "${forward_fastq_pattern=}" \
        "${backward_fastq_pattern=}" \
        "${sample_ids_cases_dir_2[@]}"
    create_links \
        ${controls_dir} \
        "${forward_fastq_pattern=}" \
        "${backward_fastq_pattern=}" \
        "${sample_ids_controls[@]}"
}

create_links_for_test_cohort() {

    data_dir="/mnt/lustre/groups/CBBI1243/Data/one-thousand-genomes"
    sample_ids=(NA18486  NA18487  NA18488)
    forward_fastq_pattern="*_1.*"
    backward_fastq_pattern="*_2.*"

    create_links \
        ${data_dir} \
        "${forward_fastq_pattern=}" \
        "${backward_fastq_pattern=}" \
        "${sample_ids[@]}"
}

create_links() {
    local samples_dir=$1; shift
    local forward_regex=$1; shift
    local backward_regex=$1; shift
    local sample_ids=("$@")

    for id in "${sample_ids[@]}"
    do
        forward=$(find "${samples_dir}/${id}/read" -name "${forward_regex}")
        backward=$(find "${samples_dir}/${id}/read" -name "${backward_regex}")
        echo $forward
        echo $backward
        ln -sf $forward "${input_data_dir}/$(basename $forward)"
        ln -sf $backward "${input_data_dir}/$(basename $backward)"
        echo -e "${id}\t$(basename $forward)\t$(basename $backward)" >> ${input_data_dir}/sample_ids.tsv
    done
}


# run main
main
