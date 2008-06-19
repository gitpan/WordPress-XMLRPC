use Test::Simple 'no_plan';
use strict;
use lib './lib';
require './t/test.pl';
use WordPress::XMLRPC;
use Smart::Comments '###';
no strict 'refs';

ok(1,'starting test.');

# WordPress has a bug - i think.. it doesn't register new categories properly via rpc
exit;

if( ! -f './t/wppost' ){
   ok(1, 'see README for further testing, skipped.');
   exit;
}



my $w = WordPress::XMLRPC->new(_conf('./t/wppost'));






my $new_category_name ='category' .( int rand 1000 );

print STDERR "new category name : $new_category_name\n";



my $new_category_id;
ok( $new_category_id = $w->newCategory($new_category_name) ) 
   or die("failed newCategory( '$new_category_name' ) ".$w->errstr );

print STDERR "newCategory( '$new_category_name' ) gets id :  $new_category_id\n\n";




$new_category_name.="_appended";
my $new_category_id2;
ok( $new_category_id2 = $w->newCategory($new_category_name) ) 
   or die("failed newCategory( '$new_category_name' ) ".$w->errstr );

print STDERR "newCategory( '$new_category_name' ) gets id :  $new_category_id2\n\n";

ok($new_category_id != $new_category_id2,
   "new cat 1 id ($new_category_id)  is not same as new cat 2 id ($new_category_id2)");



