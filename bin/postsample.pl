#!/usr/bin/env perl
use strict;
use warnings;
use utf8;
use Config::Pit;
use Yammer;
use Net::OAuth::Simple::Plugin::Post;

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

push @{ $yammer->{browser}->requests_redirectable }, 'POST';

$yammer->access_token( $access_tokens->{access_token} );
$yammer->access_token_secret( $access_tokens->{access_token_secret} );

my $response = $yammer->update_restricted_resource(
    'https://www.yammer.com/api/v1/messages.json',
    'body'     => '日本語テスト',
);
print $response->content, "\n";
