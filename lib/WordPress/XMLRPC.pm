package WordPress::XMLRPC;
use warnings;
use strict;
use Carp;
use vars qw($VERSION);
$VERSION = sprintf "%d.%02d", q$Revision: 1.18 $ =~ /(\d+)/g;

sub new {
   my ($class,$self) = @_;
   $self||={};
   bless $self, $class;
   return $self;
}

sub proxy {
   my $self = shift;
   my $val = shift;
   if( defined $val ){
      $self->{proxy} = $val;      
   }
	defined $self->{proxy} or carp("missing 'proxy'".  (caller(1))[3]);

   return $self->{proxy};
}

sub username {
   my $self = shift;
   my $val = shift;
   if( defined $val ){
      $self->{username} = $val;      
   }
	defined $self->{username} or carp("missing 'username'".  (caller(1))[3]);

   return $self->{username};
}

sub password {
   my $self = shift;
   my $val = shift;
   if( defined $val ){
      $self->{password} = $val;      
   }
	defined $self->{password} or carp("missing 'username'". (caller(1))[3]);

   return $self->{password};
}

sub blog_id {
   my $self = shift;
   my $val = shift;
   if( defined $val ){
      $val=~/^\d+$/ or croak('argument must be digits');
      $self->{blog_id} = $val;      
   }
   $self->{blog_id} ||= 1;
   return $self->{blog_id};
}

# post and page use 'publish' variable
sub publish {
   my ($self,$val) = @_;
   $self->{publish} = $val if defined $val;
   defined $self->{publish} or $self->{publish} = 1;
   return $self->{publish};
}



sub server {
   my $self = shift;
   unless( $self->{server} ){
      $self->proxy or confess('missing proxy');
      require XMLRPC::Lite;

      $self->{server} ||= XMLRPC::Lite->proxy( $self->proxy );
   }
   return $self->{server};
}

sub server_methods {
   my $self = shift;
   return qw(wp.getPage wp.getPages wp.newPage wp.deletePage wp.editPage wp.getPageList wp.getAuthors wp.getCategories wp.newCategory wp.suggestCategories wp.uploadFile blogger.getUsersBlogs blogger.getUserInfo blogger.getPost blogger.getRecentPosts blogger.getTemplate blogger.setTemplate blogger.newPost blogger.editPost blogger.deletePost metaWeblog.newPost metaWeblog.editPost metaWeblog.getPost metaWeblog.getRecentPosts metaWeblog.getCategories metaWeblog.newMediaObject metaWeblog.deletePost metaWeblog.getTemplate metaWeblog.setTemplate metaWeblog.getUsersBlogs mt.getCategoryList mt.getRecentPostTitles mt.getPostCategories mt.setPostCategories mt.supportedMethods mt.supportedTextFilters mt.getTrackbackPings mt.publishPost pingback.ping demo.sayHello demo.addTwoNumbers);   
}

sub xmlrpc_methods {
   my $self = shift;
   return qw(getPage getPages newPage deletePage editPage getPageList
   getAuthors getCategories newCategory suggestCategories uploadFile
   newPost editPost getPost getRecentPosts getCategories newMediaObject
   deletePost getTemplate setTemplate getUsersBlogs);
}

sub _call_has_fault {
   my $self = shift;
   my $call = shift;
   defined $call or confess('no call passed');
   my $err = $call->fault or return 0;
   
   #my $from = caller();   
   #my($package, $filename, $line, $subroutine, $hasargs,
   #   $wantarray, $evaltext, $is_require, $hints, $bitmask) = caller(1);
      

   my $_err;
   for my $k( keys %$err ){
      
      $_err.= sprintf "# %s() - ERROR %s, %s\n", 
         (caller(1))[3], # sub name
         $k, # error label, from XMLRPC::Simple call
         $err->{$k}, # error text                  
         ;
   }
   $self->errstr($_err);
   
   return $self->errstr;
}


