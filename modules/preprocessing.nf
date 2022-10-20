process getFastqcReport {
    input:
    tuple val(idSample), path(inputFastq1), path(inputFastq2)

    output:
    tuple val(idSample), path("${inputFastq1.getSimpleName()}*"), path("${inputFastq2.getSimpleName()}*")

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
    input:
    tuple val(idSample), path(inputFastq1), path(inputFastq2)

    output:
    tuple val(idSample), path("*.fq.gz")
    tuple val(idSample), path("*.{html,zip,txt}")

    script:
    template "${params.templatesDir}/pre-processing/trim-sample-reads.sh"
}

process saveTrimmedFastqsToOutputDir {
    publishDir "${params.outputDataDir}/trimgalore", mode: 'copy'

    input:
    tuple val(sampleId), path(fastqs)

    output:
    path("*.fq.gz"), includeInputs: true

    script:
    """
        mkdir -p ${params.outputDataDir}/trimgalore
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


