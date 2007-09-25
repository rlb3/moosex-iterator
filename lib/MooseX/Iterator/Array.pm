package MooseX::Iterator::Array;
use Moose;

use MooseX::Iterator::Meta::Iterable;

our $VERSION   = '0.05';
our $AUTHORITY = 'cpan:RLB';

with 'MooseX::Iterator::Role';

has _position => ( is => 'rw', isa => 'Int', default => 0 );
has collection => ( is => 'ro', isa => 'ArrayRef' );

sub next {
    my ($self)   = @_;
    my $position = $self->_position;
    my $next     = $self->collection->[ $position++ ];
    $self->_position($position);
    return $next;
}

sub has_next {
    my ($self) = @_;
    my $position = $self->_position;
    return exists $self->collection->[$self->_position];
}

sub peek {
    my ($self) = @_;
    if ( $self->has_next ) {
        return $self->collection->[ $self->_position + 1];
    }
    return;
}

no Moose;

1;
