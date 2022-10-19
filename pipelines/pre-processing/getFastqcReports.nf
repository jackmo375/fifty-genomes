#!~/bin/nextflow

nextflow.enable.dsl=2

include {
    getInputSampleListAsChannel
} from "${params.modulesDir}/base.nf"

include {
    getFastqcReports
} from "${params.modulesDir}/preprocessing.nf"

workflow {

    sampleFastqs = getInputSampleListAsChannel(params.sampleInputFiles)

    getFastqcReports(sampleFastqs)
}