sub errstr {
   my ($self,$val) = @_;
   $self->{errstr} = $val if defined $val;   
   return $self->{errstr};
}





# XML RPC METHODS


# xmlrpc.php: function wp_getPage
sub getPage {
	my $self = shift;
	my $blog_id = $self->blog_id;
	my $page_id = shift;
	my $username = $self->username;
	my $password = $self->password;

	$page_id or confess('missing page id');  

	my $call = $self->server->call(
		'wp.getPage',
		$blog_id,
		$page_id,
		$username,
		$password,
	);

	if ( $self->_call_has_fault($call)){
		return;
	}

	my $result = $call->result;
	defined $result
		or die('no result');

	return $result;
}

# xmlrpc.php: function wp_getPages
sub getPages {
	my $self = shift;
	my $blog_id = $self->blog_id;
	my $username = $self->username;
	my $password = $self->password;
	

	my $call = $self->server->call(
		'wp.getPages',
		$blog_id,
		$username,
		$password,
	);

	if ( $self->_call_has_fault($call)){
		return;
	}

	my $result = $call->result;
	defined $result
		or die('no result');

	return $result;
}

# xmlrpc.php: function wp_newPage
sub newPage {
	my $self = shift;
   my $blog_id = $self->blog_id;
   my $username = $self->username;
   my $password = $self->password;   
	my $page = shift;

	defined $page or confess('missing page arg');
   ref $page eq 'HASH' or croak('arg is not hash ref');
   
	my $publish = shift;
	unless (defined $publish) {
		$publish = $self->publish;
	}

   

	my $call = $self->server->call(
		'wp.newPage',
      $blog_id, # ignored
      $username, # i had missed these!!!
      $password,
		$page,
		$publish,
	);

	if ( $self->_call_has_fault($call)){
		return;
	}

	my $result = $call->result;
	defined $result
		or die('no result');

	return $result;
}

# xmlrpc.php: function wp_deletePage
sub deletePage {
	my $self       = shift;
	my $blog_id    = $self->blog_id;  
	my $username   = $self->username;
	my $password   = $self->password;
	my $page_id    = shift;

	defined $page_id or confess('missing page id arg');
   

	my $call = $self->server->call(
		'wp.deletePage',
		$blog_id,
		$username,
		$password,
		$page_id,
	);

	if ( $self->_call_has_fault($call)){
		return;
	}

	my $result = $call->result;
	defined $result
		or die('no result');

	return $result;
}

# xmlrpc.php: function wp_editPage
sub editPage {
	my $self       = shift;
	my $blog_id    = $self->blog_id;
   my $page_id    = shift;
	my $content    = shift;
	my $publish    = shift;
   my $password   = $self->password;
   my $username   = $self->username;

	defined $page_id or confess('missing page id arg');
	defined $content or confess('missing content hash ref arg');
   ref $content eq 'HASH' or croak('arg is not hash ref');
   
	unless (defined $publish) {
		$publish = $self->publish;
	}
   


	my $call = $self->server->call(
		'wp.editPage',
		$blog_id,
      $page_id,
      $username,
      $password,
		$content,
		$publish,
	);

	if ( $self->_call_has_fault($call)){
		return;
	}

	my $result = $call->result;
	defined $result
		or die('no result');

	return $result;
}

# xmlrpc.php: function wp_getPageList
sub getPageList {
	my $self = shift;
	my $blog_id = $self->blog_id;
	my $username = $self->username;
	my $password = $self->password;


	my $call = $self->server->call(
		'wp.getPageList',
		$blog_id,
		$username,
		$password,
	);

	if ( $self->_call_has_fault($call)){
		return;
	}

	my $result = $call->result;
	defined $result
		or die('no result');

	return $result;
}

