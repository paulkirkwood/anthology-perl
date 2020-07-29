package Anthology::Controller::Songs;

use Moose;
use namespace::autoclean;
use JSON;
use Text::Slugify qw(slugify);
 
BEGIN { extends 'Catalyst::Controller::REST' }

sub base :Chained('/') PathPart('songs') CaptureArgs(0) {}

sub songs :Chained('base') PathPart('') Args(0) ActionClass('REST') {}

sub songs_GET {
    my ( $self, $c ) = @_;
    my @entity = map { $self->_song_entity( $_ ) } $c->model( "DB::Song" )->all;
    $self->status_ok( $c, entity => \@entity );
}

sub songs_POST {
    my ( $self, $c ) = @_;

    my @required_fields = qw( duration title );

    foreach my $required ( @required_fields ) {
        return $self->status_bad_request( $c, message => "Missing required field: " . $required )
            unless exists( $c->req->data->{$required} );
    }

    my ( $duration, $title ) = map { $c->req->data->{$_} } @required_fields;

    my $slug = slugify( $title );

    if ( $c->model( "DB::Song" )->song_from_slug( $slug ) ) {
        return $self->status_bad_request( $c, message => "Song '${slug}' already exists" );
    }

    #
    # Convert the mm:ss
    #
    unless( $duration =~ /^(\d+):(\d+)$/ ) {
        return $self->status_bad_request( $c, message => "Invalid time format" );
    }

    my ( $mins, $secs) = map {$_ || 0} $1, $2;

    return $self->status_bad_request( $c, message => "Bad minutes value: $mins" ) if $mins > 59 && $mins >= 0;
    return $self->status_bad_request( $c, message => "Bad seconds value: $secs" ) if $secs > 59 && $secs >= 0;

    my $song = $c->model( "DB::Song" )->create( {
        duration     => ( $mins * 60 ) + $secs,
        instrumental => $c->req->data->{instrumental} ? 1 : 0,
        slug         => $slug,
        title        => $title,
    } );

    $self->status_created( $c, location => $c->req->uri->as_string, entity => $self->_song_entity( $song ) );
}

sub find_song :Chained('/') PathPart('songs') CaptureArgs(1) {
    my ( $self, $c, $slug ) = @_;

    my $song = $c->model( "DB::Song" )->song_from_slug( $slug );

    unless( $song ) {
        $self->status_bad_request( $c, message => "Song '${slug}' does not exist" );
        $c->detach;
    }

    $c->stash( song => $song );
}

sub song : Chained('find_song') PathPart('') Args(0) ActionClass('REST') {}

sub song_GET {
    my ( $self, $c ) = @_;
    $self->status_ok( $c, entity => $self->_song_entity( $c->{stash}->{song} ) );
}

sub writers : Chained('find_song') PathPart('writers') Args(0) ActionClass('REST') {}

#sub writers_GET {
#    my ( $self, $c ) = @_;
#    $self->status_ok( $c, entity => [ map { $self->_song_entity( $_ ) } $c->{stash}->{song}->song_writers ] );

sub writers_POST {
    my ( $self, $c ) = @_;

    my @required_fields = qw( writer );

    foreach my $required ( @required_fields ) {
        return $self->status_bad_request( $c, message => "Missing required field: " . $required )
            unless exists( $c->req->data->{$required} );
    }

    my ( $writer ) = map { $c->req->data->{$_} } @required_fields;

    my $person = $c->model( "DB::Person" )->person_from_slug( $writer );

    unless ( $person ) {
        return $self->status_bad_request( $c, message => "Person '${writer}' does not exist" );
    }

    my $song = $c->{stash}->{song};
    $song->add_to_song_writers( { person_id => $person->id } );

    $self->status_created( $c, location => $c->req->uri->as_string, entity => $self->_song_entity( $song ) );
}

sub _song_entity {
    my ( $self, $song ) = @_;

    return {
        duration     => sprintf( "%d:%d", $song->duration / 60 , $song->duration % 60 ),
        instrumental => $song->instrumental ? JSON::true : JSON::false,
        slug         => $song->slug,
        title        => $song->title,
        writers      => join( ",", sort map { $_->person->last_name } $song->song_writers ),
    };
}

1;
