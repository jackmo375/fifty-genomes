#!~/bin/nextflow

nextflow.enable.dsl=2

include {
    getInputSampleListAsChannel;
} from "${params.modulesDir}/base.nf"

include {
    getFastqcReport;
    renameFastqcReportWithSampleId;
} from "${params.modulesDir}/preprocessing.nf"

workflow {
    sampleFastqs = getInputSampleListAsChannel(params.sampleInputFiles)

    fastqcReports = getFastqcReport(sampleFastqs)

    renameFastqcReportWithSampleId(fastqcReports)
}
