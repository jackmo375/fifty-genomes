process getFastqcReports {
    input:
    tuple val(idSample), path(inputFastqs)

    output:
    tuple val(idSample), path("*.{html,zip}")

    script:
    template "${params.templatesDir}/pre-processing/get-fastqc-report.sh"
}

process renameFastqcReportWithSampleId {
    publishDir "${params.reportsDir}/fastqc", mode: 'copy'

    input:
    tuple val(sampleId), path(fastqcOutput_1), path(fastqcOutput_2)

    output:
    path "${sampleId}_?_fastqc.*"

    script:
       """
        mkdir -p ${params.reportsDir}/fastqc
        mv ${fastqcOutput_1[0]} ${sampleId}_1_fastqc.${fastqcOutput_1[0].getExtension()}
        mv ${fastqcOutput_1[1]} ${sampleId}_1_fastqc.${fastqcOutput_1[1].getExtension()}
        mv ${fastqcOutput_2[0]} ${sampleId}_2_fastqc.${fastqcOutput_2[0].getExtension()}
        mv ${fastqcOutput_2[1]} ${sampleId}_2_fastqc.${fastqcOutput_2[1].getExtension()}
        """
}

process trimSampleReads {
    tag "${idSample}"

    input:
    tuple val(idSample), path(inputFastq1), path(inputFastq2)

    output:
    tuple val(idSample), path("*.fq.gz")
    tuple val(idSample), path("*.{html,zip,txt}")

    script:
    template "${params.templatesDir}/pre-processing/trim-sample-reads.sh"
}

process saveTrimmedFastqsToOutputDir {
    publishDir "${params.outputDataDir}/trimmed-reads", mode: 'copy'

    input:
        tuple val(sampleId), path(fastqs)

    output:
        path("*.fq.gz"), includeInputs: true

    script:
        """
        mkdir -p ${params.outputDataDir}/trimmed-reads
        """
}

process saveTrimgaloreReportsToReportsDir {
    publishDir "${params.reportsDir}/trimgalore", mode: 'copy'

    input:
    tuple val(sampleId), path(trimgaloreOutputs)

    output:
    path("*.{txt,html,zip}"), includeInputs: true

    script:
       """
        mkdir -p ${params.reportsDir}/trimgalore
        """
}

process saveTrimmingReportsToReportsDir {
    publishDir "${params.reportsDir}/trimming", mode: 'copy'

    input:
        tuple val(sampleId), path(trimmingReports)

    output:
        path("*.{txt,html,zip,json}"), includeInputs: true

    script:
        """
        mkdir -p ${params.reportsDir}/trimming
        """
}

process trimReadsWithFastp {
    input:
    tuple val(sampleId), path(inputFastq1), path(inputFastq2)

    output:
        tuple val(sampleId), path("${sampleId}_trimmed_fastp.R{1,2}.fq.gz")
        tuple val(sampleId), path("*.{html,json}")

    script:
    template "${params.templatesDir}/pre-processing/trim-reads-with-fastp.sh"
}
