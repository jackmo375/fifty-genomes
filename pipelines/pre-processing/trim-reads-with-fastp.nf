#!~/bin/nextflow

nextflow.enable.dsl=2

include {
    getInputSampleListAsChannel;
} from "${params.modulesDir}/base.nf"

include {
    trimReadsWithFastp;
    saveTrimmedFastqsToOutputDir;
    saveTrimmingReportsToReportsDir;
} from "${params.modulesDir}/preprocessing.nf"

workflow {

    sampleFastqs = getInputSampleListAsChannel(params.sampleInputFiles)

    (trimmedFastqs, trimmingReports) = trimReadsWithFastp(sampleFastqs)

    saveTrimmedFastqsToOutputDir(trimmedFastqs)

    saveTrimmingReportsToReportsDir(trimmingReports)
}
