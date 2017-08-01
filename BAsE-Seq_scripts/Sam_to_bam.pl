use warnings;
use strict;

### CONVERT INDIVIDUAL GENOME ALIGNMENT FILES FROM SAM TO BAM
my$DIRECTORY=$ARGV[0];

system "mkdir $DIRECTORY/IndividualGenomes/bam";
opendir(SAM, "$DIRECTORY/IndividualGenomes/sam/");
my @files = readdir(SAM);
foreach my $file (@files) {
	if ($file =~ /(\w+)\.sam/) {
		my $cmd = "samtools view -buS $DIRECTORY/IndividualGenomes/sam/$file | samtools sort -  $DIRECTORY/IndividualGenomes/bam/$1_sorted";
		print "Processing $file\n";
		system $cmd;
	}
}
