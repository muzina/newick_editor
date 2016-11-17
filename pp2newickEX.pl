#!/usr/bin/perl -

#===============================================================================
##[[Information]]
# TITLE:	newick2pp.pl
# DESCRIPTION:	change newick format into pretty print
# VERSION:	2016/08/19
#
#[[Example]]
# reformat pretty-print file into newick 
#
#===============================================================================

#Encode and UserAgent
use utf8;
use Encode;
use Jcode;
my $enc_os = 'cp932'; #Windows
#my $enc_os = 'utf8'; #Unix
binmode STDIN, ":encoding($enc_os)";
binmode STDOUT, ":encoding($enc_os)";
binmode STDERR, ":encoding($enc_os)";

#variable
my $filename="null";
my $newname="null";
my $line="null";

#input file
print "Please input filename (with the extension)\n";
$filename = <STDIN>;
if ($filename =~ /\./) {
 $newname = $`;
} else {
print "Pleast input extension \n";
next;
}
if (!open(PP,"$filename")) { &error(bad_file); }
if (!open(NEWICK,">>$newname-newick.txt")) { &error(bad_file); }

while ($line=<PP>){
 chomp ($line);
 $line=~s/[0-9]{3}\t//g;
 $line=~s/ //g;
 $line=~s/\t//g;
 print NEWICK "$line";
}
close (NEWICK);
close (PP);
print "finished\n";
exit;
