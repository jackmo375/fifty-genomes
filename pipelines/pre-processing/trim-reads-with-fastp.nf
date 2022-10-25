#!~/bin/nextflow

nextflow.enable.dsl=2

include {
    getInputSampleListAsChannel;
} from "${params.modulesDir}/base.nf"

include {
    trimReadsWithFastp;
    getFastqcReports;
    saveTrimmedFastqsToOutputDir;
    saveTrimmingReportsToReportsDir;
} from "${params.modulesDir}/preprocessing.nf"

workflow {

    sampleFastqs = getInputSampleListAsChannel(params.sampleInputFiles)

    (trimmedFastqs, trimmingReports) = trimReadsWithFastp(sampleFastqs)

    fastqcReports = getFastqcReports(trimmedFastqs)

    saveTrimmedFastqsToOutputDir(trimmedFastqs)

    saveTrimmingReportsToReportsDir(trimmingReports.mix(fastqcReports))
}
