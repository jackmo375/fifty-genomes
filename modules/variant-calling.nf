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
    tuple val(interval), val(sampleId), path(outputGVCF)

    script:
    outputGVCF = "${interval.replaceAll(/:/, "_")}_${sampleId}.g.vcf.gz"
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
    tuple val(interval), path(outputWorkspace)

    script:
    outputWorkspace = "${interval.replaceAll(/:/, "_")}-workspace"
    template "${params.templatesDir}/variant-discovery/consolidate-sample-gvcfs-per-interval.sh"
}

process jointCallCohortVariantsPerInterval {
    tag "${interval}"

    input:
    tuple val(interval), path(intervalWorkspace)
    path referenceFasta

    output:
    tuple path(outputVCF), path("${outputVCF}.tbi")

    script:
    outputVCF = "${interval.replaceAll(/:/, "_")}_cohort-genotyped.vcf.gz"
    template "${params.templatesDir}/variant-discovery/joint-call-cohort-variants-per-interval.sh"
}

process mergeCohortVCFsOverIntervals {
    publishDir "${params.outputDataDir}/raw-variant-calls", mode: 'copy'

    input:
    path vcfs

    output:
    tuple path("cohort-genotyped.vcf.gz"), path("cohort-genotyped.vcf.gz.tbi")

    script:
    template "${params.templatesDir}/variant-discovery/merge-cohort-vcfs-over-intervals.sh"
}
