use warnings;
use strict;

my$REF=$ARGV[0];
my$DIRECTORY=$ARGV[1];

### OBTAIN VCF FILES FROM BAM FILES

#system "mkdir $DIRECTORY/IndividualGenomes/lofreq_vcf/";
opendir(BAM, "sorted_bam_rmdup/");
my @files = readdir(BAM);
foreach my $file (@files) {
	if ($file =~ /(\w+)_rmdup\.bam$/) {
		my $cmd = "lofreq call -D -f $REF sorted_bam_rmdup/$file -o lofreq_vcf/$1.vcf";
		print "Processing $file\n";
		my @cmds = ("bash", "-c", $cmd);
		system (@cmds);
	}
}
