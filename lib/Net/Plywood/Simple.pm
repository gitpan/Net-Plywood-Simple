package Net::Plywood::Simple;
use 5.006;
use strict;
use warnings;

use HTTP::Tiny;
use Try::Tiny;
use JSON;

our $VERSION = 0.01;

############
## Public ##
############

sub new {
	my $class  = shift;
	my $params = ref($_[0]) ? $_[0] : {@_};
	if (!$params->{scheme} || !$params->{host} || !$params->{port}) {
		die "argments 'scheme', 'host' and 'port' are required";
	}
	$params->{_json} = JSON->new->utf8;
	return bless($params, $class);
}

sub put {
	my ($self, $key, $data) = @_;
	if ($key =~ m/\//) {
		die 'can not have forward slash ( / ) characters in key names';
	}
	my $json;
	try {
		$json = $self->{_json}->encode($data);
	} catch {
		die "could not encode tree as JSON, error was: $_";
	};
	try {
		HTTP::Tiny->new->put(
			"$self->{scheme}://$self->{host}:$self->{port}/tree/$key",
			{content => $json},
		);
	} catch {
		die "could not store tree, error was: $_";
	};
	return 1;
}

sub get {
	my ($self, $key, @path) = @_;
	my $path = join('/', @path);
	my $data;
	try {
		$data = HTTP::Tiny->new->get(
			"$self->{scheme}://$self->{host}:$self->{port}/tree/$key",
		);
	} catch {
		die "could not get tree, error was: $_";
	};
	return $data;
}

1;

__END__

=head1 NAME

Net::Plywood::Simple - A simple interface to "Plywood", an index database server

=head1 DESCRIPTION

This module is a simple wrapper around "Plywood", a hierarchical data storage
and retrieval database written in Erlang. The database can be cloned from:
	https://github.com/ricecake/plywood
The basic premise is to store, retrieve, and search for nodes in large JSON
tree structures that can be merged together.

=head1 SYNOPSIS

Storing data:

	use Net::Plywood::Simple;
	my $plywood = Net::Plywood::Simple(
		scheme => 'http',
		host   => 'localhost',
		port   => 8080,
	);
	my $key  = 'PICKAKEY';
	my $data = {...}; # build your tree
	$plywood->put($key, $data);

Retrieving data:

	use Net::Plywood::Simple;
	my $plywood = Net::Plywood::Simple(
		scheme => 'http',
		host   => 'localhost',
		port   => 8080,
	);
	my $data = $plywood->get('PICKAKEY');

Just swap out scheme, host and port and you're set

=head1 AUTHOR

Shane Utt - sutt@cpan.org

=cut

