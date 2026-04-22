#!/usr/bin/env nextflow
nextflow.enable.dsl=2

params.reads       = "$projectDir/data/test/*_{1,2}.fastq"
params.outdir      = "$projectDir/results"
params.star_index  = "$projectDir/reference/star_index"
params.gtf         = "$projectDir/reference/Homo_sapiens.GRCh38.113.gtf"
params.samplesheet = "$projectDir/samplesheet.csv"
params.mode        = "local"

include { FASTQC }        from './modules/fastqc'
include { FASTP }         from './modules/fastp'
include { STAR }          from './modules/star'
include { FEATURECOUNTS } from './modules/featurecounts'
include { MULTIQC }       from './modules/multiqc'
include { SRA_FETCH }     from './modules/sra_fetch'

workflow {
    if (params.mode == "gcp") {
        sample_ch = Channel
            .fromPath(params.samplesheet)
            .splitCsv(header: true)
            .map { row -> tuple(row.sample, row.srr, row.condition) }

        SRA_FETCH(sample_ch)
        reads_ch = SRA_FETCH.out

    } else {
        reads_ch = Channel
            .fromFilePairs(params.reads, checkIfExists: true)
            .map { sample_id, files ->
                tuple(sample_id, "unknown", files.get(0), files.get(1))
            }
    }

    FASTQC(reads_ch)
    FASTP(reads_ch)
    STAR(FASTP.out.trimmed_reads, params.star_index)
    FEATURECOUNTS(STAR.out.bam.map { sample, condition, bam -> bam }.collect(), params.gtf)

    multiqc_input = FASTQC.out.reports.map { sample, condition, html, zip -> [html, zip] }
        .flatten()
        .mix(FASTP.out.json)
        .mix(STAR.out.log)
        .mix(FEATURECOUNTS.out.summary)
        .collect()

    MULTIQC(multiqc_input)
}