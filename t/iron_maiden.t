use strict;
use warnings;

use DateTime::Format::ISO8601;
use DBICx::TestDatabase;
use HTTP::Status qw( :constants );
use JSON;
use Test::Differences qw( eq_or_diff );
use Test::More;
use Test::WWW::Mechanize::Catalyst;
use Text::Slugify qw(slugify);

use Anthology();
my $schema = DBICx::TestDatabase->new( 'Anthology::Schema' );
Anthology->model( 'DB' )->schema( $schema );

Anthology->log->disable( 'debug', 'info', 'warn' );

my $mech = Test::WWW::Mechanize::Catalyst->new ( catalyst_app => 'Anthology' );
$mech->add_header( 'Content-Type' => 'application/json' );

my $json = JSON->new->allow_blessed;

#
# Create all past and present band members
#
person_POST( "Steve Harris", "1956-03-12" );
person_POST( "Dave Murray", "1956-12-23" );
person_POST( "Adrian Smith", "1957-02-27" );
person_POST( "Bruce Dickinson", "1958-08-07" );
person_POST( "Nicko McBrain", "1952-06-05" );
person_POST( "Janick Gers", "1957-01-27" );
person_POST( "Doug Sampson", "1957-06-30" );
person_POST( "Paul Di'Anno", "1958-05-17" );
person_POST( "Dennis Stratton", "1952-10-09" );
person_POST( "Clive Burr", "1957-03-08");
person_PUT( "clive-burr", "2013-03-12" );
person_POST( "Blaze Bayley", "1963-05-29" );

#
# Create the band
#
band_POST ("Iron Maiden" );

#
# Create the line ups
#
join_band( "steve-harris", "1975-12-25" );
join_band( "dave-murray", "1976-12-01" );
join_band( "doug-sampson", "1978-11-01" );
join_band( "paul-di-anno", "1978-11-30" );
join_band( "dennis-stratton", "1979-12-01" );
leave_band( "doug-sampson", "1979-12-18" );
join_band( "clive-burr", "1979-12-26" );
leave_band( "dennis-stratton", "1980-09-01" );
join_band( "adrian-smith", "1980-10-01" );
leave_band( "paul-di-anno", "1981-12-24" );
join_band( "bruce-dickinson", "1981-12-25" );
leave_band( "clive-burr", "1982-12-01" );
join_band( "nicko-mcbrain", "1982-12-02" );
leave_band( "adrian-smith", "1990-06-01" );
join_band( "janick-gers", "1990-07-01" );
leave_band( "bruce-dickinson", "1993-08-23" );
join_band( "blaze-bayley", "1994-03-01" );
leave_band( "blaze-bayley", "1999-02-28" );
join_band( "bruce-dickinson", "1999-03-01" );
join_band( "adrian-smith", "1999-03-01" );

my $lineup = members_GET();

my $expected_line_up = {
    "Nicko McBrain" => [
        {
            joined => "1982-12-02",
            left       => "-",
        }
    ],
    "Bruce Dickinson" => [
        {
            joined => "1981-12-25",
            left   => "1993-08-23"
        },
        {
            joined => "1999-03-01",
            left   => "-",
        }
    ],
    "Doug Sampson" => [
        {
            joined => "1978-11-01",
            left   => "1979-12-18",
        }
    ],
    "Clive Burr" => [
        {
            joined => "1979-12-26",
            left   => "1982-12-01",
        }
    ],
    "Blaze Bayley" => [
        {
            joined => "1994-03-01",
            left   => "1999-02-28",
        }
    ],
    "Steve Harris" => [
        {
            joined => "1975-12-25",
            left   => "-",
        }
    ],
    "Dennis Stratton" => [
        {
            joined => "1979-12-01",
            left   => "1980-09-01",
        }
    ],
    "Dave Murray" => [
        {
            joined => "1976-12-01",
            left   => "-",
        }
    ],
    "Adrian Smith" => [
        {
            joined => "1980-10-01",
            left   =>  "1990-06-01",
        },
        {
            joined => "1999-03-01",
            left   => "-",
        }
    ],
    "Janick Gers" => [
        {
            joined => "1990-07-01",
            left   => "-",
        }
    ],
    "Paul Di'Anno" => [
        {
            joined => "1978-11-30",
            left   =>  "1981-12-24"
        }
    ]
};

eq_or_diff( members_GET(), $expected_line_up, "Band members as expected" );

#
# Create the instruments
#
instrument_POST( "Backing Vocals" );
instrument_POST( "Bass" );
instrument_POST( "Drums" );
instrument_POST( "Guitars" );
instrument_POST( "Vocals" );

