#!~/bin/nextflow

nextflow.enable.dsl=2

workflow {

    sampleId = channel.from(
        [["NA18486",
        "${params.inputDataDir}/SRR011037_1.filt.fastq.gz",
        "${params.inputDataDir}/SRR011037_2.filt.fastq.gz"]])

    sampleId.view()

    trimSampleReadsWithSkewer(sampleId)
}

process trimSampleReadsWithSkewer {
    debug true

    input:
        tuple val(sampleId), path(inputFastq1), path(inputFastq2)

    script:
        """
        ${params.skewer} --help
        """
}


