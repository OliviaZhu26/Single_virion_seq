use warnings;
use strict;

##Author: Lewis HONG and ZHU O. Yuan
##Script name: PairsPerBarcode.pl
## Summarize final read pairs per barcode
## Run as: perl $SCRIPTPATH/PairsPerBarcode.pl $DATAPATH

my$DIRECTORY=$ARGV[0];

opendir(SAM, "$DIRECTORY/IndividualGenomes/sam/");
my @files = readdir(SAM);
foreach my $file (@files) {
	if ($file =~ /(\w+)\.sam/) {
		my $cmd = "wc -l $DIRECTORY/IndividualGenomes/sam/$file >> $DIRECTORY/IndividualGenomes/ReadPairsPerSam.txt";
		system $cmd;
	}
}

# example ReadPairsPerSam.txt output (sam_lines \t file_name)
# line 1//435	$PATH/IndividualGenomes/sam/bc8763.sam
# line 2//9087	$PATH/IndividualGenomes/sam/bc370.sam 
