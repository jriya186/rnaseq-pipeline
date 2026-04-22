process SRA_FETCH {
    container 'quay.io/biocontainers/sra-tools:3.0.3--h87f3376_0'
    publishDir "${params.outdir}/fastq", mode: 'copy'

    input:
    tuple val(sample), val(srr), val(condition)

    output:
    tuple val(sample), val(condition), path("${sample}_1.fastq.gz"), path("${sample}_2.fastq.gz")

    script:
    """
    prefetch ${srr}
    fasterq-dump ${srr} \
        --split-files \
        --threads 4 \
        --outdir .
    mv ${srr}_1.fastq ${sample}_1.fastq
    mv ${srr}_2.fastq ${sample}_2.fastq
    gzip ${sample}_1.fastq
    gzip ${sample}_2.fastq
    """
}