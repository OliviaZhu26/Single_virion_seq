use warnings;
use strict;

##Author: Lewis HONG and ZHU O. Yuan
##Script name: Sam_to_bam.pl
##CONVERT INDIVIDUAL GENOME ALIGNMENT FILES FROM SAM TO BAM
##Run as: perl $SCRIPTPATH/Sam_to_bam.pl $DATAPATH

my$DIRECTORY=$ARGV[0];

system "mkdir $DIRECTORY/IndividualGenomes/bam";
opendir(SAM, "$DIRECTORY/IndividualGenomes/sam/");
my @files = readdir(SAM);
foreach my $file (@files) {
	if ($file =~ /(\w+)\.sam/) {
		#converts each individual sam to sorted bam in a new bam folder
		my $cmd = "samtools view -buS $DIRECTORY/IndividualGenomes/sam/$file | samtools sort -  $DIRECTORY/IndividualGenomes/bam/$1_sorted";
		print "Processing $file\n";
		system $cmd;
	}
}
