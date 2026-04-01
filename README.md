# RNA-seq Pipeline — CAF Reprogramming (GSE280564)

A modular RNA-seq pipeline built with Nextflow DSL2 and Docker, analyzing transcriptomic differences between normal human fibroblasts (HUFs) and cancer-associated fibroblasts (CAFs) in ovarian cancer.

## Dataset
- **GEO Accession:** GSE280564
- **Samples:** 12 total — HUFs vs Kuramochi-conditioned CAFs (3 replicates each condition)
- **Sequencing:** Illumina NovaSeq 6000, paired-end, cDNA
- **Biology:** CAF reprogramming in ovarian cancer microenvironment

## Pipeline Steps
1. **FastQC** — raw read quality control
2. **Fastp** — adapter trimming and quality filtering
3. **STAR** — splice-aware alignment to GRCh38
4. **featureCounts** — gene-level read counting across all samples
5. **MultiQC** — aggregated QC report

## Tools and Containers
All tools run inside Docker containers from `quay.io/biocontainers`.

| Tool | Version | Container |
|------|---------|-----------|
| FastQC | 0.12.1 | `quay.io/biocontainers/fastqc:0.12.1--hdfd78af_0` |
| Fastp | 0.23.4 | `quay.io/biocontainers/fastp:0.23.4--h5f740d0_0` |
| STAR | 2.7.11a | `quay.io/biocontainers/star:2.7.11a--h0033a41_0` |
| Samtools | 1.19 | `quay.io/biocontainers/samtools:1.19--h50ea8bc_0` |
| featureCounts | 2.0.6 | `quay.io/biocontainers/subread:2.0.6--he4a0461_0` |
| MultiQC | 1.21 | `quay.io/biocontainers/multiqc:1.21--pyhdfd78af_0` |

## Project Structure
```
rnaseq-pipeline/
├── main.nf              # workflow logic
├── nextflow.config      # local and GCP profiles
├── modules/
│   ├── fastqc.nf
│   ├── fastp.nf
│   ├── star.nf
│   ├── featurecounts.nf
│   └── multiqc.nf
└── scripts/
    └── build_star_index.sh
```

## Usage

### Local testing (chr22 index, subsampled reads)
```bash
nextflow run main.nf -profile local
```

### Resume after failure
```bash
nextflow run main.nf -profile local -resume
```

### Full run on GCP (all 12 samples, full GRCh38)
```bash
nextflow run main.nf -profile gcp -resume
```

## Requirements

### Local
- Nextflow 25+
- Docker Desktop
- Java 17+

### GCP
- Google Cloud project with Batch and Storage APIs enabled
- GCS bucket: `gs://rnaseq-pipeline-490019-data`
- Full GRCh38 STAR index uploaded to GCS

## Reference
- Genome: GRCh38 (Ensembl release 113)
- Annotation: `Homo_sapiens.GRCh38.113.gtf`
- Local testing: chr22 only, 1M subsampled reads per sample via seqtk