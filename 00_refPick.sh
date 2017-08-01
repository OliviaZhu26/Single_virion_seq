##!/usr/bin/bash

##command: ./refPick.sh fastq_file.list ref_genomes.list data_directory/

fastqs="$1"
cat $fastqs | while read line
do
head -4000 $line > $line.subreads.fastq
done

filename="$2"
path="$3"
#echo $filename
var=$(wc -l $path/$filename | awk '{print $1}')
echo $var' reference genomes detected'

echo "new run" > 01_mapped-reads.txt
echo "new run" > 02_mismatches.txt
cat $path/$filename | while read line
#for every genome
do
    files=$(ls | grep 'subreads.fastq' | tr '\n' ' ')
    #echo $path/$filename $files
    bwa mem $path/$line $files > aln-pe.$line.sam
    samtools view -Sb aln-pe.$line.sam > aln-pe.$line.bam
    samtools sort aln-pe.$line.bam aln-pe.$line.sorted 
    samtools index aln-pe.$line.sorted.bam
    echo $line >> 01_mapped-reads.txt
    echo $line >> 02_mismatches.txt
    samtools view -F 0x40 aln-pe.$line.sorted.bam | cut -f1 | sort | uniq | wc -l >> 01_mapped-reads.txt
    samtools mpileup -f $path/$line aln-pe.$line.sorted.bam > aln-pe.$line.sorted.pileup
    perl $path/01_chrom_select_variants.pl aln-pe.$line.sorted.pileup >> 02_mismatches.txt
    perl $path/02_chrom_select_out.pl mismatches.txt > 03_best_match_chroms.txt
    rm aln-pe.$line.sam
    rm aln-pe.$line.bam
done
