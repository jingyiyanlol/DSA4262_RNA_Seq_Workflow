# DSA4262_RNA_Seq_Workflow
Individual project to implement a complete long read RNA-Seq pipeline using a workflow management system

The workflow performs the following steps:

1. Alignment with Minimap2
2. sam to bam conversion with samtools
3. transcript discovery and quantification with Bambu

The following files should be used as input and returned as output from the workflow:

* Input: fastq file, fa file, gtf file

* Output: bam file (aligned sequences), gtf file (extended annotations), read counts (1 for transcripts 1 for genes)

# Steps to reproduce results
## Step 1: Install Softwares Required 

One can run the following command to excute the bash script for sofware download:
```bash
source download-software.cmd
```

Alternatively, one can follow the instructions from this [website](https://www.nextflow.io/blog/2021/setup-nextflow-on-windows.html) to set up the dependencies needed for Nextflow

## Step 2: Download the NextFlow Script from dropbox/ Use the Nextflow in this Repository
Download the Nextflow script from drop box by run the following command:
```bash
rm nextflow/*
wget https://www.dropbox.com/s/tu0c367dh0bsw6z/workflow_longReadRNASeq.nf -P nextflow/
```

## Step 3: Download the Full Dataset using AWS CLI
Run the following commands to download reference genome files:
```bash
aws s3 cp --no-sign-request s3://sg-nex-data/data/annotations/genome_fasta/hg38_sequins_SIRV_ERCCs_longSIRVs.fa reference/
aws s3 cp --no-sign-request s3://sg-nex-data/data/annotations/genome_fasta/hg38_sequins_SIRV_ERCCs_longSIRVs.fa.fai reference/
aws s3 cp --no-sign-request s3://sg-nex-data/data/annotations/gtf_file/hg38_sequins_SIRV_ERCCs_longSIRVs_v5_reformatted.gtf reference/
```
Run the following commands to download RNA sample fasq file to compare against referencce genom:
```bash
aws s3 cp --no-sign-request s3://sg-nex-data/data/sequencing_data_ont/fastq/SGNex_Hct116_directRNA_replicate3_run1/SGNex_Hct116_directRNA_replicate3_run1.fastq.gz fastq/
```

## Step 4: Run the workflow using command in script
Run the following command:
```bash
source run-workflow.cmd
```
**As it will take very long for the workflow to run on a local computer, I have decided to run the workflow on a smaller dataset.**

Bash commands to download smaller dataset:
```bash
mkdir -p workshop/reference
mkdir workshop/fastq
mkdir workshop/nextflow
```
```bash
aws s3 cp --no-sign-request s3://sg-nex-data/data/data_tutorial/annotations/hg38_chr22.fa workshop/reference/
aws s3 cp --no-sign-request s3://sg-nex-data/data/data_tutorial/annotations/hg38_chr22.fa.fai workshop/reference/
aws s3 cp --no-sign-request s3://sg-nex-data/data/data_tutorial/annotations/hg38_chr22.gtf workshop/reference/

aws s3 sync --no-sign-request s3://sg-nex-data/data/data_tutorial/fastq/ workshop/fastq/
```

Commands to run the workflow on small dataset:
```bash
nextflow run nextflow/workflow_longReadRNASeq.nf -resume \
      --reads $PWD/workshop/fastq/A549_directRNA_sample2.fastq.gz \
      --refFa $PWD/workshop/reference/hg38_chr22.fa \
      --refGtf $PWD/workshop/reference/hg38_chr22.gtf \
      --outdir $PWD/workshop/results/
```

## Step 5: Getting insights from Bambu output for full dataset
Run the following commands to download the Bambu output for full dataset:

1. Download Bam file for full dataset from AWS S3:
```bash
aws s3 cp --no-sign-request s3://sg-nex-data/data/sequencing_data_ont/bam/genome/SGNex_Hct116_directRNA_replicate3_run1/SGNEX_Hct116_directRNA_replicate3_run1.bam bam/     
```

2. Run the [R file](https://github.com/jingyiyanlol/DSA4262_RNA_Seq_Workflow/RNA_Seq_Analysis.R) / [Rmd file](https://github.com/jingyiyanlol/DSA4262_RNA_Seq_Workflow/RNA_Seq_Analysis.Rmd) in Rstudio. The [knitted HTML file](https://github.com/jingyiyanlol/DSA4262_RNA_Seq_Workflow/RNA_Seq_Analysis.html) from the Rmd file is also included in the repository.


#### **Additional information:**

- Example workflows are available here: https://github.com/GoekeLab/bioinformatics-workflows

- Wratten, L., Wilm, A. & Göke, J. Reproducible, scalable, and shareable analysis pipelines with bioinformatics workflow managers. Nature Methods (2021). https://doi.org/10.1038/s41592-021-01254-9 (Full text link: https://rdcu.be/cyjRN)

- nf-core hosts nextflow pipelines: https://nf-co.re/. The nf-core project is describes in this publication: Ewels, Philip A., et al. "The nf-core framework for community-curated bioinformatics pipelines." Nature Biotechnology 38.3 (2020): 276-278. (Full text link: https://rdcu.be/b1GjZ)

- The SG-NEx data is available through AWS S3. Data access is described here: https://github.com/GoekeLab/sg-nex-data

- The SG-Nex project is described in this publication: Chen, Ying, et al. "A systematic benchmark of Nanopore long read RNA sequencing for transcript level analysis in human cell lines." bioRxiv (2021). doi: https://doi.org/10.1101/2021.04.21.440736
