#!~/bin/nextflow

nextflow.enable.dsl=2

params.testMessage="hello"

workflow {

    getInputSampleListAsChannel(params.sampleInputFiles).view()

    //PrintSampleIds(sampleIds)
}

process PrintSampleIds {
    debug true

    input:
        tuple val(idSample) path(fastq_1) path(fastq_2)

    script:
        """
        echo "${idSample}"
        """
}

def extractFastq(tsvFile) {
    Channel.from(tsvFile)
        .splitCsv(sep: '\t')
        .map { row ->
            def idSample   = row[0]
            def file1      = row[1]
            def file2      = row[2]
            [idSample, file1, file2]
        }
}

def getInputSampleListAsChannel(inputTsvPath) {
  tsvFile = file(inputTsvPath)
  return extractFastq(tsvFile)
}

def returnFile(it) {
    if (!file(it).exists()) exit 1, "Missing file in TSV file: ${it}, see --help for more information"
    return file(it)
}
