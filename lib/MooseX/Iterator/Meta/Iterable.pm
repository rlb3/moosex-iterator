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

    if (defined $options->{is}) {
        confess "Can not use 'is' with the Iterable metaclass" ;
    }

    $class->meta->add_attribute( iterate_name => ( is => 'ro', isa => 'Str', default => $name ) );
};

after 'install_accessors' => sub {
    my ($self) = @_;
    my $class = $self->associated_class;

    my $collection_name = $self->iterate_over;
    my $iterate_name    = $self->iterate_name;

    $class->add_method(
        $iterate_name => sub {
            my ($self) = @_;
            my $collection = $self->$collection_name;

            my $type = $self->meta->get_attribute($collection_name)->type_constraint;

            if ( $type eq 'ArrayRef' ) {
                MooseX::Iterator::Array->new( collection => $self->$collection_name );
            }
            elsif ( $type eq 'HashRef') {
                MooseX::Iterator::Hash->new( collection => $self->$collection_name );
            }
        }
    );
};

no Moose;

package Moose::Meta::Attribute::Custom::Iterable;
sub register_implementation { 'MooseX::Iterator::Meta::Iterable' }

1;