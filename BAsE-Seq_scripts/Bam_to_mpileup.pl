use warnings;
use strict;

## Author: Lewis HONG and ZHU O. Yuan
## Script name: Bam_to_mpileup.pl
## OBTAIN PILEUP FILES FROM BAM FILES
## Run as: perl $SCRIPTPATH/Bam_to_mpileup.pl $REFPATH $DATAPATH

my$REF=$ARGV[0];
my$DIRECTORY=$ARGV[1];

system "mkdir $DIRECTORY/IndividualGenomes/pileup/"; #creates new folder for pileup files
opendir(BAM, "$DIRECTORY/IndividualGenomes/sorted_bam_rmdup/"); 
my @files = readdir(BAM);
foreach my $file (@files) {
	if ($file =~ /(\w+)_rmdup\.bam/) {
		#creating pileup file from bam
		my $cmd = "samtools mpileup -f $REF $DIRECTORY/IndividualGenomes/sorted_bam_rmdup/$file > $DIRECTORY/IndividualGenomes/pileup/$1.pileup";
		print "Creating pileup for $file\n";
		my @cmds = ("bash", "-c", $cmd);
		system (@cmds);
	}
}
