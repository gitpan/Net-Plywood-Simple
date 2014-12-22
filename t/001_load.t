# -*- perl -*-

# t/001_load.t - check module loading and create testing directory

use Test::More tests => 2;

BEGIN { use_ok( 'Net::Plywood::Simple' ); }

my $object = Net::Plywood::Simple->new(
	scheme => 'http',
	host   => 'localhost',
	port   => 8080
);
isa_ok ($object, 'Net::Plywood::Simple');


