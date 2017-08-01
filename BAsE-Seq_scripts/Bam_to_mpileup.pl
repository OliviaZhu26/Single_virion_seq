use warnings;
use strict;

my$REF=$ARGV[0];
my$DIRECTORY=$ARGV[1];

### OBTAIN VCF FILES FROM BAM FILES

system "mkdir $DIRECTORY/IndividualGenomes/pileup/";
opendir(BAM, "$DIRECTORY/IndividualGenomes/sorted_bam_rmdup/");
my @files = readdir(BAM);
foreach my $file (@files) {
	if ($file =~ /(\w+)_rmdup\.bam/) {
		my $cmd = "samtools mpileup -f $REF $DIRECTORY/IndividualGenomes/sorted_bam_rmdup/$file > $DIRECTORY/IndividualGenomes/pileup/$1.pileup";
		print "Processing $file\n";
		my @cmds = ("bash", "-c", $cmd);
		system (@cmds);
	}
}
