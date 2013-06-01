package MyCookie;
use strict;
use warnings;

our $VERSION = '0.01';

use Data::Dumper;
local $Data::Dumper::Sortkeys = 1;
local $Data::Dumper::Indent   = 1;
local $Data::Dumper::Terse    = 1;

sub new {
    my ($class, %opt) = @_;
    bless \%opt, $class;
}
sub add_cookie_header {
    my ($self, $req) = @_;
    $req->header(Cookie => $self->{cookie}) if $self->{cookie};
}
sub extract_cookies {
    my ($self, $res) = @_;
    my @cookie = $res->headers->header('set-cookie');
    return unless @cookie;
    @cookie = map { [ split /;\s+/ ] } @cookie;
    if ($self->{dump}) {
        warn Dumper \@cookie;
    }
    if ($self->{save}) {
        open my $fh, ">>", $self->{save} or die "$self->{save}: $!";
        print {$fh} Dumper(\@cookie);
    }
}

1;
__END__

=head1 NAME

MyCookie - my cookie class

=head1 SYNOPSIS

  use LWP::UserAgent;
  use MyCookie;

  my $ua1 = LWP::UserAgent->new(
      cookie_jar => MyCookie->new(dump => 1)
  );
  $ua1->get('http://example.com'); # dump cookies to STDERR

  my $ua2 = LWP::UserAgent->new(
      cookie_jar => MyCookie->new(cookie => "NAME=VALUE")
  );
  $ua2->get('http://example.jp');  # request with header Cookie: NAME=VALUE

=head1 DESCRIPTION

=head2 C<< my $cookie = MyCookie->new(%option) >>

Available options are:

=over 4

=item C<< dump => Bool >>

Dumping cookie.

=item C<< save => Filename >>

Save cookie to given file.

=item C<< cookie => String >>

Cookie string, which will be set in request header.

=back

=head1 WHY

L<HTTP::Cookies> provides many features.
I sometimes just want to set NAME=VALUE cookie.

=head1 AUTHOR

Shoichi Kaji

=cut
