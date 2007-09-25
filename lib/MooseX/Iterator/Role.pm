package MooseX::Iterator::Role;
use Moose::Role;

our $VERSION   = '0.05';
our $AUTHORITY = 'cpan:RLB';

requires $_ for qw{
    next
    has_next
    peek
};

has '_collection' => (is => 'rw', init_arg => 'collection');

1;