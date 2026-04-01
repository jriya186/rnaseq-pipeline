process MULTIQC {
    container 'quay.io/biocontainers/multiqc:1.21--pyhdfd78af_0'
    publishDir "${params.outdir}/multiqc", mode: 'copy'

    input:
    path collected_files

    output:
    path "multiqc_report.html", emit: report
    path "multiqc_data", emit: data

    script:
    """
    multiqc . 
    """
}