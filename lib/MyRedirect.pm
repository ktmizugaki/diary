package MyRedirect;
use parent qw( Plack::Middleware );

sub scheme {
    my $addr = shift;
    if ($addr =~ /192\.168\.\d+\.\d+|127\.\d+\.\d+\.\d+/) {
        return 'http';
    } else {
        return 'https';
    }
}

sub call {
    my($self, $env) = @_;

    # check scheme
    my $expected = scheme($env->{REMOTE_ADDR});
    if ($env->{'psgi.url_scheme'} ne $expected) {
        return [302,
                ['Location' => $expected."://".$env->{HTTP_HOST}.$env->{REQUEST_URI}],
                []];
    }

    return $self->app->($env);
}

1;
