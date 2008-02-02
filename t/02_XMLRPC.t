use Test::Simple 'no_plan';
use strict;
use lib './lib';
require './t/test.pl';
use WordPress::XMLRPC;
use Smart::Comments '###';
no strict 'refs';

ok(1,'starting test.');


if( ! -f './t/wppost' ){
   ok(1, usage());
   exit;
}



my $w = WordPress::XMLRPC->new(_conf('./t/wppost'));

my $_attempt_delete = 0;






my $getAuthors = $w->getAuthors;
### getAuthors
ok($getAuthors,'getAuthors()');

my $getCategories = $w->getCategories;
ok(ref $getCategories eq 'ARRAY' ,'getCategories');
### $getCategories


my $newCategory = $w->newCategory('test_category');
### $newCategory




for my $m (qw(getRecentPosts getUsersBlogs)){
   my $r = $w->$m;
   ok($r, "m $m");
   ### $m
   ### $r
}

#getTemplate
#setTemplate
#uploadFile



my $suggestCategories = $w->suggestCategories;
ok($suggestCategories, "suggestCategories()");
### $suggestCategories