#
# Create all the studio albums
#
my $iron_maiden_studio_albums = {
    "Iron Maiden" => {
        release_date => "1908-04-14",
        tracks => [
            [ "Prowler", "3:56" ],
            [ "Sanctuary", "3:16" ],
            [ "Remember Tomorrow", "5:29", [ "steve-harris", "paul-di-anno" ] ],
            [ "Running Free", "3:17", [ "steve-harris", "paul-di-anno" ] ],
            [ "Phantom of the Opera", "7:08" ],
            [ "Transylvania", "4:19" ],
            [ "Strange World", "5:32" ],
            [ "Charlotte the Harlot", "4:13", [ "dave-murray" ] ],
            [ "Iron Maiden", "3:36" ],
        ],
        credits => {
            "steve-harris"    => [ "bass", "backing-vocals" ],
            "dave-murray"     => [ "guitars" ],
            "dennis-stratton" => [ "guitars", "backing-vocals" ],
            "clive-burr"      => [ "drums" ],
            "paul-di-anno"    => [ "vocals" ],
        },
    },

    "Killers" => {
        release_date => "1981-02-02",
        tracks => [
            [ "The Ides of March", "1:46" ],
            [ "Wrathchild", "2:55" ],
            [ "Murders in the Rue Morgue", "4:19" ],
            [ "Another Life", "3:23" ],
            [ "Genghis Khan", "3:09" ],
            [ "Innocent Exile", "3:54" ],
            [ "Killers", "5:02", [ "paul-di-anno", "steve-harris" ] ],
            [ "Prodigal Son", "6:13" ],
            [ "Purgatory", "3:21" ],
            [ "Drifter", "4:50" ],
        ],
        credits => {
            "steve-harris" => [ "bass" ],
            "dave-murray"  => [ "guitars" ],
            "adrian-smith" => [ "guitars" ],
            "clive-burr"   => [ "drums" ],
            "paul-di-anno" => [ "vocals" ],
        },
    },

    "The number of the Beast" => {
        release_date => "1982-03-22",
        tracks => [
            [ "Invaders", "3:24" ],
            [ "Children of the Damned", "4:36" ],
            [ "The Prisoner", "6:03", [ "adrian-smith", "steve-harris" ] ],
            [ "22 Acacia Avenue", "6:38", [ "steve-harris", "adrian-smith" ] ],
            [ "The number of the Beast", "4:51" ],
            [ "Run to the Hills", "3:54" ],
            [ "Gangland", "3:49", [ "adrian-smith", "clive-burr" ] ],
            [ "Hallowed be Thy Name", "7:13" ],
        ],
        credits => {
            "steve-harris"    => [ "bass" ],
            "dave-murray"     => [ "guitars" ],
            "adrian-smith"    => [ "guitars" ],
            "clive-burr"      => [ "drums" ],
            "bruce-dickinson" => [ "vocals" ],
        },
    },

    "Piece of Mind" => {
        release_date => "1983-05-16",
        tracks => [
            [ "Where eagles dare", "6:10" ],
            [ "Revelations", "6:48", [ "bruce-dickinson" ] ],
            [ "Flight of Icarus", "3:51", [ "adrian-smith", "bruce-dickinson" ] ],
            [ "Die with your Boots on", "5:29", [ "adrian-smith", "bruce-dickinson", "steve-harris" ] ],
            [ "The Trooper", "4:11" ],
            [ "Still Life", "4:54", [ "dave-murray", "steve-harris" ] ],
            [ "Quest for Fire", "3:41" ],
            [ "Sun and Steel", "3:27", [ "bruce-dickinson", "adrian-smith" ] ],
            [ "To tame a land", "7:25" ],
        ],
        credits => {
            "steve-harris"    => [ "bass" ],
            "dave-murray"     => [ "guitars" ],
            "adrian-smith"    => [ "guitars" ],
            "nicko-mcbrain"   => [ "drums" ],
            "bruce-dickinson" => [ "vocals" ],
        },
    },

    "Powerslave" => {
        release_date => "1984-09-03",
        tracks => [
            [ "Aces High", "4:29" ],
            [ "2 minutes to Midnight", "6:00", [ "adrian-smith", "bruce-dickinson" ] ],
            [ "Losfer Words (Big 'Orra)", "4:13" ],
            [ "Flash of the Blade", "4:03", [ "bruce-dickinson" ] ],
            [ "Duellists", "6:06" ],
            [ "Back in the Village", "5:21", [ "adrian-smith", "bruce-dickinson" ] ],
            [ "Powerslave", "6:48", [ "bruce-dickinson" ] ],
            [ "Rime of the Ancient Mariner", "13:34" ],
        ],
        credits => {
            "steve-harris"    => [ "bass" ],
            "dave-murray"     => [ "guitars" ],
            "adrian-smith"    => [ "guitars" ],
            "nicko-mcbrain"   => [ "drums" ],
            "bruce-dickinson" => [ "vocals" ],
        },
    },

    "Somewhere in Time" => {
        release_date => "1986-08-29",
        tracks => [
            [ "Caught somewhere in time", "7:26" ],
            [ "Wasted years", "5:08", [ "adrian-smith" ] ],
            [ "Sea of Madness", "5:42", [ "adrian-smith" ] ],
            [ "Heaven can wait", "7:21" ],
            [ "The Loneliness of the long distance runner", "6:31" ],
            [ "Stranger in a strange land", "5:44", [ "adrian-smith" ] ],
            [ "Deja Vu", "4:56", [ "dave-murray", "steve-harris" ] ],
            [ "Alexander the Great", "8:36" ],
        ],
        credits => {
            "steve-harris"    => [ "bass" ],
            "dave-murray"     => [ "guitars" ],
            "adrian-smith"    => [ "guitars" ],
            "nicko-mcbrain"   => [ "drums" ],
            "bruce-dickinson" => [ "vocals" ],
        },
    },

    "Seventh Son of a seventh Son" => {
        release_date => "1988-04-11",
        tracks => [
            [ "Moonchild", "5:42", [ "adrian-smith", "bruce-dickinson" ] ],
            [ "Infinite Dreams", "6:09" ],
            [ "Can I play with madness", "3:31", [ "adrian-smith", "bruce-dickinson", "steve-harris" ] ],
            [ "The evil that Men do", "4:36", [ "adrian-smith", "bruce-dickinson", "steve-harris" ] ],
            [ "Seventh Son of a seventh Son", "9:54" ],
            [ "The Prophecy", "5:05", [ "dave-murray", "steve-harris" ] ],
            [ "The Clairvoyant", "4:27" ],
            [ "Only the good die young", "4:43", [ "steve-harris", "bruce-dickinson" ] ],
        ],
        credits => {
            "steve-harris"    => [ "bass" ],
            "dave-murray"     => [ "guitars" ],
            "adrian-smith"    => [ "guitars" ],
            "nicko-mcbrain"   => [ "drums" ],
            "bruce-dickinson" => [ "vocals" ],
        },
    },

    "No prayer for the dying" => {
        release_date => "1990-10-01",
        tracks => [
            [ "Tailgunner", "4:15", [ "steve-harris", "bruce-dickinson" ] ],
            [ "Holy Smoke", "3:50", [ "steve-harris", "bruce-dickinson" ] ],
            [ "No prayer for the dying", "4:23" ],
            [ "Public enema number one", "4:13", [ "dave-murray", "bruce-dickinson" ] ],
            [ "Fates Warning", "4:12", [ "dave-murray", "steve-harris" ] ],
            [ "The Assassin", "4:35" ],
            [ "Run silent run deep", "4:36", [ "steve-harris", "bruce-dickinson" ] ],
            [ "Hooks in you", "4:08", [ "steve-harris", "adrian-smith" ] ],
            [ "Bring your Daughter ... ... to the slaughter", "4:45", [ "bruce-dickinson" ] ],
            [ "Mother Russia", "5:31" ],
        ],
        credits => {
            "steve-harris"    => [ "bass" ],
            "dave-murray"     => [ "guitars" ],
            "janick-gers"     => [ "guitars" ],
            "nicko-mcbrain"   => [ "drums" ],
            "bruce-dickinson" => [ "vocals" ],
        },
    },

    "Fear of the Dark" => {
        release_date => "1992-05-11",
        tracks => [
            [ "Be Quick or be Dead", "3:24", [ "bruce-dickinson", "janick-gers" ] ],
            [ "From Here to Eternity", "3:38" ],
            [ "Afraid to shoot Strangers", "6:56" ],
            [ "Fear is the Key", "5:35", [ "bruce-dickinson", "janick-gers" ] ],
            [ "Childhood's End", "4:41" ],
            [ "Wasting Love", "4:54", [ "bruce-dickinson", "janick-gers" ] ],
            [ "The Fugitive", "3:37" ],
            [ "Chains of Misery", "3:55", [ "bruce-dickinson", "dave-murray" ] ],
            [ "The Apparition", "3:53", [ "steve-harris", "janick-gers" ] ],
            [ "Judas be my Guide", "3:09", [ "bruce-dickinson", "dave-murray" ] ],
            [ "Weekend Warrior", "5:40", [ "steve-harris", "janick-gers" ] ],
            [ "Fear of the Dark", "7:17" ],
        ],
        credits => {
            "steve-harris"    => [ "bass" ],
            "dave-murray"     => [ "guitars" ],
            "janick-gers"     => [ "guitars" ],
            "nicko-mcbrain"   => [ "drums" ],
            "bruce-dickinson" => [ "vocals" ],
        },
    },

    "The X Factor" => {
        release_date => "1995-10-02",
        tracks => [
            [ "Sign of the Cross", "11:18" ],
            [ "Lord of the Flies", "5:04", [ "steve-harris", "janick-gers" ] ],
            [ "Man on the Edge", "4:13", [ "blaze-bayley", "janick-gers" ] ],
            [ "Fortunes of War", "7:24" ],
            [ "Look for the Truth", "5:10", [ "blaze-bayley", "janick-gers", "steve-harris" ] ],
            [ "The Aftermath", "6:21", [ "steve-harris", "blaze-bayley", "janick-gers" ] ],
            [ "Judgement of Heaven", "5:12" ],
            [ "Blood on the World's hands", "5:58" ],
            [ "The edge of Darkness", "6:39", [ "steve-harris", "blaze-bayley", "janick-gers" ] ],
            [ "2 A.M.", "5:38", [ "blaze-bayley", "janick-gers", "steve-harris" ] ],
            [ "The Unbeliever", "8:10", [ "steve-harris", "janick-gers" ] ],
        ],
        credits => {
            "steve-harris"  => [ "bass" ],
            "dave-murray"   => [ "guitars" ],
            "janick-gers"   => [ "guitars" ],
            "nicko-mcbrain" => [ "drums" ],
            "blaze-bayley"  => [ "vocals" ],
        },
    },

    "Virtual XI" => {
        release_date => "1998-03-23",
        tracks => [
            [ "Futureal", "2:56", [ "steve-harris", "blaze-bayley" ] ],
            [ "The Angel and the Gambler", "9:53" ],
            [ "Lightning strikes Twice", "4:50", [ "dave-murray", "steve-harris" ] ],
            [ "The Clansman", "9:00" ],
            [ "When two Worlds collide", "6:17", [ "dave-murray", "blaze-bayley", "steve-harris" ] ],
            [ "The Educated Fool", "6:45" ],
            [ "Don't look to the eyes of a Stranger", "8:04" ],
            [ "Comos Estais Amigo", "5:30", [ "janick-gers", "blaze-bayley" ] ],
        ],
        credits => {
            "steve-harris"  => [ "bass" ],
            "dave-murray"   => [ "guitars" ],
            "janick-gers"   => [ "guitars" ],
            "nicko-mcbrain" => [ "drums" ],
            "blaze-bayley"  => [ "vocals" ],
        },
    },

    "Brave New World" => {
        release_date => "2000-05-29",
        tracks => [
            [ "The Wicker Man", "4:36", [ "adrian-smith", "steve-harris", "bruce-dickinson" ] ],
            [ "Ghost of the Navigator", "6:50", [ "janick-gers", "bruce-dickinson", "steve-harris" ] ],
            [ "Brave New World", "6:19", [ "dave-murray", "bruce-dickinson", "steve-harris" ] ],
            [ "Blood Brothers", "7:14" ],
            [ "The Mercenary", "4:42", [ "janick-gers", "steve-harris" ] ],
            [ "Dream of Mirrors", "9:21", [ "janick-gers", "steve-harris" ] ],
            [ "The Fallen Angel", "4:01", [ "adrian-smith", "steve-harris" ] ],
            [ "The Nomad", "9:06", [ "dave-murray", "steve-harris" ] ],
            [ "Out of the silent Planet", "6:25", [ "janick-gers", "bruce-dickinson", "steve-harris" ] ],
            [ "The thin line between Love and Hate", "8:27", [ "dave-murray", "steve-harris" ] ],
        ],
        credits => {
            "steve-harris"    => [ "bass" ],
            "dave-murray"     => [ "guitars" ],
            "adrian-smith"    => [ "guitars" ],
            "janick-gers"     => [ "guitars" ],
            "nicko-mcbrain"   => [ "drums" ],
            "bruce-dickinson" => [ "vocals" ],
        },
    },

    "Dance of Death" => {
        release_date => "2003-09-08",
        tracks => [
            [ "Wildest Dreams", "3:53", [ "adrian-smith", "steve-harris" ] ],
            [ "Rainmaker", "3:49", [ "dave-murray", "steve-harris", "bruce-dickinson" ] ],
            [ "No more Lies", "7:22" ],
            [ "Montsegur", "5:50", [ "janick-gers", "steve-harris", "bruce-dickinson" ] ],
            [ "Dance of Death", "8:37", [ "janick-gers", "steve-harris" ] ],
            [ "Gates of Tomorrow", "5:12", [ "janick-gers", "steve-harris", "bruce-dickinson" ] ],
            [ "New Frontier", "5:04", [ "nicko-mcbrain", "adrian-smith", "bruce-dickinson" ] ],
            [ "Paschendale", "8:28", [ "adrian-smith", "steve-harris" ] ],
            [ "Face in the Sand", "6:31", [ "adrian-smith", "steve-harris", "bruce-dickinson" ] ],
            [ "The age of Innocence", "6:10", [ "dave-murray", "steve-harris" ] ],
            [ "Journeyman", "7:07", [ "adrian-smith", "steve-harris", "bruce-dickinson" ] ],
        ],
        credits => {
            "steve-harris"    => [ "bass" ],
            "dave-murray"     => [ "guitars" ],
            "adrian-smith"    => [ "guitars" ],
            "janick-gers"     => [ "guitars" ],
            "nicko-mcbrain"   => [ "drums" ],
            "bruce-dickinson" => [ "vocals" ],
        },
    },

    "A Matter of Life and Death" => {
        release_date => "2006-08-28",
        tracks => [
            [ "Different World", "4:19", [ "adrian-smith", "steve-harris" ] ],
            [ "These Colours don't run", "6:52", [ "adrian-smith", "steve-harris", "bruce-dickinson" ] ],
            [ "Brighter than a thousand Suns", "8:46", [ "adrian-smith", "steve-harris", "bruce-dickinson" ] ],
            [ "The Pilgrim", "5:08", [ "janick-gers", "steve-harris" ] ],
            [ "The longest Day", "7:48", [ "adrian-smith", "steve-harris", "bruce-dickinson" ] ],
            [ "Out of the Shadows", "5:37", [ "bruce-dickinson", "steve-harris" ] ],
            [ "The Reincarnation of Benjamin Breeg", "7:22", [ "dave-murray", "steve-harris" ] ],
            [ "For the greater good of God", "9:25" ],
            [ "Lord of Light", "7:25", [ "adrian-smith", "steve-harris", "bruce-dickinson" ] ],
            [ "The Legacy", "9:23", [ "janick-gers", "steve-harris" ] ],
        ],
        credits => {
            "steve-harris"    => [ "bass" ],
            "dave-murray"     => [ "guitars" ],
            "adrian-smith"    => [ "guitars" ],
            "janick-gers"     => [ "guitars" ],
            "nicko-mcbrain"   => [ "drums" ],
            "bruce-dickinson" => [ "vocals" ],
        },
    },

    "The Final Frontier" => {
        release_date => "2010-08-13",
        tracks => [
            [ "Satellite 15.....The Final Frontier", "8:41", [ "adrian-smith", "steve-harris" ] ],
            [ "El Dorado", "6:49", [ "adrian-smith", "steve-harris", "bruce-dickinson" ] ],
            [ "Mother of Mercy", "5:20", [ "adrian-smith", "steve-harris" ] ],
            [ "Coming Home", "5:52", [ "adrian-smith", "steve-harris", "bruce-dickinson" ] ],
            [ "The Alchemist", "4:29", [ "janick-gers", "steve-harris", "bruce-dickinson" ] ],
            [ "Isle of Avalon", "9:06", [ "adrian-smith", "steve-harris" ] ],
            [ "Starblind", "7:48", [ "adrian-smith", "steve-harris", "bruce-dickinson" ] ],
            [ "The Talisman", "9:03", [ "janick-gers", "steve-harris" ] ],
            [ "The Man who would be King", "8:28", [ "dave-murray", "steve-harris" ] ],
            [ "When the Wild Wind blows", "11:02" ],
        ],
        credits => {
            "steve-harris"    => [ "bass" ],
            "dave-murray"     => [ "guitars" ],
            "adrian-smith"    => [ "guitars" ],
            "janick-gers"     => [ "guitars" ],
            "nicko-mcbrain"   => [ "drums" ],
            "bruce-dickinson" => [ "vocals" ],
        },
    },

    "The Book of Souls" => {
        release_date => "2015-09-04",
        tracks => [
            [ "If Eternity should fail", "8:28", [ "bruce-dickinson" ] ],
            [ "Speed of Light", "5:02", [  "adrian-smith", "bruce-dickinson" ] ],
            [ "The Great Unknown", "6:38", [ "adrian-smith", "steve-harris" ] ],
            [ "The Red and the Black", "13:34" ],
            [ "When the River runs deep", "5:53", [ "adrian-smith", "steve-harris" ] ],
            [ "The Book of Souls", "10:28", [ "janick-gers", "steve-harris" ] ],
            [ "Death or Glory", "5:13", [ "adrian-smith", "bruce-dickinson" ] ],
            [ "Shadows of the Valley", "7:32", [ "janick-gers", "steve-harris" ] ],
            [ "Tears of a Clown", "4:49", [ "adrian-smith", "steve-harris" ] ],
            [ "The Man of Sorrows", "6:28", [ "dave-murray", "steve-harris" ] ],
            [ "Empire of the Clouds", "18:01", [ "bruce-dickinson" ] ],
        ],
        credits => {
            "steve-harris"    => [ "bass" ],
            "dave-murray"     => [ "guitars" ],
            "adrian-smith"    => [ "guitars" ],
            "janick-gers"     => [ "guitars" ],
            "nicko-mcbrain"   => [ "drums" ],
            "bruce-dickinson" => [ "vocals" ],
        },
    },
};

