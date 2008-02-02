use Test::Simple 'no_plan';
use strict;
use lib './lib';
require './t/test.pl';
use WordPress::XMLRPC;
use Smart::Comments '###';
no strict 'refs';

ok(1,'starting test.');

if( ! -f './t/wppost' ){
   ok(1, 'see README');
   exit;
}



my $w = WordPress::XMLRPC->new(_conf('./t/wppost'));

### $w

my $publish = $w->publish;
### $publish
#
my $_attempt_delete =1;





### PAGE
my $_name = 'page '.time().int(rand(256));
my $newPage = $w->newPage({title => $_name,  description => 'bogus content' });
### $newPage
ok($newPage, "new page returns id $newPage") or die;

my $editPage = $w->editPage($newPage, 
   { title => 'test_test_1', description => 'bogus content edited' });
### $editPage
ok( $editPage,'editPage succeeds');


my $getPage = $w->getPage($newPage);
## $getPage;

ok( ref $getPage eq 'HASH', 'getPage returns hash ref');


my $getPages = $w->getPages;
ok( ref $getPages eq 'ARRAY', 'getPages returns array ref');
## $getPages


my $getPageList = $w->getPageList;
## $getPageList
ok( ref $getPageList eq 'ARRAY', 'getPageList returns array ref');


if ($_attempt_delete){
   my $deletePage = $w->deletePage($newPage);
   ok($deletePage, 'deletePage succeeds');
}






