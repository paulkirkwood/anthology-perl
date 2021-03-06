use utf8;
package Anthology::Schema::Result::Instrument;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Anthology::Schema::Result::Instrument

=cut

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';

=head1 COMPONENTS LOADED

=over 4

=item * L<DBIx::Class::InflateColumn::DateTime>

=back

=cut

__PACKAGE__->load_components("InflateColumn::DateTime");

=head1 TABLE: C<instruments>

=cut

__PACKAGE__->table("instruments");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0
  sequence: 'instruments_id_seq'

=head2 name

  data_type: 'text'
  is_nullable: 0

=head2 slug

  data_type: 'text'
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "id",
  {
    data_type         => "integer",
    is_auto_increment => 1,
    is_nullable       => 0,
    sequence          => "instruments_id_seq",
  },
  "name",
  { data_type => "text", is_nullable => 0 },
  "slug",
  { data_type => "text", is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 RELATIONS

=head2 album_musicians

Type: has_many

Related object: L<Anthology::Schema::Result::AlbumMusician>

=cut

__PACKAGE__->has_many(
  "album_musicians",
  "Anthology::Schema::Result::AlbumMusician",
  { "foreign.instrument_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07049 @ 2020-03-16 19:59:37
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:pzJrkmnyhkHAr3DgQ6W04Q


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
