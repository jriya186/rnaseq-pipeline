#!/bin/bash
# Build STAR index for chr22 (local testing)
# Full GRCh38 index will be built on GCP

docker run \
    # Force Intel architecture emulation on Apple Silicon Mac
    --platform linux/amd64 \
    # Mount local reference/ folder into container at /reference
    -v ~/rnaseq-pipeline/reference:/reference \
    # STAR container image from biocontainers
    quay.io/biocontainers/star:2.7.11a--h0033a41_0 \
    STAR \
    # Tell STAR to build an index, not align reads
    --runMode genomeGenerate \
    # Where to write the index files
    --genomeDir /reference/star_index \
    # chr22 FASTA to index
    --genomeFastaFiles /reference/Homo_sapiens.GRCh38.dna.chromosome.22.fa \
    # GTF annotation for splice junction database
    --sjdbGTFfile /reference/Homo_sapiens.GRCh38.113.gtf \
    # Adjusted for small genome (chr22 only). Use 14 for full GRCh38
    --genomeSAindexNbases 11 \
    # Number of CPU cores to use
    --runThreadN 4