#!/bin/bash

# includes
source ./config.sh

# global variables
data_dir="/mnt/lustre/groups/CBBI1243/Data/one-thousand-genomes"

main() {

    printf "" > ${input_data_dir}/sample_ids.tsv

    sample_ids=(NA18486  NA18487  NA18488)

    create_links ${data_dir} "${sample_ids[@]}"
}


# methods
create_links() {
    local samples_dir=$1; shift
    local sample_ids=("$@")

    for id in "${sample_ids[@]}"
    do
        forward=$(find "${samples_dir}/${id}/read" -name "*_1.*")
        backward=$(find "${samples_dir}/${id}/read" -name "*_2.*")
        echo $forward
        echo $backward
        ln -sf $forward "${input_data_dir}/$(basename $forward)"
        ln -sf $backward "${input_data_dir}/$(basename $backward)"
        echo -e "${id}\t$(basename $forward)\t$(basename $backward)" >> ${input_data_dir}/sample_ids.tsv
    done
}


# run main
main
