process FASTP {
    container 'quay.io/biocontainers/fastp:0.23.4--h5f740d0_0'
    publishDir "${params.outdir}/fastp", mode: 'copy'

    input:
    tuple val(sample_id), path(reads)

    output:
    tuple val(sample_id), path("${sample_id}_1.trimmed.fastq"), path("${sample_id}_2.trimmed.fastq"), emit: trimmed_reads
    path "${sample_id}_fastp.json", emit: json
    path "${sample_id}_fastp.html", emit: html

    script:
    """
    fastp \
        --in1 ${reads[0]} \
        --in2 ${reads[1]} \
        --out1 ${sample_id}_1.trimmed.fastq \
        --out2 ${sample_id}_2.trimmed.fastq \
        --json ${sample_id}_fastp.json \
        --html ${sample_id}_fastp.html \
        --thread 4
    """
}