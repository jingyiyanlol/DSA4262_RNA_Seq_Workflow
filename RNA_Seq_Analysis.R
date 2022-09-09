#######################
# Install BAMBU for R #
#######################
if (!require("BiocManager", quietly = TRUE))
    install.packages("BiocManager")

BiocManager::install("bambu", update = FALSE)

########################################
# Output Transcript Discovery Findings #
########################################

library(bambu)
library(dplyr)

# Read in datasets downloaded from S3
fa.file <- 'reference/hg38_sequins_SIRV_ERCCs_longSIRVs.fa'
gtf.file <- 'reference/hg38_sequins_SIRV_ERCCs_longSIRVs_v5_reformatted.gtf'
reads_bam <- 'bam/SGNex_Hct116_directRNA_replicate3_run1.bam'

# create a reference annotation to be used as input for bambu function
annotations <- prepareAnnotations(gtf.file)  

se <- bambu(reads = reads_bam, annotations = annotations, genome = fa.file, ncore = 4)  
se

show(assays(se)) #returns the transcript abundance estimates as counts or CPM.
show(head(assays(se)$counts))

rowData(se) # returns additional information about each transcript such as the gene name and the class of the newly discovered transcript.

rowRanges(se) # returns a GRangesList (with genomic coordinates) with all annotated and newly discovered transcripts.

show(table(mcols(se)$newTxClass))
show(which((mcols(se)$newTxClass)=='newGene-spliced'))
show(rowRanges(se)[which((mcols(se)$newTxClass)=='newGene-spliced')[1]])

writeBambuOutput(se, path = "./output/")

##########################################
# Number of novel transcripts discovered #
##########################################

# method 1: Count number of genes in se with the newTxClass not annotated
length(which((mcols(se)$newTxClass)!='annotation'))

# method 2: Using transcripts_counts from output and filter TXNAME
transcripts_counts <- as.data.frame(read.table(file = "output/counts_transcript.txt", header = TRUE))
transcripts_counts <- data.frame(TXNAME = transcripts_counts$TXNAME, GENEID = transcripts_counts$GENEID, TX_EXPR = transcripts_counts$SGNex_Hct116_directRNA_replicate3_run1)
# List of novel_transcripts
novel_transcripts <- transcripts_counts[grepl("tx.", transcripts_counts$TXNAME),] 
novel_transcripts
# Count number of rows
nrow(novel_transcripts)

#######################################################################################

#################################
# 5 most highly expressed genes #
#################################
# read in output gene count table and sort in descending order to find top 5 most expressive genes
gene_counts <- as.data.frame(read.table(file = "output/counts_gene.txt", header = TRUE))
gene_counts <- data.frame(gene = row.names(gene_counts), counts = gene_counts$SGNex_Hct116_directRNA_replicate3_run1)

gene_counts_desc <- gene_counts %>% group_by(gene) %>% arrange(desc(counts))
head(gene_counts_desc, n=5)

#######################################################################################

########################################################
# Min, Max, Average number of transcripts of each gene #
########################################################
transcripts_counts_table <- aggregate(cbind(TRANSCRIPT_COUNT = TX_EXPR) ~ GENEID, data = transcripts_counts, FUN = function(x){NROW(x)}) %>%
  arrange(desc(TRANSCRIPT_COUNT))
summary(transcripts_counts_table)

#######################################################################################
