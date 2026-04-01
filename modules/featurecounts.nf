process FEATURECOUNTS {
    container 'quay.io/biocontainers/subread:2.0.6--he4a0461_0'
    publishDir "${params.outdir}/featurecounts", mode: 'copy'

    input:
    path bams
    path gtf

    output:
    path "counts_matrix.txt", emit: counts
    path "counts_matrix.txt.summary", emit: summary

    script:
   """
    featureCounts \
        -T 4 \
        -p \
        --countReadPairs \
        -s 0 \
        -a ${gtf} \
        -o counts_matrix.txt \
        ${bams}
    """
}