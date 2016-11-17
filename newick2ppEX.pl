#!/usr/bin/perl -

#===============================================================================
#
#[[Information]]
# TITLE:	newick2pp.pl
# DESCRIPTION:	change newick format into pretty print
# VERSION:	2016/08/19
#
#[[Example]]
#
# *input:
# (((A:0.00001,B:0.00002)99:0.00006,(C:0.00003,D:0.00004)94:0.00007)94:0.00008,E:0.00005)100:0.00009;
#
# *outputA:
#000	(
#001	 (
#002	  (
#003	   A:0.00001
#003	   ,
#003	   B:0.00002
#002	  )99:0.00006
#002	  ,
#002	  (
#003	   C:0.00003
#003	   ,
#003	   D:0.00004
#002	  )94:0.00007
#001	 )94:0.00008
#001	 ,
#001	 E:0.00005
#000	)100:0.00009;
#
# *outputB:
# (
#  (
#   A:0.00001
#   ,
#   B:0.00002
#  )99:0.00006
#  ,
#  (
#   C:0.00003
#   ,
#   D:0.00004
#  )94:0.00007
# )94:0.00008
# ,
# E:0.00005
#)100:0.00009;
#
#[[Disclaimer]]
# * The limitation of depth is 999.
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
my $line="null";
my @mozi="null";
my $char="null";
my $maxmozicount=0;
my $mozicount=0;
my $kaiso=0;
my $padkaiso="000";
my $mono="\t";#indent monomer
my $indent="";
my $currentmozi="null";
my $filename="null";
my $newname="null";
my $kaisoadd="null";
my $startcount=0;
my $endcount=0;

#input file
print "Please input filename (with the extension)\n";
$filename = <STDIN>;
if ($filename =~ /\./) {
 $newname = $`;
} else {
print "Pleast input extension \n";
next;
}
if (!open(NEWICK,"$filename")) { &error(bad_file); }
if (!open(RESULT,">>$newname-result.txt")) { &error(bad_file); }

#check depth output
until($kaisoadd eq "y" or $kaisoadd eq "n"){
 print "Do you need the depth information ? (y/n)\n";
 $kaisoadd = <STDIN>;
 chomp($kaisoadd); 
}

#main
while($line=<NEWICK>){
 chomp($line);
 @mozi=split(//,$line);
 $maxmozicount=@mozi;
 if($kaisoadd eq "y"){
  print RESULT "$padkaiso\t";
 }
 while($mozicount < $maxmozicount){
  $currentmozi=$mozi[$mozicount];

  if ($currentmozi eq "\(") {
   $startcount++;
   $kaiso++;
   $padkaiso = sprintf("%03d",$kaiso);
   $indent="$indent"."$mono";
   if($kaisoadd eq "y"){
   print RESULT "\(\n$padkaiso\t$indent";
   }else{
   print RESULT "\(\n$indent";
   }
  }

  elsif ($currentmozi eq "\)") {
   $endcount++;
   $kaiso=$kaiso-1;
   $padkaiso = sprintf("%03d",$kaiso);
   chop($indent);
   if($kaisoadd eq "y"){
    print RESULT "\n$padkaiso\t$indent\)";
   }else{
    print RESULT "\n$indent\)";
   }
  }

  elsif ($currentmozi eq "\,") {
   $padkaiso = sprintf("%03d",$kaiso);
   if($kaisoadd eq "y"){
    print RESULT "\,\n$padkaiso\t$indent";
   }else{
    print RESULT "\,\n$indent";
   }
  }

  else {
   print RESULT "$currentmozi";
  }

  $mozicount++;

  if ($kaiso == 1000) {
   print "ERROR! TOO MUCH NODES!\n";
   exit;
  }

 }

}

close (NEWICK);
close (RESULT);
print "number of \( \: $startcount\n";
print "number of \) \: $endcount\n";
print "finished\n";
exit;
