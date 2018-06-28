#!/user/bin/perl
use warnings;
use strict;

##Author: ZHU O. Yuan (Genome Institute of Singapore)
##Script name: 02_chrom_select_out.pl
##selects best match genotype reference from a list 
##Run as: perl $scriptpath/02_chrom_select_out.pl 02_mismatches.txt > 03_best_match_chroms.txt

my%simi=();my$ref="";
open(TXT, $ARGV[0]);
while(<TXT>){
    my$line=$_; chomp $line;
    my@reads=split('\t',$line);
    #stores all mismatch values for all genotypes
    if(defined $reads[1]){$simi{$ref}=$reads[0];}
    else{$ref=$reads[0];}
}close(TXT);

#prints out the lowest mismatch genotype
my$lowest=1;
foreach my $key (keys %simi){
    if($simi{$key}<$lowest){$lowest=$simi{$key};}
}
foreach my $key2 (keys %simi){
    if($simi{$key2} <= $lowest){print $key2."\t".$simi{$key2}."\n";}
}
