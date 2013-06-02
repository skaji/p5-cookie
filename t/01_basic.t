use strict;
use warnings;
use utf8;
use Test::More;
use MyCookie;
use Test::Requires qw(
    LWP::UserAgent
    LWP::Protocol::PSGI
    Test::TCP
    Plack::Test
    Plack::Builder
    Plack::Loader
    Plack::Middleware::Session
);

subtest 'can' => sub {
    my $cookie = MyCookie->new;
    isa_ok $cookie, 'MyCookie';
    can_ok $cookie, qw(req_cookie res_cookie);
};

subtest 'response cookie check' => sub {
    my $app = builder {
        enable 'Session';
        sub {
            [ 200, [ 'Content-Type' => 'text/plain' ], [ 'Hello Foo' ] ];
        };
    };
    my $client = sub {
        my $url = shift;
        my $ua  = LWP::UserAgent->new(
            cookie_jar => MyCookie->new
        );
        $ua->get($url);
        my $res_cookie = $ua->cookie_jar->res_cookie;
        is ref($res_cookie),      'ARRAY';
        is ref($res_cookie->[0]), 'ARRAY';
        like $res_cookie->[0][0], qr/^plack_session=/;
    };

    test_tcp(
        client => sub {
            my $port = shift;
            my $url  = "http://localhost:$port";
            $client->($url);
        },
        server => sub {
            my $port = shift;
            my $server = Plack::Loader->auto(
                port => $port,
                host => 'localhost',
            );
            $server->run($app);
        },
    );
};

subtest 'reqest cookie check' => sub {
    my $app = sub {
        my $env = shift;
        ok exists $env->{HTTP_COOKIE};
        is $env->{HTTP_COOKIE}, "NAME=VALUE";
        [ 200, [ 'Content-Type' => 'text/plain' ], [ 'Hello Foo' ] ];
    };
    LWP::Protocol::PSGI->register($app, host => 'localhost');
    my $url = "http://localhost";
    my $ua  = LWP::UserAgent->new(
        cookie_jar => MyCookie->new(req_cookie => "NAME=VALUE"),
    );
    $ua->get($url);
};

done_testing;
