use strict;
use warnings;
use lib "/home/ralphsch/perl5/lib/perl5";  
use File::Copy::Recursive qw (dircopy);
use Data::Dumper;

my @sizes;
#76	
#my @sizes = qw(8 10 12 14 16 18 20 22 24 26 28 30 32 34 36 38 40 42 44 46 48 50 52 54 56 58 60 62 64 66 68 70 72 74 76);

#80
#my @sizes = qw (8 10 12 14 16 18 20 22 24 26 28 30 32 34 36 38 40 42 44 46 48 50 52 54 56 58 60 62 64 66 68 70 72 74 76 78 80);

#10 - 110 2er Schritte
#my @sizes = qw (10 12 14 16 18 20 22 24 26 28 30 32 34 36 38 40 42 44 46 48 50 52 54 56 58 60 62 64 66 68 70 72 74 76 78 80 82 84 86 88 90 92 94 96 98 100 102 104 106 108 110);

#112
#my @sizes = qw (20 24 28 32 36 42 48 54 60 64 68 76 84 92 102 112);

#160
#my @sizes = qw (20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 52 56 60 64 72 80 88 96 112 128 144 160);

#100
#my @sizes = qw (8 10 12 14 16 18 20 22 24 26 28 30 32 34 36 38 40 42 44 46 48 50 52 54 56 58 60 62 64 66 68 70 72 74 76 78 80 82 84 86 88 90 92 94 96 98 100);

#200
#my @sizes = qw (20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 52 56 60 64 72 80 88 96 112 128 144 160 200);

#300
#my @sizes = qw (20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 52 56 60 64 72 80 88 96 112 128 144 160 200 300);

#320
#my @sizes = qw (20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 52 56 60 64 72 80 88 96 112 128 144 160 200 320);

#354
#my @sizes = qw (20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 52 56 60 64 72 80 88 96 112 128 144 160 200 354);

#480
#my @sizes = qw (20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 52 56 60 64 72 80 88 96 112 128 144 160 200 320 480);

#532
#my @sizes = qw (20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 52 56 60 64 72 80 88 96 112 128 144 160 200 320 480 532);


my $pieceset = $ARGV[0];
chdir "./$pieceset";

open(DAT, './definition') or die $!;
my @z = <DAT>;
close(DAT);

foreach my $r (@z) {
	chomp ($r);
	if ($r =~ m/size\.list/) {
		$r =~ s/size\.list \= //;
		print "$r\n";
		@sizes = split(/ +/, $r);
	}
}

print Dumper(@sizes);
my $orig = pop(@sizes);

foreach my $size (@sizes) {
	print "$size\n";
	dircopy ($orig, $size) or die $!;
	chdir ($size);
	
	foreach my $file (<*.png>) {
		system "convert -resize $size" . "x" . "$size $file $file"; #z.B. convert -resize 64x64 f.png f.png
	}
	foreach my $file (<*.gif>) {
		system "convert -resize $size" . "x" . "$size $file $file"; #z.B. convert -resize 64x64 f.png f.png
	}

	chdir ("..");
}

system("zip -r $pieceset.zip *");
system("/usr/local/bin/dropbox-api put $pieceset.zip dropbox:/Users/ralph/Dropbox/Games/Jin-Stuff/resources/pieces");

