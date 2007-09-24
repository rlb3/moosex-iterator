use inc::Module::Install;

# Define metadata
name 'MooseX-Iterator';
all_from 'lib/MooseX/Iterator.pm';

# Specific dependencies
requires 'Moose'            => '0.25';
build_requires 'Test::More' => '0.42';
license 'perl';

auto_install;
WriteAll;
