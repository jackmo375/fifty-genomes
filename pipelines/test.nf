#!~/bin/nextflow

nextflow.enable.dsl=2

workflow() {
    getReferenceFastaBundle().view()
}

def getReferenceFastaBundle() {
    return channel.fromPath(
        ["${params.referenceFasta}*",
        "${params.referenceFasta}" - ~/\.fasta/ + '.dict']).toSortedList()
}
