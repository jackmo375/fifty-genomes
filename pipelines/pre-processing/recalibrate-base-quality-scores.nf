#!~/bin/nextflow

nextflow.enable.dsl=2

include {
    getMarkedDuplicateSampleBams;
    getGenomeIntervals;
    getVariantDatabases;
    getReferenceFastaBundle;
} from "${params.modulesDir}/base.nf"

include {
    calculateRecalibrationModel;
    recalibrateBases;
    calculatePostRecalibrationModel;
} from "${params.modulesDir}/preprocessing.nf"

workflow() {

    sampleBams = getMarkedDuplicateSampleBams(params.sampleInputFiles)

    referenceFasta = getReferenceFastaBundle()
    genomeIntervals = getGenomeIntervals()
    variantDatabases = getVariantDatabases()

    sampleRecalibrationModels = calculateRecalibrationModel(
        sampleBams,
        referenceFasta,
        genomeIntervals,
        variantDatabases)

    recalibratedSampleBams = recalibrateBases(
        sampleBams.join(sampleRecalibrationModels),
        referenceFasta,
        genomeIntervals)

    calculatePostRecalibrationModel(
        recalibratedSampleBams,
        referenceFasta,
        genomeIntervals,
        variantDatabases)
}
