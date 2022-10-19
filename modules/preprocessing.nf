process getFastqcReports {
    debug true

    input:
    tuple val(idSample), path(inputFastq1), path(inputFastq2)

    script:
    template "${params.templatesDir}/pre-processing/get-fastqc-report.sh"
}
