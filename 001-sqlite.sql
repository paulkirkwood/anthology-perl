--
-- Drops just in case you are reloading
---
PRAGMA foreign_keys = ON;

DROP TABLE IF EXISTS tracks;
DROP TABLE IF EXISTS albums;
DROP TABLE IF EXISTS band_members;
DROP TABLE IF EXISTS bands;
DROP TABLE IF EXISTS people;
DROP TABLE IF EXISTS band_instruments;
DROP TABLE IF EXISTS instruments;
DROP TABLE IF EXISTS songs;
 
CREATE TABLE bands (
  id   INTEGER PRIMARY KEY,
  name TEXT NOT NULL,
  slug TEXT NOT NULL
);

CREATE TABLE albums (
  id    INTEGER PRIMARY KEY,
  release_date TIMESTAMP NOT NULL,
  slug  TEXT NOT NULL,
  title TEXT NOT NULL,
  band_id INTEGER REFERENCES bands(id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE songs (
  id           INTEGER PRIMARY KEY,
  instrumental INTEGER NOT NULL DEFAULT(1),
  live         INTEGER NOT NULL DEFAULT(0),
  length       INTEGER NOT NULL,
  slug         TEXT NOT NULL,
  title        TEXT NOT NULL
);

CREATE TABLE tracks (
  id     INTEGER PRIMARY KEY,
  number INT NOT NULL,
  album_id INTEGER REFERENCES albums(id) ON DELETE CASCADE ON UPDATE CASCADE,
  song_id INTEGER REFERENCES songs(id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE people (
  id         INTEGER PRIMARY KEY,
  first_name TEXT NOT NULL,
  last_name  TEXT NOT NULL,
  slug       TEXT NOT NULL,
  date_of_birth TIMESTAMP NOT NULL,
  deceased_date TIMESTAMP NULL
);

CREATE TABLE band_members (
  id         INTEGER PRIMARY KEY,
  band_id     INTEGER REFERENCES bands(id) ON DELETE CASCADE ON UPDATE CASCADE,
  person_id   INTEGER REFERENCES people(id) ON DELETE CASCADE ON UPDATE CASCADE,
  joined_date TIMESTAMP NOT NULL,
  left_date   TIMESTAMP NULL
);

CREATE TABLE instruments (
  id   INTEGER PRIMARY KEY,
  name TEXT NOT NULL,
  slug TEXT NOT NULL
);

INSERT INTO instruments (name, slug)
VALUES ('Vocals', 'vocals');

INSERT INTO instruments (name, slug)
VALUES ('Bass', 'bass');

INSERT INTO instruments (name,slug)
VALUES ('Percussion', 'percussion');

INSERT INTO instruments (name,slug)
VALUES ('Lead guitar', 'lead-guitar');

INSERT INTO instruments (name,slug)
VALUES ('Rythmn guitar', 'rythmn-guitar');

INSERT INTO instruments (name,slug)
VALUES ('Lead/Rythmn guitar', 'lead-rythmn-guitar');

CREATE TABLE band_instruments (
  id            INTEGER PRIMARY KEY,
  band_member_id INTEGER REFERENCES band_members(id) ON DELETE CASCADE ON UPDATE CASCADE,
  instrument_id INTEGER REFERENCES instruments(id) ON DELETE CASCADE ON UPDATE CASCADE
);
