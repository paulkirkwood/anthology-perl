package Anthology::Controller::Bands;

use Moose;
use namespace::autoclean;
use JSON;
use Text::Slugify qw(slugify);
 
BEGIN { extends 'Catalyst::Controller::REST' }

sub base :Chained('/') PathPart('bands') CaptureArgs(0) {}

sub bands :Chained('base') PathPart('') Args(0) ActionClass('REST') {}

sub bands_GET {
    my ( $self, $c ) = @_;
    my @entity = map { $self->_band_entity( $_ ) } $c->model( "DB::Band" )->all;
    $self->status_ok( $c, entity => \@entity );
}

sub bands_POST {
    my ( $self, $c ) = @_;

    my @required_fields = qw( name );

    foreach my $required ( @required_fields ) {
        return $self->status_bad_request( $c, message => "Missing required field: " . $required )
            unless exists( $c->req->data->{$required} );
    }

    my ( $name ) = map { $c->req->data->{$_} } @required_fields;

    my $slug = slugify( $name );

    if ( $c->model( "DB::Band" )->search( { slug => $slug }, {} )->single ) {
        $self->status_bad_request( $c, message => "Band '${name}' already exists" );
        $c->detach;
    }

    my $band = $c->model( "DB::Band" )->create( {
        name => $name,
        slug => $slug,
    } );

    $self->status_created( $c, location => $c->req->uri->as_string, entity => $self->_band_entity( $band ) );
}

sub find_band :Chained('/') PathPart('bands') CaptureArgs(1) {
    my ( $self, $c, $slug ) = @_;

    my $where = {
        slug => $slug,
    };

    my $attrs = {
        prefetch => [ { band_members => [ 'person' ] } ],
        order_by => [ 'band_members.joined_date' ],
    };

    my $band = $c->model( "DB::Band" )->find( $where, $attrs );

    unless( $band ) {
        $self->status_bad_request( $c, message => "Band '${slug}' does not exist" );
        $c->detach;
    }

    $c->stash( band => $band );
}

sub band : Chained('find_band') PathPart('') Args(0) ActionClass('REST') {}

sub band_GET {
    my ( $self, $c ) = @_;
    $self->status_ok( $c, entity => $self->_band_entity( $c->{stash}->{band} ) );
}

sub albums : Chained('find_band') PathPart('albums') Args(0) ActionClass('REST') {}

sub albums_GET {
    my ( $self, $c ) = @_;
    $self->status_ok( $c, entity => [ map { $self->_album_entity( $_ ) } $c->{stash}->{band}->albums ] );
}

sub albums_POST {
    my ( $self, $c ) = @_;

    my @required_fields = qw( release_date title );

    foreach my $required ( @required_fields ) {
        return $self->status_bad_request( $c, message => "Missing required field: " . $required )
            unless exists( $c->req->data->{$required} );
    }

    my ( $release_date, $title ) = map { $c->req->data->{$_} } @required_fields;

    my $album_slug = slugify( $title );

    if ( $c->model( "DB::Album" )->album_from_slug( $album_slug ) ) {
        return $self->status_bad_request( $c, message => "Album '${album_slug}' already exists" );
    }

    my $album = $c->model( "DB::Album" )->create( {
        band_id      => $c->{stash}->{band}->id,
        release_date => $release_date,
        slug         => $album_slug,
        title        => $title,
    } );

    $self->status_created( $c, location => $c->req->uri->as_string, entity => $self->_album_entity( $album ) );
}

sub find_album :Chained('find_band') PathPart('albums') CaptureArgs(1) {
    my ( $self, $c, $slug ) = @_;

    my $where = {
        slug => $slug,
    };

    my $attrs = {
        prefetch => [ { album_musicians => [ 'instrument', 'person' ] }, { tracks => [ 'song' ] } ],
    };

    my $album = $c->model( "DB::Album" )->find( $where, $attrs );

    unless( $album ) {
        $self->status_bad_request( $c, message => "Album '${slug}' does not exist" );
        $c->detach;
    }

    $c->stash( album => $album );
}

sub album : Chained('find_album') PathPart('') Args(0) ActionClass('REST') {}

sub album_GET {
    my ( $self, $c ) = @_;
    $self->status_ok( $c, entity => $self->_album_entity( $c->{stash}->{album} ) );
}

sub tracks :Chained('find_album') PathPart('tracks') Args(0) ActionClass('REST') {}

sub tracks_GET {
    my ( $self, $c ) = @_;

    my $where = {
        album_id => $c->stash->{album}->id,
    };

    my $attrs = {
        order_by => 'number',
    };

    my $tracks_rs = $c->model( "DB::Track" )->search( $where, $attrs );

    $self->status_ok( $c, entity => [ map { $self->_track_entity( $_ ) } $tracks_rs->all ] );
}

