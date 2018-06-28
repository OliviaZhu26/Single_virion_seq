##!/usr/bin/bash

##Author: ZHU O. Yuan (Genome Institute of Singapore)
##Script used in manuscript <Single-virion sequencing of lamivudine-treated HBV populations reveal population evolution dynamics and demographic history> doi:10.1186/s12864-017-4217-1
##Script name: 00_refPick.sh

##This script subsamples 1000 reads (change at will according to genome size) from each fastq file and maps them to each included reference
##Skip this script if best match genotype for the sample is known
##Outputs files 01_mapped-reads.txt 02_mismatches.txt and 03_best_match_chroms.txt
##01_mapped-reads.txt: 
##Written for ~3.2kb HBV genomes to identify best match reference genotype. Not tested on other species or optimized for speed. 

##Required software: bwa, samtools
##Calls scripts: 01_chrom_select_variants.pl 02_chrom_select_out.pl 

#run command from folder containing fastq files as follows
#00_refPick.sh fastq_file.list ref_genomes.list directory_containing_reference_fastas directory_containing_scripts

#sample fastq_file.list looks something like this (Only for fastq files belonging to the same sample. Do not mix samples).
#line 1//sample_file1.fq
#line 2//sample_file2.fq

#sample ref_genomes.list looks something like this
#line 1//HBV_genotypeA.fa
#line 2//HBV_genotypeB.fa ...etc

#subsample reads from each fastq for rapid mapping to candidate references
fastqs="$1"
cat $fastqs | while read line
do
head -4000 $line > $line.subreads.fastq ##modify number of subsampled reads here if necessary
done

#checks the number of candidate genomes (just a sanity check)
filename="$2"
path="$3"
var=$(wc -l $path/$filename | awk '{print $1}')
echo $var' reference genomes detected'

#maps every sub-samples fastq to every reference genome
echo "new run" > 01_mapped-reads.txt
echo "new run" > 02_mismatches.txt
scriptpath="$4"
cat $path/$filename | while read line
do
    files=$(ls | grep 'subreads.fastq' | tr '\n' ' ')
    bwa mem $path/$line $files > aln-pe.$line.sam 
    samtools view -Sb aln-pe.$line.sam > aln-pe.$line.bam
    samtools sort aln-pe.$line.bam aln-pe.$line.sorted 
    #sort and convert to bam (can be merged into one command {bwa mem | samtools view | samtools sort} if intermediate sam file is not necessary for visual checks) 
    samtools index aln-pe.$line.sorted.bam
    echo $line >> 01_mapped-reads.txt
    echo $line >> 02_mismatches.txt
    samtools view -F 0x40 aln-pe.$line.sorted.bam | cut -f1 | sort | uniq | wc -l >> 01_mapped-reads.txt
    samtools mpileup -f $path/$line aln-pe.$line.sorted.bam > aln-pe.$line.sorted.pileup
    #calls perl script to summarize number of mismatches against each genotype reference
    perl $scriptpath/01_chrom_select_variants.pl aln-pe.$line.sorted.pileup >> 02_mismatches.txt 
    rm aln-pe.$line.sam
    rm aln-pe.$line.bam
done
#summarizes best match reference
perl $scriptpath/02_chrom_select_out.pl 02_mismatches.txt > 03_best_match_chroms.txt

# example 01_mapped-reads.txt output (number of reads mapped to each candidate reference)
# line 1// new run
# line 2// GenotypeA.fasta
# line 3// 1000
# line 4// GenotypeB.fasta
# line 5// 1000
# ...

# example 02_mismatches.txt output (% mismatch, count mismatch, number of mapped bases)
# line 1// new run
# line 2// GenotypeA.fasta
# line 3// 0.076151  167 2193
# line 4// GenotypeB.fasta
# line 5// 0.083928  188 2240
# ...

# example 03_best_match_chroms.txt output
# line 1// GenotypeC.fasta 0.0200655 
