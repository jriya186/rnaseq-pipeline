#!/usr/bin/env nextflow
nextflow.enable.dsl=2

// Parameters
params.reads       = "$projectDir/data/test/*_{1,2}.fastq"
params.outdir      = "$projectDir/results"
params.star_index  = "$projectDir/reference/star_index"
params.gtf         = "$projectDir/reference/Homo_sapiens.GRCh38.113.gtf"

// Import modules
include { FASTQC } from './modules/fastqc'
include { FASTP } from './modules/fastp'
include { STAR } from './modules/star'
include { FEATURECOUNTS } from './modules/featurecounts'
include { MULTIQC } from './modules/multiqc'

// Workflow

workflow{
    // Create channel from paired-end reads
    reads_ch = Channel.fromFilePairs(params.reads, checkIfExists: true)

    // Run FastQC
    FASTQC(reads_ch)

    // Run Fastp trimming
    FASTP(reads_ch)

    // Run STAR alignment on trimmed reads
    STAR(FASTP.out.trimmed_reads, params.star_index)

    // Run featureCounts on all BAMs at once
    FEATURECOUNTS(STAR.out.bam.map { sample_id, bam -> bam }.collect(), params.gtf)

    // Collect all QC files and run MultiQC
    multiqc_input = FASTQC.out.map { sample_id, html, zip -> html }
        .mix(FASTQC.out.map { sample_id, html, zip -> zip })
        .mix(FASTP.out.json)
        .mix(STAR.out.log)
        .mix(FEATURECOUNTS.out.summary)
        .collect()
    
    MULTIQC(multiqc_input)

}