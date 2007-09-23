package MooseX::Iterator::Meta::Array;
use Moose;

our $VERSION   = '0.03';
our $AUTHORITY = 'cpan:RLB';

extends 'Moose::Meta::Attribute';

has iterate_over => ( is => 'ro', isa => 'Str', default => '' );

before '_process_options' => sub {
    my ( $class, $name, $options ) = @_;

    $class->meta->add_attribute(
        iterate_name => ( is => 'ro', isa => 'Str', default => $name ) );
};

after 'install_accessors' => sub {
    my ($self) = @_;
    my $class = $self->associated_class;

    my $collection_name = $self->iterate_over;
    my $iterate_name    = $self->iterate_name;
    my $collection      = $class->construct_instance->$collection_name;

    $class->add_method(
        $iterate_name => sub {
            MooseX::Iterator->new( collection => $collection, );
        }
    );
};

no Moose;

package Moose::Meta::Attribute::Custom::Iterate;
sub register_implementation { 'MooseX::Iterator::Meta::Array' }

1;