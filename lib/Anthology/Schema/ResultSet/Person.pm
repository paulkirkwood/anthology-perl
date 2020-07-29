package Anthology::Schema::ResultSet::Person;

use strict;
use warnings;

use base 'DBIx::Class::ResultSet';

sub person_from_slug {
    my ( $self, $slug ) = @_;
    return $self->search( { slug => $slug }, { rows => 1 } )->single;
}

1;
