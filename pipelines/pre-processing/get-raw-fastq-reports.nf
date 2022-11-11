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
    debug true
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
    debug true
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
    debug true
    publishDir "${params.reportsDir}/multiqc", mode: 'copy'

    input:
    path reports

    output:
    path "cohort-raw-fastq-multiqc.html"

    script:
    template "${params.templatesDir}/pre-processing/combine-raw-fastq-reports.sh"
}
