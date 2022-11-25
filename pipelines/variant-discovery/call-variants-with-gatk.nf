#!~/bin/nextflow

nextflow.enable.dsl=2

include {
    getBaseRecalibratedSampleBams;
    getReferenceFastaBundle;
} from "${params.modulesDir}/base.nf"

include {
    getGenomeIntervals;
    callVariantsPerIntervalPerSample;
    getSampleMapsPerInterval;
    consolidateSampleGVCFsPerInterval;
    jointCallCohortVariantsPerInterval;
    mergeCohortVCFsOverIntervals;
} from "${params.modulesDir}/variant-calling.nf"

workflow() {

    sampleBams = getBaseRecalibratedSampleBams().filter{ it[0] == 'CP40' || it[0] == 'SCD351' }

    genomeIntervals = getGenomeIntervals()

    //genomeIntervals = getGenomeIntervals().filter{ it == 'chr9:61785369-62149738' || it == 'chr16:33264596-33392411' }

    referenceFasta = getReferenceFastaBundle()

    intervalSampleGVCFs = callVariantsPerIntervalPerSample(genomeIntervals.combine(sampleBams), referenceFasta)

    intervalSampleMaps = getSampleMapsPerInterval(intervalSampleGVCFs)

    intervalWorkspaces = consolidateSampleGVCFsPerInterval(intervalSampleGVCFs.groupTuple().join(intervalSampleMaps))

    intervalCohortVCFs = jointCallCohortVariantsPerInterval(intervalWorkspaces, referenceFasta)

    mergeCohortVCFsOverIntervals(intervalCohortVCFs.collect())
}
