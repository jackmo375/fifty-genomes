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
