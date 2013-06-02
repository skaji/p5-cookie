package MyCookie;
use strict;
use warnings;

our $VERSION = '0.01';

sub new {
    my ($class, %opt) = @_;
    bless \%opt, $class;
}
sub req_cookie {
    my ($self, $cookie) = @_;
    defined $cookie ? $self->{req_cookie} = $cookie
                    : $self->{req_cookie};
}
sub res_cookie {
    my ($self, $cookie) = @_;
    defined $cookie ? $self->{res_cookie} = $cookie
                    : $self->{res_cookie};
}
sub add_cookie_header {
    my ($self, $req) = @_;
    $req->header(Cookie => $self->req_cookie)
        if defined $self->req_cookie;
}
sub extract_cookies {
    my ($self, $res) = @_;
    my @cookie = $res->headers->header('set-cookie');
    return unless @cookie;
    $self->res_cookie( [ map { [ split /;\s+/ ] } @cookie ] );
}

1;
__END__

=head1 NAME

MyCookie - my cookie class

=head1 SYNOPSIS

  use LWP::UserAgent;
  use Data::Dumper;
  use MyCookie;

  my $ua1 = LWP::UserAgent->new(
      cookie_jar => MyCookie->new
  );
  $ua1->get('http://example.com');
  print Dumper $ua1->cookie_jar->res_coookie;

  my $ua2 = LWP::UserAgent->new(
      cookie_jar => MyCookie->new(req_cookie => "NAME=VALUE")
  );
  $ua2->get('http://example.jp'); # request with header Cookie: NAME=VALUE

=head1 DESCRIPTION

=head2 CONSTRUCTOR

=head3 C<< $cookie_jar = MyCookie->new(%option) >>

Available option is:

=over 4

=item C<< req_cookie => String >>

Cookie string, which will be set in request header.

=back

=head2 METHOD

=head3 C<< $cookie = $cookie_jar->res_cookie >>

Get cookies in response header.

=head3 C<< $cookie_jar->req_cookie(String) >>

Set given cookie string to request header.

=head1 WHY

L<HTTP::Cookies> provides many features.
I sometimes just want to set NAME=VALUE cookie.

=head1 AUTHOR

Shoichi Kaji

=cut
