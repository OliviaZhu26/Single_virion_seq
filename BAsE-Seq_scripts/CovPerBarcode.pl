use warnings;
use strict;

## Author: Lewis HONG and ZHU O. Yuan
## Script name: CovPerBarcode.pl
## Summarizes positions covered > X per barcode in a single output text file
## Run as: perl $SCRIPTPATH/CovPerBarcode.pl $DATAPATH $COVREQ

my$DIRECTORY=$ARGV[0];
my$CUTOFF=$ARGV[1];
my$OUTFILE=$DIRECTORY."/IndividualGenomes/Cov_per_barcode_".$CUTOFF.".txt"; #example:Cov_per_barcode_4.txt

open OUT,">> $OUTFILE" or die $!;
opendir(SAM, "$DIRECTORY/IndividualGenomes/pileup/");
my @files = readdir(SAM);
foreach my $file (@files) {
    if ($file =~ /pileup/) {
	my$count=0;
	open(R1,"IndividualGenomes/pileup/$file") or die;
	while(my$line=<R1>){	
	    #for each pileup file in directory summarize the number of positions with more than 4x coverage 
	    my@data=split('\t',$line);
	    if($data[3] > $CUTOFF){$count++;}
	}
	print OUT "$count\t$file\n";
    }
}

# example Cov_per_barcode_4.txt output (number_bases \t file_name)
# line 1//299	bc9051_sorted.pileup
# line 2//1363	bc3799_sorted.pileup 