while ( my ( $title, $album ) = each %$iron_maiden_studio_albums ) {

    album_POST( $title, $album->{release_date} );

    foreach my $track ( @{ $album->{tracks} } ) {

        my $song = {
            title    => $track->[0],
            duration => $track->[1],
        };

        song_POST( $track->[0], $track->[1] );
        track_POST( $title, $track->[0] );

        my $writers = $track->[2];

        if ( $writers ) {
            map { writer_POST( $track->[0], $_ ) } @$writers;
        }
        else {
            writer_POST( $track->[0], "steve-harris" );
        }
    }

    if ( $album->{credits} ) {
        while ( my ( $musician, $instruments ) = each %{ $album->{credits} } ) {
            foreach my $instrument ( @$instruments ) {
                album_musician_POST( $title, $musician, $instrument );
            }
        }
    }
}

my $speed_of_light = track_GET( "The Book of Souls", 2 );
is( $speed_of_light->{title}, "Speed of Light" );

my $seventh_son_of_a_seventh_son = track_GET( "Seventh Son of a Seventh Son", 8 );
is( $seventh_son_of_a_seventh_son->{title}, "Only the good die young" );

my $adrian_smith_songs = {
    solo => [
        "Sea of Madness",
        "Stranger in a strange land",
        "Wasted years",
    ],
    'co-writer' => [
        "2 minutes to Midnight",
        "22 Acacia Avenue",
        "Back in the Village",
        "Brighter than a thousand Suns",
        "Can I play with madness",
        "Coming Home",
        "Death or Glory",
        "Die with your Boots on",
        "Different World",
        "El Dorado",
        "Face in the Sand",
        "Flight of Icarus",
        "Gangland",
        "Hooks in you",
        "Isle of Avalon",
        "Journeyman",
        "Lord of Light",
        "Moonchild",
        "Mother of Mercy",
        "New Frontier",
        "Paschendale",
        "Satellite 15.....The Final Frontier",
        "Speed of Light",
        "Starblind",
        "Sun and Steel",
        "Tears of a Clown",
        "The Fallen Angel",
        "The Great Unknown",
        "The Prisoner",
        "The Wicker Man",
        "The evil that Men do",
        "The longest Day",
        "These Colours don't run",
        "When the River runs deep",
        "Wildest Dreams",
    ],
};

