use warnings;
use strict;

## Authors: Lewis HONG and ZHU O. Yuan
## Script filter_sam.pl
## CREATE A SAM FILE FOR CONCORDANT ALIGNMENTS
## Run as: perl $SCRIPTPATH/filter_sam.pl $DATAPATH/$PREFX.sam > $DATAPATH/$PREFX.filtered.sam

open (SAM, "$ARGV[0]") or die;
while (my $line = <SAM>) {
	if ($line =~ /(^@.*\n)/) {
		print "$line"; #print all sam header lines
	}
	if ($line =~ /^.*?\t(\d+)\t/) {
		if ($1 == 99 || $1 == 147) { #if barcode is in read 2, read 1 should be in forward and read 2 should be in reverse
			print "$line"; #print only concordant alignments
		}
	}
}
close (SAM);