# xmlrpc.php: function wp_getAuthors
sub getAuthors {
	my $self = shift;
	my $blog_id = $self->blog_id;
	my $username = $self->username;
	my $password = $self->password;


	my $call = $self->server->call(
		'wp.getAuthors',
		$blog_id,
		$username,
		$password,
	);

	if ( $self->_call_has_fault($call)){
		return;
	}

	my $result = $call->result;
	defined $result
		or die('no result');

	return $result;
}


# xmlrpc.php: function wp_newCategory
sub newCategory {
	my $self = shift;
	my $blog_id = $self->blog_id;
	my $username = $self->username;
	my $password = $self->password;
	my $category = shift;
   (ref $category and ref $category eq 'HASH')
      or croak("category must be a hash ref");

   $category->{name} or confess('missing name in category struct');
   

   ### $category

	defined $category or confess('missing category string');

	my $call = $self->server->call(
		'wp.newCategory',
		$blog_id,
		$username,
		$password,
		$category,
	);

	if ( $self->_call_has_fault($call)){
		return;
	}

	my $result = $call->result;
	defined $result
		or die('no result');

	return $result;
}

# xmlrpc.php: function wp_suggestCategories
sub suggestCategories {
	my $self = shift;
	my $blog_id = $self->blog_id;
	my $username = $self->username;
	my $password = $self->password;
	my $category = shift;
	my $max_results = shift; # optional

	

	my $call = $self->server->call(
		'wp.suggestCategories',
		$blog_id,
		$username,
		$password,
		$category,
		$max_results,
	);

	if ( $self->_call_has_fault($call)){
		return;
	}

	my $result = $call->result;
	defined $result
		or die('no result');

	return $result;
}

# xmlrpc.php: function mw_newMediaObject
sub uploadFile {
	my $self = shift;
	my $blog_id = $self->blog_id;
	my $data = shift;
	
	defined $data or confess('missing data hash ref arg');
   ref $data eq 'HASH' or croak('arg is not hash ref');
   

	my $call = $self->server->call(
		'wp.uploadFile',
		$blog_id,
		$data,
	);

	if ( $self->_call_has_fault($call)){
		return;
	}

	my $result = $call->result;
	defined $result
		or die('no result');

	return $result;
}

# xmlrpc.php: function mw_newPost
sub newPost {
	my $self = shift;
	my $blog_id = $self->blog_id;
	my $user_login = $self->username;
	my $user_pass = $self->password;
	my $content_struct = shift;
	my $publish = shift;
	unless (defined $publish) {
		$publish = $self->publish;
	}
   defined $content_struct or confess('missing post hash ref arg');
   ref $content_struct eq 'HASH' or croak('arg is not hash ref');

	my $call = $self->server->call(
		'metaWeblog.newPost',
		$blog_id,
		$user_login,
		$user_pass,
		$content_struct,
		$publish,
	);

	if ( $self->_call_has_fault($call)){
		return;
	}

	my $result = $call->result;
	defined $result
		or die('no result');

	return $result;
}

# xmlrpc.php: function mw_editPost
sub editPost {
	my $self = shift;
	my $post_id = shift;
	my $user_login = $self->username;
	my $user_pass = $self->password;
	my $content_struct = shift;
	my $publish = shift;
	unless (defined $publish) {
		$publish = $self->publish;
	}

	defined $post_id or confess('missing post id');
	defined $content_struct or confess('missing content struct hash ref arg');
   ref $content_struct eq 'HASH' or croak('arg is not hash ref');

	my $call = $self->server->call(
		'metaWeblog.editPost',
		$post_id,
		$user_login,
		$user_pass,
		$content_struct,
		$publish,
	);

	if ( $self->_call_has_fault($call)){
		return;
	}

	my $result = $call->result;
	defined $result
		or die('no result');

	return $result;
}

# xmlrpc.php: function mw_getPost
sub getPost {
	my $self = shift;
	my $post_id = shift;
	my $user_login = $self->username;
	my $user_pass = $self->password;
   defined $post_id or confess('missing post id arg');


	my $call = $self->server->call(
		'metaWeblog.getPost',
		$post_id,
		$user_login,
		$user_pass,
	);

	if ( $self->_call_has_fault($call)){
		return;
	}

	my $result = $call->result;
	defined $result
		or die('no result');

	return $result;
}

