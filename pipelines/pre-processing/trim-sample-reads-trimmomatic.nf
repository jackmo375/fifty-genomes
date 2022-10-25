#!~/bin/nextflow

nextflow.enable.dsl=2

workflow {

    println "${params.trimmomaticJar}"

    sampleId = channel.from(
        [["NA18486",
        "${params.inputDataDir}/SRR011037_1.filt.fastq.gz",
        "${params.inputDataDir}/SRR011037_2.filt.fastq.gz"]])

    sampleId.view()

    trimSampleReadsWithTrimmomatic(sampleId)
}

process trimSampleReadsWithTrimmomatic {
    debug true

    input:
        tuple val(sampleId), path(inputFastq1), path(inputFastq2)

    script:
        """
        java -jar trimmomatic-0.39.jar PE \
            ${inputFastq1} ${inputFastq2} \
            output_forward_paired.fq.gz output_forward_unpaired.fq.gz \
            output_reverse_paired.fq.gz output_reverse_unpaired.fq.gz \
            ILLUMINACLIP:TruSeq3-PE.fa:2:30:10:2:True \
            LEADING:3 \
            TRAILING:3 \
            MINLEN:36
        """
}
