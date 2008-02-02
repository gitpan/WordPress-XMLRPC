use ExtUtils::MakeMaker;
WriteMakefile(
   NAME => 'WordPress::XMLRPC',
   VERSION_FROM => 'lib/WordPress/XMLRPC.pm',
   PREREQ_PM => {
      'YAML' => 0,
      'Smart::Comments' => 0,
      'XMLRPC::Lite' => 0,

   },
);
