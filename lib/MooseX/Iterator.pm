package MooseX::Iterator;
use Moose::Role;

our $VERSION   = '0.04';
our $AUTHORITY = 'cpan:RLB';

requires $_ for qw{
    next
    has_next
    peek
};

1;