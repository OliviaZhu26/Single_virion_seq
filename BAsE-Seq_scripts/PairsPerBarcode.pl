use warnings;
use strict;

### Read pairs per barcode
my$DIRECTORY=$ARGV[0];

opendir(SAM, "$DIRECTORY/IndividualGenomes/sam/");
my @files = readdir(SAM);
foreach my $file (@files) {
	if ($file =~ /(\w+)\.sam/) {
		my $cmd = "wc -l $DIRECTORY/IndividualGenomes/sam/$file >> $DIRECTORY/IndividualGenomes/ReadPairsPerSam.txt";
		system $cmd;
	}
}



