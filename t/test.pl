use strict;

sub _conf {
   my $abs = shift;
   require YAML;
   my $conf = YAML::LoadFile($abs);
   $conf->{username} = $conf->{U};
   $conf->{password} = $conf->{P};
   $conf->{proxy} = $conf->{p};
   return $conf;
}

1;
