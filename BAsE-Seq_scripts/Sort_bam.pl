use warnings;
use strict;

### SORT INDIVIDUAL GENOME BAM FILES 

my$DIRECTORY=$ARGV[0];

system "mkdir $DIRECTORY/IndividualGenomes/sorted_bam";
opendir(BAM, "$DIRECTORY/IndividualGenomes/bam/");
my @files = readdir(BAM);
foreach my $file (@files) {
	if ($file =~ /(\w+)\.bam/) {
		my $cmd = "samtools sort $DIRECTORY/IndividualGenomes/bam/$file $DIRECTORY/IndividualGenomes/sorted_bam/$1_sorted";
		print "Processing $file\n";
		system $cmd;
	}
}
