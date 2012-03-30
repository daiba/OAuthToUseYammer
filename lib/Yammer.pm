package Yammer;
use strict;
use warnings;
use 5.008001;
our $VERSION = '0.01';

use base qw(Net::OAuth::Simple);

sub new {
    my $class  = shift;
    my %tokens = @_;
    return $class->SUPER::new(
        tokens => \%tokens,
        urls   => {
            authorization_url => "https://www.yammer.com/oauth/authorize",
            request_token_url => "https://www.yammer.com/oauth/request_token",
            access_token_url  => "https://www.yammer.com/oauth/access_token",
        },
        protocol_version => '1.0a',
    );
}

sub view_restricted_resource {
    my $self = shift;
    my $url  = shift;
    return $self->make_restricted_request( $url, 'GET' );
}

sub update_restricted_resource {
    my $self         = shift;
    my $url          = shift;
    my %extra_params = @_;
    return $self->make_restricted_request( $url, 'POST', %extra_params );
}


1;
__END__

=encoding utf8

=head1 NAME

Yammer -

=head1 SYNOPSIS

  use Yammer;

=head1 DESCRIPTION

Yammer is

=head1 AUTHOR

 E<lt>E<gt>

=head1 SEE ALSO

=head1 LICENSE

Copyright (C) 

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
