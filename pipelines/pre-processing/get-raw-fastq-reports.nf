#!~/bin/nextflow

nextflow.enable.dsl=2

include {
    extractFastq;
    returnFile;
} from "${params.modulesDir}/base.nf"

workflow() {

    sampleFastqs = getRawSampleFastqs()

    sampleFastqcReports = getRawFastqFastqcReport(sampleFastqs)

    sampleJellyfishReports = getRawFastqJellyfishReport(sampleFastqs)

    combineRawFastqReportsWithMultiQC(sampleFastqReports.mix(sampleJellyfishReports).collect())
}

def getRawSampleFastqs(inputTsvPath) {
  tsvFile = returnFile(inputTsvPath)
  return extractFastq(tsvFile)
}

process getRawFastqFastqcReport {
    tag "${sampleId}"
    publishDir "${params.reportsDir}/fastqc", mode: 'copy'

    input:
    tuple val(sampleId), path(sampleFastqs)

    output:
    path("${sampleId}_raw-fastq-fastqc.{html,zip}")

    script:
    template "${params.templatesDir}/pre-processing/get-raw-fastq-fastqc-report.sh"
}

process getRawFastqJellyfishReport {
    tag "${sampleId}"
    publishDir "${params.reportsDir}/jellyfish", mode: 'copy'

    input:
    tuple val(sampleId), path(sampleFastqs)

    output:
    path("${sampleId}_raw-fastq-R?_jf.hist")

    script:
    template "${params.templatesDir}/pre-processing/get-raw-fastq-jellyfish-report.sh"
}

process combineRawFastqReportsWithMultiQC {
    publishDir "${params.reportsDir}/multiqc", mode: 'copy'

    input:
    path reports

    output:
    path "${outputReport}"

    script:
    outputReport = "cohort-raw-fastq-multiqc.html"
    template "${params.templatesDir}/pre-processing/combine-reports-with-multiqc.sh"
}
