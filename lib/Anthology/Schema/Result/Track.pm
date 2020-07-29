use utf8;
package Anthology::Schema::Result::Track;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Anthology::Schema::Result::Track

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

=head1 TABLE: C<tracks>

=cut

__PACKAGE__->table("tracks");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0
  sequence: 'tracks_id_seq'

=head2 number

  data_type: 'integer'
  is_nullable: 0

=head2 duration

  data_type: 'integer'
  is_nullable: 1

=head2 album_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 1

=head2 song_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 1

=head2 live

  data_type: 'boolean'
  default_value: false
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "id",
  {
    data_type         => "integer",
    is_auto_increment => 1,
    is_nullable       => 0,
    sequence          => "tracks_id_seq",
  },
  "number",
  { data_type => "integer", is_nullable => 0 },
  "duration",
  { data_type => "integer", is_nullable => 1 },
  "album_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 1 },
  "song_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 1 },
  "live",
  { data_type => "boolean", default_value => \"false", is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 RELATIONS

=head2 album

Type: belongs_to

Related object: L<Anthology::Schema::Result::Album>

=cut

__PACKAGE__->belongs_to(
  "album",
  "Anthology::Schema::Result::Album",
  { id => "album_id" },
  {
    is_deferrable => 0,
    join_type     => "LEFT",
    on_delete     => "CASCADE",
    on_update     => "CASCADE",
  },
);

=head2 song

Type: belongs_to

Related object: L<Anthology::Schema::Result::Song>

=cut

__PACKAGE__->belongs_to(
  "song",
  "Anthology::Schema::Result::Song",
  { id => "song_id" },
  {
    is_deferrable => 0,
    join_type     => "LEFT",
    on_delete     => "CASCADE",
    on_update     => "CASCADE",
  },
);


# Created by DBIx::Class::Schema::Loader v0.07049 @ 2020-03-15 12:31:55
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:ZxElu/r1EwSULzBDYWBsdQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