# xmlrpc.php: function mw_getRecentPosts
sub getRecentPosts {
	my $self = shift;
	my $blog_id = $self->blog_id;
	my $user_login = $self->username;
	my $user_pass = $self->password;
	my $num_posts = shift;
   

	my $call = $self->server->call(
		'metaWeblog.getRecentPosts',
		$blog_id,
		$user_login,
		$user_pass,
		$num_posts,
	);

	if ( $self->_call_has_fault($call)){
		return;
	}

	my $result = $call->result;
	defined $result
		or die('no result');

	return $result;
}

# xmlrpc.php: function mw_getCategories
sub getCategories {
	my $self = shift;
	my $blog_id = $self->blog_id;
	my $user_login = $self->username;
	my $user_pass = $self->password;
   

	my $call = $self->server->call(
		'metaWeblog.getCategories',
		$blog_id,
		$user_login,
		$user_pass,
	);

	if ( $self->_call_has_fault($call)){
		return;
	}

	my $result = $call->result;
	defined $result
		or die('no result');

	return $result;
}


# this nextone doesn't really exist.. this is a hack ..
# this is not keeping in par with xmlrpc.php but.. shikes..
sub getCategory {
   my $self = shift;
   my $id = shift;
   $id or croak('missing id argument');

   # get all categorise

   my @cat = grep { $_->{categoryId} == $id } @{$self->getCategories};

   @cat and scalar @cat 
      or $self->errstr("Category id $id not found.")
      and return;

   return $cat[0];
}



# xmlrpc.php: function mw_newMediaObject
sub newMediaObject {
	my $self = shift;
	my $blog_id = $self->blog_id;
	my $data = shift;

   defined $data or confess('missing data hash ref arg');
   ref $data eq 'HASH' or croak('arg is not hash ref');

	my $call = $self->server->call(
		'metaWeblog.newMediaObject',
		$blog_id,
      $self->username,
      $self->password,
		$data,
	);

	if ( $self->_call_has_fault($call)){
		return;
	}

	my $result = $call->result;
	defined $result
		or die('no result');

	return $result;
}

# xmlrpc.php: function blogger_deletePost
sub deletePost {
	my $self = shift;
   my $blog_id = $self->blog_id;
	my $post_id = shift;
	my $user_login = $self->username;
	my $user_pass = $self->password;
	my $publish = shift;
	unless (defined $publish) {
		$publish = $self->publish;
	}

	defined $post_id or confess('missing post id');

	my $call = $self->server->call(
		'metaWeblog.deletePost',
      $blog_id, #ignored
		$post_id,
		$user_login,
		$user_pass,
		$publish,
	);

	if ( $self->_call_has_fault($call)){
		return;
	}

	my $result = $call->result;
	defined $result
		or die('no result');

	return $result;
}

# xmlrpc.php: function blogger_getTemplate
sub getTemplate {
	my $self = shift;
	my $blog_id = $self->blog_id;
	my $user_login = $self->username;
	my $user_pass = $self->password;
	my $template = shift;

	defined $template or confess('missing template string');   

	my $call = $self->server->call(
		'metaWeblog.getTemplate',
		$blog_id,
		$user_login,
		$user_pass,
		$template,
	);

	if ( $self->_call_has_fault($call)){
		return;
	}

	my $result = $call->result;
	defined $result
		or die('no result');

	return $result;
}

