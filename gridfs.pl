#!/Users/jayrunkel/perl5/perlbrew/perls/perl-5.18.2/bin/perl -w
# gridfs.pl --- Test code to load files into GridFS
# Author: Jay Runkel <jayrunkel@RunkelMac-3.local>
# Created: 19 Nov 2014
# Version: 0.01

use warnings;
use strict;

use MongoDB;
use MongoDB::GridFS;
use IO::File;
use Data::Dump qw(dump);


#!/usr/bin/perl

sub getFiles($) {
    
    my $dir = shift;

    my @fileList = ();

    opendir(DIR, $dir) or die $!;

    while (my $file = readdir(DIR)) {

        # Use a regular expression to ignore files beginning with a period
        next if ($file =~ m/^\./);

        push(@fileList, $file);
#	print "$file\n";
    }

    closedir(DIR);
    return @fileList;
}


my $movieDir   = "/Users/jayrunkel/Movies";
my $client     = MongoDB::MongoClient->new(host => 'localhost', port => 27017);
my $database   = $client->get_database( 'digital' );
my $grid       = $database->get_gridfs;
my @vidFiles   = getFiles($movieDir);

$grid->drop();

foreach my $file (@vidFiles) {
    my $fh         = IO::File->new("$movieDir/$file", "r");
    $grid->insert($fh, {"filename" => $file, "content-type" => "video/quicktime", "author" => "deb"});
}




__END__

=head1 NAME

gridfs.pl - Describe the usage of script briefly

=head1 SYNOPSIS

gridfs.pl [options] args

      -opt --long      Option description

=head1 DESCRIPTION

Stub documentation for gridfs.pl, 

=head1 AUTHOR

Jay Runkel, E<lt>jayrunkel@RunkelMac-3.localE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2014 by Jay Runkel

This program is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.2 or,
at your option, any later version of Perl 5 you may have available.

=head1 BUGS

None reported... yet.

=cut
