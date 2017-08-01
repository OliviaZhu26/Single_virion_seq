#!/bin/sh
##BAsE-Seq command line sequence for data processing from fastq to single vision haplotypes  
##./Base_seq.sh parameter_file_from-desktop.txt

##reads in all necessary parameters for script
echo "Loading parameters from parameter_file.txt"
. ./$1

##extract read pairs with barcode at desired location
echo "Extracting fastq read pairs with barcodes"
perl $SCRIPTPATH/Obtain_barcode.pl $DATAPATH/$READ1 $DATAPATH/$READ2 $DATAPATH/$PREFX.barcoded_1.fastq $DATAPATH/$PREFX.barcoded_2.fastq $RNLEN $BARCD

##trims away adaptor sequences and headcrop removes barcode sequences, leaves only reads >20bp length
echo "Trimming adaptor sequences and low quality reads”
fastx_clipper -Q 33 -v -a 'ATGTCGAT' -i $DATAPATH/$PREFX.barcoded_1.fastq | fastx_clipper -Q 33 -v -a 'ATGCTGCCTGCAGG' -i - | java -jar -Djava.io.tmpdir=./tmp -Xmx2g trimmomatic-0.30.jar SE -threads 12 -phred33 /dev/stdin $DATAPATH/$PREFX.barcoded_1_clipped.fastq MINLEN:20 &
fastx_clipper -Q 33 -v -a 'CTGTCTCTTATAC' -i $DATAPATH/$PREFX.barcoded_2.fastq | java -jar -Djava.io.tmpdir=./tmp -Xmx2g trimmomatic-0.30.jar SE -threads 12 -phred33 /dev/stdin $DATAPATH/$PREFX.barcoded_2_clipped.fastq HEADCROP:28 MINLEN:15 &

##retrieve read pairs after trimming
echo "Retrieving read pairs post trimming"
perl $SCRIPTPATH/Obtain_pfreads.pl $DATAPATH/$PREFX.barcoded_1_clipped.fastq $DATAPATH/$PREFX.barcoded_2_clipped.fastq $DATAPATH/$PREFX.barcoded_1_clipped_pf.fastq $DATAPATH/$PREFX.barcoded_2_clipped_pf.fastq

##align fastq read pairs
echo  "BWA-mem Alignment"
bwa mem $REFPATH $DATAPATH/$PREFX.barcoded_1_clipped_pf.fastq $DATAPATH/$PREFX.barcoded_2_clipped_pf.fastq > $DATAPATH/$PREFX.sam
java -Djava.io.tmpdir=tmp -Xmx8g -jar SortSam.jar INPUT=2-139.sam OUTPUT=2-139.sorted.bam SORT_ORDER=coordinate

##optional steps
##echo  “Add groups”
##java -jar AddOrReplaceReadGroups.jar INPUT=$PREFX.sorted.dedup.bam OUTPUT=$PREFX.sorted.dedup.grouped.bam RGID= RGLB= RGPL= RGPU= RGSM=
##echo “Local realignment”
##java -jar GenomeAnalysisTK.jar -T RealignerTargetCreator -R $REFPATH -I $PREFX.sorted.dedup.bam -o $PREFX.sorted.dedup.grouped.intervals

##mark read duplicates
echo  "BWA-mem Alignment"
java -jar MarkDuplicates.jar INPUT=$PREFX.sorted.bam OUTPUT=$PREFX.sorted.dedup.bam METRICS_FILE=$PREFX_metrics.txt

##Filter sam file to keep only concordant alignments:
echo "Retrieve concordant reads"
perl $SCRIPTPATH/filter_sam.pl $DATAPATH/$PREFX.sam > $DATAPATH/$PREFX.filtered.sam

##Keep uniquely mapped reads (can use -bp to output bam file)
echo "Retrieve unique reads"
samtools view -q 1 -S  $DATAPATH/$PREFX.filtered.sam > $DATAPATH/$PREFX.filtered.unique.sam

echo "Processing Individual genomes"
##splits sam file into individual barcodes
perl $SCRIPTPATH/Split_sam.pl $DATAPATH/$PREFX.barcoded_2_clipped_pf.fastq $DATAPATH/$PREFX.barcoded_2.fastq $DATAPATH/$PREFX.filtered.unique.sam $READSPERBRCD $REFNAME $REFLEN

##Convert sam to bam, then sort:
perl $SCRIPTPATH/Sam_to_bam.pl $DATAPATH
perl $SCRIPTPATH/Sort_bam.pl $DATAPATH

echo "Calling SNPs"
##Remove read duplicates:
perl $SCRIPTPATH/Rmdup.pl $DATAPATH
##Create vcf files:
perl $SCRIPTPATH/Bam_to_vcf_lofreq.pl $REFPATH $DATAPATH

echo "Coverage Pileups"
perl $SCRIPTPATH/Bam_to_mpileup.pl $REFPATH $DATAPATH

echo "Pairs per sam"
perl $SCRIPTPATH/PairsPerBarcode.pl $DATAPATH

echo "Reads over 4x"
perl $SCRIPTPATH/CovPerBarcode.pl $DATAPATH $COVREQ

echo "Plot QC"
cp $SCRIPTPATH/Script.r $DATAPATH/
./Script.r