eq_or_diff( song_compositions_GET( 'adrian-smith' ), $adrian_smith_songs,
    "Adrian's solo and co-written songs are as expected" );

my $bruce_dickinson_songs = {
    solo => [
        "Bring your Daughter ... ... to the slaughter",
        "Empire of the Clouds",
        "Flash of the Blade",
        "If Eternity should fail",
        "Powerslave",
        "Revelations",
    ],
    'co-writer' => [
        "2 minutes to Midnight",
        "Back in the Village",
        "Be Quick or be Dead",
        "Brave New World",
        "Brighter than a thousand Suns",
        "Can I play with madness",
        "Chains of Misery",
        "Coming Home",
        "Death or Glory",
        "Die with your Boots on",
        "El Dorado",
        "Face in the Sand",
        "Fear is the Key",
        "Flight of Icarus",
        "Gates of Tomorrow",
        "Ghost of the Navigator",
        "Holy Smoke",
        "Journeyman",
        "Judas be my Guide",
        "Lord of Light",
        "Montsegur",
        "Moonchild",
        "New Frontier",
        "Only the good die young",
        "Out of the Shadows",
        "Out of the silent Planet",
        "Public enema number one",
        "Rainmaker",
        "Run silent run deep",
        "Speed of Light",
        "Starblind",
        "Sun and Steel",
        "Tailgunner",
        "The Alchemist",
        "The Wicker Man",
        "The evil that Men do",
        "The longest Day",
        "These Colours don't run",
        "Wasting Love",
    ],
};

