use warnings;
use strict;
### OBTAIN BARCODE-ASSOCIATED READS
### BARCODE-CONTAINING READS ARE ANCHORED BY A 20 BP BARCODE AND UNI-A SEQUENCE UP TO THE SBFI SITE
### perl ../lch_base_scripts/Obtain_barcode.pl R1_001.fastq R2_001.fastq New_01_barcoded_R1.fastq New_01_barcoded.R2.fastq

my$LEN=$ARGV[4];
my$CODE=$ARGV[5];
my$tracker=0;my%pas=();
my$line_number=0;
my$pass_filter=0;
my($line1,$line2,$line3,$line4);

open(OUT1,">$ARGV[3]"); #output file1
open(FASTA, $ARGV[1]);
while(my$line=<FASTA>){
    $line_number++;$tracker++;#print"$line_number\t$tracker\n";
    if($line_number==1){$line1=$line;}
    if($line_number==2){
	#print substr($line,20,4)."\n";#print "$line\n";
	if($line =~ /^([ATCGN]{$LEN})$CODE/){
	    #print "OK\n";
	    $line2=$line;
	    $pass_filter=1;
	    #print"$pass_filter\n";
	}
    }
    if($line_number==3){$line3=$line;}
    if($line_number==4){
	$line4=$line;
	if($pass_filter==1){
	    print OUT1 "$line1$line2$line3$line4";
	    $pas{($tracker)}=1;$pas{($tracker-1)}=1;$pas{($tracker-2)}=1;$pas{($tracker-3)}=1;
	}
	$line_number = 0;
	$pass_filter = 0;
    }	
}close(OUT1);

$tracker=0;
open(OUT2,">$ARGV[2]"); #output file2
open(FASTB, $ARGV[0]);
while(my$line=<FASTB>){
	$tracker++;
	if(defined $pas{$tracker}){print OUT2 "$line";}
}close(OUT2);
