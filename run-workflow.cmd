nextflow run nextflow/workflow_longReadRNASeq.nf -resume --reads "`$PWD`/fastq/SGNex_Hct116_directRNA_replicate3_run1.fastq.gz" --refFa "`$PWD`/reference/hg38_sequins_SIRV_ERCCs_longSIRVs.fa" --refGtf "'$PWD'/reference/hg38_sequins_SIRV_ERCCs_longSIRVs_v5_reformatted.gtf" --outdir "`$PWD`/results_full/"