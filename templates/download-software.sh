#!/bin/bash

source ./config.sh

# fastqc
wget https://www.bioinformatics.babraham.ac.uk/projects/fastqc/fastqc_v0.11.9.zip \
    --directory-prefix $software_dir \
    --no-check-certificate \
    --no-clobber
unzip -n -d ${software_dir} "${software_dir}/fastqc_v0.11.9.zip"
chmod +x $fastqc

# bwa
wget https://github.com/lh3/bwa/releases/download/v0.7.17/bwa-0.7.17.tar.bz2 \
    --directory-prefix $software_dir \
    --no-clobber
tar -xf "${software_dir}/bwa-0.7.17.tar.bz2" \
    --directory ${software_dir}
### then dont forget to build bwa with $cd ${software_dir}/bwa-0.7.17; make

# gatk
wget https://github.com/broadinstitute/gatk/releases/download/4.3.0.0/gatk-4.3.0.0.zip \
    --directory-prefix $software_dir \
    --no-clobber
unzip -n -d ${software_dir} "${software_dir}/gatk-4.3.0.0.zip"