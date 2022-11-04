#!~/bin/nextflow

nextflow.enable.dsl=2

include {
    getTrimmedSampleFastqs;
    getReferenceFastaBundle;
} from "${params.modulesDir}/base.nf"

include {
    alignSampleReadsToReference;
    markDuplicateReads;
} from "${params.modulesDir}/preprocessing.nf"

workflow() {

    sampleFastqs = getTrimmedSampleFastqs(params.sampleInputFiles)

    referenceFastaWithIndices = getReferenceFastaBundle()

    sampleBams = alignSampleReadsToReference(sampleFastqs.filter{it[0]=='SCD109'}, referenceFastaWithIndices)

    markDuplicateReads(sampleBams)
}