sub tracks_POST {
    my ( $self, $c ) = @_;

    my @required_fields = qw( song );

    foreach my $required ( @required_fields ) {
        unless( exists( $c->req->data->{$required} ) ) {
            $self->status_bad_request( $c, message => "Missing required field: " . $required );
            $c->detach;
        }
    }

    my ( $slug ) = map { $c->req->data->{$_} } @required_fields;

    my $song = $c->model( "DB::Song" )->song_from_slug( $slug );

    unless( $song ) {
        $self->status_bad_request( $c, message => "Song '${slug}' does not exist" );
        $c->detach;
    }

    my $track_rs = $c->model( "DB::Track" )->search( { album_id => $c->stash->{album}->id } );
    my $number = $track_rs->get_column( 'number' )->max || 0;

    my $where = {
        album_id => $c->stash->{album}->id,
        number   => $number++,
        song_id  => $song->id,
    };

    if ( $c->model( "DB::Track" )->search( $where, { rows => 1 } )->single ) {
        return $self->status_bad_request( $c, message => "Track '${number}' already exists" );
    }

    my $duration;
    if ( $c->req->data->{duration} ) {

        unless( $c->req->data->{duration} =~ /^(\d+):(\d+)$/ ) {
            return $self->status_bad_request( $c, message => "Invalid time format" );
        }

        my ( $mins, $secs) = map {$_ || 0} $1, $2;

        return $self->status_bad_request( $c, message => "Bad minutes value: $mins" ) if $mins > 59 && $mins >= 0;
        return $self->status_bad_request( $c, message => "Bad seconds value: $secs" ) if $secs > 59 && $secs >= 0;

        $duration = ( $mins * 60 ) + $secs;
    }
    else {
        $duration = $song->duration;
    }

    my $track = $c->stash->{album}->add_to_tracks({
        duration => $duration,
        live     => $c->req->data->{live} ? $c->req->data->{live} : 0,
        number   => $number,
        song_id  => $song->id,
    } );

    $self->status_created( $c, location => $c->req->uri->as_string, entity => $self->_track_entity( $track ) );
}

sub find_track :Chained('find_album') PathPart('tracks') CaptureArgs(1) {
    my ( $self, $c, $id ) = @_;

    my $where = {
        album_id => $c->stash->{album}->id,
        number   => $id,
    };

    my $track = $c->model( "DB::Track" )->search( $where, { rows => 1 } )->single();

    unless( $track ) {
        $self->status_bad_request( $c, message => "Track '${id}' does not exist" );
        $c->detach;
    }

    $c->stash( track => $track );
}

sub track : Chained('find_track') PathPart('') Args(0) ActionClass('REST') {}

sub track_GET {
    my ( $self, $c ) = @_;
    $self->status_ok( $c, entity => $self->_track_entity( $c->{stash}->{track} ) );
}

sub musicians :Chained('find_album') PathPart('musicians') Args(0) ActionClass('REST') {}

sub musicians_GET {
    my ( $self, $c ) = @_;
    $self->status_ok( $c, entity => $self->_musicians_entity( $c->{stash}->{album} ) );
}

sub musicians_POST {
    my ( $self, $c ) = @_;

    my @required_fields = qw( instrument musician );

    foreach my $required ( @required_fields ) {
        return $self->status_bad_request( $c, message => "Missing required field: " . $required )
            unless exists( $c->req->data->{$required} );
    }

    my ( $instrument_slug, $person_slug ) = map { $c->req->data->{$_} } @required_fields;

    my $instrument = $c->model( "DB::Instrument" )->instrument_from_slug( $instrument_slug );
    unless( $instrument ) {
        return $self->status_bad_request( $c, message => "Instrument '${instrument_slug}' does not exist" );
    }

    my $person = $c->model( "DB::Person" )->person_from_slug( $person_slug);
    unless( $person ) {
        return $self->status_bad_request( $c, message => "Person '${person_slug}' does not exist" );
    }

    my $album = $c->{stash}->{album};

    $album->add_to_album_musicians( {
        instrument_id => $instrument->id,
        person_id     => $person->id,
    } );

    $self->status_created( $c, location => $c->req->uri->as_string, entity => $self->_album_entity( $album ) );
}

sub members :Chained('find_band') PathPart('members') Args(0) ActionClass('REST') {}

sub members_GET {
    my ( $self, $c ) = @_;
    $self->status_ok( $c, entity => $self->_members_entity( $c->{stash}->{band} ) );
}

