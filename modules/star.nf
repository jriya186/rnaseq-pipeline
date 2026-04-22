process STAR {
    container 'quay.io/biocontainers/star:2.7.11a--h0033a41_0'
    publishDir "${params.outdir}/star", mode: 'copy'

    input:
    tuple val(sample), val(condition), path(read1), path(read2)
    path star_index

    output:
    tuple val(sample), val(condition), path("${sample}.Aligned.sortedByCoord.out.bam"), emit: bam
    path "${sample}.Log.final.out", emit: log

    script:
    """
    STAR \
        --runThreadN 4 \
        --genomeDir ${star_index} \
        --readFilesIn ${read1} ${read2} \
        --outSAMtype BAM SortedByCoordinate \
        --outSAMattributes NH HI AS NM \
        --outFileNamePrefix ${sample}. \
        --runMode alignReads
    """
}