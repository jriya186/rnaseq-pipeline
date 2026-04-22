process FASTQC {
    container 'quay.io/biocontainers/fastqc:0.12.1--hdfd78af_0'
    publishDir "${params.outdir}/fastqc", mode: 'copy'

    input:
    tuple val(sample), val(condition), path(read1), path(read2)

    output:
    tuple val(sample), val(condition), path("*.html"), path("*.zip"), emit: reports

    script:
    """
    fastqc ${read1} ${read2} --threads 2
    """
}