eq_or_diff( song_compositions_GET( 'bruce-dickinson' ), $bruce_dickinson_songs,
    "Bruce's solo and co-written songs are as expected" );

my $clive_burr_songs = {
    solo => [],
    'co-writer' => [
        "Gangland",
    ],
};

eq_or_diff( song_compositions_GET( 'clive-burr' ), $clive_burr_songs,
    "Clive's solo and co-written songs are as expected" );

my $dave_murray_songs = {
    solo => [
        "Charlotte the Harlot",
    ],
    'co-writer' => [
        "Brave New World",
        "Chains of Misery",
        "Deja Vu",
        "Fates Warning",
        "Judas be my Guide",
        "Lightning strikes Twice",
        "Public enema number one",
        "Rainmaker",
        "Still Life",
        "The Man of Sorrows",
        "The Man who would be King",
        "The Nomad",
        "The Prophecy",
        "The Reincarnation of Benjamin Breeg",
        "The age of Innocence",
        "The thin line between Love and Hate",
        "When two Worlds collide",
    ],
};

eq_or_diff( song_compositions_GET( 'dave-murray' ), $dave_murray_songs,
    "Dave's solo and co-written songs are as expected" );

my $janick_gers_songs = {
    solo => [],
    'co-writer' => [
        "2 A.M.",
        "Be Quick or be Dead",
        "Comos Estais Amigo",
        "Dance of Death",
        "Dream of Mirrors",
        "Fear is the Key",
        "Gates of Tomorrow",
        "Ghost of the Navigator",
        "Look for the Truth",
        "Lord of the Flies",
        "Man on the Edge",
        "Montsegur",
        "Out of the silent Planet",
        "Shadows of the Valley",
        "The Aftermath",
        "The Alchemist",
        "The Apparition",
        "The Book of Souls",
        "The Legacy",
        "The Mercenary",
        "The Pilgrim",
        "The Talisman",
        "The Unbeliever",
        "The edge of Darkness",
        "Wasting Love",
        "Weekend Warrior",
    ],
};

