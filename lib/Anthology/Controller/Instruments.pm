package Anthology::Controller::Instruments;

use Moose;
use namespace::autoclean;
use JSON;
use Text::Slugify qw(slugify);
 
BEGIN { extends 'Catalyst::Controller::REST' }

sub base :Chained('/') PathPart('instruments') CaptureArgs(0) {}

sub instruments :Chained('base') PathPart('') Args(0) ActionClass('REST') {}

sub instruments_GET {
    my ( $self, $c ) = @_;
    $self->status_ok( $c, entity => [ map { $self->_instrument_entity( $_ ) } $c->model( "DB::Instrument" )->all ] );
}

sub instruments_POST {
    my ( $self, $c ) = @_;

    my @required_fields = qw( name );

    foreach my $required ( @required_fields ) {
        return $self->status_bad_request( $c, message => "Missing required field: " . $required )
            unless exists( $c->req->data->{$required} );
    }

    my ( $name ) = map { $c->req->data->{$_} } @required_fields;

    my $slug = slugify( $name );

    if ( $c->model( "DB::Instrument" )->instrument_from_slug( $slug ) ) {
        $self->status_bad_request( $c, message => "Instrument '${name}' already exists" );
        $c->detach;
    }

    my $instrument = $c->model( "DB::Instrument" )->create( {
        name => $name,
        slug => $slug,
    } );

    $self->status_created( $c, location => $c->req->uri->as_string, entity => $self->_instrument_entity( $instrument ) );
}

sub find_instrument :Chained('/') PathPart('instruments') CaptureArgs(1) {
    my ( $self, $c, $slug ) = @_;

    my $instrument = $c->model( "DB::Instrument" )->instrument_from_slug( $slug );

    unless( $instrument ) {
        $self->status_bad_request( $c, message => "Instrument '${slug}' does not exist" );
        $c->detach;
    }

    $c->stash( instrument => $instrument );
}

sub instrument : Chained('find_instrument') PathPart('') Args(0) ActionClass('REST') {}

sub instrument_GET {
    my ( $self, $c ) = @_;
    $self->status_ok( $c, entity => $self->_instrument_entity( $c->{stash}->{instrument} ) );
}

sub _instrument_entity {
    my ( $self, $instrument ) = @_;

    return {
        name => $instrument->name,
        slug => $instrument->slug,
    };
}

1;
