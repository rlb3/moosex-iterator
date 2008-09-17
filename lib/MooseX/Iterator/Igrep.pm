package MooseX::Iterator::Igrep;
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
    while ($self->iterator->has_next) {
        local $_ = $self->iterator->next;
        if ($self->filter->()) {
            return $_;
        }
    }
}

no Moose;

1;
