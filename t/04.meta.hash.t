#!perl

use Test::More (no_plan);

package TestIterator;

use Moose;
use MooseX::Iterator;

has collection => (
    is      => 'ro',
    isa     => 'HashRef',
    default => sub { { one => '1', two => '2', three => '3' } },
);

has iter => (
    metaclass    => 'Iterable',
    iterate_over => 'collection',
);

no Moose;

package main;
use Data::Dumper;

my $test = TestIterator->new;

my $it= $test->iter;

while ( $it->has_next ) {
    my $next = $it->next;

    is ref $next, 'HASH';
    diag Dumper $next;

}
