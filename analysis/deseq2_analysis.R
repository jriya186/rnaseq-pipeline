library(DESeq2)
library(tidyverse)
library(pheatmap)
library(RColorBrewer)
library(ggrepel)
library(EnhancedVolcano)
library(org.Hs.eg.db)
library(AnnotationDbi)

# Loading counts matrix
counts <- read.table("~/rnaseq-pipeline/results/featurecounts/counts_matrix.txt",
                     header = TRUE,
                     skip = 1,
                     row.names = 1)
dim(counts)
colnames(counts)

# cleaning matrix
count_matrix <- counts[, 6:17]
colnames(count_matrix) <- gsub("\\.Aligned\\.sortedByCoord\\.out\\.bam", "", colnames(count_matrix))
colnames(count_matrix)

# Creating metadata 
metadata <- data.frame(
  sample = colnames(count_matrix),
  condition = c("HUF", "Kuramochi_CAF", "Primary_CAF", 
                "SKOV3_CAF", "SKOV3_CAF", "SKOV3_CAF",
                "Kuramochi_CAF", "Primary_CAF", "Primary_CAF",
                "HUF", "HUF", "Kuramochi_CAF"),
  row.names = colnames(count_matrix)
)

# Setting HUF as reference level
metadata$condition <- factor(metadata$condition,
                             levels = c("HUF","Kuramochi_CAF", "Primary_CAF","SKOV3_CAF"))
table(metadata$condition)

# DESeq2 object
dds<- DESeqDataSetFromMatrix(countData=count_matrix,
                             colData = metadata,
                             design = ~ condition)
dds <- DESeq(dds)

resultsNames(dds)

kuramochi_res <- results(dds,
                         name = "condition_Kuramochi_CAF_vs_HUF",
                         alpha = 0.05)
primary_res <- results(dds,
                       name = "condition_Primary_CAF_vs_HUF",
                       alpha = 0.05)
skov3_res <- results(dds,
                     name = "condition_SKOV3_CAF_vs_HUF",
                     alpha = 0.05)

summary(kuramochi_res)
summary(primary_res)
summary(skov3_res)

# Converting to dataframes
kuramochi_df <- as.data.frame(kuramochi_res)
primary_df <- as.data.frame(primary_res)
skov3_df <- as.data.frame(skov3_res)

# Adding gene symbols to all three
kuramochi_df$symbol <- mapIds(org.Hs.eg.db,
                              keys = rownames(kuramochi_df),
                              column = "SYMBOL",
                              keytype = "ENSEMBL",
                              multiVals = "first")

primary_df$symbol <- mapIds(org.Hs.eg.db,
                            keys = rownames(primary_df),
                            column = "SYMBOL",
                            keytype = "ENSEMBL",
                            multiVals = "first")

skov3_df$symbol <- mapIds(org.Hs.eg.db,
                          keys = rownames(skov3_df),
                          column = "SYMBOL",
                          keytype = "ENSEMBL",
                          multiVals = "first")

# Checking top genes for kuramochi
head(kuramochi_df[order(kuramochi_df$padj), c("symbol", "log2FoldChange", "padj")])





