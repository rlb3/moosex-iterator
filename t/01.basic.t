#!perl

use Test::More tests => 18;

package TestIterator;

use Moose;
use MooseX::Iterator;

has numbers => (
    is      => 'ro',
    isa     => 'ArrayRef',
    default => sub { [ 5, 6, 7, 8, 9, 10 ] },
);

has iter => (
    metaclass    => 'MooseX::Iterator',
    iterate_over => 'numbers',
    provides     => {
        next     => 'my_next',
        has_next => 'my_has_next',
        peek     => 'my_peek',
        contents => 'my_contents',
    },
);

no Moose;

package main;

my $test = TestIterator->new;

my $count = 5;
while ( $test->my_has_next ) {
    my $peek = $test->my_peek;
    my $next = $test->my_next;

    is $next, $count, 'Current position value ' . $count;

    if ( $count < 10 ) {
        ok $test->my_has_next, 'has next';
    }
    else {
        ok !$test->my_has_next, 'does not have next';
        last;
    }

    is $peek, $count + 1, 'peek ahead of ' . $count . " ($peek)";

    $count += 1;
}

is_deeply $test->my_contents, [ 5, 6, 7, 8, 9, 10 ], 'Contents';
