use warnings;
use strict;

### CREATE A SAM FILE FOR CONCORDANT ALIGNMENTS ###

my $concordant;
my $discordant;
my $mapped;
my $count = 0;

open (SAM, "$ARGV[0]") or die; #input *_pf_bwa.sam
while (my $line = <SAM>) {
	if ($line =~ /(^@.*\n)/) {
		print "$line";
	}
	$count++;
	if ($line =~ /^.*?\t(\d+)\t/) {
		if ($1 == 99 || $1 == 147) { #if barcode is in read 2, read 1 should be in forward and read 2 should be in reverse
			print "$line";
		}
	}
}
close (SAM);

