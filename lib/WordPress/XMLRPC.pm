package WordPress::XMLRPC;
use warnings;
use strict;
use Carp;
use vars qw($VERSION);
$VERSION = sprintf "%d.%02d", q$Revision: 1.4 $ =~ /(\d+)/g;



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
   return $self->{proxy};
}

sub username {
   my $self = shift;
   my $val = shift;
   if( defined $val ){
      $self->{username} = $val;      
   }
   return $self->{username};
}

sub password {
   my $self = shift;
   my $val = shift;
   if( defined $val ){
      $self->{password} = $val;      
   }
   return $self->{password};
}

sub blog_id {
   my $self = shift;
   my $val = shift;
   if( defined $val ){
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
      $self->proxy or croak('missing proxy');
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
   
   my $_err;
   for( keys %$err ){
      
      $_err.="ERROR:$_ $$err{$_}\n";
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
	my $page = shift;
   defined $page or croak('missing page hash ref arg');
	my $publish = shift;
	unless (defined $publish) {
		$publish = $self->publish;
	}

	my $call = $self->server->call(
		'wp.newPage',
      $self->blog_id, # ignored
      $self->username, # i had missed these!!!
      $self->password,
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
	my $self = shift;
	my $blog_id = $self->blog_id;
  
	my $username = $self->username;
	my $password = $self->password;
	my $page_id = shift;
   defined $page_id or croak('missing page id arg');

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
	my $self = shift;
	my $blog_id = $self->blog_id;
   my $page_id = shift;
	my $content = shift;
	my $publish = shift;
	unless (defined $publish) {
		$publish = $self->publish;
	}
   defined $page_id or croak('missing page id arg');
   defined $content or croak('missing page content hash ref arg');

	my $call = $self->server->call(
		'wp.editPage',
		$blog_id,
      $page_id,
      $self->username,
      $self->password,
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

   defined $category or croak('missing category string arg');
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
	my $max_results = shift;

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
   defined $data or croak('missing data hash ref arg');

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
   defined $content_struct or croak('missing post hash ref arg');

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
   defined $content_struct or croak('missing post hash ref arg');

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
   defined $post_id or croak('missing post id arg');

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

# xmlrpc.php: function mw_newMediaObject
sub newMediaObject {
	my $self = shift;
	my $blog_id = $self->blog_id;
	my $data = shift;

   defined $data or croak('missing data hash ref arg');

	my $call = $self->server->call(
		'metaWeblog.newMediaObject',
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

# xmlrpc.php: function blogger_deletePost
sub deletePost {
	my $self = shift;
	my $post_id = shift;
	my $user_login = $self->username;
	my $user_pass = $self->password;
	my $publish = shift;
	unless (defined $publish) {
		$publish = $self->publish;
	}

   defined $post_id or croak('missing post id arg');

	my $call = $self->server->call(
		'metaWeblog.deletePost',
      1, #ignored
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

WordPress::XMLRPC

=head1 DESCRIPTION

Interaction with xmlrpc.php as client.

=head1 XML RPC METHODS

=head2 getPage()

takes 1 args: page_id (number)

returns page hashref struct(ure)

example return:

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

This is the same struct hashref you would send to newPage()

=head2 getPages()

returns array ref
each element is a hash ref same as getPage() returns.
If you want less info, just basic info on each page, use getPageList()

=head2 newPage()

takes 2 args: page (hashref), publish (boolean)
you can leave out publish, as discussed further in this documentation.
the hashref must have at least a title and description
returns page id (number, assigned by server).


=head2 deletePage()

takes 1 args: page_id (number)
returns boolean (true or false)

=head2 editPage()

takes 2 args: page (hashref), publish(boolean)
the page hashref is just as discussed in getPage()

you could use getPage(), edit the returned hashref, and resubmit with editPage()

   my $page_hashref = $o->getPage(5);
   $page_hashref->{title} = 'This is the New Title';

   $o->editPage($page_hashref) or die( $o->errstr );

obviously the page id is in the page data (hashref), this is there inherently when you
call getPage().

The same would be done with the posts.

=head2 getPageList()

returns array ref
each element is a hash ref
this is sort of a short version of getPages(), which returns all info for each.

example return:

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


=head2 getAuthors()

takes no argument
returns array ref, each element is a hashref 

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


=head2 getCategories()

takes no argument

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


=head2 newCategory()

takes 1 args: category (string)
returns category id (number)

=head2 suggestCategories()

takes 2 args: category, max_results

returns array ref, each element is a hashref
(not sure what this is for)

=head2 uploadFile()

takes 1 args: data
data is a hash ref, see WordPress::MediaObject

=head2 newPost()

takes 2 args: content_struct, publish
returns id number of new post

=head2 editPost()

takes 3 args: post_ID, content_struct, publish
returns boolean, true or false

=head2 getPost()

takes 1 args: post_ID
returns post struct, hashref

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

=head2 getRecentPosts()

takes 1 args: num_posts (number, optional)

returns array ref
each element is hash ref same as getPost() would return

=head2 getCategories()

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

=head2 newMediaObject()

takes 1 args: data (hashref)
See WordPress::MediaObject

=head2 getTemplate()

takes 1 args: template

=head2 setTemplate()

takes 2 args: content, template

=head2 getUsersBlogs()

no argument, terutns users blogs
example return :

	 $r: [
	       {
	         blogName => 'leo charre',
	         blogid => '1',
	         isAdmin => '1',
	         url => 'http://leocharre.com/'
	       }
	     ]


=head1 deletePost()

argument is post id(number)
returns boolean


=head1 METHODS

=head2 xmlrpc_methods()

returns array of methods in this package that make calls via xmlrpc

=head2 server_methods()

returns array of server methods accessible via xmlrpc.

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
If you pass 'poxy' to constructor, it is prepopulated.

=head2 server()

returns XMLRPC::Lite object
proxy must be set

=head2 blog_id()

setget method, set to '1' by default

=head2 publish()

many methods use 'publish' boolean value, by default we set to 1
you can still pass a value for publish such as

   $o->newPost( $content_hashref, 1 );

but you can also call 

   $o->newPost( $content_hashref );

As we said, by default it is set to 1, if you want to set the default to 0,

   $o->publish(0);

=head2 errstr()

returns error string if a call fails

   $o->newPost(@args) or die($o->errstr);

=head1 AUTHOR

Leo Charre leocharre at cpan dot org

=head1 BUGS

Please submit to AUTHOR

=head1 CAVEATS

This distro is alpha.
Included are the metaWeblog and wp method calls.

=head1 SEE ALSO

XMLRPC::Lite
SOAP::Lite

=cut
