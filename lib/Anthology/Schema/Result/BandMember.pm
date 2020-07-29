use utf8;
package Anthology::Schema::Result::BandMember;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Anthology::Schema::Result::BandMember

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 COMPONENTS LOADED

=over 4

=item * L<DBIx::Class::InflateColumn::DateTime>

=back

=cut

__PACKAGE__->load_components("InflateColumn::DateTime");

=head1 TABLE: C<band_members>

=cut

__PACKAGE__->table("band_members");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0
  sequence: 'band_members_id_seq'

=head2 band_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 1

=head2 person_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 1

=head2 joined_date

  data_type: 'date'
  is_nullable: 0

=head2 left_date

  data_type: 'date'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "id",
  {
    data_type         => "integer",
    is_auto_increment => 1,
    is_nullable       => 0,
    sequence          => "band_members_id_seq",
  },
  "band_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 1 },
  "person_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 1 },
  "joined_date",
  { data_type => "date", is_nullable => 0 },
  "left_date",
  { data_type => "date", is_nullable => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 RELATIONS

=head2 band

Type: belongs_to

Related object: L<Anthology::Schema::Result::Band>

=cut

__PACKAGE__->belongs_to(
  "band",
  "Anthology::Schema::Result::Band",
  { id => "band_id" },
  {
    is_deferrable => 0,
    join_type     => "LEFT",
    on_delete     => "CASCADE",
    on_update     => "CASCADE",
  },
);

=head2 person

Type: belongs_to

Related object: L<Anthology::Schema::Result::Person>

=cut

__PACKAGE__->belongs_to(
  "person",
  "Anthology::Schema::Result::Person",
  { id => "person_id" },
  {
    is_deferrable => 0,
    join_type     => "LEFT",
    on_delete     => "CASCADE",
    on_update     => "CASCADE",
  },
);


# Created by DBIx::Class::Schema::Loader v0.07049 @ 2020-03-08 20:56:33
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:0O8IBcHUNuxrL8zn5ZsHVg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
