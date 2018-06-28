use warnings;
use strict;
## Authors: Lewis HONG and ZHU O. Yuan
## Script Obtain_pfreads.pl
## OBTAIN BARCODE-CONTAINING READ-PAIRS THAT SURVIVED TRIMMING
## Can probably be skipped if a trimmer that only output paired reads was used
## Run as: perl $SCRIPTPATH/Obtain_pfreads.pl $DATAPATH/$PREFX.barcoded_1_clipped.fastq $DATAPATH/$PREFX.barcoded_2_clipped.fastq $DATAPATH/$PREFX.barcoded_1_clipped_pf.fastq $DATAPATH/$PREFX.barcoded_2_clipped_pf.fastq

#stores all read IDs for read 1 in hash %pf
my$line_number=0;my%pf;
open(R1,"$ARGV[0]")or die; #input R1_clipped3.fastq
while(my$line=<R1>){
	$line_number++;
 	if($line_number==1 && $line =~ /^(@.+?)\s/){$pf{$1}++;}
	if($line_number==4){$line_number=0;}
}close (R1);

#stores read IDs for read 2 in hash %pf only if matching read 1 is already stored
#print read 2 information if so
my$pass_filter=0;$line_number=0; #define required variables
my($line1,$line2,$line3,$line4); #stores 4 lines of information for each read being processed
open(READ2,">$ARGV[3]");
open(R2,"$ARGV[1]")or die; #input R2_clipped2.fastq
while (my $line = <R2>){$line_number++;
 	if($line_number==1 && $line=~/^(@.+?)\s/){
		$pf{$1}++;
		#if both reads from a pair survive, note for output
		if($pf{$1}==2){$line1=$line;$pass_filter=1;}
	}
	if($line_number==2){$line2=$line;}
	if($line_number==3){$line3=$line;}
	if($line_number==4){$line4=$line;
		if ($pass_filter==1) {
			#if noted for output, print read information to output file and reset variables
			print READ2 "$line1$line2$line3$line4";
			$pass_filter=0;
		}$line_number=0;
	}
}close (R2);

#retrieves read 1 information for printed read 2s for output
my$count;$pass_filter=0;$line_number=0;
open(READ1,">$ARGV[2]");
open(R1,"$ARGV[0]")or die;
while(my$line=<R1>){$line_number++;
 	if ($line_number==1&&$line=~/^(@.+?)\s/) {
		#if both reads from a pair survived, note for output
		if($pf{$1}==2){$line1=$line;$pass_filter=1;}
	}
	if($line_number==2){$line2=$line;}
	if($line_number==3){$line3=$line;}
	if($line_number==4){$line4=$line;
		if($pass_filter==1){
			#if noted for output, print read information to output file and reset variables
			print READ1 "$line1$line2$line3$line4";
			$pass_filter=0;$count++;
		}$line_number=0;
	}
}close (R1);

print "$count pass-filter read-pairs\n";
