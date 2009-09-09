use Test::Simple 'no_plan';
use strict;
use lib './lib';
require './t/test.pl';
use WordPress::XMLRPC;
no strict 'refs';
use Smart::Comments '###';
ok(1,'starting test.');

if( ! -f './t/wppost' ){
   ok(1, 'see README for further testing, skipped.');
   exit;
}

$WordPress::XMLRPC::DEBUG = 1;
my $w = WordPress::XMLRPC->new(_conf('./t/wppost'));



for my $method (qw/getTags/){
   ok $w->can($method), "can $method()";
}

my $r;

ok( $r = $w->getTags, 'getTags()');
### return: $r