# xmlrpc.php: function blogger_setTemplate
sub setTemplate {
	my $self = shift;
	my $blog_id = $self->blog_id;
	my $user_login = $self->username;
	my $user_pass = $self->password;
	my $content = shift;
	my $template = shift;

	defined $template or confess('missing template string arg');
	defined $content or confess('missing content hash ref arg');
   ref $content eq 'HASH' or croak('arg is not hash ref');

	my $call = $self->server->call(
		'metaWeblog.setTemplate',
		$blog_id,
		$user_login,
		$user_pass,
		$content,
		$template,
	);

	if ( $self->_call_has_fault($call)){
		return;
	}

	my $result = $call->result;
	defined $result
		or die('no result');

	return $result;
}

# xmlrpc.php: function blogger_getUsersBlogs
sub getUsersBlogs {
	my $self = shift;
	my $user_login = $self->username;
	my $user_pass = $self->password;
   

	my $call = $self->server->call(
		'metaWeblog.getUsersBlogs',
      $self->blog_id, # ignored
		$user_login,
		$user_pass,
	);

	if ( $self->_call_has_fault($call)){
		return;
	}

	my $result = $call->result;
	defined $result
		or die('no result');

	return $result;
}



1;

__END__

=pod

=head1 NAME

WordPress::XMLRPC - api to wordpress rpc

=head1 SYNOPSIS

   use WordPress::XMLRPC;

   my $o = WordPress:::XMLRPC->new({
     username => 'author1',
     password => 'superpass',
     proxy => 'http://mysite.com/xmlrpc.php',
   });

   my $post = $o->getPost(5); # id 5

   # let's change the title
   $post->{title} = 'I did not like the old title.';

   # let's save the changes back to the server..
   $o->editPost(5, $post, 1); # 1 is publish


=head1 DESCRIPTION

I wanted to interact via the command line to a wordpress blog's xmlrpc.php file.
Bascially this is interaction with xmlrpc.php as client.
This module is not meant for speed, it is meant for convenience.

=head1 CONSTRUCTOR

=head2 new()

Optional arg is hash ref.

Before we open a connection with xmlrpc, we need to have 
username, password, and proxy in the object's data.
You can provide this in the following ways..

   my $o = WordPress:::XMLRPC->new({
     username => 'author1',
     password => 'superpass',
     proxy => 'http://mysite.com/xmlrpc.php',
   });

Or..

   my $o = WordPress:::XMLRPC->new;  
   
   $o->username('author1');
   $o->password('superpass');
   $o->proxy('http://mysite.com/xmlrpc.php');

   $o->server 
      or die( 
         sprintf 'could not connect with %s:%s to %s',
            $self->username,
            $self->password,
            $self->proxy,
         );
 
=head1 METHODS

=head2 xmlrpc_methods()

Returns array of methods in this package that make calls via xmlrpc.

=head2 server_methods()

Returns array of server methods accessible via xmlrpc.

=head2 username()

Perl set/get method. Argument is string.
If you pass 'username' to constructor, it is prepopulated.

   my $username = $o->username;
   $o->username('bill');

=head2 password()

Perl set/get method. Argument is string.
If you pass 'password' to constructor, it is prepopulated.

   my $pw = $o->password;
   $o->password('jim');

=head2 proxy()

Perl set/get method. Argument is string.
If you pass 'proxy' to constructor, it is prepopulated.

=head2 server()

Returns XMLRPC::Lite object.
proxy() must be set.

=head2 blog_id()

Setget method, set to '1' by default.
This seems unused by wordpress. They have some documentation on this.

=head2 publish()

Many methods use 'publish' boolean value, by default we set to 1.
You can still pass a value for publish such as;

   $o->newPost( $content_hashref, 1 );

But you can also call;

   $o->newPost( $content_hashref );

As we said, by default it is set to 1, if you want to set the default to 0,

   $o->publish(0);

=head2 errstr()

Returns error string if a call fails. 

   $o->newPost(@args) or die($o->errstr);


=head2 XML RPC METHODS

These methods specifically mirror the xmlrpc.php file provided by WordPress installations.
This file sits on your website.

=head3 getPage()

Takes 1 args: page_id (number).

Returns page hashref struct(ure).

