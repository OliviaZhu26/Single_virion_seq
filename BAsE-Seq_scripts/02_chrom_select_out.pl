#!/user/bin/perl
use warnings;
use strict;
#open OUT, "> $ARGV[1]" or die("Couldn't open $ARGV[1]\n");

my%simi=();my$ref="";
open(TXT, $ARGV[0]);
while(<TXT>){
    my$line=$_; chomp $line;
    my@reads=split('\t',$line);
    if(defined $reads[1]){$simi{$ref}=$reads[0];}
    else{$ref=$reads[0];}
}close(TXT);

my$lowest=1;
foreach my $key (keys %simi){
    if($simi{$key}<$lowest){$lowest=$simi{$key};}
}
foreach my $key2 (keys %simi){
    if($simi{$key2} <= $lowest){print $key2."\t".$simi{$key2}."\n";}
}
