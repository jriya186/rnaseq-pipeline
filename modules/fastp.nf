process FASTP {
    container 'quay.io/biocontainers/fastp:0.23.4--h5f740d0_0'
    publishDir "${params.outdir}/fastp", mode: 'copy'

    input:
    tuple val(sample), val(condition), path(read1), path(read2)

    output:
    tuple val(sample), val(condition), path("${sample}_1.trimmed.fastq"), path("${sample}_2.trimmed.fastq"), emit: trimmed_reads
    path "${sample}_fastp.json", emit: json
    path "${sample}_fastp.html", emit: html

    script:
    """
    fastp \
        --in1 ${read1} \
        --in2 ${read2} \
        --out1 ${sample}_1.trimmed.fastq \
        --out2 ${sample}_2.trimmed.fastq \
        --json ${sample}_fastp.json \
        --html ${sample}_fastp.html \
        --thread 4
    """
}