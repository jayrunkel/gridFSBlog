#!/usr/bin/perl
use warnings;
use strict;
 
use MongoDB;
use MongoDB::GridFS;
use File::Basename;
use IO::File;
 
my ($movieDir, $author) = @ARGV;
 
unless ( $movieDir && $author ) {
    die "Usage: $0 <movie-directory> <author>\n";
}
 
unless ( -d $movieDir && -r _ ) {
    die "Directory '$movieDir' is not a readable directory";
}
 
my $client = MongoDB::MongoClient->new(host => 'localhost', port => 27017);
my $database = $client->get_database( 'digital' );
my $grid = $database->get_gridfs;
 
$grid->drop();
 
foreach my $file ( <$movieDir/*> ) {
    if ( my $fh = IO::File->new($file, "r") ) {
        print "Storing $file\n";
        my $meta = {
            "filename" => basename($file),
            "content-type" => "video/quicktime",
            "author" => $author
        };
        $grid->insert($fh, $meta);
    }
    else {
        warn "File '$file' could not be opened: $!";
    }
} 
