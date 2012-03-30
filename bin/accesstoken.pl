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

my $yammer = Yammer->new(%$consumer_tokens);

print "Goto " . $yammer->get_authorization_url . "\n";
print "Then hit return after\n";
<STDIN>;

my ( $access_token, $access_token_secret ) = $yammer->request_access_token;

Config::Pit::set(
    "access.yammer.com",
    data => {
        access_token        => $access_token,
        access_token_secret => $access_token_secret
    }
);

