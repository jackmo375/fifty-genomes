#!~/bin/nextflow

nextflow.enable.dsl=2

include {
    getReferenceFastaBundle;
    getSampleIdsAsChannel;
    returnFile;
} from "${params.modulesDir}/base.nf"

include {
} from "${params.modulesDir}/preprocessing.nf"

params.genomeIntervals = "${params.referenceDataDir}/gatk-resource-bundle-hg38/wgs_calling_regions.hg38.interval_list"
params.variantDatabases = [
    "${params.referenceDataDir}/gatk-resource-bundle-hg38/1000G_omni2.5.hg38.vcf.gz",
    "${params.referenceDataDir}/gatk-resource-bundle-hg38/1000G_phase1.snps.high_confidence.hg38.vcf.gz",
    "${params.referenceDataDir}/gatk-resource-bundle-hg38/hapmap_3.3.hg38.vcf.gz",
    "${params.referenceDataDir}/gatk-resource-bundle-hg38/Homo_sapiens_assembly38.known_indels.vcf.gz",
    "${params.referenceDataDir}/gatk-resource-bundle-hg38/Mills_and_1000G_gold_standard.indels.hg38.vcf.gz"]

workflow() {

    sampleBams = getMarkedDuplicateSampleBams(params.sampleInputFiles).filter{it[0]=='SCD109'}

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

def getMarkedDuplicateSampleBams(sampleInputFiles) {
    return getSampleIdsAsChannel(sampleInputFiles).map {
        [it,[
            returnFile("${params.outputDataDir}/trimmed-reads/${it}_trimmed_fastp.R1.fq.gz"),
            returnFile("${params.outputDataDir}/trimmed-reads/${it}_trimmed_fastp.R2.fq.gz")]]
    } // this is a placeholder. Instead of fastqs it should be the bam and bai files
}

def getGenomeIntervals() {
    return channel.fromPath("${params.genomeIntervals}")
}

def getVariantDatabases() {
    return channel.fromPath(params.variantDatabases).toSortedList()
}

process calculateRecalibrationModel {
    tag "${sampleId}"
    publishDir "${params.reportsDir}/bases-recalibrated", mode: 'copy'

    input:
    tuple val(sampleId), path(bamAndBai)
    path(referenceFasta)
    path(genomeIntervals)
    path(variantDatabases)

    output:
    tuple val(sampleId), path("${bamAndBai[0].getSimpleName()}.recal.table")

    script:
    template "${params.templatesDir}/pre-processing/calculate-base-recalibration-model.sh"
}

process recalibrateBases {
    tag "${sampleId}"
    publishDir "${params.outputDataDir}/bases-recalibrated", mode: 'copy'

    input:
    tuple val(sampleId), path(bamAndBai), path(recalibrationModel)
    path(referenceFasta)
    path(genomeIntervals)

    output:
    tuple val(sampleId), path("${sampleId}_bases-recalibrated.{bai,bam}")

    script:
    template "${params.templatesDir}/pre-processing/recalibrate-sample-bases.sh"
}

process calculatePostRecalibrationModel {
    tag "${sampleId}"
    publishDir "${params.reportsDir}/bases-recalibrated", mode: 'copy'

    input:
    tuple val(sampleId), path(bamAndBai)
    path(referenceFasta)
    path(genomeIntervals)
    path(variantDatabases)

    output:
    tuple val(sampleId), path("${bamAndBai[0].getSimpleName()}.recal.table")

    script:
    template "${params.templatesDir}/pre-processing/calculate-base-recalibration-model.sh"
}
