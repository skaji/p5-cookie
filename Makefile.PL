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
);