eq_or_diff( song_compositions_GET( 'janick-gers' ), $janick_gers_songs,
    "Janicks's solo and co-written songs are as expected" );

my $nicko_mcbrain_songs = {
    solo => [],
    'co-writer' => [ "New Frontier" ],
};

eq_or_diff( song_compositions_GET( 'nicko-mcbrain' ), $nicko_mcbrain_songs,
    "Nicko's solo and co-written songs are as expected" );

my $paul_di_anno_songs = {
    solo => [],
    'co-writer' => [
        "Killers",
        "Remember Tomorrow",
        "Running Free",
    ],
};

eq_or_diff( song_compositions_GET( 'paul-di-anno' ), $paul_di_anno_songs,
    "Paul's solo and co-written songs are as expected" );

#
# Live albums
#
song_POST( "Intro: Churchill's Speech", "0:49" );

my $live_albums = {
        "Live after Death" => {
        release_date => "1985-10-14",
        tracks => [
            [ "Intro: Churchill's Speech", "0:49" ],
            [ "Aces High", "4:40" ],
            [ "2 minutes to Midnight", "6:03" ],
            [ "The Trooper", "4:32" ],
            [ "Revelations", "6:11" ],
            [ "Flight of Icarus", "3:28" ],
            [ "Rime of the Ancient Mariner", "13:19" ],
            [ "Powerslave", "7:13" ],
            [ "The number of the Beast", "4:53" ],
            [ "Hallowed be Thy Name", "7:22" ],
            [ "Iron Maiden", "4:21" ],
            [ "Run to the Hills", "3:54" ],
            [ "Running Free", "8:43" ],
            [ "Wrathchild", "3:06" ],
            [ "22 Acacia Avenue", "6:18" ],
            [ "Children of the Damned", "4:36" ],
            [ "Die with your Boots on", "5:12" ],
            [ "Phantom of the Opera", "7:22" ],
        ],
        credits => {
            "steve-harris"    => [ "bass", "backing-vocals" ],
            "dave-murray"     => [ "guitars" ],
            "adrian-smith"    => [ "guitars", "backing-vocals" ],
            "nicko-mcbrain"   => [ "drums" ],
            "bruce-dickinson" => [ "vocals" ],
        },
    },
};

