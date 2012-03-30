#!/usr/bin/env perl
use strict;
use warnings;
use Config::Pit;
use Yammer;

my $consumer_tokens = pit_get(
    "consumer.yammer.com",
    require => {
        consumer_key    => 'my consumer key',
        consumer_secret => 'my consumer secret',
    }
);
my $access_tokens = pit_get(
    "access.yammer.com",
    require => {
        access_token        => 'my access token',
        access_token_secret => 'my access token secret',
    }
);

my $yammer = Yammer->new(%$consumer_tokens);

$yammer->access_token( $access_tokens->{access_token} );
$yammer->access_token_secret( $access_tokens->{access_token_secret} );

my $response =
  $yammer->view_restricted_resource('https://www.yammer.com/api/v1/groups.xml');
print $response->content, "\n";
