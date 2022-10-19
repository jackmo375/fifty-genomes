#!/bin/bash

source ./config.sh

# fastqc
wget https://www.bioinformatics.babraham.ac.uk/projects/fastqc/fastqc_v0.11.9.zip \
    --directory-prefix $software_dir \
    --no-check-certificate \
    --no-clobber
unzip -n -d ${software_dir} "${software_dir}/fastqc_v0.11.9.zip"
chmod +x $fastqc

# trim galore
wget https://github.com/FelixKrueger/TrimGalore/archive/refs/tags/0.6.7.zip \
    --directory-prefix $software_dir \
    --no-clobber
unzip -n -d ${software_dir} "${software_dir}/0.6.7.zip"

# cutadapt
wget https://github.com/marcelm/cutadapt/archive/refs/tags/v4.0.zip \
    --directory-prefix $software_dir \
    --no-clobber
unzip -n -d ${software_dir} "${software_dir}/v4.0.zip"

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

# qualimap
wget https://bitbucket.org/kokonech/qualimap/downloads/qualimap_v2.2.1.zip \
    --directory-prefix $software_dir \
    --no-clobber
unzip -n -d ${software_dir} "${software_dir}/qualimap_v2.2.1.zip"