while ( my ( $title, $album ) = each %$live_albums ) {

    album_POST( $title, $album->{release_date} );

    foreach my $track ( @{ $album->{tracks} } ) {
        live_track_POST( $title, $track->[0], $track->[1] );
    }

    while ( my ( $musician, $instruments ) = each %{ $album->{credits} } ) {
        foreach my $instrument ( @$instruments ) {
            album_musician_POST( $title, $musician, $instrument );
        }
    }
}

my $live_after_death = album_GET( "Iron Maiden", "Live after Death" );
my $is_live = $live_after_death->{live} ? 1 : 0;
ok( $is_live, "Live after Death - all tracks recorded live" );

done_testing();

sub person_POST {
    my ( $name, $date_of_birth ) = @_;

    my ( $first_name, $last_name ) = split( /\s/, $name );

    my $person = {
        date_of_birth => $date_of_birth,
        first_name    => $first_name,
        last_name     => $last_name,
    };

    my $resp = $mech->post( '/people', content => $json->encode( $person ) );
    is( $resp->code, HTTP_CREATED, "Added $name ok" );
}

sub person_PUT {
    my ( $slug, $deceased_date ) = @_;

    my $resp = $mech->put( '/people/' . $slug, content => $json->encode( { deceased_date => $deceased_date } ) );
    is( $resp->code, HTTP_ACCEPTED, "Updated $slug deceased date" );
}

