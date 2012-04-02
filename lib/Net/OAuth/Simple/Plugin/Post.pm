package Net::OAuth::Simple::Plugin::Post;
use Net::OAuth::Message;
use strict;
use warnings;

sub import {
    my $class = shift;
    *Net::OAuth::Simple::_make_request = \&my_make_request;
}

sub my_make_request {

    my $self   = shift;
    my $class  = shift;
    my $url    = shift;
    my $method = uc(shift);
    my @extra  = @_;

    my $uri   = URI->new($url);
    my %query = $uri->query_form;
    $uri->query_form( {} );

    my $request = $class->new(
        consumer_key     => $self->consumer_key,
        consumer_secret  => $self->consumer_secret,
        request_url      => $uri,
        request_method   => $method,
        signature_method => $self->signature_method,
        protocol_version => $self->oauth_1_0a
        ? Net::OAuth::PROTOCOL_VERSION_1_0A
        : Net::OAuth::PROTOCOL_VERSION_1_0,
        timestamp    => time,
        nonce        => $self->_nonce,
        extra_params => \%query,
        @extra,
    );
    $request->sign;
    return $self->_error("COULDN'T VERIFY! Check OAuth parameters.")
      unless $request->verify;

    my @args    = ();
    my $req_url = $url;
    my $params  = $request->to_hash;
    if ( 'GET' eq $method || 'PUT' eq $method ) {
        $req_url = URI->new($url);
        $req_url->query_form(%$params);
    }

    my $req = HTTP::Request->new( $method => $req_url, @args );

    if ( 'POST' eq $method ) {
        $req->content( $request->to_post_body );
        $req->header( 'Content-Type' => 'application/x-www-form-urlencoded' );
    }
    my $response = $self->{browser}->request($req);
    return $self->_error(
        "$method on $request failed: " . $response->status_line )
      unless ( $response->is_success );

    return $response;
}

1;
