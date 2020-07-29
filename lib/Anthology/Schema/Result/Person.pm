use utf8;
package Anthology::Schema::Result::Person;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Anthology::Schema::Result::Person

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

=head1 TABLE: C<people>

=cut

__PACKAGE__->table("people");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0
  sequence: 'people_id_seq'

=head2 first_name

  data_type: 'text'
  is_nullable: 0

=head2 last_name

  data_type: 'text'
  is_nullable: 0

=head2 slug

  data_type: 'text'
  is_nullable: 0

=head2 date_of_birth

  data_type: 'date'
  is_nullable: 0

=head2 deceased_date

  data_type: 'date'
  is_nullable: 1

=head2 male

  data_type: 'boolean'
  default_value: true
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "id",
  {
    data_type         => "integer",
    is_auto_increment => 1,
    is_nullable       => 0,
    sequence          => "people_id_seq",
  },
  "first_name",
  { data_type => "text", is_nullable => 0 },
  "last_name",
  { data_type => "text", is_nullable => 0 },
  "slug",
  { data_type => "text", is_nullable => 0 },
  "date_of_birth",
  { data_type => "date", is_nullable => 0 },
  "deceased_date",
  { data_type => "date", is_nullable => 1 },
  "male",
  { data_type => "boolean", default_value => \"true", is_nullable => 0 },
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
  { "foreign.person_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 song_writers

Type: has_many

Related object: L<Anthology::Schema::Result::SongWriter>

=cut

__PACKAGE__->has_many(
  "song_writers",
  "Anthology::Schema::Result::SongWriter",
  { "foreign.person_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07049 @ 2020-03-16 19:59:37
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:HdDspLpkq8PPsHerAnZ3Pw

__PACKAGE__->many_to_many( 'albums', 'album_musicians', 'album' );

__PACKAGE__->many_to_many( 'songs', 'song_writers', 'song' );


__PACKAGE__->has_many(
  "band_members",
  "Anthology::Schema::Result::BandMember",
  { "foreign.person_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

__PACKAGE__->many_to_many( 'bands', 'band_members', 'band' );

sub full_name {
    my ( $self ) = @_;
    return sprintf( "%s %s", $self->first_name, $self->last_name );
}

# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