sub band_POST {
    my ( $name ) = @_;
    my $resp = $mech->post( '/bands', content => $json->encode( { name => $name } ) );
    is( $resp->code, HTTP_CREATED, "Added $name ok" );
}

sub album_GET {
    my ( $band, $title ) = @_;
    my $resp = $mech->get( '/bands/' . slugify( $band ) . '/albums/' . slugify( $title ) );
    return $json->decode( $resp->decoded_content );
}

sub album_POST {
    my ( $title, $release_date ) = @_;

    my $album = {
        release_date => $release_date,
        title        => $title,
    };

    my $resp = $mech->post( '/bands/iron-maiden/albums', content => $json->encode( $album ) );
    is( $resp->code, HTTP_CREATED, "Added $title ok" );
}

sub song_POST {
    my ( $title, $duration ) = @_;

    my $song = { 
        title    => $title,
        duration => $duration,
    };
                                            
    if ( $title eq "Genghis Khan" || $title eq "Transylvania" || $title eq "The Ides of March" || $title =~ /^Losfer/ ) {
        $song->{instrumental} = 'true';
    };

    my $resp = $mech->post( '/songs', content => $json->encode( $song ) );
    is( $resp->code, HTTP_CREATED, "Added song $title ok" );
}

sub track_POST {
    my ( $album, $title ) = @_;
    my $resp = $mech->post( '/bands/iron-maiden/albums/' . slugify( $album ) . '/tracks',
        content => $json->encode( { song => slugify( $title ) } ) );
    is( $resp->code, HTTP_CREATED, "Added $album $title ok" );
}

sub live_track_POST {
    my ( $album, $title, $duration ) = @_;

    my $track = {
        duration => $duration,
        song     => slugify( $title ),
        live     => 'true',
    };

    my $resp = $mech->post( '/bands/iron-maiden/albums/' . slugify( $album ) . '/tracks',
        content => $json->encode( $track ) );
    is( $resp->code, HTTP_CREATED, "Added $album $title [live] ok" );
}

sub track_GET {
    my ( $album, $number ) = @_;

    my $resp = $mech->get( '/bands/iron-maiden/albums/' . slugify( $album ) . '/tracks/' . $number );
    is( $resp->code, HTTP_OK, "Able to GET /bands/:id/albums/:id/track/:number" );
    return $json->decode( $resp->decoded_content );
}

sub writer_POST {
    my ( $title, $writer ) = @_;
    my $resp = $mech->post( '/songs/' . slugify( $title ) . '/writers',
        content => $json->encode( { writer => $writer } ) );
    is( $resp->code, HTTP_CREATED, "Added $writer as a writer on $title ok" );
}

sub instrument_POST {
    my ( $instrument ) = @_;
    my $resp = $mech->post( '/instruments', content => $json->encode( { name => $instrument } ) );
    is( $resp->code, HTTP_CREATED, "Added $instrument ok" );
}

sub album_musician_POST {
    my ( $album, $musician, $instrument ) = @_;

    my $album_musician = {
        instrument => $instrument,
        musician   => $musician,
    };

    my $resp = $mech->post( '/bands/iron-maiden/albums/' . slugify( $album ) . '/musicians',
        content => $json->encode( $album_musician ) );
    is( $resp->code, HTTP_CREATED, "Added album musician ok" );
}

sub members_GET {
    my $resp = $mech->get( '/bands/iron-maiden/members' );
    return $json->decode( $resp->decoded_content );
}

sub join_band {
    my ( $person, $date ) = @_;

    my $member = {
        joined_date => $date,
        person      => $person,
    };

    my $resp = $mech->post( '/bands/iron-maiden/members', content => $json->encode( $member ) );
    is( $resp->code, HTTP_CREATED, "$person join_banded the band on $date" );
}

sub leave_band {
    my ( $person, $date ) = @_;

    my $member = {
        left_date => $date,
    };

    my $resp = $mech->delete( '/bands/iron-maiden/members/' . $person, content => $json->encode( $member ) );
    is( $resp->code, HTTP_ACCEPTED, "$person left the band on $date" );
}

sub song_compositions_GET {
    my ( $person ) = @_;
    my $resp = $mech->get( '/people/' . $person . '/songs' );
    return $json->decode( $resp->decoded_content );
}
