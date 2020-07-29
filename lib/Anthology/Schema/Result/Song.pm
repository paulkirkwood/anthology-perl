use utf8;
package Anthology::Schema::Result::Song;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Anthology::Schema::Result::Song

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

=head1 TABLE: C<songs>

=cut

__PACKAGE__->table("songs");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0
  sequence: 'songs_id_seq'

=head2 instrumental

  data_type: 'boolean'
  default_value: false
  is_nullable: 0

=head2 duration

  data_type: 'integer'
  is_nullable: 0

=head2 slug

  data_type: 'text'
  is_nullable: 0

=head2 title

  data_type: 'text'
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "id",
  {
    data_type         => "integer",
    is_auto_increment => 1,
    is_nullable       => 0,
    sequence          => "songs_id_seq",
  },
  "instrumental",
  { data_type => "boolean", default_value => \"false", is_nullable => 0 },
  "duration",
  { data_type => "integer", is_nullable => 0 },
  "slug",
  { data_type => "text", is_nullable => 0 },
  "title",
  { data_type => "text", is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 RELATIONS

=head2 song_writers

Type: has_many

Related object: L<Anthology::Schema::Result::SongWriter>

=cut

__PACKAGE__->has_many(
  "song_writers",
  "Anthology::Schema::Result::SongWriter",
  { "foreign.song_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 tracks

Type: has_many

Related object: L<Anthology::Schema::Result::Track>

=cut

__PACKAGE__->has_many(
  "tracks",
  "Anthology::Schema::Result::Track",
  { "foreign.song_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07049 @ 2020-03-15 14:47:22
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:Jgdjp34Rdbp0T4ZKjoyk6w

__PACKAGE__->many_to_many( 'writers', 'song_writers', 'person' );

# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
