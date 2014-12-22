use ExtUtils::MakeMaker;
WriteMakefile(
	NAME         => 'Net::Plywood::Simple',
	VERSION_FROM => 'lib/Net/Plywood/Simple.pm', # finds \$VERSION
	AUTHOR       => 'Shane Utt (sutt@cpan.org)',
	ABSTRACT     => 'A simple Perl5 interface to the Erlang "Plywood" tree-object storage and convergence server.',
	PREREQ_PM    => {
		'HTTP::Tiny'   => 0.053,
		'Test::Simple' => 0.44,
		'Try::Tiny'    => 0.22,
	},
);
