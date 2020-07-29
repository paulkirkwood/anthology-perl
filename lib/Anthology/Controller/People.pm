package Anthology::Controller::People;

use Moose;
use namespace::autoclean;
use DateTime;
use DateTime::Format::ISO8601;
use DateTime::Format::Strptime;
use Text::Slugify qw(slugify);
 
BEGIN { extends 'Catalyst::Controller::REST' }

sub base :Chained('/') PathPart('people') CaptureArgs(0) {}

sub people :Chained('base') PathPart('') Args(0) ActionClass('REST') {}

sub people_GET {
    my ( $self, $c ) = @_;
    $self->status_ok( $c, entity => [ map { $self->_person_entity( $_ ) } $c->model( "DB::Person" )->all ] );
}

sub people_POST {
    my ( $self, $c ) = @_;

    my @required_fields = qw( date_of_birth first_name last_name );

    foreach my $required ( @required_fields ) {
        unless( exists( $c->req->data->{$required} ) ) {
            $self->status_bad_request( $c, message => "Missing required field: " . $required );
            $c->detach();
        }
    }

    my ( $date_of_birth, $first_name, $last_name ) = map { $c->req->data->{$_} } @required_fields;

    my $slug = slugify( sprintf( "%s %s", $first_name, $last_name ) );

    if ( $c->model( "DB::Person" )->search( { slug => $slug }, {} )->single ) {
        $self->status_bad_request( $c, message => "Person '${slug}' already exists" );
        $c->detach;
    }

    my $person = $c->model( "DB::Person" )->create( {
        date_of_birth => $date_of_birth,
        first_name    => $first_name,
        last_name     => $last_name,
        male          => $c->req->data->{gender} ? $c->req->data->{gender} : 1,
        slug          => $slug,
    } );

    $self->status_created( $c, location => $c->req->uri->as_string, entity => $self->_person_entity( $person ) );
}

sub find_person :Chained('/') PathPart('people') CaptureArgs(1) {
    my ( $self, $c, $slug ) = @_;

    my $where = {
        slug => $slug,
    };

    my $attrs = {
        prefetch => [
            {
                band_members => [ 'band' ]
            },
            {
                song_writers => [ 'song' ]
            },
        ],
        order_by => [ 'band_members.joined_date' ],
    };

    my $person = $c->model( "DB::Person" )->find( $where, $attrs );

    unless( $person ) {
        $self->status_bad_request( $c, message => "Person '${slug}' does not exist" );
        $c->detach();
    }

    $c->stash( person => $person );
}

sub person : Chained('find_person') PathPart('') Args(0) ActionClass('REST') {}

sub person_GET {
    my ( $self, $c ) = @_;
    $self->status_ok( $c, entity => $self->_person_entity( $c->{stash}->{person} ) );
}

sub person_PUT {
    my ( $self, $c ) = @_;

    my @required_fields = qw( deceased_date );

    foreach my $required ( @required_fields ) {
        unless ( exists( $c->req->data->{$required} ) ) {
            $self->status_bad_request( $c, message => "Missing required field: " . $required );
            $c->detach();
        }
    }

    my ( $raw_deceased_date ) = map { $c->req->data->{$_} } @required_fields;

    my $iso8601 = DateTime::Format::ISO8601->new;
    my $deceased_date = $iso8601->parse_datetime( $raw_deceased_date );

    my $person = $c->stash->{person};
    $person->update( { deceased_date => $deceased_date } );

    $self->status_accepted( $c, entity => $self->_person_entity( $person, $deceased_date ) );
}

sub bands : Chained('find_person') PathPart('bands') Args(0) ActionClass('REST') {}

sub bands_GET {
    my ( $self, $c ) = @_;

    my $bands = {};
    foreach my $band_membership ( $c->{stash}->{person}->band_members ) {
        my $band = $band_membership->band->name;
        my $stints = $bands->{$band} ||= [];
        my $joined = $band_membership->joined_date->strftime( "%Y" );

        if ( $band_membership->left_date ) {
            push @$stints, sprintf( "%s - %s", $joined, $band_membership->left_date->strftime( "%Y" ) );
        }
        else {
            push @$stints, sprintf( "%s -", $joined );
        }
    }

    $self->status_ok( $c, entity => $bands );
}

sub songs : Chained('find_person') PathPart('songs') Args(0) ActionClass('REST') {}

sub songs_GET {
    my ( $self, $c ) = @_;

    my $song_ids = {};
    my $songs = {};
    foreach my $song_writer ( $c->{stash}->{person}->song_writers ) {
        my $song = $song_writer->song->title;
        $songs->{$song} ||= 0;
        $songs->{$song}++;
        $song_ids->{$song_writer->song_id} = 1;
    }

    my $rs = $c->model( "DB::SongWriter" )->search(
        {
            song_id => {
                '-in' => [ keys %$song_ids ],
            },
            person_id => {
                '-not_in' => [ $c->{stash}->{person}->id ],
            },
        },
        {
            prefetch => 'song',
        },
    );

    foreach my $song_writer ( $rs->all ) {
        $songs->{$song_writer->song->title}++;
    }

    my ( @solo, @co_written );
    while ( my ( $song, $number_of_writers ) = each %$songs ) {
        if ( $number_of_writers > 1 ) {
            push @co_written, $song;
        }
        else {
            push @solo, $song;
        }
    };

    my $compositions = {
        solo        => [ sort @solo ],
        'co-writer' => [ sort @co_written ],
    };

    $self->status_ok( $c, entity => $compositions );
}

sub _person_entity {
    my ( $self, $person, $now ) = @_;

    return {
        #age           => $self->_person_age_at_date( $person, $now ),
        date_of_birth => $person->date_of_birth->strftime( "%Y-%m-%d" ),
        deceased_date => $person->deceased_date ? $person->deceased_date->strftime( "%Y-%m-%d" ) : "-",
        first_name    => $person->first_name,
        gender        => $person->male ? "Male" : "Female",
        last_name     => $person->last_name,
        slug          => $person->slug,
    };
}

sub _person_age_at_date {
    my ( $self, $person, $now ) = @_;

    if ( DateTime->compare( $person->date_of_birth, $now ) == 0 ) {
        print "Now: " . $now->year, "\n";
        print "DoB: " . $person->date_of_birth->year, "\n";
        my $age = $now->year - $person->date_of_birth->year;
        $age-- unless sprintf("%02d%02d", $now->month, $now->day)
            >= sprintf("%02d%02d", $person->date_of_birth->month, $person->date_of_birth->day);
        return $age;
    }

    return $now->year - $person->date_of_birth->year;
}

1;
