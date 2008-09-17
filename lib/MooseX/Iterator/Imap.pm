package MooseX::Iterator::Imap;
use Moose;

with 'MooseX::Iterator::Role';

has filter => (
    is       => 'ro',
    isa      => 'CodeRef',
    required => 1,
);

has iterator => (
    is       => 'rw',
    does     => 'MooseX::Iterator::Role',
    handles  => ['_position', '_collection'],
    required => 1,
);

sub has_next {
    my ($self) = @_;
    $self->iterator->has_next;
}

sub peek {
    my ($self) = @_;
    $self->iterator->peek;
}

sub next {
    my ($self)   = @_;
    my $position = $self->iterator->_position;
    local $_ = $self->iterator->_collection->[ $position++ ];
    $self->iterator->_position($position);
    my $next = $self->filter->();
    return $next;
}

no Moose;

1;

