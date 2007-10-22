package MooseX::Iterator::Meta::Iterable;
use Moose;
use MooseX::Iterator::Array;

use Carp 'confess';

our $VERSION   = '0.05';
our $AUTHORITY = 'cpan:RLB';

extends 'Moose::Meta::Attribute';

has iterate_over => ( is => 'ro', isa => 'Str', default => '' );

before '_process_options' => sub {
    my ( $class, $name, $options ) = @_;

    if ( defined $options->{is} ) {
        confess "Can not use 'is' with the Iterable metaclass";
    }

    $class->meta->add_attribute( iterate_name => ( is => 'ro', isa => 'Str', default => $name ) );
};

after 'install_accessors' => sub {
    my ($self) = @_;
    my $class = $self->associated_class;

    my $iterate_name    = $self->iterate_name;
    my $collection_name = $self->iterate_over;

    my $type       = $class->get_attribute($collection_name)->type_constraint->name;
    my $collection = $class->get_attribute($collection_name)->get_read_method;

    my $iterator_class_name;
    if ( $type eq 'ArrayRef' ) {
        $iterator_class_name = 'MooseX::Iterator::Array';
    }
    elsif ( $type eq 'HashRef' ) {
        $iterator_class_name = 'MooseX::Iterator::Hash';
    }
    else {
        confess 'The type must be either ArrayRef or HashRef';
    }

    $class->add_method(
        $iterate_name => sub {
            my ($self) = @_;
            $iterator_class_name->new( collection => $self->$collection );
        }
    );
};

no Moose;

package Moose::Meta::Attribute::Custom::Iterable;
sub register_implementation { 'MooseX::Iterator::Meta::Iterable' }

1;
