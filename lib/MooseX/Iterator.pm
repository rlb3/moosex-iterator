package MooseX::Iterator;
use Moose;

our $VERSION   = '0.01';
our $AUTHORITY = 'cpan:RLB';

extends 'Moose::Meta::Attribute';

has 'provides'     => ( is => 'ro', isa => 'HashRef', default => sub { {} } );
has 'iterate_over' => ( is => 'ro', isa => 'Str',     default => ''         );

has 'methods' => (
    is      => 'ro',
    isa     => 'HashRef',
    default => sub {
        {
            next => sub {
                my ( $self, $collection ) = @_;
                my $position = $self->__position;
                my $next     = $self->$collection->[ $position++ ];
                $self->__position($position);
                return $next;
              },
              has_next => sub {
                my ( $self, $collection ) = @_;
                my $position = $self->__position;
                return exists $self->$collection->[ $position++ ];
              },
              peek => sub {
                my ( $self, $collection, $method_names ) = @_;

                my $has_next = $method_names->{'has_next'};

                if ( $self->$has_next ) {
                    my $position = $self->__position;
                    return $self->$collection->[ ++$position ];
                }
                return;
              },
              contents => sub {
                my ( $self, $collection ) = @_;
                return $self->$collection;
              },
        };
    },
);

after 'install_accessors' => sub {
    my ($attr)     = @_;
    my $class      = $attr->associated_class;
    my $collection = $attr->iterate_over;

    $class->add_attribute(
        '__position', => ( is => 'rw', isa => 'Int', default => 0 ) );

    my %reverse_methods = reverse %{ $attr->provides };

    foreach my $method ( keys %{ $attr->provides } ) {
        $class->add_method(
            $method => sub {
                my ($self) = @_;
                $attr->methods->{ $attr->provides->{$method} }
                  ->( $self, $collection, \%reverse_methods );
            },
        );

    }
};

no Moose;

1;
