def getInputSampleListAsChannel(inputTsvPath) {
  tsvFile = file(inputTsvPath)
  return extractFastq(tsvFile)
}

def extractFastq(tsvFile) {
    Channel.from(tsvFile)
        .splitCsv(sep: '\t')
        .map { row ->
            def idSample   = row[0]
            def file1      = returnFile("${params.inputDataDir}/${row[1]}")
            def file2      = returnFile("${params.inputDataDir}/${row[2]}")
            [idSample, file1, file2]
        }
}

def returnFile(it) {
    if (!file(it).exists()) exit 1, "Missing file: ${it} - please check your inuts and try again"
    return file(it)
}

def getSampleIdsAsChannel(sampleInputFiles) {
    return getInputSampleListAsChannel(sampleInputFiles).map{it[0]}
}

def getTrimmedSampleFastqs(sampleInputFiles) {
    return getSampleIdsAsChannel(sampleInputFiles).map {
        [it,[
            returnFile("${params.outputDataDir}/trimmed-reads/${it}_trimmed_fastp.R1.fq.gz"),
            returnFile("${params.outputDataDir}/trimmed-reads/${it}_trimmed_fastp.R2.fq.gz")]]
    }
}

def getReferenceFastaBundle() {
    return channel.fromPath(
        ["${params.referenceFasta}*",
        "${params.referenceFasta}" - ~/\.fasta/ + '.dict']).toSortedList()
}

def getMarkedDuplicateSampleBams(sampleInputFiles) {
    return getSampleIdsAsChannel(sampleInputFiles).map {
        [it,[
            returnFile("${params.outputDataDir}/aligned/${it}_duplicates-marked.bai"),
            returnFile("${params.outputDataDir}/aligned/${it}_duplicates-marked.bam")]]
    } // note that the bam index is listed before the bam itself! 
}

def getBaseRecalibratedSampleBams() {
    return getSampleIdsAsChannel(params.sampleInputFiles).map {
        [it,[
            returnFile("${params.outputDataDir}/bases-recalibrated/${it}_bases-recalibrated.bai"),
            returnFile("${params.outputDataDir}/bases-recalibrated/${it}_bases-recalibrated.bam")]]
    } // note that the bam index is listed before the bam itself! 
}

def getGenomeIntervals() {
    return channel.value(file("${params.genomeIntervals}"))
}

def getVariantDatabases() {
    databasePaths = channel.fromPath(params.variantDatabases).toSortedList()
    gatkOptions = channel.from(params.variantDatabases)
        .map{ it -> "--known-sites ${it}" }
        .collect()
        .map{ it -> it.join(' ') }
    return databasePaths.mix(gatkOptions).toSortedList()
}

