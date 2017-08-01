use warnings;
use strict;

### REMOVE DUPLICATES FROM INDIVIDUAL GENOMES
my$DIRECTORY=$ARGV[0];

system "mkdir $DIRECTORY/IndividualGenomes/sorted_bam_rmdup";
opendir(SAM, "$DIRECTORY/IndividualGenomes/bam/");
my @files = readdir(SAM);
foreach my $file (@files) {
	if ($file =~ /(\w+)_sorted\.bam/) {
		my $cmd = "samtools rmdup $DIRECTORY/IndividualGenomes/bam/$file $DIRECTORY/IndividualGenomes/sorted_bam_rmdup/$1_rmdup.bam";
		print "Processing $file\n";
		system $cmd;
	}
}



