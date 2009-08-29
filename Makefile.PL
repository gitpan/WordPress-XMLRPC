use ExtUtils::MakeMaker;
WriteMakefile(
   NAME => 'WordPress::XMLRPC',
   VERSION_FROM => 'lib/WordPress/XMLRPC.pm',
   PREREQ_PM => {
      'YAML' => 0,
      'SOAP::Lite' => 0,
      'XMLRPC::Lite' => 0,
   },
   LICENSE => 'perl',
   AUTHOR => 'Leo Charre leocharre at cpan dot org',
   ABSTRACT_FROM => 'lib/WordPress/XMLRPC.pm',

);
