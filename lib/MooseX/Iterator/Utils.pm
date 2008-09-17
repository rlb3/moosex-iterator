package MooseX::Iterator::Utils;
use strict;
use warnings;

use MooseX::Iterator::Imap;
use MooseX::Iterator::Igrep;

my @export = qw(imap igrep);
sub import {
    my $caller = caller();
    no strict 'refs';
    foreach my $sub (@export) {
        *{$caller . '::' . $sub} = \&{$sub};
    }
}

sub imap(&$) {
    my ( $filter, $it ) = @_;
    my $imap = MooseX::Iterator::Imap->new(
        filter   => $filter,
        iterator => $it,
    );
    return $imap;
}

sub igrep(&$) {
    my ( $filter, $it ) = @_;
    my $igrep = MooseX::Iterator::Igrep->new(
        filter   => $filter,
        iterator => $it,
    );
}

1;
