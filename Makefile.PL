use strict;
use warnings;
use ExtUtils::MakeMaker;

sub MY::libscan {
    my ($self, $file) = @_;
    $file eq 'README.pod' ? 0 : $file;
}

WriteMakefile(
    NAME          => 'MyCookie',
    VERSION_FROM  => 'lib/MyCookie.pm',
    TEST_REQUIRES => {
        'Test::More'     => '0.98',
        'Test::Requires' => 0,
        'Plack'          => 0,
        'LWP::UserAgent' => 0,
        'LWP::Protocol::PSGI' => 0,
        'Plack::Middleware::Session' => 0,
    },
);

