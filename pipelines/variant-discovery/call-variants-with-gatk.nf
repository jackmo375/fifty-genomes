#!~/bin/nextflow

nextflow.enable.dsl=2

include {
    getBaseRecalibratedSampleBams;
    getReferenceFastaBundle;
    //getGenomeIntervals;
} from "${params.modulesDir}/base.nf"

workflow() {

    sampleBams = getBaseRecalibratedSampleBams().filter{ it[0] == 'CP40' || it[0] == 'SCD351' }

    genomeIntervals = getGenomeIntervals().filter{ it == 'chr9:61785369-62149738' || it == 'chr16:33264596-33392411' }

    referenceFasta = getReferenceFastaBundle()

    genomeIntervals.combine(sampleBams)

    intervalXSampleGVCFs = callVariantsPerIntervalPerSample(genomeIntervals.combine(sampleBams), referenceFasta)

    intervalSampleMaps = getSampleMapsPerInterval(intervalXSampleGVCFs)

    intervalWorkspaces = consolidateSampleGVCFsPerInterval(intervalXSampleGVCFs.groupTuple().join(intervalSampleMaps))

    intervalCohortVCFs = jointCallCohortVariantsPerInterval(intervalWorkspaces, referenceFasta)

    mergeCohortVCFsOverIntervals(intervalCohortVCFs.collect())

/*
    sampleGVCFs = callVariantsPerSample(sampleBams, referenceFasta, genomeIntervals)

    sampleGVCFMap = getSampleGVCFMap(sampleGVCFs)

    genomicsDBWorkspace = consolidateSampleGVCFs(sampleGVCFs.collect(), sampleGVCFMap, genomeIntervals)

    jointCallCohortVariants(genomicsDBWorkspace, referenceFasta, genomeIntervals)
*/
}

def getGenomeIntervals() {
    return channel
        .value(file("${params.genomeIntervals}"))
        .splitCsv(sep: '\t')
        .filter{ it[0] =~ /chr/ }
        .map{ it -> "${it[0]}:${it[1]}-${it[2]}" }
}

process callVariantsPerIntervalPerSample {
    tag "${interval}|${sampleId}"

    input:
    tuple val(interval), val(sampleId), path(baiAndBam)
    path referenceFasta

    output:
    tuple val(interval), val(sampleId), path("${interval}_${sampleId}.g.vcf.gz")

    script:
    template "${params.templatesDir}/variant-discovery/call-variants-per-interval-per-sample.sh"
}

def getSampleMapsPerInterval(intervalXSampleGVCFs) {
    return intervalXSampleGVCFs.map { it ->
        [it[0], "${it[1]}\t${it[2]}\n"]
    }.collectFile() { it ->
        ["${it[0]}.samplemap", it[1]]
    }.map { it ->
        [it.getSimpleName(), it]
    }
}

process consolidateSampleGVCFsPerInterval {
    tag "${interval}"

    input:
    tuple val(interval), val(sampleIds), path(sampleGVCFs), path(sampleMap)

    output:
    tuple val(interval), path("${interval}-workspace")

    script:
    template "${params.templatesDir}/variant-discovery/consolidate-sample-gvcfs-per-interval.sh"
}

process jointCallCohortVariantsPerInterval {
    tag "${interval}"

    input:
    tuple val(interval), path(intervalWorkspace)
    path referenceFasta

    output:
    path "${interval}_cohort-genotyped.vcf"

    script:
    template "${params.templatesDir}/variant-discovery/joint-call-cohort-variants-per-interval.sh"
}

process mergeCohortVCFsOverIntervals {
    publishDir "${params.outputDataDir}/raw-variant-calls", mode: 'copy'

    input:
    path vcfs

    output:
    path "cohort-genotyped.vcf"

    script:
    template "${params.templatesDir}/variant-discovery/merge-cohort-vcfs-over-intervals.sh"
}







process callVariantsPerSample {
    tag "${sampleId}"

    input:
    tuple val(sampleId), path(baiAndBam)
    path referenceFasta
    path intervals

    output:
    tuple val(sampleId), path("${sampleId}_raw-calls.g.vcf.gz")

    script:
    template "${params.templatesDir}/variant-discovery/call-variants-per-sample.sh"
}

def getSampleGVCFMap(sampleGVCFs) {

    return sampleGVCFs.map { it ->
        sampleId = it[0]
        sampleGVCFPath = it[1]
        "${sampleID}\t${sampleGVCFPath}"
    }.collectFile(name: 'sampleGVCFMap.tsv')
}

process consolidateSampleGVCFs {
    input:
    tuple val(sampleId), path(sampleGVCFs)
    path sampleGVCFsMap
    path interevals

    output:
    path "genomicsdb-workspace"

    script:
    template "${params.templatesDir}/variant-discovery/consolidate-gvcfs.sh"
}

process jointCallCohortVariants {
    publishDir "${params.outputDataDir}/raw-variant-calls", mode: 'copy'

    input:
    path genomicsdbWorkspace
    path referenceFasta
    path intervals

    output:
    path "cohort-joint-calls.vcf.gz"

    script:
    template "${params.templatesDir}/variant-discovery/joint-call-cohort-variants.sh"
}
