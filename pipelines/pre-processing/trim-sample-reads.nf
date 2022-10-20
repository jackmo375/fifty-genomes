#!~/bin/nextflow

nextflow.enable.dsl=2

include {
    getInputSampleListAsChannel;
} from "${params.modulesDir}/base.nf"

include {
    trimSampleReads;
    saveTrimmedFastqsToOutputDir;
    saveTrimgaloreReportsToReportsDir;
} from "${params.modulesDir}/preprocessing.nf"

workflow {

    sampleFastqs = getInputSampleListAsChannel(params.sampleInputFiles)

    (trimmedFastqs, trimmingReports) = trimSampleReads(sampleFastqs)

    saveTrimmedFastqsToOutputDir(trimmedFastqs)

    saveTrimgaloreReportsToReportsDir(trimmingReports)
}
