use warnings;
use strict;
## Authors: Lewis HONG and ZHU O. Yuan
## Script Obtain_barcode.pl
## OBTAIN BARCODE-ASSOCIATED READS ONLY
## BARCODE-CONTAINING READS ARE ANCHORED BY A 20 BP BARCODE AND UNI-A SEQUENCE UP TO THE SBFI SITE
## Run as: perl Obtain_barcode.pl R1_001.fastq R2_001.fastq New_01_barcoded_R1.fastq New_01_barcoded.R2.fastq 20 CGAC

#assign variables
my$LEN=$ARGV[4];
my$CODE=$ARGV[5];
my$tracker=0; #variable tracking line number in entire fastq file
my%pas=(); #hash to store line information on passed reads
my$line_number=0; #variable tracking line number in each set of 4 lines
my$pass_filter=0; #tracks whether read being assessed passes required format
my($line1,$line2,$line3,$line4); #temporary storage for the 4 lines of fastq information for each read being assessed

open(OUT1,">$ARGV[3]"); #output barcoded_R2.fq
open(FASTA, $ARGV[1]); #input R2.fq
while(my$line=<FASTA>){
    $line_number++;
    $tracker++;
    if($line_number==1){$line1=$line;} #stores read header info
    if($line_number==2){
	if($line =~ /^([ATCGN]{$LEN})$CODE/){
	    #if read begins with a string of nucleotides 20bp long followed by the known barcode
	    $line2=$line; #store read sequence
	    $pass_filter=1; #note that read contains required barcode
	}
    }
    if($line_number==3){$line3=$line;} #stores "+"
    if($line_number==4){
	$line4=$line;
	if($pass_filter==1){
	#if read contains required barcode, print read to output file
	    print OUT1 "$line1$line2$line3$line4";
	    #store line numbers of passed reads
	    $pas{($tracker)}=1;$pas{($tracker-1)}=1;$pas{($tracker-2)}=1;$pas{($tracker-3)}=1;
	}
	#reset variables
	$line_number = 0;
	$pass_filter = 0;
    }	
}close(OUT1);

$tracker=0;
open(OUT2,">$ARGV[2]"); #output barcoded_R1.fq
open(FASTB, $ARGV[0]); #input R1.fq
while(my$line=<FASTB>){
	$tracker++;
	#retrieve mates of reads that contain required barcodes above
	if(defined $pas{$tracker}){print OUT2 "$line";}
}close(OUT2);
