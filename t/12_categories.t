use Test::Simple 'no_plan';
use strict;
use lib './lib';
require './t/test.pl';
use WordPress::XMLRPC;
no strict 'refs';
ok(1,'starting test.');

# WordPress has a bug - i think.. it doesn't register new categories properly via rpc



if( ! -f './t/wppost' ){
   ok(1, 'see README for further testing, skipped.');
   exit;
}



my $w = WordPress::XMLRPC->new(_conf('./t/wppost'));





my $new_category_name ='category' .( int rand 1000 );
print STDERR "new category name : $new_category_name\n";
my $new_category_id;
ok( $new_category_id = $w->newCategory({
   name => $new_category_name, 
   description => ' different description then name..', # not supported, apparently
   }) ) 
   or die("failed name => '$new_category_name',  ".$w->errstr );

print STDERR " gets id :  $new_category_id\n\n\n";


print STDERR "\n\n\nPART2\n\n";


my $getCategories;
ok( $getCategories = $w->getCategories, 'getCategories() returns');

my $ref = ref $getCategories;

=pod
ok( $ref eq 'ARRAY' ,"getCategories() returns array ref (got $ref)");
for my $c ( @$getCategories ){
   map { print STDERR "$_: $$c{$_}\n" } keys %$c;
   print STDERR "\n";
}
=cut

print STDERR "\n\nTEST GET CATEGORY\n\n";

my $got = $w->getCategory($new_category_id);
ok( $got,"getCategory( $new_category_id  ) returns.. ");

### $got




my $ncn = 'testcat'.( int rand 10000 );

print STDERR "\n\n=======\nnewCategory.. \n";
my $newCategory = $w->newCategory({ name => $ncn}) 
   or warn("newCategory no return, " . $w->errstr );


### $newCategory
unless( ok( $newCategory->{categoryName} eq $ncn ) ){
   my @k = keys %$newCategory;
   print STDERR "keys: ".scalar @k."\n";
   for my $k  (@k){
      my $v = $newCategory->{$k};
      print STDERR" k:$k, v:$v\n";
   }

 die;
}






#my $suggestCategories = $w->suggestCategories;
#ok($suggestCategories, "suggestCategories()");
## $suggestCategories
