package Anthology::Schema::ResultSet::Band;

use strict;
use warnings;

use base 'DBIx::Class::ResultSet';

sub band_from_slug {
    my ( $self, $slug ) = @_;
    return $self->search( { slug => $slug }, { rows => 1 } )->single;
}

1;
