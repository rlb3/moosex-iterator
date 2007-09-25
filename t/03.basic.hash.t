#!perl

use Test::More (no_plan);

use Data::Dumper;
use Moose;
use MooseX::Iterator;

my $test =
  MooseX::Iterator::Hash->new(
    collection => { one => '1', two => '2', three => '3' } );

while ( $test->has_next ) {
    my $next = $test->next;

    is ref $next, 'HASH';
    diag Dumper $next;

}
