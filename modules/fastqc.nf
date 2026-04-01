// Step 1: FastQC
process FASTQC {
    container 'quay.io/biocontainers/fastqc:0.12.1--hdfd78af_0'
    publishDir "${params.outdir}/fastqc", mode: 'copy'

    input:
    tuple val(sample_id), path(reads)

    output:
    tuple val(sample_id), path("*.html"), path("*.zip")

    script:
    """
    fastqc ${reads[0]} ${reads[1]} --threads 2
    """
}