package MooseX::Iterator;
use Moose;

our $VERSION   = '0.01';
our $AUTHORITY = 'cpan:RLB';

extends 'Moose::Meta::Attribute';

has provides     => ( is => 'ro', isa => 'HashRef', default => sub { {} } );
has iterate_over => ( is => 'ro', isa => 'Str', default => '' );

has methods => (
    is      => 'ro',
    isa     => 'HashRef',
    default => sub {
        {
              next => sub {
                my ( $self, $collection, $collection_position_name ) = @_;
                my $position = $self->$collection_position_name;
                my $next     = $self->$collection->[ $position++ ];
                $self->$collection_position_name($position);
                return $next;
              },
              has_next => sub {
                my ( $self, $collection, $collection_position_name ) = @_;
                my $position = $self->$collection_position_name;
                return exists $self->$collection->[ $position++ ];
              },
              peek => sub {
                my ( $self, $collection, $collection_position_name, $method_names ) = @_;

                my $has_next = $method_names->{'has_next'};

                if ( $self->$has_next ) {
                    my $position = $self->$collection_position_name;
                    return $self->$collection->[ ++$position ];
                }
                return;
              },
              contents => sub {
                my ( $self, $collection ) = @_;
                return $self->$collection;
              },
        },
    },
);

after 'install_accessors' => sub {
    my ($attr)                   = @_;
    my $class                    = $attr->associated_class;
    my $collection               = $attr->iterate_over;
    my $collection_position_name = '__' . $collection . '_position';

    $class->add_attribute(
        $collection_position_name => ( is => 'rw', isa => 'Int', default => 0 ) );

    my %methods = %{ $attr->provides };

    foreach my $method ( keys %{ $attr->provides } ) {
        $class->add_method(
            $attr->provides->{$method} => sub {
                my ($self) = @_;
                $attr->methods->{$method}->( $self, $collection, $collection_position_name, \%methods );
            },
        );

    }
};

no Moose;

1;
