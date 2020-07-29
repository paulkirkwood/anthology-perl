package Anthology::Schema::ResultSet::Album;

use strict;
use warnings;

use base 'DBIx::Class::ResultSet';

sub album_from_slug {
    my ( $self, $slug ) = @_;
    return $self->search( { slug => $slug }, { rows => 1 } )->single;
}

1;