sub members_POST {
    my ( $self, $c ) = @_;

    my @required_fields = qw( joined_date person );

    foreach my $required ( @required_fields ) {
        return $self->status_bad_request( $c, message => "Missing required field: " . $required )
            unless exists( $c->req->data->{$required} );
    }

    my ( $joined_date, $person_slug ) = map { $c->req->data->{$_} } @required_fields;

    my $person = $c->model( "DB::Person" )->person_from_slug( $person_slug);
    unless( $person ) {
        return $self->status_bad_request( $c, message => "Person '${person_slug}' does not exist" );
    }

    my $band = $c->{stash}->{band};

    $band->add_to_band_members( {
        joined_date => $joined_date,
        person_id   => $person->id,
    } );

    $self->status_created( $c, location => $c->req->uri->as_string, entity => $self->_members_entity( $band ) );
}

sub find_member :Chained('find_band') PathPart('members') CaptureArgs(1) {
    my ( $self, $c, $slug ) = @_;

    my $person = $c->model( "DB::Person" )->person_from_slug( $slug);
    unless( $person ) {
        return $self->status_bad_request( $c, message => "Person '${slug}' does not exist" );
    }

    my $where = {
        band_id     => $c->stash->{band}->id,
        person_id   => $person->id,
        joined_date => { '!=', undef },
        left_date   => undef,
    };

    my $member = $c->model( "DB::BandMember" )->search( $where, { rows => 1 } )->single();

    unless( $member ) {
        $self->status_bad_request( $c, message => $person->full_name . " is not a member of the band" );
        $c->detach;
    }

    $c->stash( band_member => $member );
}

sub member : Chained('find_member') PathPart('') Args(0) ActionClass('REST') {}

sub member_DELETE {
    my ( $self, $c ) = @_;

    my $body = $c->req->data;

    my @required_fields = qw( left_date );

    foreach my $required ( @required_fields ) {
        return $self->status_bad_request( $c, message => "Missing required field: " . $required )
            unless exists( $c->req->data->{$required} );
    }

    my ( $left_date ) = map { $c->req->data->{$_} } @required_fields;

    my $member = $c->stash->{band_member};
    $member->update( { left_date => $left_date } );

    $self->status_accepted( $c, entity => { status => $member->person->full_name . " left the band" } );
}

#
# Private methods
#
sub _album_entity {
    my ( $self, $album ) = @_;

    my ( $duration, $live_tracks, $total_tracks ) = ( 0, 0, 0 );

    my @tracks;
    foreach my $track ( $album->tracks ) {
        $duration += $track->duration;
        $live_tracks++ if $track->live;
        $total_tracks++;
        push @tracks, $self->_track_entity( $track );
    }

    my $duration_str;
    if ( $duration > 3600 ) {
        $duration_str = sprintf( "%d:%d:%d", $duration / 3600, $duration / 60, $duration % 60 );
    }
    else {
        $duration_str = sprintf( "%d:%d", $duration / 60, $duration % 60 );
    }

    my $musicians = {};
    foreach my $album_musician ( $album->album_musicians ) {
        my $musician = $album_musician->person->full_name;
        my $instruments = $musicians->{$musician} ||= [];
        push @$instruments, $album_musician->instrument->name;
    }

    return {
        duration     => $duration_str,
        release_date => $album->release_date->strftime( "%Y-%m-%d" ),
        slug         => $album->slug,
        title        => $album->title,
        tracks       => \@tracks,
        credits      => $self->_musicians_entity( $album ),
        live         => $live_tracks == $total_tracks ? JSON::true : JSON::false,
    };
}

sub _band_entity {
    my ( $self, $band ) = @_;

    my $entity = {
        name   => $band->name,
        slug   => $band->slug,
    };

    my @memberships = sort { DateTime->compare($a->joined_date, $b->joined_date) } $band->band_members;
    if ( @memberships ) {
        $entity->{formed} = $memberships[0]->joined_date->strftime( "%Y-%m-%d" ),
    }

    return $entity;
}

sub _track_entity {
    my ( $self, $track ) = @_;

    return {
        duration => sprintf( "%d:%d", $track->duration / 60, $track->duration % 60 ),
        live     => $track->live ? JSON::true : JSON::false,
        number   => $track->number,
        title    => $track->song->title,
    };
}

sub _members_entity {
    my ( $self, $band ) = @_;

    my $members = {};
    foreach my $band_member ( $band->band_members ) {
        my $member = $band_member->person->full_name;
        my $memberships = $members->{$member} ||= [];

        my $left_date = $band_member->left_date ? $band_member->left_date->strftime( "%Y-%m-%d" ) : '-';

        push @$memberships, {
            joined => $band_member->joined_date->strftime( "%Y-%m-%d" ),
            left   => $left_date,
        };
    }

    return $members;
}

sub _musicians_entity {
    my ( $self, $album ) = @_;

    my $musicians = {};
    foreach my $album_musician ( $album->album_musicians ) {
        my $musician = $album_musician->person->full_name;
        my $instruments = $musicians->{$musician} ||= [];
        push @$instruments, $album_musician->instrument->name;
    }

    return $musicians;
}

1;