Example return:

	 $val: {
	         categories => [
	                         'Uncategorized'
	                       ],
	         dateCreated => '20080121T12:38:30',
	         date_created_gmt => '20080121T20:38:30',
	         description => 'These are some interesting resources online.',
	         excerpt => '',
	         link => 'http://leocharre.com/perl-resources/',
	         mt_allow_comments => '0',
	         mt_allow_pings => '0',
	         page_id => '87',
	         page_status => 'publish',
	         permaLink => 'http://leocharre.com/perl-resources/',
	         text_more => '',
	         title => 'Resources',
	         userid => '2',
	         wp_author => 'leocharre',
	         wp_author_display_name => 'leocharre',
	         wp_author_id => '2',
	         wp_page_order => '0',
	         wp_page_parent_id => '0',
	         wp_page_parent_title => '',
	         wp_password => '',
	         wp_slug => 'perl-resources'
	       }

This is the same struct hashref you would send to newPage().

=head3 getPages()

Returns array ref.
Each element is a hash ref same as getPage() returns.
If you want less info, just basic info on each page, use getPageList().

=head3 newPage()

Takes 2 args: page (hashref), publish (boolean).
You can leave out publish, as discussed further in this documentation.
The hashref must have at least a title and description.
Returns page id (number, assigned by server).

=head3 deletePage()

Takes 1 args: page_id (number).
Returns boolean (true or false).

=head3 editPage()

Takes 2 args: page (hashref), publish(boolean).
The page hashref is just as discussed in getPage().

You could use getPage(), edit the returned hashref, and resubmit with editPage().

   my $page_hashref = $o->getPage(5);
   $page_hashref->{title} = 'This is the New Title';

   $o->editPage($page_hashref) or die( $o->errstr );

Obviously the page id is in the page data (hashref), this is there inherently when you
call getPage().

The same would be done with the posts.

=head3 getPageList()

Returns arrayref.
Each element is a hashref.
This is sort of a short version of getPages(), which returns all info for each.

Example return:

	 $return_value: [
	                  {
	                    dateCreated => '20061113T11:08:22',
	                    date_created_gmt => '20061113T19:08:22',
	                    page_id => '2',
	                    page_parent_id => '0',
	                    page_title => 'About Moi'
	                  },
	                  {
	                    dateCreated => '20080105T18:57:24',
	                    date_created_gmt => '20080106T02:57:24',
	                    page_id => '43',
	                    page_parent_id => '74',
	                    page_title => 'tree'
	                  },
	                ]


=head3 getAuthors()

Takes no argument.
Returns array ref, each element is a hashref.

	 $return_value: [
	                  {
	                    display_name => 'leo',
	                    user_id => '2',
	                    user_login => 'leo'
	                  },
	                  {
	                    display_name => 'chamon',
	                    user_id => '3',
	                    user_login => 'chamon'
	                  }
	                ]


=head3 getCategories()

Takes no argument.

	 $return_value: [
	                  {
	                    categoryId => '4',
	                    categoryName => 'art',
	                    description => 'art',
	                    htmlUrl => 'http://leocharre.com/articles/category/art/',
	                    parentId => '0',
	                    rssUrl => 'http://leocharre.com/articles/category/art/feed/'
	                  },
	                  {
	                    categoryId => '1',
	                    categoryName => 'Uncategorized',
	                    description => 'Uncategorized',
	                    htmlUrl => 'http://leocharre.com/articles/category/uncategorized/',
	                    parentId => '0',
	                    rssUrl => 'http://leocharre.com/articles/category/uncategorized/feed/'
	                  }
	                ]


=head3 newCategory()

Takes 1 args: category struct.
Returns category id (number).

The category struct is a hash ref alike..

   {
      name => 'Ugly houses',
      parent_id => 34, # (if this is a sub category )
      description => 'this is a great category',
   }

The key 'name' must be present or croaks.

=head3 getCategory()

