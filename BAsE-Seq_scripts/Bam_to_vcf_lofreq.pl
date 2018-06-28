use warnings;
use strict;

##Author: Lewis HONG and ZHU O. Yuan
##Script name: Bam_to_vcf_lofreq.pl
##OBTAIN VCF FILES FROM BAM FILES
##Run as: perl $SCRIPTPATH/Bam_to_vcf_lofreq.pl $REFPATH $DATAPATH

my$REF=$ARGV[0]; #reference fasta for lofreq to call SNPs off of
my$DIRECTORY=$ARGV[1]; #path to sample files

system "mkdir $DIRECTORY/IndividualGenomes/lofreq_vcf/"; #creates new folder for vcf files
opendir(BAM, "sorted_bam_rmdup/"); #reads in sorted rmdup bams to lofreq caller
my @files = readdir(BAM);
foreach my $file (@files) {
	if ($file =~ /(\w+)_rmdup\.bam$/) {
		my $cmd = "lofreq call -D -f $REF sorted_bam_rmdup/$file -o lofreq_vcf/$1.vcf";
		print "SNP calling on $file with Lofreq\n";
		my @cmds = ("bash", "-c", $cmd);
		system (@cmds);
	}
}
