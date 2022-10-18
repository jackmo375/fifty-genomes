project_dir="/mnt/lustre/users/jmorrice/projects/fifty-genomes"

input_data_dir="${project_dir}/input-data"
working_data_dir="${project_dir}/working-data"
output_data_dir="${project_dir}/output-data"
reference_data_dir="${project_dir}/reference-data"
software_dir="${project_dir}/software"
reports_dir="${project_dir}/reports"

gsutil="~/python-enviroments/gsutil/bin/gsutil"
fastqc="${software_dir}/FastQC/fastqc"
bwa="${software_dir}/bwa-0.7.17/bwa"
gatk="${software_dir}/gatk-4.3.0.0/gatk"

reference_fasta="${reference_data_dir}/Homo_sapiens_assembly38.fasta"
intervals="${reference_data_dir}/wgs_calling_regions.hg38.interval_list"

variant_databases=(\
    "${reference_data_dir}/1000G_omni2.5.hg38.vcf.gz" \
    "${reference_data_dir}/1000G_phase1.snps.high_confidence.hg38.vcf.gz" \
    "${reference_data_dir}/hapmap_3.3.hg38.vcf.gz" \
    "${reference_data_dir}/Homo_sapiens_assembly38.known_indels.vcf.gz" \
    "${reference_data_dir}/Mills_and_1000G_gold_standard.indels.hg38.vcf.gz")