Argument is category id, will return struct (hash ref).

   ### $got: {
   ####         categoryId => 99,
   ####         categoryName => 'category772',
   ####         description => 'category772',
   ####         htmlUrl => 'http://leocharre.com/articles/category/category772/',
   ####         parentId => '0',
   ####         rssUrl => 'http://leocharre.com/articles/category/category772/feed/'
   ####       }

=head4 CAVEAT 

There seems to be a bug in xmlrpc.php (wordpress v 2.3.2) , that does not fill out 
the categories properly. You can use  newCategory() to insert a description, bu
upon getCategory(), the struct description is replaced by the categoryName field.

=head3 suggestCategories()

Takes 2 args: category, max_results.

Returns array ref, each element is a hashref (not sure what this is for).

=head3 uploadFile()

Takes 1 args: data.
Data is a hash ref, see WordPress::MediaObject.

=head3 newPost()

Takes 2 args: content_struct, publish.
Returns id number of new post.

=head3 editPost()

Takes 3 args: post_ID, content_struct, publish.
Returns boolean, true or false.

=head3 getPost()

Takes 1 args: post_ID
Returns post struct, hashref.

	 $example_return_value: {
	                          categories => [
	                                          'Uncategorized'
	                                        ],
	                          dateCreated => '20080130T14:19:05',
	                          date_created_gmt => '20080130T22:19:05',
	                          description => 'test description here',
	                          link => 'http://leocharre.com/articles/test_1201731544/',
	                          mt_allow_comments => '1',
	                          mt_allow_pings => '1',
	                          mt_excerpt => '',
	                          mt_keywords => '',
	                          mt_text_more => '',
	                          permaLink => 'http://leocharre.com/articles/test_1201731544/',
	                          postid => '119',
	                          title => 'test_1201731544',
	                          userid => '2',
	                          wp_author_display_name => 'leocharre',
	                          wp_author_id => '2',
	                          wp_password => '',
	                          wp_slug => 'test_1201731544'
	                        }

=head3 getRecentPosts()

Takes 1 args: num_posts (number, optional).

Returns arrayref.
Each element is hash ref same as getPost() would return.

=head3 getCategories()

Example return value:

	 $return_value: [
	                  {
	                    categoryId => '4',
	                    categoryName => 'art',
	                    description => 'art',
	                    htmlUrl => 'http://leocharre.com/articles/category/art/',
	                    parentId => '0',
	                    rssUrl => 'http://leocharre.com/articles/category/art/feed/'
	                  },
	                  {
	                    categoryId => '6',
	                    categoryName => 'cool linux commands',
	                    description => 'cool linux commands',
	                    htmlUrl => 'http://leocharre.com/articles/category/cool-linux-commands/',
	                    parentId => '0',
	                    rssUrl => 'http://leocharre.com/articles/category/cool-linux-commands/feed/'
	                  }
	                ]

=head3 newMediaObject()

Takes 1 args: data (hashref).
The hashref keys and values are bits (Mime::Base64), type (mime type), and name (filename).

=head3 getTemplate()

Takes 1 args: template.

=head3 setTemplate()

Takes 2 args: content, template.

=head3 getUsersBlogs()

No argument, returns users blogs.
Example return :

	 $r: [
	       {
	         blogName => 'leo charre',
	         blogid => '1',
	         isAdmin => '1',
	         url => 'http://leocharre.com/'
	       }
	     ]

=head3 deletePost()

Argument is post id(number).
Returns boolean.

=head1 WISHLIST

It'd be nice to manage links via xmlrpc.

=head1 AUTHOR

Leo Charre leocharre at cpan dot org

=head1 BUGS

Please submit to AUTHOR

=head1 CAVEATS

This distro is alpha.
Included are the metaWeblog and wp method calls.

=head1 REQUIREMENTS

L<XMLRPC::Lite>

=head1 SEE ALSO

L<XMLRPC::Lite>
L<SOAP::Lite>
WordPress L<http://wordpress.org>

=cut
