--
-- Drops just in case you are reloading
---
DROP TABLE IF EXISTS band_members;
DROP TABLE IF EXISTS album_musicians;
DROP TABLE IF EXISTS tracks;
DROP TABLE IF EXISTS albums;
DROP TABLE IF EXISTS bands;
DROP TABLE IF EXISTS song_writers;
DROP TABLE IF EXISTS songs;
DROP TABLE IF EXISTS instruments;
DROP TABLE IF EXISTS people;
 
CREATE TABLE bands (
  id   SERIAL PRIMARY KEY,
  name TEXT NOT NULL,
  slug TEXT NOT NULL
);

INSERT INTO bands (name, slug) VALUES ( 'AC/DC', 'ac-dc');

CREATE TABLE albums (
  id           SERIAL PRIMARY KEY,
  release_date DATE NOT NULL,
  slug         TEXT NOT NULL,
  title        TEXT NOT NULL,
  band_id      INTEGER REFERENCES bands(id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE songs (
  id           SERIAL PRIMARY KEY,
  instrumental BOOLEAN NOT NULL DEFAULT(FALSE),
  duration     INTEGER NOT NULL,
  slug         TEXT NOT NULL,
  title        TEXT NOT NULL
);

CREATE TABLE tracks (
  id       SERIAL PRIMARY KEY,
  number   INTEGER NOT NULL,
  duration INTEGER NULL,
  album_id INTEGER REFERENCES albums(id) ON DELETE CASCADE ON UPDATE CASCADE,
  song_id  INTEGER REFERENCES songs(id) ON DELETE CASCADE ON UPDATE CASCADE,
  live     BOOLEAN NOT NULL DEFAULT(FALSE)
);

CREATE TABLE people (
  id         SERIAL PRIMARY KEY,
  first_name TEXT NOT NULL,
  last_name  TEXT NOT NULL,
  slug       TEXT NOT NULL,
  date_of_birth DATE NOT NULL,
  deceased_date DATE NULL,
  male          BOOLEAN NOT NULL DEFAULT(TRUE)
);

INSERT INTO people (first_name, last_name, slug, date_of_birth) VALUES
('Angus', 'Young', 'angus-young', '1955-03-31'),
('Brian', 'Johnson', 'brian-johnson', '1947-10-05'),
('Phil', 'Rudd', 'phil-rudd', '1954-05-19'),
('Cliff', 'Williams', 'cliff-williams', '1949-12-14'),
('Mark', 'Evans', 'mark-evans', '1956-03-02'),
('Simon', 'Wright', 'simon-wright', '1963-06-19'),
('Chris', 'Slade', 'chris-slade', '1946-10-30'),
('Stevie', 'Young', 'stevie-young', '1956-12-11');

INSERT INTO people (first_name, last_name, slug, date_of_birth, deceased_date) VALUES
('Malcolm', 'Young', 'malcolm-young', '1953-01-03', '2017-11-18'),
('Bon', 'Scott', 'bon-scott', '1946-07-09', '1980-02-19');

CREATE TABLE song_writers (
  id        SERIAL PRIMARY KEY,
  person_id INTEGER REFERENCES people(id) ON DELETE CASCADE ON UPDATE CASCADE,
  song_id   INTEGER REFERENCES songs(id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE band_members (
  id         SERIAL PRIMARY KEY,
  band_id     INTEGER REFERENCES bands(id) ON DELETE CASCADE ON UPDATE CASCADE,
  person_id   INTEGER REFERENCES people(id) ON DELETE CASCADE ON UPDATE CASCADE,
  joined_date DATE NOT NULL,
  left_date   DATE NULL
);

CREATE TABLE instruments (
  id   SERIAL PRIMARY KEY,
  name TEXT NOT NULL,
  slug TEXT NOT NULL
);

INSERT INTO instruments (name, slug) VALUES
('Lead vocals', 'lead-vocals'),
('Backing vocals', 'backing-vocals'),
('Lead Guitar', 'lead-guitar'),
('Rhythm Guitar', 'rhythm-guitar'),
('Bass Guitar', 'bass-guitar');

CREATE TABLE album_musicians (
  id            SERIAL PRIMARY KEY,
  album_id      INTEGER REFERENCES albums(id) ON DELETE CASCADE ON UPDATE CASCADE,
  instrument_id INTEGER REFERENCES instruments(id) ON DELETE CASCADE ON UPDATE CASCADE,
  person_id     INTEGER REFERENCES people(id) ON DELETE CASCADE ON UPDATE CASCADE
);

INSERT INTO albums (title, slug, release_date, band_id)
SELECT E'High Voltage', 'high-voltage', '1976-04-30'::date, b.id
FROM bands b
WHERE b.slug = 'ac-dc'
UNION
SELECT E'T.N.T', 't-n-t', '1975-12-01'::date, b.id
FROM bands b
WHERE b.slug = 'ac-dc'
UNION
SELECT E'Dirty Deeds Done Dirt Cheap', 'dirty-deeds-done-dirt-cheap', '1976-09-20'::date, b.id
FROM bands b
WHERE b.slug = 'ac-dc'
UNION
SELECT E'Let There Be Rock', 'let-there-be-rock', '1977-03-22'::date, b.id
FROM bands b
WHERE b.slug = 'ac-dc'
UNION
SELECT E'Powerage', 'powerage', '1978-05-05'::date, b.id
FROM bands b
WHERE b.slug = 'ac-dc'
UNION
SELECT E'If You Want Blood You\'ve Got It', 'if-you-want-blood-you-ve-got-it', '1978-10-13'::date, b.id
FROM bands b
WHERE b.slug = 'ac-dc'
UNION
SELECT E'Highway to Hell', 'highway-to-hell', '1979-07-27'::date, b.id
FROM bands b
WHERE b.slug = 'ac-dc'
UNION
SELECT E'Back in Black', 'back-in-black', '1980-07-25'::date, b.id
FROM bands b
WHERE b.slug = 'ac-dc'
UNION
SELECT E'For Those About to Rock We Salute You', 'for-those-about-to-rock-we-salute-you', '1981-11-23'::date, b.id
FROM bands b
WHERE b.slug = 'ac-dc'
UNION
SELECT E'Flick of the Switch', 'flick-of-the-switch', '1983-08-15'::date, b.id
FROM bands b
WHERE b.slug = 'ac-dc'
UNION
SELECT E'Fly on the Wall', 'fly-on-the-wall', '1985-06-28'::date, b.id
FROM bands b
WHERE b.slug = 'ac-dc'
UNION
SELECT E'Blow Up Your Video', 'blow-up-your-video', '1988-01-18'::date, b.id
FROM bands b
WHERE b.slug = 'ac-dc'
UNION
SELECT E'The Razors Edge', 'the-razors-edge', '1990-09-01'::date, b.id
FROM bands b
WHERE b.slug = 'ac-dc'
UNION
SELECT E'AC/DC Live', 'ac-dc-live', '1992-10-27'::date, b.id
FROM bands b
WHERE b.slug = 'ac-dc'
UNION
SELECT E'Ballbreaker', 'ballbreaker', '1995-09-26'::date, b.id
FROM bands b
WHERE b.slug = 'ac-dc'
UNION
SELECT E'Stiff Upper Lip', 'stiff-upper-lip', '2000-02-28'::date, b.id
FROM bands b
WHERE b.slug = 'ac-dc'
UNION
SELECT E'Black Ice', 'black-ice', '2008-10-20'::date, b.id
FROM bands b
WHERE b.slug = 'ac-dc'
UNION
SELECT E'Live at River Plate', 'live-at-river-plate', '2012-11-19'::date, b.id
FROM bands b
WHERE b.slug = 'ac-dc'
UNION
SELECT E'Rock or Bust', 'rock-or-bust', '2014-11-28'::date, b.id
FROM bands b
WHERE b.slug = 'ac-dc';

INSERT INTO songs (title, slug, duration) VALUES
(E'Rock \'n\' Roll Train', 'rock-n-roll-train', 261);

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'angus-young' and s.slug = 'rock-n-roll-train';

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'malcolm-young' and s.slug = 'rock-n-roll-train';

INSERT INTO tracks (number, duration, album_id, song_id)
SELECT 1, 261, a.id, s.id
FROM songs s, albums a
WHERE s.slug = 'rock-n-roll-train' and a.slug = 'black-ice';

INSERT INTO songs (title, slug, duration) VALUES
(E'Skies on Fire', 'skies-on-fire', 214);

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'angus-young' and s.slug = 'skies-on-fire';

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'malcolm-young' and s.slug = 'skies-on-fire';

INSERT INTO tracks (number, duration, album_id, song_id)
SELECT 2, 214, a.id, s.id
FROM songs s, albums a
WHERE s.slug = 'skies-on-fire' and a.slug = 'black-ice';

INSERT INTO songs (title, slug, duration) VALUES
(E'Big Jack', 'big-jack', 237);

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'angus-young' and s.slug = 'big-jack';

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'malcolm-young' and s.slug = 'big-jack';

INSERT INTO tracks (number, duration, album_id, song_id)
SELECT 3, 237, a.id, s.id
FROM songs s, albums a
WHERE s.slug = 'big-jack' and a.slug = 'black-ice';

INSERT INTO songs (title, slug, duration) VALUES
(E'Anything Goes', 'anything-goes', 202);

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'angus-young' and s.slug = 'anything-goes';

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'malcolm-young' and s.slug = 'anything-goes';

INSERT INTO tracks (number, duration, album_id, song_id)
SELECT 4, 202, a.id, s.id
FROM songs s, albums a
WHERE s.slug = 'anything-goes' and a.slug = 'black-ice';

INSERT INTO songs (title, slug, duration) VALUES
(E'War Machine', 'war-machine', 189);

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'angus-young' and s.slug = 'war-machine';

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'malcolm-young' and s.slug = 'war-machine';

INSERT INTO tracks (number, duration, album_id, song_id)
SELECT 5, 189, a.id, s.id
FROM songs s, albums a
WHERE s.slug = 'war-machine' and a.slug = 'black-ice';

INSERT INTO songs (title, slug, duration) VALUES
(E'Smash \'n\' Grab', 'smash-n-grab', 246);

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'angus-young' and s.slug = 'smash-n-grab';

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'malcolm-young' and s.slug = 'smash-n-grab';

INSERT INTO tracks (number, duration, album_id, song_id)
SELECT 6, 246, a.id, s.id
FROM songs s, albums a
WHERE s.slug = 'smash-n-grab' and a.slug = 'black-ice';

INSERT INTO songs (title, slug, duration) VALUES
(E'Spoilin\' for a Fight', 'spoilin-for-a-fight', 197);

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'angus-young' and s.slug = 'spoilin-for-a-fight';

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'malcolm-young' and s.slug = 'spoilin-for-a-fight';

INSERT INTO tracks (number, duration, album_id, song_id)
SELECT 7, 197, a.id, s.id
FROM songs s, albums a
WHERE s.slug = 'spoilin-for-a-fight' and a.slug = 'black-ice';

INSERT INTO songs (title, slug, duration) VALUES
(E'Wheels', 'wheels', 208);

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'angus-young' and s.slug = 'wheels';

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'malcolm-young' and s.slug = 'wheels';

INSERT INTO tracks (number, duration, album_id, song_id)
SELECT 8, 208, a.id, s.id
FROM songs s, albums a
WHERE s.slug = 'wheels' and a.slug = 'black-ice';

INSERT INTO songs (title, slug, duration) VALUES
(E'Decibel', 'decibel', 214);

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'angus-young' and s.slug = 'decibel';

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'malcolm-young' and s.slug = 'decibel';

INSERT INTO tracks (number, duration, album_id, song_id)
SELECT 9, 214, a.id, s.id
FROM songs s, albums a
WHERE s.slug = 'decibel' and a.slug = 'black-ice';

INSERT INTO songs (title, slug, duration) VALUES
(E'Stormy May Day', 'stormy-may-day', 190);

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'angus-young' and s.slug = 'stormy-may-day';

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'malcolm-young' and s.slug = 'stormy-may-day';

INSERT INTO tracks (number, duration, album_id, song_id)
SELECT 10, 190, a.id, s.id
FROM songs s, albums a
WHERE s.slug = 'stormy-may-day' and a.slug = 'black-ice';

INSERT INTO songs (title, slug, duration) VALUES
(E'She Likes Rock \'n\' Roll', 'she-likes-rock-n-roll', 233);

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'angus-young' and s.slug = 'she-likes-rock-n-roll';

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'malcolm-young' and s.slug = 'she-likes-rock-n-roll';

INSERT INTO tracks (number, duration, album_id, song_id)
SELECT 11, 233, a.id, s.id
FROM songs s, albums a
WHERE s.slug = 'she-likes-rock-n-roll' and a.slug = 'black-ice';

INSERT INTO songs (title, slug, duration) VALUES
(E'Money Made', 'money-made', 255);

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'angus-young' and s.slug = 'money-made';

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'malcolm-young' and s.slug = 'money-made';

INSERT INTO tracks (number, duration, album_id, song_id)
SELECT 12, 255, a.id, s.id
FROM songs s, albums a
WHERE s.slug = 'money-made' and a.slug = 'black-ice';

INSERT INTO songs (title, slug, duration) VALUES
(E'Rock \'n\' Roll Dream', 'rock-n-roll-dream', 281);

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'angus-young' and s.slug = 'rock-n-roll-dream';

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'malcolm-young' and s.slug = 'rock-n-roll-dream';

INSERT INTO tracks (number, duration, album_id, song_id)
SELECT 13, 281, a.id, s.id
FROM songs s, albums a
WHERE s.slug = 'rock-n-roll-dream' and a.slug = 'black-ice';

INSERT INTO songs (title, slug, duration) VALUES
(E'Rocking All the Way', 'rocking-all-the-way', 202);

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'angus-young' and s.slug = 'rocking-all-the-way';

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'malcolm-young' and s.slug = 'rocking-all-the-way';

INSERT INTO tracks (number, duration, album_id, song_id)
SELECT 14, 202, a.id, s.id
FROM songs s, albums a
WHERE s.slug = 'rocking-all-the-way' and a.slug = 'black-ice';

INSERT INTO songs (title, slug, duration) VALUES
(E'Black Ice', 'black-ice', 205);

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'angus-young' and s.slug = 'black-ice';

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'malcolm-young' and s.slug = 'black-ice';

INSERT INTO tracks (number, duration, album_id, song_id)
SELECT 15, 205, a.id, s.id
FROM songs s, albums a
WHERE s.slug = 'black-ice' and a.slug = 'black-ice';

INSERT INTO songs (title, slug, duration) VALUES
(E'Highway to Hell', 'highway-to-hell', 209);

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'angus-young' and s.slug = 'highway-to-hell';

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'malcolm-young' and s.slug = 'highway-to-hell';

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'bon-scott' and s.slug = 'highway-to-hell';

INSERT INTO tracks (number, duration, album_id, song_id)
SELECT 1, 209, a.id, s.id
FROM songs s, albums a
WHERE s.slug = 'highway-to-hell' and a.slug = 'highway-to-hell';

INSERT INTO songs (title, slug, duration) VALUES
(E'Girls Got Rhythm', 'girls-got-rhythm', 204);

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'angus-young' and s.slug = 'girls-got-rhythm';

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'malcolm-young' and s.slug = 'girls-got-rhythm';

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'bon-scott' and s.slug = 'girls-got-rhythm';

INSERT INTO tracks (number, duration, album_id, song_id)
SELECT 2, 204, a.id, s.id
FROM songs s, albums a
WHERE s.slug = 'girls-got-rhythm' and a.slug = 'highway-to-hell';

INSERT INTO songs (title, slug, duration) VALUES
(E'Walk All Over You', 'walk-all-over-you', 310);

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'angus-young' and s.slug = 'walk-all-over-you';

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'malcolm-young' and s.slug = 'walk-all-over-you';

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'bon-scott' and s.slug = 'walk-all-over-you';

INSERT INTO tracks (number, duration, album_id, song_id)
SELECT 3, 310, a.id, s.id
FROM songs s, albums a
WHERE s.slug = 'walk-all-over-you' and a.slug = 'highway-to-hell';

INSERT INTO songs (title, slug, duration) VALUES
(E'Touch Too Much', 'touch-too-much', 268);

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'angus-young' and s.slug = 'touch-too-much';

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'malcolm-young' and s.slug = 'touch-too-much';

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'bon-scott' and s.slug = 'touch-too-much';

INSERT INTO tracks (number, duration, album_id, song_id)
SELECT 4, 268, a.id, s.id
FROM songs s, albums a
WHERE s.slug = 'touch-too-much' and a.slug = 'highway-to-hell';

INSERT INTO songs (title, slug, duration) VALUES
(E'Beating Around the Bush', 'beating-around-the-bush', 237);

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'angus-young' and s.slug = 'beating-around-the-bush';

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'malcolm-young' and s.slug = 'beating-around-the-bush';

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'bon-scott' and s.slug = 'beating-around-the-bush';

INSERT INTO tracks (number, duration, album_id, song_id)
SELECT 5, 237, a.id, s.id
FROM songs s, albums a
WHERE s.slug = 'beating-around-the-bush' and a.slug = 'highway-to-hell';

INSERT INTO songs (title, slug, duration) VALUES
(E'Shot Down in Flames', 'shot-down-in-flames', 203);

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'angus-young' and s.slug = 'shot-down-in-flames';

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'malcolm-young' and s.slug = 'shot-down-in-flames';

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'bon-scott' and s.slug = 'shot-down-in-flames';

INSERT INTO tracks (number, duration, album_id, song_id)
SELECT 6, 203, a.id, s.id
FROM songs s, albums a
WHERE s.slug = 'shot-down-in-flames' and a.slug = 'highway-to-hell';

INSERT INTO songs (title, slug, duration) VALUES
(E'Get it Hot', 'get-it-hot', 155);

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'angus-young' and s.slug = 'get-it-hot';

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'malcolm-young' and s.slug = 'get-it-hot';

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'bon-scott' and s.slug = 'get-it-hot';

INSERT INTO tracks (number, duration, album_id, song_id)
SELECT 7, 155, a.id, s.id
FROM songs s, albums a
WHERE s.slug = 'get-it-hot' and a.slug = 'highway-to-hell';

INSERT INTO songs (title, slug, duration) VALUES
(E'If You Want Blood (You Got It)', 'if-you-want-blood-you-got-it', 278);

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'angus-young' and s.slug = 'if-you-want-blood-you-got-it';

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'malcolm-young' and s.slug = 'if-you-want-blood-you-got-it';

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'bon-scott' and s.slug = 'if-you-want-blood-you-got-it';

INSERT INTO tracks (number, duration, album_id, song_id)
SELECT 8, 278, a.id, s.id
FROM songs s, albums a
WHERE s.slug = 'if-you-want-blood-you-got-it' and a.slug = 'highway-to-hell';

INSERT INTO songs (title, slug, duration) VALUES
(E'Love Hungry Man', 'love-hungry-man', 258);

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'angus-young' and s.slug = 'love-hungry-man';

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'malcolm-young' and s.slug = 'love-hungry-man';

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'bon-scott' and s.slug = 'love-hungry-man';

INSERT INTO tracks (number, duration, album_id, song_id)
SELECT 9, 258, a.id, s.id
FROM songs s, albums a
WHERE s.slug = 'love-hungry-man' and a.slug = 'highway-to-hell';

INSERT INTO songs (title, slug, duration) VALUES
(E'Night Prowler', 'night-prowler', 378);

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'angus-young' and s.slug = 'night-prowler';

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'malcolm-young' and s.slug = 'night-prowler';

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'bon-scott' and s.slug = 'night-prowler';

INSERT INTO tracks (number, duration, album_id, song_id)
SELECT 10, 378, a.id, s.id
FROM songs s, albums a
WHERE s.slug = 'night-prowler' and a.slug = 'highway-to-hell';

INSERT INTO songs (title, slug, duration) VALUES
(E'Stiff Upper Lip', 'stiff-upper-lip', 214);

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'angus-young' and s.slug = 'stiff-upper-lip';

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'malcolm-young' and s.slug = 'stiff-upper-lip';

INSERT INTO tracks (number, duration, album_id, song_id)
SELECT 1, 214, a.id, s.id
FROM songs s, albums a
WHERE s.slug = 'stiff-upper-lip' and a.slug = 'stiff-upper-lip';

INSERT INTO songs (title, slug, duration) VALUES
(E'Meltdown', 'meltdown', 221);

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'angus-young' and s.slug = 'meltdown';

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'malcolm-young' and s.slug = 'meltdown';

INSERT INTO tracks (number, duration, album_id, song_id)
SELECT 2, 221, a.id, s.id
FROM songs s, albums a
WHERE s.slug = 'meltdown' and a.slug = 'stiff-upper-lip';

INSERT INTO songs (title, slug, duration) VALUES
(E'House of Jazz', 'house-of-jazz', 236);

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'angus-young' and s.slug = 'house-of-jazz';

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'malcolm-young' and s.slug = 'house-of-jazz';

INSERT INTO tracks (number, duration, album_id, song_id)
SELECT 3, 236, a.id, s.id
FROM songs s, albums a
WHERE s.slug = 'house-of-jazz' and a.slug = 'stiff-upper-lip';

INSERT INTO songs (title, slug, duration) VALUES
(E'Hold Me Back', 'hold-me-back', 239);

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'angus-young' and s.slug = 'hold-me-back';

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'malcolm-young' and s.slug = 'hold-me-back';

INSERT INTO tracks (number, duration, album_id, song_id)
SELECT 4, 239, a.id, s.id
FROM songs s, albums a
WHERE s.slug = 'hold-me-back' and a.slug = 'stiff-upper-lip';

INSERT INTO songs (title, slug, duration) VALUES
(E'Safe in New York City', 'safe-in-new-york-city', 239);

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'angus-young' and s.slug = 'safe-in-new-york-city';

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'malcolm-young' and s.slug = 'safe-in-new-york-city';

INSERT INTO tracks (number, duration, album_id, song_id)
SELECT 5, 239, a.id, s.id
FROM songs s, albums a
WHERE s.slug = 'safe-in-new-york-city' and a.slug = 'stiff-upper-lip';

INSERT INTO songs (title, slug, duration) VALUES
(E'Can\'t Stand Still', 'can-t-stand-still', 221);

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'angus-young' and s.slug = 'can-t-stand-still';

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'malcolm-young' and s.slug = 'can-t-stand-still';

INSERT INTO tracks (number, duration, album_id, song_id)
SELECT 6, 221, a.id, s.id
FROM songs s, albums a
WHERE s.slug = 'can-t-stand-still' and a.slug = 'stiff-upper-lip';

INSERT INTO songs (title, slug, duration) VALUES
(E'Can\'t Stop Rock \'n\' Roll', 'can-t-stop-rock-n-roll', 242);

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'angus-young' and s.slug = 'can-t-stop-rock-n-roll';

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'malcolm-young' and s.slug = 'can-t-stop-rock-n-roll';

INSERT INTO tracks (number, duration, album_id, song_id)
SELECT 7, 242, a.id, s.id
FROM songs s, albums a
WHERE s.slug = 'can-t-stop-rock-n-roll' and a.slug = 'stiff-upper-lip';

INSERT INTO songs (title, slug, duration) VALUES
(E'Satellite Blues', 'satellite-blues', 226);

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'angus-young' and s.slug = 'satellite-blues';

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'malcolm-young' and s.slug = 'satellite-blues';

INSERT INTO tracks (number, duration, album_id, song_id)
SELECT 8, 226, a.id, s.id
FROM songs s, albums a
WHERE s.slug = 'satellite-blues' and a.slug = 'stiff-upper-lip';

INSERT INTO songs (title, slug, duration) VALUES
(E'Damned', 'damned', 232);

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'angus-young' and s.slug = 'damned';

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'malcolm-young' and s.slug = 'damned';

INSERT INTO tracks (number, duration, album_id, song_id)
SELECT 9, 232, a.id, s.id
FROM songs s, albums a
WHERE s.slug = 'damned' and a.slug = 'stiff-upper-lip';

INSERT INTO songs (title, slug, duration) VALUES
(E'Come and Get It', 'come-and-get-it', 242);

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'angus-young' and s.slug = 'come-and-get-it';

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'malcolm-young' and s.slug = 'come-and-get-it';

INSERT INTO tracks (number, duration, album_id, song_id)
SELECT 10, 242, a.id, s.id
FROM songs s, albums a
WHERE s.slug = 'come-and-get-it' and a.slug = 'stiff-upper-lip';

INSERT INTO songs (title, slug, duration) VALUES
(E'All Screwed Up', 'all-screwed-up', 276);

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'angus-young' and s.slug = 'all-screwed-up';

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'malcolm-young' and s.slug = 'all-screwed-up';

INSERT INTO tracks (number, duration, album_id, song_id)
SELECT 11, 276, a.id, s.id
FROM songs s, albums a
WHERE s.slug = 'all-screwed-up' and a.slug = 'stiff-upper-lip';

INSERT INTO songs (title, slug, duration) VALUES
(E'Give It Up', 'give-it-up', 234);

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'angus-young' and s.slug = 'give-it-up';

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'malcolm-young' and s.slug = 'give-it-up';

INSERT INTO tracks (number, duration, album_id, song_id)
SELECT 12, 234, a.id, s.id
FROM songs s, albums a
WHERE s.slug = 'give-it-up' and a.slug = 'stiff-upper-lip';

INSERT INTO songs (title, slug, duration) VALUES
(E'Dirty Deeds Done Dirt Cheap', 'dirty-deeds-done-dirt-cheap', 252);

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'angus-young' and s.slug = 'dirty-deeds-done-dirt-cheap';

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'malcolm-young' and s.slug = 'dirty-deeds-done-dirt-cheap';

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'bon-scott' and s.slug = 'dirty-deeds-done-dirt-cheap';

INSERT INTO tracks (number, duration, album_id, song_id)
SELECT 1, 252, a.id, s.id
FROM songs s, albums a
WHERE s.slug = 'dirty-deeds-done-dirt-cheap' and a.slug = 'dirty-deeds-done-dirt-cheap';

INSERT INTO songs (title, slug, duration) VALUES
(E'Love at First Feel', 'love-at-first-feel', 193);

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'angus-young' and s.slug = 'love-at-first-feel';

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'malcolm-young' and s.slug = 'love-at-first-feel';

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'bon-scott' and s.slug = 'love-at-first-feel';

INSERT INTO tracks (number, duration, album_id, song_id)
SELECT 2, 193, a.id, s.id
FROM songs s, albums a
WHERE s.slug = 'love-at-first-feel' and a.slug = 'dirty-deeds-done-dirt-cheap';

INSERT INTO songs (title, slug, duration) VALUES
(E'Big Balls', 'big-balls', 158);

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'angus-young' and s.slug = 'big-balls';

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'malcolm-young' and s.slug = 'big-balls';

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'bon-scott' and s.slug = 'big-balls';

INSERT INTO tracks (number, duration, album_id, song_id)
SELECT 3, 158, a.id, s.id
FROM songs s, albums a
WHERE s.slug = 'big-balls' and a.slug = 'dirty-deeds-done-dirt-cheap';

INSERT INTO songs (title, slug, duration) VALUES
(E'Rocker', 'rocker', 172);

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'angus-young' and s.slug = 'rocker';

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'malcolm-young' and s.slug = 'rocker';

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'bon-scott' and s.slug = 'rocker';

INSERT INTO tracks (number, duration, album_id, song_id)
SELECT 4, 172, a.id, s.id
FROM songs s, albums a
WHERE s.slug = 'rocker' and a.slug = 'dirty-deeds-done-dirt-cheap';

INSERT INTO songs (title, slug, duration) VALUES
(E'Problem Child', 'problem-child', 347);

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'angus-young' and s.slug = 'problem-child';

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'malcolm-young' and s.slug = 'problem-child';

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'bon-scott' and s.slug = 'problem-child';

INSERT INTO tracks (number, duration, album_id, song_id)
SELECT 5, 347, a.id, s.id
FROM songs s, albums a
WHERE s.slug = 'problem-child' and a.slug = 'dirty-deeds-done-dirt-cheap';

INSERT INTO songs (title, slug, duration) VALUES
(E'There\'s Gonna Be Some Rockin\'', 'there-s-gonna-be-some-rockin', 198);

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'angus-young' and s.slug = 'there-s-gonna-be-some-rockin';

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'malcolm-young' and s.slug = 'there-s-gonna-be-some-rockin';

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'bon-scott' and s.slug = 'there-s-gonna-be-some-rockin';

INSERT INTO tracks (number, duration, album_id, song_id)
SELECT 6, 198, a.id, s.id
FROM songs s, albums a
WHERE s.slug = 'there-s-gonna-be-some-rockin' and a.slug = 'dirty-deeds-done-dirt-cheap';

INSERT INTO songs (title, slug, duration) VALUES
(E'Ain\'t No Fun (Waiting \'Round to be a Millionaire)', 'ain-t-no-fun-waiting-round-to-be-a-millionaire', 451);

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'angus-young' and s.slug = 'ain-t-no-fun-waiting-round-to-be-a-millionaire';

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'malcolm-young' and s.slug = 'ain-t-no-fun-waiting-round-to-be-a-millionaire';

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'bon-scott' and s.slug = 'ain-t-no-fun-waiting-round-to-be-a-millionaire';

INSERT INTO tracks (number, duration, album_id, song_id)
SELECT 7, 451, a.id, s.id
FROM songs s, albums a
WHERE s.slug = 'ain-t-no-fun-waiting-round-to-be-a-millionaire' and a.slug = 'dirty-deeds-done-dirt-cheap';

INSERT INTO songs (title, slug, duration) VALUES
(E'Ride On', 'ride-on', 354);

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'angus-young' and s.slug = 'ride-on';

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'malcolm-young' and s.slug = 'ride-on';

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'bon-scott' and s.slug = 'ride-on';

INSERT INTO tracks (number, duration, album_id, song_id)
SELECT 8, 354, a.id, s.id
FROM songs s, albums a
WHERE s.slug = 'ride-on' and a.slug = 'dirty-deeds-done-dirt-cheap';

INSERT INTO songs (title, slug, duration) VALUES
(E'Squealer', 'squealer', 315);

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'angus-young' and s.slug = 'squealer';

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'malcolm-young' and s.slug = 'squealer';

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'bon-scott' and s.slug = 'squealer';

INSERT INTO tracks (number, duration, album_id, song_id)
SELECT 9, 315, a.id, s.id
FROM songs s, albums a
WHERE s.slug = 'squealer' and a.slug = 'dirty-deeds-done-dirt-cheap';

INSERT INTO songs (title, slug, duration) VALUES
(E'Rock \'n\' Roll Damnation', 'rock-n-roll-damnation', 217);

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'angus-young' and s.slug = 'rock-n-roll-damnation';

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'malcolm-young' and s.slug = 'rock-n-roll-damnation';

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'bon-scott' and s.slug = 'rock-n-roll-damnation';

INSERT INTO tracks (number, duration, album_id, song_id)
SELECT 1, 217, a.id, s.id
FROM songs s, albums a
WHERE s.slug = 'rock-n-roll-damnation' and a.slug = 'powerage';

INSERT INTO songs (title, slug, duration) VALUES
(E'Down Payment Blues', 'down-payment-blues', 364);

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'angus-young' and s.slug = 'down-payment-blues';

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'malcolm-young' and s.slug = 'down-payment-blues';

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'bon-scott' and s.slug = 'down-payment-blues';

INSERT INTO tracks (number, duration, album_id, song_id)
SELECT 2, 364, a.id, s.id
FROM songs s, albums a
WHERE s.slug = 'down-payment-blues' and a.slug = 'powerage';

INSERT INTO songs (title, slug, duration) VALUES
(E'Gimme a Bullet', 'gimme-a-bullet', 201);

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'angus-young' and s.slug = 'gimme-a-bullet';

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'malcolm-young' and s.slug = 'gimme-a-bullet';

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'bon-scott' and s.slug = 'gimme-a-bullet';

INSERT INTO tracks (number, duration, album_id, song_id)
SELECT 3, 201, a.id, s.id
FROM songs s, albums a
WHERE s.slug = 'gimme-a-bullet' and a.slug = 'powerage';

INSERT INTO songs (title, slug, duration) VALUES
(E'Riff Raff', 'riff-raff', 312);

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'angus-young' and s.slug = 'riff-raff';

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'malcolm-young' and s.slug = 'riff-raff';

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'bon-scott' and s.slug = 'riff-raff';

INSERT INTO tracks (number, duration, album_id, song_id)
SELECT 4, 312, a.id, s.id
FROM songs s, albums a
WHERE s.slug = 'riff-raff' and a.slug = 'powerage';

INSERT INTO songs (title, slug, duration) VALUES
(E'Sin City', 'sin-city', 285);

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'angus-young' and s.slug = 'sin-city';

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'malcolm-young' and s.slug = 'sin-city';

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'bon-scott' and s.slug = 'sin-city';

INSERT INTO tracks (number, duration, album_id, song_id)
SELECT 5, 285, a.id, s.id
FROM songs s, albums a
WHERE s.slug = 'sin-city' and a.slug = 'powerage';

INSERT INTO songs (title, slug, duration) VALUES
(E'What\'s next to the Moon', 'what-s-next-to-the-moon', 212);

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'angus-young' and s.slug = 'what-s-next-to-the-moon';

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'malcolm-young' and s.slug = 'what-s-next-to-the-moon';

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'bon-scott' and s.slug = 'what-s-next-to-the-moon';

INSERT INTO tracks (number, duration, album_id, song_id)
SELECT 6, 212, a.id, s.id
FROM songs s, albums a
WHERE s.slug = 'what-s-next-to-the-moon' and a.slug = 'powerage';

INSERT INTO songs (title, slug, duration) VALUES
(E'Gone Shootin\'', 'gone-shootin', 306);

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'angus-young' and s.slug = 'gone-shootin';

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'malcolm-young' and s.slug = 'gone-shootin';

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'bon-scott' and s.slug = 'gone-shootin';

INSERT INTO tracks (number, duration, album_id, song_id)
SELECT 7, 306, a.id, s.id
FROM songs s, albums a
WHERE s.slug = 'gone-shootin' and a.slug = 'powerage';

INSERT INTO songs (title, slug, duration) VALUES
(E'Up to My Neck in You', 'up-to-my-neck-in-you', 253);

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'angus-young' and s.slug = 'up-to-my-neck-in-you';

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'malcolm-young' and s.slug = 'up-to-my-neck-in-you';

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'bon-scott' and s.slug = 'up-to-my-neck-in-you';

INSERT INTO tracks (number, duration, album_id, song_id)
SELECT 8, 253, a.id, s.id
FROM songs s, albums a
WHERE s.slug = 'up-to-my-neck-in-you' and a.slug = 'powerage';

INSERT INTO songs (title, slug, duration) VALUES
(E'Kicked in the Teeth', 'kicked-in-the-teeth', 234);

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'angus-young' and s.slug = 'kicked-in-the-teeth';

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'malcolm-young' and s.slug = 'kicked-in-the-teeth';

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'bon-scott' and s.slug = 'kicked-in-the-teeth';

INSERT INTO tracks (number, duration, album_id, song_id)
SELECT 9, 234, a.id, s.id
FROM songs s, albums a
WHERE s.slug = 'kicked-in-the-teeth' and a.slug = 'powerage';

INSERT INTO songs (title, slug, duration) VALUES
(E'Hells Bells', 'hells-bells', 310);

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'angus-young' and s.slug = 'hells-bells';

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'malcolm-young' and s.slug = 'hells-bells';

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'brian-johnson' and s.slug = 'hells-bells';

INSERT INTO tracks (number, duration, album_id, song_id)
SELECT 1, 310, a.id, s.id
FROM songs s, albums a
WHERE s.slug = 'hells-bells' and a.slug = 'back-in-black';

INSERT INTO songs (title, slug, duration) VALUES
(E'Shoot to Thrill', 'shoot-to-thrill', 317);

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'angus-young' and s.slug = 'shoot-to-thrill';

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'malcolm-young' and s.slug = 'shoot-to-thrill';

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'brian-johnson' and s.slug = 'shoot-to-thrill';

INSERT INTO tracks (number, duration, album_id, song_id)
SELECT 2, 317, a.id, s.id
FROM songs s, albums a
WHERE s.slug = 'shoot-to-thrill' and a.slug = 'back-in-black';

INSERT INTO songs (title, slug, duration) VALUES
(E'What Do You Do for Money Honey', 'what-do-you-do-for-money-honey', 213);

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'angus-young' and s.slug = 'what-do-you-do-for-money-honey';

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'malcolm-young' and s.slug = 'what-do-you-do-for-money-honey';

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'brian-johnson' and s.slug = 'what-do-you-do-for-money-honey';

INSERT INTO tracks (number, duration, album_id, song_id)
SELECT 3, 213, a.id, s.id
FROM songs s, albums a
WHERE s.slug = 'what-do-you-do-for-money-honey' and a.slug = 'back-in-black';

INSERT INTO songs (title, slug, duration) VALUES
(E'Given the Dog a Bone', 'given-the-dog-a-bone', 210);

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'angus-young' and s.slug = 'given-the-dog-a-bone';

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'malcolm-young' and s.slug = 'given-the-dog-a-bone';

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'brian-johnson' and s.slug = 'given-the-dog-a-bone';

INSERT INTO tracks (number, duration, album_id, song_id)
SELECT 4, 210, a.id, s.id
FROM songs s, albums a
WHERE s.slug = 'given-the-dog-a-bone' and a.slug = 'back-in-black';

INSERT INTO songs (title, slug, duration) VALUES
(E'Let Me Put My Love into You', 'let-me-put-my-love-into-you', 256);

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'angus-young' and s.slug = 'let-me-put-my-love-into-you';

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'malcolm-young' and s.slug = 'let-me-put-my-love-into-you';

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'brian-johnson' and s.slug = 'let-me-put-my-love-into-you';

INSERT INTO tracks (number, duration, album_id, song_id)
SELECT 5, 256, a.id, s.id
FROM songs s, albums a
WHERE s.slug = 'let-me-put-my-love-into-you' and a.slug = 'back-in-black';

INSERT INTO songs (title, slug, duration) VALUES
(E'Back in Black', 'back-in-black', 254);

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'angus-young' and s.slug = 'back-in-black';

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'malcolm-young' and s.slug = 'back-in-black';

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'brian-johnson' and s.slug = 'back-in-black';

INSERT INTO tracks (number, duration, album_id, song_id)
SELECT 6, 254, a.id, s.id
FROM songs s, albums a
WHERE s.slug = 'back-in-black' and a.slug = 'back-in-black';

INSERT INTO songs (title, slug, duration) VALUES
(E'You Shook Me All Night Long', 'you-shook-me-all-night-long', 210);

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'angus-young' and s.slug = 'you-shook-me-all-night-long';

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'malcolm-young' and s.slug = 'you-shook-me-all-night-long';

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'brian-johnson' and s.slug = 'you-shook-me-all-night-long';

INSERT INTO tracks (number, duration, album_id, song_id)
SELECT 7, 210, a.id, s.id
FROM songs s, albums a
WHERE s.slug = 'you-shook-me-all-night-long' and a.slug = 'back-in-black';

INSERT INTO songs (title, slug, duration) VALUES
(E'Have a Drink on Me', 'have-a-drink-on-me', 237);

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'angus-young' and s.slug = 'have-a-drink-on-me';

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'malcolm-young' and s.slug = 'have-a-drink-on-me';

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'brian-johnson' and s.slug = 'have-a-drink-on-me';

INSERT INTO tracks (number, duration, album_id, song_id)
SELECT 8, 237, a.id, s.id
FROM songs s, albums a
WHERE s.slug = 'have-a-drink-on-me' and a.slug = 'back-in-black';

INSERT INTO songs (title, slug, duration) VALUES
(E'Shake a Leg', 'shake-a-leg', 246);

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'angus-young' and s.slug = 'shake-a-leg';

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'malcolm-young' and s.slug = 'shake-a-leg';

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'brian-johnson' and s.slug = 'shake-a-leg';

INSERT INTO tracks (number, duration, album_id, song_id)
SELECT 9, 246, a.id, s.id
FROM songs s, albums a
WHERE s.slug = 'shake-a-leg' and a.slug = 'back-in-black';

INSERT INTO songs (title, slug, duration) VALUES
(E'Rock and Roll Ain\'t Noise Pollution', 'rock-and-roll-ain-t-noise-pollution', 255);

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'angus-young' and s.slug = 'rock-and-roll-ain-t-noise-pollution';

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'malcolm-young' and s.slug = 'rock-and-roll-ain-t-noise-pollution';

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'brian-johnson' and s.slug = 'rock-and-roll-ain-t-noise-pollution';

INSERT INTO tracks (number, duration, album_id, song_id)
SELECT 10, 255, a.id, s.id
FROM songs s, albums a
WHERE s.slug = 'rock-and-roll-ain-t-noise-pollution' and a.slug = 'back-in-black';

INSERT INTO songs (title, slug, duration) VALUES
(E'Go Down', 'go-down', 331);

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'angus-young' and s.slug = 'go-down';

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'malcolm-young' and s.slug = 'go-down';

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'bon-scott' and s.slug = 'go-down';

INSERT INTO tracks (number, duration, album_id, song_id)
SELECT 1, 331, a.id, s.id
FROM songs s, albums a
WHERE s.slug = 'go-down' and a.slug = 'let-there-be-rock';

INSERT INTO songs (title, slug, duration) VALUES
(E'Dog Eat Dog', 'dog-eat-dog', 215);

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'angus-young' and s.slug = 'dog-eat-dog';

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'malcolm-young' and s.slug = 'dog-eat-dog';

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'bon-scott' and s.slug = 'dog-eat-dog';

INSERT INTO tracks (number, duration, album_id, song_id)
SELECT 2, 215, a.id, s.id
FROM songs s, albums a
WHERE s.slug = 'dog-eat-dog' and a.slug = 'let-there-be-rock';

INSERT INTO songs (title, slug, duration) VALUES
(E'Let There Be Rock', 'let-there-be-rock', 366);

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'angus-young' and s.slug = 'let-there-be-rock';

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'malcolm-young' and s.slug = 'let-there-be-rock';

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'bon-scott' and s.slug = 'let-there-be-rock';

INSERT INTO tracks (number, duration, album_id, song_id)
SELECT 3, 366, a.id, s.id
FROM songs s, albums a
WHERE s.slug = 'let-there-be-rock' and a.slug = 'let-there-be-rock';

INSERT INTO songs (title, slug, duration) VALUES
(E'Bad Boy Boogie', 'bad-boy-boogie', 267);

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'angus-young' and s.slug = 'bad-boy-boogie';

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'malcolm-young' and s.slug = 'bad-boy-boogie';

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'bon-scott' and s.slug = 'bad-boy-boogie';

INSERT INTO tracks (number, duration, album_id, song_id)
SELECT 4, 267, a.id, s.id
FROM songs s, albums a
WHERE s.slug = 'bad-boy-boogie' and a.slug = 'let-there-be-rock';

INSERT INTO tracks (number, duration, album_id, song_id)
SELECT 5, 325, a.id, s.id
FROM songs s, albums a
WHERE s.slug = 'problem-child' and a.slug = 'let-there-be-rock';

INSERT INTO songs (title, slug, duration) VALUES
(E'Overdose', 'overdose', 369);

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'angus-young' and s.slug = 'overdose';

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'malcolm-young' and s.slug = 'overdose';

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'bon-scott' and s.slug = 'overdose';

INSERT INTO tracks (number, duration, album_id, song_id)
SELECT 6, 369, a.id, s.id
FROM songs s, albums a
WHERE s.slug = 'overdose' and a.slug = 'let-there-be-rock';

INSERT INTO songs (title, slug, duration) VALUES
(E'Hell Ain\'t a Bad Place to Be', 'hell-ain-t-a-bad-place-to-be', 254);

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'angus-young' and s.slug = 'hell-ain-t-a-bad-place-to-be';

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'malcolm-young' and s.slug = 'hell-ain-t-a-bad-place-to-be';

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'bon-scott' and s.slug = 'hell-ain-t-a-bad-place-to-be';

INSERT INTO tracks (number, duration, album_id, song_id)
SELECT 7, 254, a.id, s.id
FROM songs s, albums a
WHERE s.slug = 'hell-ain-t-a-bad-place-to-be' and a.slug = 'let-there-be-rock';

INSERT INTO songs (title, slug, duration) VALUES
(E'Whole Lotta Rosie', 'whole-lotta-rosie', 324);

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'angus-young' and s.slug = 'whole-lotta-rosie';

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'malcolm-young' and s.slug = 'whole-lotta-rosie';

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'bon-scott' and s.slug = 'whole-lotta-rosie';

INSERT INTO tracks (number, duration, album_id, song_id)
SELECT 8, 324, a.id, s.id
FROM songs s, albums a
WHERE s.slug = 'whole-lotta-rosie' and a.slug = 'let-there-be-rock';

INSERT INTO songs (title, slug, duration) VALUES
(E'Rock or Bust', 'rock-or-bust', 183);

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'angus-young' and s.slug = 'rock-or-bust';

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'malcolm-young' and s.slug = 'rock-or-bust';

INSERT INTO tracks (number, duration, album_id, song_id)
SELECT 1, 183, a.id, s.id
FROM songs s, albums a
WHERE s.slug = 'rock-or-bust' and a.slug = 'rock-or-bust';

INSERT INTO songs (title, slug, duration) VALUES
(E'Play Ball', 'play-ball', 167);

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'angus-young' and s.slug = 'play-ball';

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'malcolm-young' and s.slug = 'play-ball';

INSERT INTO tracks (number, duration, album_id, song_id)
SELECT 2, 167, a.id, s.id
FROM songs s, albums a
WHERE s.slug = 'play-ball' and a.slug = 'rock-or-bust';

INSERT INTO songs (title, slug, duration) VALUES
(E'Rock the Blues Away', 'rock-the-blues-away', 204);

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'angus-young' and s.slug = 'rock-the-blues-away';

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'malcolm-young' and s.slug = 'rock-the-blues-away';

INSERT INTO tracks (number, duration, album_id, song_id)
SELECT 3, 204, a.id, s.id
FROM songs s, albums a
WHERE s.slug = 'rock-the-blues-away' and a.slug = 'rock-or-bust';

INSERT INTO songs (title, slug, duration) VALUES
(E'Miss Adventure', 'miss-adventure', 177);

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'angus-young' and s.slug = 'miss-adventure';

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'malcolm-young' and s.slug = 'miss-adventure';

INSERT INTO tracks (number, duration, album_id, song_id)
SELECT 4, 177, a.id, s.id
FROM songs s, albums a
WHERE s.slug = 'miss-adventure' and a.slug = 'rock-or-bust';

INSERT INTO songs (title, slug, duration) VALUES
(E'Dogs of War', 'dogs-of-war', 215);

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'angus-young' and s.slug = 'dogs-of-war';

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'malcolm-young' and s.slug = 'dogs-of-war';

INSERT INTO tracks (number, duration, album_id, song_id)
SELECT 5, 215, a.id, s.id
FROM songs s, albums a
WHERE s.slug = 'dogs-of-war' and a.slug = 'rock-or-bust';

INSERT INTO songs (title, slug, duration) VALUES
(E'Got Some Rock & Roll Thunder', 'got-some-rock-roll-thunder', 202);

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'angus-young' and s.slug = 'got-some-rock-roll-thunder';

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'malcolm-young' and s.slug = 'got-some-rock-roll-thunder';

INSERT INTO tracks (number, duration, album_id, song_id)
SELECT 6, 202, a.id, s.id
FROM songs s, albums a
WHERE s.slug = 'got-some-rock-roll-thunder' and a.slug = 'rock-or-bust';

INSERT INTO songs (title, slug, duration) VALUES
(E'Hard Times', 'hard-times', 164);

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'angus-young' and s.slug = 'hard-times';

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'malcolm-young' and s.slug = 'hard-times';

INSERT INTO tracks (number, duration, album_id, song_id)
SELECT 7, 164, a.id, s.id
FROM songs s, albums a
WHERE s.slug = 'hard-times' and a.slug = 'rock-or-bust';

INSERT INTO songs (title, slug, duration) VALUES
(E'Baptism of Fire', 'baptism-of-fire', 210);

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'angus-young' and s.slug = 'baptism-of-fire';

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'malcolm-young' and s.slug = 'baptism-of-fire';

INSERT INTO tracks (number, duration, album_id, song_id)
SELECT 8, 210, a.id, s.id
FROM songs s, albums a
WHERE s.slug = 'baptism-of-fire' and a.slug = 'rock-or-bust';

INSERT INTO songs (title, slug, duration) VALUES
(E'Rock the House', 'rock-the-house', 162);

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'angus-young' and s.slug = 'rock-the-house';

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'malcolm-young' and s.slug = 'rock-the-house';

INSERT INTO tracks (number, duration, album_id, song_id)
SELECT 9, 162, a.id, s.id
FROM songs s, albums a
WHERE s.slug = 'rock-the-house' and a.slug = 'rock-or-bust';

INSERT INTO songs (title, slug, duration) VALUES
(E'Sweet Candy', 'sweet-candy', 189);

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'angus-young' and s.slug = 'sweet-candy';

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'malcolm-young' and s.slug = 'sweet-candy';

INSERT INTO tracks (number, duration, album_id, song_id)
SELECT 10, 189, a.id, s.id
FROM songs s, albums a
WHERE s.slug = 'sweet-candy' and a.slug = 'rock-or-bust';

INSERT INTO songs (title, slug, duration) VALUES
(E'Emission Control', 'emission-control', 221);

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'angus-young' and s.slug = 'emission-control';

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'malcolm-young' and s.slug = 'emission-control';

INSERT INTO tracks (number, duration, album_id, song_id)
SELECT 11, 221, a.id, s.id
FROM songs s, albums a
WHERE s.slug = 'emission-control' and a.slug = 'rock-or-bust';

INSERT INTO songs (title, slug, duration) VALUES
(E'Hard as a Rock', 'hard-as-a-rock', 271);

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'angus-young' and s.slug = 'hard-as-a-rock';

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'malcolm-young' and s.slug = 'hard-as-a-rock';

INSERT INTO tracks (number, duration, album_id, song_id)
SELECT 1, 271, a.id, s.id
FROM songs s, albums a
WHERE s.slug = 'hard-as-a-rock' and a.slug = 'ballbreaker';

INSERT INTO songs (title, slug, duration) VALUES
(E'Cover You in Oil', 'cover-you-in-oil', 272);

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'angus-young' and s.slug = 'cover-you-in-oil';

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'malcolm-young' and s.slug = 'cover-you-in-oil';

INSERT INTO tracks (number, duration, album_id, song_id)
SELECT 2, 272, a.id, s.id
FROM songs s, albums a
WHERE s.slug = 'cover-you-in-oil' and a.slug = 'ballbreaker';

INSERT INTO songs (title, slug, duration) VALUES
(E'The Furor', 'the-furor', 250);

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'angus-young' and s.slug = 'the-furor';

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'malcolm-young' and s.slug = 'the-furor';

INSERT INTO tracks (number, duration, album_id, song_id)
SELECT 3, 250, a.id, s.id
FROM songs s, albums a
WHERE s.slug = 'the-furor' and a.slug = 'ballbreaker';

INSERT INTO songs (title, slug, duration) VALUES
(E'Boogie Man', 'boogie-man', 247);

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'angus-young' and s.slug = 'boogie-man';

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'malcolm-young' and s.slug = 'boogie-man';

INSERT INTO tracks (number, duration, album_id, song_id)
SELECT 4, 247, a.id, s.id
FROM songs s, albums a
WHERE s.slug = 'boogie-man' and a.slug = 'ballbreaker';

INSERT INTO songs (title, slug, duration) VALUES
(E'The Honey Roll', 'the-honey-roll', 334);

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'angus-young' and s.slug = 'the-honey-roll';

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'malcolm-young' and s.slug = 'the-honey-roll';

INSERT INTO tracks (number, duration, album_id, song_id)
SELECT 5, 334, a.id, s.id
FROM songs s, albums a
WHERE s.slug = 'the-honey-roll' and a.slug = 'ballbreaker';

INSERT INTO songs (title, slug, duration) VALUES
(E'Burnin\' Alive', 'burnin-alive', 305);

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'angus-young' and s.slug = 'burnin-alive';

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'malcolm-young' and s.slug = 'burnin-alive';

INSERT INTO tracks (number, duration, album_id, song_id)
SELECT 6, 305, a.id, s.id
FROM songs s, albums a
WHERE s.slug = 'burnin-alive' and a.slug = 'ballbreaker';

INSERT INTO songs (title, slug, duration) VALUES
(E'Hail Caesar', 'hail-caesar', 314);

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'angus-young' and s.slug = 'hail-caesar';

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'malcolm-young' and s.slug = 'hail-caesar';

INSERT INTO tracks (number, duration, album_id, song_id)
SELECT 7, 314, a.id, s.id
FROM songs s, albums a
WHERE s.slug = 'hail-caesar' and a.slug = 'ballbreaker';

INSERT INTO songs (title, slug, duration) VALUES
(E'Love Bomb', 'love-bomb', 194);

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'angus-young' and s.slug = 'love-bomb';

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'malcolm-young' and s.slug = 'love-bomb';

INSERT INTO tracks (number, duration, album_id, song_id)
SELECT 8, 194, a.id, s.id
FROM songs s, albums a
WHERE s.slug = 'love-bomb' and a.slug = 'ballbreaker';

INSERT INTO songs (title, slug, duration) VALUES
(E'Caught with Your Pants Down', 'caught-with-your-pants-down', 254);

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'angus-young' and s.slug = 'caught-with-your-pants-down';

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'malcolm-young' and s.slug = 'caught-with-your-pants-down';

INSERT INTO tracks (number, duration, album_id, song_id)
SELECT 9, 254, a.id, s.id
FROM songs s, albums a
WHERE s.slug = 'caught-with-your-pants-down' and a.slug = 'ballbreaker';

INSERT INTO songs (title, slug, duration) VALUES
(E'Whiskey on the Rocks', 'whiskey-on-the-rocks', 275);

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'angus-young' and s.slug = 'whiskey-on-the-rocks';

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'malcolm-young' and s.slug = 'whiskey-on-the-rocks';

INSERT INTO tracks (number, duration, album_id, song_id)
SELECT 10, 275, a.id, s.id
FROM songs s, albums a
WHERE s.slug = 'whiskey-on-the-rocks' and a.slug = 'ballbreaker';

INSERT INTO songs (title, slug, duration) VALUES
(E'Ballbreaker', 'ballbreaker', 271);

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'angus-young' and s.slug = 'ballbreaker';

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'malcolm-young' and s.slug = 'ballbreaker';

INSERT INTO tracks (number, duration, album_id, song_id)
SELECT 11, 271, a.id, s.id
FROM songs s, albums a
WHERE s.slug = 'ballbreaker' and a.slug = 'ballbreaker';

INSERT INTO songs (title, slug, duration) VALUES
(E'Fly on the Wall', 'fly-on-the-wall', 224);

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'angus-young' and s.slug = 'fly-on-the-wall';

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'malcolm-young' and s.slug = 'fly-on-the-wall';

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'brian-johnson' and s.slug = 'fly-on-the-wall';

INSERT INTO tracks (number, duration, album_id, song_id)
SELECT 1, 224, a.id, s.id
FROM songs s, albums a
WHERE s.slug = 'fly-on-the-wall' and a.slug = 'fly-on-the-wall';

INSERT INTO songs (title, slug, duration) VALUES
(E'Shake Your Foundations', 'shake-your-foundations', 250);

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'angus-young' and s.slug = 'shake-your-foundations';

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'malcolm-young' and s.slug = 'shake-your-foundations';

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'brian-johnson' and s.slug = 'shake-your-foundations';

INSERT INTO tracks (number, duration, album_id, song_id)
SELECT 2, 250, a.id, s.id
FROM songs s, albums a
WHERE s.slug = 'shake-your-foundations' and a.slug = 'fly-on-the-wall';

INSERT INTO songs (title, slug, duration) VALUES
(E'First Blood', 'first-blood', 226);

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'angus-young' and s.slug = 'first-blood';

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'malcolm-young' and s.slug = 'first-blood';

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'brian-johnson' and s.slug = 'first-blood';

INSERT INTO tracks (number, duration, album_id, song_id)
SELECT 3, 226, a.id, s.id
FROM songs s, albums a
WHERE s.slug = 'first-blood' and a.slug = 'fly-on-the-wall';

INSERT INTO songs (title, slug, duration) VALUES
(E'Danger', 'danger', 262);

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'angus-young' and s.slug = 'danger';

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'malcolm-young' and s.slug = 'danger';

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'brian-johnson' and s.slug = 'danger';

INSERT INTO tracks (number, duration, album_id, song_id)
SELECT 4, 262, a.id, s.id
FROM songs s, albums a
WHERE s.slug = 'danger' and a.slug = 'fly-on-the-wall';

INSERT INTO songs (title, slug, duration) VALUES
(E'Sink the Pink', 'sink-the-pink', 255);

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'angus-young' and s.slug = 'sink-the-pink';

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'malcolm-young' and s.slug = 'sink-the-pink';

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'brian-johnson' and s.slug = 'sink-the-pink';

INSERT INTO tracks (number, duration, album_id, song_id)
SELECT 5, 255, a.id, s.id
FROM songs s, albums a
WHERE s.slug = 'sink-the-pink' and a.slug = 'fly-on-the-wall';

INSERT INTO songs (title, slug, duration) VALUES
(E'Playing with Girls', 'playing-with-girls', 224);

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'angus-young' and s.slug = 'playing-with-girls';

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'malcolm-young' and s.slug = 'playing-with-girls';

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'brian-johnson' and s.slug = 'playing-with-girls';

INSERT INTO tracks (number, duration, album_id, song_id)
SELECT 6, 224, a.id, s.id
FROM songs s, albums a
WHERE s.slug = 'playing-with-girls' and a.slug = 'fly-on-the-wall';

INSERT INTO songs (title, slug, duration) VALUES
(E'Stand Up', 'stand-up', 233);

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'angus-young' and s.slug = 'stand-up';

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'malcolm-young' and s.slug = 'stand-up';

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'brian-johnson' and s.slug = 'stand-up';

INSERT INTO tracks (number, duration, album_id, song_id)
SELECT 7, 233, a.id, s.id
FROM songs s, albums a
WHERE s.slug = 'stand-up' and a.slug = 'fly-on-the-wall';

INSERT INTO songs (title, slug, duration) VALUES
(E'Hell or High Water', 'hell-or-high-water', 272);

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'angus-young' and s.slug = 'hell-or-high-water';

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'malcolm-young' and s.slug = 'hell-or-high-water';

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'brian-johnson' and s.slug = 'hell-or-high-water';

INSERT INTO tracks (number, duration, album_id, song_id)
SELECT 8, 272, a.id, s.id
FROM songs s, albums a
WHERE s.slug = 'hell-or-high-water' and a.slug = 'fly-on-the-wall';

INSERT INTO songs (title, slug, duration) VALUES
(E'Back in Business', 'back-in-business', 264);

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'angus-young' and s.slug = 'back-in-business';

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'malcolm-young' and s.slug = 'back-in-business';

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'brian-johnson' and s.slug = 'back-in-business';

INSERT INTO tracks (number, duration, album_id, song_id)
SELECT 9, 264, a.id, s.id
FROM songs s, albums a
WHERE s.slug = 'back-in-business' and a.slug = 'fly-on-the-wall';

INSERT INTO songs (title, slug, duration) VALUES
(E'Send for the Man', 'send-for-the-man', 216);

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'angus-young' and s.slug = 'send-for-the-man';

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'malcolm-young' and s.slug = 'send-for-the-man';

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'brian-johnson' and s.slug = 'send-for-the-man';

INSERT INTO tracks (number, duration, album_id, song_id)
SELECT 10, 216, a.id, s.id
FROM songs s, albums a
WHERE s.slug = 'send-for-the-man' and a.slug = 'fly-on-the-wall';

INSERT INTO songs (title, slug, duration) VALUES
(E'Thunderstruck', 'thunderstruck', 292);

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'angus-young' and s.slug = 'thunderstruck';

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'malcolm-young' and s.slug = 'thunderstruck';

INSERT INTO tracks (number, duration, album_id, song_id)
SELECT 1, 292, a.id, s.id
FROM songs s, albums a
WHERE s.slug = 'thunderstruck' and a.slug = 'the-razors-edge';

INSERT INTO songs (title, slug, duration) VALUES
(E'Fire Your Guns', 'fire-your-guns', 173);

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'angus-young' and s.slug = 'fire-your-guns';

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'malcolm-young' and s.slug = 'fire-your-guns';

INSERT INTO tracks (number, duration, album_id, song_id)
SELECT 2, 173, a.id, s.id
FROM songs s, albums a
WHERE s.slug = 'fire-your-guns' and a.slug = 'the-razors-edge';

INSERT INTO songs (title, slug, duration) VALUES
(E'Moneytalks', 'moneytalks', 228);

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'angus-young' and s.slug = 'moneytalks';

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'malcolm-young' and s.slug = 'moneytalks';

INSERT INTO tracks (number, duration, album_id, song_id)
SELECT 3, 228, a.id, s.id
FROM songs s, albums a
WHERE s.slug = 'moneytalks' and a.slug = 'the-razors-edge';

INSERT INTO songs (title, slug, duration) VALUES
(E'The Razors Edge', 'the-razors-edge', 262);

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'angus-young' and s.slug = 'the-razors-edge';

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'malcolm-young' and s.slug = 'the-razors-edge';

INSERT INTO tracks (number, duration, album_id, song_id)
SELECT 4, 262, a.id, s.id
FROM songs s, albums a
WHERE s.slug = 'the-razors-edge' and a.slug = 'the-razors-edge';

INSERT INTO songs (title, slug, duration) VALUES
(E'Mistress for Christmas', 'mistress-for-christmas', 239);

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'angus-young' and s.slug = 'mistress-for-christmas';

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'malcolm-young' and s.slug = 'mistress-for-christmas';

INSERT INTO tracks (number, duration, album_id, song_id)
SELECT 5, 239, a.id, s.id
FROM songs s, albums a
WHERE s.slug = 'mistress-for-christmas' and a.slug = 'the-razors-edge';

INSERT INTO songs (title, slug, duration) VALUES
(E'Rock Your Heart Out', 'rock-your-heart-out', 246);

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'angus-young' and s.slug = 'rock-your-heart-out';

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'malcolm-young' and s.slug = 'rock-your-heart-out';

INSERT INTO tracks (number, duration, album_id, song_id)
SELECT 6, 246, a.id, s.id
FROM songs s, albums a
WHERE s.slug = 'rock-your-heart-out' and a.slug = 'the-razors-edge';

INSERT INTO songs (title, slug, duration) VALUES
(E'Are You Ready', 'are-you-ready', 250);

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'angus-young' and s.slug = 'are-you-ready';

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'malcolm-young' and s.slug = 'are-you-ready';

INSERT INTO tracks (number, duration, album_id, song_id)
SELECT 7, 250, a.id, s.id
FROM songs s, albums a
WHERE s.slug = 'are-you-ready' and a.slug = 'the-razors-edge';

INSERT INTO songs (title, slug, duration) VALUES
(E'Got You by the Balls', 'got-you-by-the-balls', 270);

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'angus-young' and s.slug = 'got-you-by-the-balls';

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'malcolm-young' and s.slug = 'got-you-by-the-balls';

INSERT INTO tracks (number, duration, album_id, song_id)
SELECT 8, 270, a.id, s.id
FROM songs s, albums a
WHERE s.slug = 'got-you-by-the-balls' and a.slug = 'the-razors-edge';

INSERT INTO songs (title, slug, duration) VALUES
(E'Shot of Love', 'shot-of-love', 236);

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'angus-young' and s.slug = 'shot-of-love';

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'malcolm-young' and s.slug = 'shot-of-love';

INSERT INTO tracks (number, duration, album_id, song_id)
SELECT 9, 236, a.id, s.id
FROM songs s, albums a
WHERE s.slug = 'shot-of-love' and a.slug = 'the-razors-edge';

INSERT INTO songs (title, slug, duration) VALUES
(E'Let\'s Make it', 'let-s-make-it', 212);

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'angus-young' and s.slug = 'let-s-make-it';

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'malcolm-young' and s.slug = 'let-s-make-it';

INSERT INTO tracks (number, duration, album_id, song_id)
SELECT 10, 212, a.id, s.id
FROM songs s, albums a
WHERE s.slug = 'let-s-make-it' and a.slug = 'the-razors-edge';

INSERT INTO songs (title, slug, duration) VALUES
(E'Goodbye ad Good Riddance to Bad Luck', 'goodbye-ad-good-riddance-to-bad-luck', 193);

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'angus-young' and s.slug = 'goodbye-ad-good-riddance-to-bad-luck';

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'malcolm-young' and s.slug = 'goodbye-ad-good-riddance-to-bad-luck';

INSERT INTO tracks (number, duration, album_id, song_id)
SELECT 11, 193, a.id, s.id
FROM songs s, albums a
WHERE s.slug = 'goodbye-ad-good-riddance-to-bad-luck' and a.slug = 'the-razors-edge';

INSERT INTO songs (title, slug, duration) VALUES
(E'If You Dare', 'if-you-dare', 188);

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'angus-young' and s.slug = 'if-you-dare';

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'malcolm-young' and s.slug = 'if-you-dare';

INSERT INTO tracks (number, duration, album_id, song_id)
SELECT 12, 188, a.id, s.id
FROM songs s, albums a
WHERE s.slug = 'if-you-dare' and a.slug = 'the-razors-edge';

INSERT INTO songs (title, slug, duration) VALUES
(E'Heatseaker', 'heatseaker', 230);

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'angus-young' and s.slug = 'heatseaker';

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'malcolm-young' and s.slug = 'heatseaker';

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'brian-johnson' and s.slug = 'heatseaker';

INSERT INTO tracks (number, duration, album_id, song_id)
SELECT 1, 230, a.id, s.id
FROM songs s, albums a
WHERE s.slug = 'heatseaker' and a.slug = 'blow-up-your-video';

INSERT INTO songs (title, slug, duration) VALUES
(E'That\'s the Way I Wanna Rock \'n\' Roll', 'that-s-the-way-i-wanna-rock-n-roll', 225);

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'angus-young' and s.slug = 'that-s-the-way-i-wanna-rock-n-roll';

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'malcolm-young' and s.slug = 'that-s-the-way-i-wanna-rock-n-roll';

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'brian-johnson' and s.slug = 'that-s-the-way-i-wanna-rock-n-roll';

INSERT INTO tracks (number, duration, album_id, song_id)
SELECT 2, 225, a.id, s.id
FROM songs s, albums a
WHERE s.slug = 'that-s-the-way-i-wanna-rock-n-roll' and a.slug = 'blow-up-your-video';

INSERT INTO songs (title, slug, duration) VALUES
(E'Meanstreak', 'meanstreak', 248);

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'angus-young' and s.slug = 'meanstreak';

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'malcolm-young' and s.slug = 'meanstreak';

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'brian-johnson' and s.slug = 'meanstreak';

INSERT INTO tracks (number, duration, album_id, song_id)
SELECT 3, 248, a.id, s.id
FROM songs s, albums a
WHERE s.slug = 'meanstreak' and a.slug = 'blow-up-your-video';

INSERT INTO songs (title, slug, duration) VALUES
(E'Go Zone', 'go-zone', 266);

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'angus-young' and s.slug = 'go-zone';

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'malcolm-young' and s.slug = 'go-zone';

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'brian-johnson' and s.slug = 'go-zone';

INSERT INTO tracks (number, duration, album_id, song_id)
SELECT 4, 266, a.id, s.id
FROM songs s, albums a
WHERE s.slug = 'go-zone' and a.slug = 'blow-up-your-video';

INSERT INTO songs (title, slug, duration) VALUES
(E'Kissin\' Dynamite', 'kissin-dynamite', 238);

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'angus-young' and s.slug = 'kissin-dynamite';

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'malcolm-young' and s.slug = 'kissin-dynamite';

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'brian-johnson' and s.slug = 'kissin-dynamite';

INSERT INTO tracks (number, duration, album_id, song_id)
SELECT 5, 238, a.id, s.id
FROM songs s, albums a
WHERE s.slug = 'kissin-dynamite' and a.slug = 'blow-up-your-video';

INSERT INTO songs (title, slug, duration) VALUES
(E'Nick of Time', 'nick-of-time', 256);

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'angus-young' and s.slug = 'nick-of-time';

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'malcolm-young' and s.slug = 'nick-of-time';

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'brian-johnson' and s.slug = 'nick-of-time';

INSERT INTO tracks (number, duration, album_id, song_id)
SELECT 6, 256, a.id, s.id
FROM songs s, albums a
WHERE s.slug = 'nick-of-time' and a.slug = 'blow-up-your-video';

INSERT INTO songs (title, slug, duration) VALUES
(E'Some Sin for Nuthin\'', 'some-sin-for-nuthin', 251);

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'angus-young' and s.slug = 'some-sin-for-nuthin';

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'malcolm-young' and s.slug = 'some-sin-for-nuthin';

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'brian-johnson' and s.slug = 'some-sin-for-nuthin';

INSERT INTO tracks (number, duration, album_id, song_id)
SELECT 7, 251, a.id, s.id
FROM songs s, albums a
WHERE s.slug = 'some-sin-for-nuthin' and a.slug = 'blow-up-your-video';

INSERT INTO songs (title, slug, duration) VALUES
(E'Ruff Stuff', 'ruff-stuff', 268);

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'angus-young' and s.slug = 'ruff-stuff';

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'malcolm-young' and s.slug = 'ruff-stuff';

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'brian-johnson' and s.slug = 'ruff-stuff';

INSERT INTO tracks (number, duration, album_id, song_id)
SELECT 8, 268, a.id, s.id
FROM songs s, albums a
WHERE s.slug = 'ruff-stuff' and a.slug = 'blow-up-your-video';

INSERT INTO songs (title, slug, duration) VALUES
(E'Two\'s Up', 'two-s-up', 319);

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'angus-young' and s.slug = 'two-s-up';

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'malcolm-young' and s.slug = 'two-s-up';

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'brian-johnson' and s.slug = 'two-s-up';

INSERT INTO tracks (number, duration, album_id, song_id)
SELECT 9, 319, a.id, s.id
FROM songs s, albums a
WHERE s.slug = 'two-s-up' and a.slug = 'blow-up-your-video';

INSERT INTO songs (title, slug, duration) VALUES
(E'This Means War', 'this-means-war', 261);

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'angus-young' and s.slug = 'this-means-war';

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'malcolm-young' and s.slug = 'this-means-war';

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'brian-johnson' and s.slug = 'this-means-war';

INSERT INTO tracks (number, duration, album_id, song_id)
SELECT 10, 261, a.id, s.id
FROM songs s, albums a
WHERE s.slug = 'this-means-war' and a.slug = 'blow-up-your-video';

INSERT INTO songs (title, slug, duration) VALUES
(E'For Those About to Rock (We Salute You)', 'for-those-about-to-rock-we-salute-you', 343);

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'angus-young' and s.slug = 'for-those-about-to-rock-we-salute-you';

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'malcolm-young' and s.slug = 'for-those-about-to-rock-we-salute-you';

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'brian-johnson' and s.slug = 'for-those-about-to-rock-we-salute-you';

INSERT INTO tracks (number, duration, album_id, song_id)
SELECT 1, 343, a.id, s.id
FROM songs s, albums a
WHERE s.slug = 'for-those-about-to-rock-we-salute-you' and a.slug = 'for-those-about-to-rock-we-salute-you';

INSERT INTO songs (title, slug, duration) VALUES
(E'Put the Finger on You', 'put-the-finger-on-you', 205);

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'angus-young' and s.slug = 'put-the-finger-on-you';

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'malcolm-young' and s.slug = 'put-the-finger-on-you';

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'brian-johnson' and s.slug = 'put-the-finger-on-you';

INSERT INTO tracks (number, duration, album_id, song_id)
SELECT 2, 205, a.id, s.id
FROM songs s, albums a
WHERE s.slug = 'put-the-finger-on-you' and a.slug = 'for-those-about-to-rock-we-salute-you';

INSERT INTO songs (title, slug, duration) VALUES
(E'Let\'s Get It Up', 'let-s-get-it-up', 233);

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'angus-young' and s.slug = 'let-s-get-it-up';

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'malcolm-young' and s.slug = 'let-s-get-it-up';

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'brian-johnson' and s.slug = 'let-s-get-it-up';

INSERT INTO tracks (number, duration, album_id, song_id)
SELECT 3, 233, a.id, s.id
FROM songs s, albums a
WHERE s.slug = 'let-s-get-it-up' and a.slug = 'for-those-about-to-rock-we-salute-you';

INSERT INTO songs (title, slug, duration) VALUES
(E'Inject the Venom', 'inject-the-venom', 211);

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'angus-young' and s.slug = 'inject-the-venom';

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'malcolm-young' and s.slug = 'inject-the-venom';

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'brian-johnson' and s.slug = 'inject-the-venom';

INSERT INTO tracks (number, duration, album_id, song_id)
SELECT 4, 211, a.id, s.id
FROM songs s, albums a
WHERE s.slug = 'inject-the-venom' and a.slug = 'for-those-about-to-rock-we-salute-you';

INSERT INTO songs (title, slug, duration) VALUES
(E'Snowballed', 'snowballed', 203);

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'angus-young' and s.slug = 'snowballed';

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'malcolm-young' and s.slug = 'snowballed';

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'brian-johnson' and s.slug = 'snowballed';

INSERT INTO tracks (number, duration, album_id, song_id)
SELECT 5, 203, a.id, s.id
FROM songs s, albums a
WHERE s.slug = 'snowballed' and a.slug = 'for-those-about-to-rock-we-salute-you';

INSERT INTO songs (title, slug, duration) VALUES
(E'Evil Walks', 'evil-walks', 263);

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'angus-young' and s.slug = 'evil-walks';

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'malcolm-young' and s.slug = 'evil-walks';

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'brian-johnson' and s.slug = 'evil-walks';

INSERT INTO tracks (number, duration, album_id, song_id)
SELECT 6, 263, a.id, s.id
FROM songs s, albums a
WHERE s.slug = 'evil-walks' and a.slug = 'for-those-about-to-rock-we-salute-you';

INSERT INTO songs (title, slug, duration) VALUES
(E'C.O.D.', 'c-o-d', 199);

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'angus-young' and s.slug = 'c-o-d';

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'malcolm-young' and s.slug = 'c-o-d';

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'brian-johnson' and s.slug = 'c-o-d';

INSERT INTO tracks (number, duration, album_id, song_id)
SELECT 7, 199, a.id, s.id
FROM songs s, albums a
WHERE s.slug = 'c-o-d' and a.slug = 'for-those-about-to-rock-we-salute-you';

INSERT INTO songs (title, slug, duration) VALUES
(E'Breaking the Rules', 'breaking-the-rules', 263);

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'angus-young' and s.slug = 'breaking-the-rules';

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'malcolm-young' and s.slug = 'breaking-the-rules';

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'brian-johnson' and s.slug = 'breaking-the-rules';

INSERT INTO tracks (number, duration, album_id, song_id)
SELECT 8, 263, a.id, s.id
FROM songs s, albums a
WHERE s.slug = 'breaking-the-rules' and a.slug = 'for-those-about-to-rock-we-salute-you';

INSERT INTO songs (title, slug, duration) VALUES
(E'Night of the Long Knives', 'night-of-the-long-knives', 205);

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'angus-young' and s.slug = 'night-of-the-long-knives';

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'malcolm-young' and s.slug = 'night-of-the-long-knives';

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'brian-johnson' and s.slug = 'night-of-the-long-knives';

INSERT INTO tracks (number, duration, album_id, song_id)
SELECT 9, 205, a.id, s.id
FROM songs s, albums a
WHERE s.slug = 'night-of-the-long-knives' and a.slug = 'for-those-about-to-rock-we-salute-you';

INSERT INTO songs (title, slug, duration) VALUES
(E'Spellbound', 'spellbound', 268);

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'angus-young' and s.slug = 'spellbound';

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'malcolm-young' and s.slug = 'spellbound';

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'brian-johnson' and s.slug = 'spellbound';

INSERT INTO tracks (number, duration, album_id, song_id)
SELECT 10, 268, a.id, s.id
FROM songs s, albums a
WHERE s.slug = 'spellbound' and a.slug = 'for-those-about-to-rock-we-salute-you';

INSERT INTO songs (title, slug, duration) VALUES
(E'It\'s a Long Way to the Top (If You Wanna Rock \'n\' Roll)', 'it-s-a-long-way-to-the-top-if-you-wanna-rock-n-roll', 302);

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'angus-young' and s.slug = 'it-s-a-long-way-to-the-top-if-you-wanna-rock-n-roll';

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'malcolm-young' and s.slug = 'it-s-a-long-way-to-the-top-if-you-wanna-rock-n-roll';

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'bon-scott' and s.slug = 'it-s-a-long-way-to-the-top-if-you-wanna-rock-n-roll';

INSERT INTO tracks (number, duration, album_id, song_id)
SELECT 1, 302, a.id, s.id
FROM songs s, albums a
WHERE s.slug = 'it-s-a-long-way-to-the-top-if-you-wanna-rock-n-roll' and a.slug = 'high-voltage';

INSERT INTO songs (title, slug, duration) VALUES
(E'Rock \'n\' Roll Singer', 'rock-n-roll-singer', 304);

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'angus-young' and s.slug = 'rock-n-roll-singer';

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'malcolm-young' and s.slug = 'rock-n-roll-singer';

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'bon-scott' and s.slug = 'rock-n-roll-singer';

INSERT INTO tracks (number, duration, album_id, song_id)
SELECT 2, 304, a.id, s.id
FROM songs s, albums a
WHERE s.slug = 'rock-n-roll-singer' and a.slug = 'high-voltage';

INSERT INTO songs (title, slug, duration) VALUES
(E'The Jack', 'the-jack', 353);

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'angus-young' and s.slug = 'the-jack';

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'malcolm-young' and s.slug = 'the-jack';

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'bon-scott' and s.slug = 'the-jack';

INSERT INTO tracks (number, duration, album_id, song_id)
SELECT 3, 353, a.id, s.id
FROM songs s, albums a
WHERE s.slug = 'the-jack' and a.slug = 'high-voltage';

INSERT INTO songs (title, slug, duration) VALUES
(E'Live Wire', 'live-wire', 350);

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'angus-young' and s.slug = 'live-wire';

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'malcolm-young' and s.slug = 'live-wire';

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'bon-scott' and s.slug = 'live-wire';

INSERT INTO tracks (number, duration, album_id, song_id)
SELECT 4, 350, a.id, s.id
FROM songs s, albums a
WHERE s.slug = 'live-wire' and a.slug = 'high-voltage';

INSERT INTO songs (title, slug, duration) VALUES
(E'T.N.T', 't-n-t', 215);

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'angus-young' and s.slug = 't-n-t';

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'malcolm-young' and s.slug = 't-n-t';

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'bon-scott' and s.slug = 't-n-t';

INSERT INTO tracks (number, duration, album_id, song_id)
SELECT 5, 215, a.id, s.id
FROM songs s, albums a
WHERE s.slug = 't-n-t' and a.slug = 'high-voltage';

INSERT INTO songs (title, slug, duration) VALUES
(E'Can I Sit Next to You Girl', 'can-i-sit-next-to-you-girl', 252);

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'angus-young' and s.slug = 'can-i-sit-next-to-you-girl';

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'malcolm-young' and s.slug = 'can-i-sit-next-to-you-girl';

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'bon-scott' and s.slug = 'can-i-sit-next-to-you-girl';

INSERT INTO tracks (number, duration, album_id, song_id)
SELECT 6, 252, a.id, s.id
FROM songs s, albums a
WHERE s.slug = 'can-i-sit-next-to-you-girl' and a.slug = 'high-voltage';

INSERT INTO songs (title, slug, duration) VALUES
(E'Little Lover', 'little-lover', 340);

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'angus-young' and s.slug = 'little-lover';

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'malcolm-young' and s.slug = 'little-lover';

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'bon-scott' and s.slug = 'little-lover';

INSERT INTO tracks (number, duration, album_id, song_id)
SELECT 7, 340, a.id, s.id
FROM songs s, albums a
WHERE s.slug = 'little-lover' and a.slug = 'high-voltage';

INSERT INTO songs (title, slug, duration) VALUES
(E'She\'s Got Balls', 'she-s-got-balls', 292);

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'angus-young' and s.slug = 'she-s-got-balls';

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'malcolm-young' and s.slug = 'she-s-got-balls';

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'bon-scott' and s.slug = 'she-s-got-balls';

INSERT INTO tracks (number, duration, album_id, song_id)
SELECT 8, 292, a.id, s.id
FROM songs s, albums a
WHERE s.slug = 'she-s-got-balls' and a.slug = 'high-voltage';

INSERT INTO songs (title, slug, duration) VALUES
(E'High Voltage', 'high-voltage', 244);

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'angus-young' and s.slug = 'high-voltage';

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'malcolm-young' and s.slug = 'high-voltage';

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'bon-scott' and s.slug = 'high-voltage';

INSERT INTO tracks (number, duration, album_id, song_id)
SELECT 9, 244, a.id, s.id
FROM songs s, albums a
WHERE s.slug = 'high-voltage' and a.slug = 'high-voltage';

INSERT INTO songs (title, slug, duration) VALUES
(E'Rising Power', 'rising-power', 223);

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'angus-young' and s.slug = 'rising-power';

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'malcolm-young' and s.slug = 'rising-power';

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'brian-johnson' and s.slug = 'rising-power';

INSERT INTO tracks (number, duration, album_id, song_id)
SELECT 1, 223, a.id, s.id
FROM songs s, albums a
WHERE s.slug = 'rising-power' and a.slug = 'flick-of-the-switch';

INSERT INTO songs (title, slug, duration) VALUES
(E'This House Is on Fire', 'this-house-is-on-fire', 203);

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'angus-young' and s.slug = 'this-house-is-on-fire';

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'malcolm-young' and s.slug = 'this-house-is-on-fire';

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'brian-johnson' and s.slug = 'this-house-is-on-fire';

INSERT INTO tracks (number, duration, album_id, song_id)
SELECT 2, 203, a.id, s.id
FROM songs s, albums a
WHERE s.slug = 'this-house-is-on-fire' and a.slug = 'flick-of-the-switch';

INSERT INTO songs (title, slug, duration) VALUES
(E'Flick of the Switch', 'flick-of-the-switch', 193);

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'angus-young' and s.slug = 'flick-of-the-switch';

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'malcolm-young' and s.slug = 'flick-of-the-switch';

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'brian-johnson' and s.slug = 'flick-of-the-switch';

INSERT INTO tracks (number, duration, album_id, song_id)
SELECT 3, 193, a.id, s.id
FROM songs s, albums a
WHERE s.slug = 'flick-of-the-switch' and a.slug = 'flick-of-the-switch';

INSERT INTO songs (title, slug, duration) VALUES
(E'Nervous Shakedown', 'nervous-shakedown', 267);

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'angus-young' and s.slug = 'nervous-shakedown';

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'malcolm-young' and s.slug = 'nervous-shakedown';

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'brian-johnson' and s.slug = 'nervous-shakedown';

INSERT INTO tracks (number, duration, album_id, song_id)
SELECT 4, 267, a.id, s.id
FROM songs s, albums a
WHERE s.slug = 'nervous-shakedown' and a.slug = 'flick-of-the-switch';

INSERT INTO songs (title, slug, duration) VALUES
(E'Landslide', 'landslide', 237);

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'angus-young' and s.slug = 'landslide';

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'malcolm-young' and s.slug = 'landslide';

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'brian-johnson' and s.slug = 'landslide';

INSERT INTO tracks (number, duration, album_id, song_id)
SELECT 5, 237, a.id, s.id
FROM songs s, albums a
WHERE s.slug = 'landslide' and a.slug = 'flick-of-the-switch';

INSERT INTO songs (title, slug, duration) VALUES
(E'Guns for Hire', 'guns-for-hire', 204);

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'angus-young' and s.slug = 'guns-for-hire';

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'malcolm-young' and s.slug = 'guns-for-hire';

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'brian-johnson' and s.slug = 'guns-for-hire';

INSERT INTO tracks (number, duration, album_id, song_id)
SELECT 6, 204, a.id, s.id
FROM songs s, albums a
WHERE s.slug = 'guns-for-hire' and a.slug = 'flick-of-the-switch';

INSERT INTO songs (title, slug, duration) VALUES
(E'Deep in the Hole', 'deep-in-the-hole', 199);

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'angus-young' and s.slug = 'deep-in-the-hole';

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'malcolm-young' and s.slug = 'deep-in-the-hole';

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'brian-johnson' and s.slug = 'deep-in-the-hole';

INSERT INTO tracks (number, duration, album_id, song_id)
SELECT 7, 199, a.id, s.id
FROM songs s, albums a
WHERE s.slug = 'deep-in-the-hole' and a.slug = 'flick-of-the-switch';

INSERT INTO songs (title, slug, duration) VALUES
(E'Bedlam in Belgium', 'bedlam-in-belgium', 232);

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'angus-young' and s.slug = 'bedlam-in-belgium';

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'malcolm-young' and s.slug = 'bedlam-in-belgium';

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'brian-johnson' and s.slug = 'bedlam-in-belgium';

INSERT INTO tracks (number, duration, album_id, song_id)
SELECT 8, 232, a.id, s.id
FROM songs s, albums a
WHERE s.slug = 'bedlam-in-belgium' and a.slug = 'flick-of-the-switch';

INSERT INTO songs (title, slug, duration) VALUES
(E'Badlands', 'badlands', 218);

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'angus-young' and s.slug = 'badlands';

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'malcolm-young' and s.slug = 'badlands';

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'brian-johnson' and s.slug = 'badlands';

INSERT INTO tracks (number, duration, album_id, song_id)
SELECT 9, 218, a.id, s.id
FROM songs s, albums a
WHERE s.slug = 'badlands' and a.slug = 'flick-of-the-switch';

INSERT INTO songs (title, slug, duration) VALUES
(E'Brain Shake', 'brain-shake', 240);

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'angus-young' and s.slug = 'brain-shake';

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'malcolm-young' and s.slug = 'brain-shake';

INSERT INTO song_writers( person_id, song_id)
SELECT p.id, s.id
FROM people p, songs s
WHERE p.slug = 'brian-johnson' and s.slug = 'brain-shake';

INSERT INTO tracks (number, duration, album_id, song_id)
SELECT 10, 240, a.id, s.id
FROM songs s, albums a
WHERE s.slug = 'brain-shake' and a.slug = 'flick-of-the-switch';

INSERT INTO album_musicians ( album_id, instrument_id, person_id)
SELECT a.id, i.id, p.id
FROM albums a, instruments i, people p
WHERE a.slug = 'high-voltage' and i.slug = 'lead-vocals' and p.slug = 'bon-scott';

INSERT INTO album_musicians ( album_id, instrument_id, person_id)
SELECT a.id, i.id, p.id
FROM albums a, instruments i, people p
WHERE a.slug = 'high-voltage' and i.slug = 'bass-guitar' and p.slug = 'cliff-williams';

INSERT INTO album_musicians ( album_id, instrument_id, person_id)
SELECT a.id, i.id, p.id
FROM albums a, instruments i, people p
WHERE a.slug = 'high-voltage' and i.slug = 'backing-vocals' and p.slug = 'cliff-williams';

INSERT INTO album_musicians ( album_id, instrument_id, person_id)
SELECT a.id, i.id, p.id
FROM albums a, instruments i, people p
WHERE a.slug = 'high-voltage' and i.slug = 'drums' and p.slug = 'phil-rudd';

INSERT INTO album_musicians ( album_id, instrument_id, person_id)
SELECT a.id, i.id, p.id
FROM albums a, instruments i, people p
WHERE a.slug = 'high-voltage' and i.slug = 'lead-guitar' and p.slug = 'angus-young';

INSERT INTO album_musicians ( album_id, instrument_id, person_id)
SELECT a.id, i.id, p.id
FROM albums a, instruments i, people p
WHERE a.slug = 'high-voltage' and i.slug = 'rhythm-guitar' and p.slug = 'malcolm-young';

INSERT INTO album_musicians ( album_id, instrument_id, person_id)
SELECT a.id, i.id, p.id
FROM albums a, instruments i, people p
WHERE a.slug = 'high-voltage' and i.slug = 'backing-vocals' and p.slug = 'malcolm-young';

INSERT INTO album_musicians ( album_id, instrument_id, person_id)
SELECT a.id, i.id, p.id
FROM albums a, instruments i, people p
WHERE a.slug = 'ballbreaker' and i.slug = 'rhythm-guitar' and p.slug = 'malcolm-young';

INSERT INTO album_musicians ( album_id, instrument_id, person_id)
SELECT a.id, i.id, p.id
FROM albums a, instruments i, people p
WHERE a.slug = 'ballbreaker' and i.slug = 'backing-vocals' and p.slug = 'malcolm-young';

INSERT INTO album_musicians ( album_id, instrument_id, person_id)
SELECT a.id, i.id, p.id
FROM albums a, instruments i, people p
WHERE a.slug = 'ballbreaker' and i.slug = 'drums' and p.slug = 'phil-rudd';

INSERT INTO album_musicians ( album_id, instrument_id, person_id)
SELECT a.id, i.id, p.id
FROM albums a, instruments i, people p
WHERE a.slug = 'ballbreaker' and i.slug = 'bass-guitar' and p.slug = 'cliff-williams';

INSERT INTO album_musicians ( album_id, instrument_id, person_id)
SELECT a.id, i.id, p.id
FROM albums a, instruments i, people p
WHERE a.slug = 'ballbreaker' and i.slug = 'backing-vocals' and p.slug = 'cliff-williams';

INSERT INTO album_musicians ( album_id, instrument_id, person_id)
SELECT a.id, i.id, p.id
FROM albums a, instruments i, people p
WHERE a.slug = 'ballbreaker' and i.slug = 'lead-guitar' and p.slug = 'angus-young';

INSERT INTO album_musicians ( album_id, instrument_id, person_id)
SELECT a.id, i.id, p.id
FROM albums a, instruments i, people p
WHERE a.slug = 'ballbreaker' and i.slug = 'lead-vocals' and p.slug = 'brian-johnson';

INSERT INTO album_musicians ( album_id, instrument_id, person_id)
SELECT a.id, i.id, p.id
FROM albums a, instruments i, people p
WHERE a.slug = 'back-in-black' and i.slug = 'lead-vocals' and p.slug = 'brian-johnson';

INSERT INTO album_musicians ( album_id, instrument_id, person_id)
SELECT a.id, i.id, p.id
FROM albums a, instruments i, people p
WHERE a.slug = 'back-in-black' and i.slug = 'bass-guitar' and p.slug = 'cliff-williams';

INSERT INTO album_musicians ( album_id, instrument_id, person_id)
SELECT a.id, i.id, p.id
FROM albums a, instruments i, people p
WHERE a.slug = 'back-in-black' and i.slug = 'backing-vocals' and p.slug = 'cliff-williams';

INSERT INTO album_musicians ( album_id, instrument_id, person_id)
SELECT a.id, i.id, p.id
FROM albums a, instruments i, people p
WHERE a.slug = 'back-in-black' and i.slug = 'drums' and p.slug = 'phil-rudd';

INSERT INTO album_musicians ( album_id, instrument_id, person_id)
SELECT a.id, i.id, p.id
FROM albums a, instruments i, people p
WHERE a.slug = 'back-in-black' and i.slug = 'lead-guitar' and p.slug = 'angus-young';

INSERT INTO album_musicians ( album_id, instrument_id, person_id)
SELECT a.id, i.id, p.id
FROM albums a, instruments i, people p
WHERE a.slug = 'back-in-black' and i.slug = 'rhythm-guitar' and p.slug = 'malcolm-young';

INSERT INTO album_musicians ( album_id, instrument_id, person_id)
SELECT a.id, i.id, p.id
FROM albums a, instruments i, people p
WHERE a.slug = 'back-in-black' and i.slug = 'backing-vocals' and p.slug = 'malcolm-young';

INSERT INTO album_musicians ( album_id, instrument_id, person_id)
SELECT a.id, i.id, p.id
FROM albums a, instruments i, people p
WHERE a.slug = 'black-ice' and i.slug = 'lead-vocals' and p.slug = 'brian-johnson';

INSERT INTO album_musicians ( album_id, instrument_id, person_id)
SELECT a.id, i.id, p.id
FROM albums a, instruments i, people p
WHERE a.slug = 'black-ice' and i.slug = 'drums' and p.slug = 'phil-rudd';

INSERT INTO album_musicians ( album_id, instrument_id, person_id)
SELECT a.id, i.id, p.id
FROM albums a, instruments i, people p
WHERE a.slug = 'black-ice' and i.slug = 'bass-guitar' and p.slug = 'cliff-williams';

INSERT INTO album_musicians ( album_id, instrument_id, person_id)
SELECT a.id, i.id, p.id
FROM albums a, instruments i, people p
WHERE a.slug = 'black-ice' and i.slug = 'backing-vocals' and p.slug = 'cliff-williams';

INSERT INTO album_musicians ( album_id, instrument_id, person_id)
SELECT a.id, i.id, p.id
FROM albums a, instruments i, people p
WHERE a.slug = 'black-ice' and i.slug = 'lead-guitar' and p.slug = 'angus-young';

INSERT INTO album_musicians ( album_id, instrument_id, person_id)
SELECT a.id, i.id, p.id
FROM albums a, instruments i, people p
WHERE a.slug = 'black-ice' and i.slug = 'rhythm-guitar' and p.slug = 'malcolm-young';

INSERT INTO album_musicians ( album_id, instrument_id, person_id)
SELECT a.id, i.id, p.id
FROM albums a, instruments i, people p
WHERE a.slug = 'black-ice' and i.slug = 'backing-vocals' and p.slug = 'malcolm-young';

INSERT INTO album_musicians ( album_id, instrument_id, person_id)
SELECT a.id, i.id, p.id
FROM albums a, instruments i, people p
WHERE a.slug = 'fly-on-the-wall' and i.slug = 'bass-guitar' and p.slug = 'cliff-williams';

INSERT INTO album_musicians ( album_id, instrument_id, person_id)
SELECT a.id, i.id, p.id
FROM albums a, instruments i, people p
WHERE a.slug = 'fly-on-the-wall' and i.slug = 'backing-vocals' and p.slug = 'cliff-williams';

INSERT INTO album_musicians ( album_id, instrument_id, person_id)
SELECT a.id, i.id, p.id
FROM albums a, instruments i, people p
WHERE a.slug = 'fly-on-the-wall' and i.slug = 'lead-guitar' and p.slug = 'angus-young';

INSERT INTO album_musicians ( album_id, instrument_id, person_id)
SELECT a.id, i.id, p.id
FROM albums a, instruments i, people p
WHERE a.slug = 'fly-on-the-wall' and i.slug = 'drums' and p.slug = 'simon-wright';

INSERT INTO album_musicians ( album_id, instrument_id, person_id)
SELECT a.id, i.id, p.id
FROM albums a, instruments i, people p
WHERE a.slug = 'fly-on-the-wall' and i.slug = 'rhythm-guitar' and p.slug = 'malcolm-young';

INSERT INTO album_musicians ( album_id, instrument_id, person_id)
SELECT a.id, i.id, p.id
FROM albums a, instruments i, people p
WHERE a.slug = 'fly-on-the-wall' and i.slug = 'backing-vocals' and p.slug = 'malcolm-young';

INSERT INTO album_musicians ( album_id, instrument_id, person_id)
SELECT a.id, i.id, p.id
FROM albums a, instruments i, people p
WHERE a.slug = 'fly-on-the-wall' and i.slug = 'lead-vocals' and p.slug = 'brian-johnson';

INSERT INTO album_musicians ( album_id, instrument_id, person_id)
SELECT a.id, i.id, p.id
FROM albums a, instruments i, people p
WHERE a.slug = 'stiff-upper-lip' and i.slug = 'drums' and p.slug = 'phil-rudd';

INSERT INTO album_musicians ( album_id, instrument_id, person_id)
SELECT a.id, i.id, p.id
FROM albums a, instruments i, people p
WHERE a.slug = 'stiff-upper-lip' and i.slug = 'bass-guitar' and p.slug = 'cliff-williams';

INSERT INTO album_musicians ( album_id, instrument_id, person_id)
SELECT a.id, i.id, p.id
FROM albums a, instruments i, people p
WHERE a.slug = 'stiff-upper-lip' and i.slug = 'backing-vocals' and p.slug = 'cliff-williams';

INSERT INTO album_musicians ( album_id, instrument_id, person_id)
SELECT a.id, i.id, p.id
FROM albums a, instruments i, people p
WHERE a.slug = 'stiff-upper-lip' and i.slug = 'lead-guitar' and p.slug = 'angus-young';

INSERT INTO album_musicians ( album_id, instrument_id, person_id)
SELECT a.id, i.id, p.id
FROM albums a, instruments i, people p
WHERE a.slug = 'stiff-upper-lip' and i.slug = 'rhythm-guitar' and p.slug = 'malcolm-young';

INSERT INTO album_musicians ( album_id, instrument_id, person_id)
SELECT a.id, i.id, p.id
FROM albums a, instruments i, people p
WHERE a.slug = 'stiff-upper-lip' and i.slug = 'backing-vocals' and p.slug = 'malcolm-young';

INSERT INTO album_musicians ( album_id, instrument_id, person_id)
SELECT a.id, i.id, p.id
FROM albums a, instruments i, people p
WHERE a.slug = 'stiff-upper-lip' and i.slug = 'lead-vocals' and p.slug = 'brian-johnson';

INSERT INTO album_musicians ( album_id, instrument_id, person_id)
SELECT a.id, i.id, p.id
FROM albums a, instruments i, people p
WHERE a.slug = 'powerage' and i.slug = 'bass-guitar' and p.slug = 'cliff-williams';

INSERT INTO album_musicians ( album_id, instrument_id, person_id)
SELECT a.id, i.id, p.id
FROM albums a, instruments i, people p
WHERE a.slug = 'powerage' and i.slug = 'backing-vocals' and p.slug = 'cliff-williams';

INSERT INTO album_musicians ( album_id, instrument_id, person_id)
SELECT a.id, i.id, p.id
FROM albums a, instruments i, people p
WHERE a.slug = 'powerage' and i.slug = 'drums' and p.slug = 'phil-rudd';

INSERT INTO album_musicians ( album_id, instrument_id, person_id)
SELECT a.id, i.id, p.id
FROM albums a, instruments i, people p
WHERE a.slug = 'powerage' and i.slug = 'lead-guitar' and p.slug = 'angus-young';

INSERT INTO album_musicians ( album_id, instrument_id, person_id)
SELECT a.id, i.id, p.id
FROM albums a, instruments i, people p
WHERE a.slug = 'powerage' and i.slug = 'rhythm-guitar' and p.slug = 'malcolm-young';

INSERT INTO album_musicians ( album_id, instrument_id, person_id)
SELECT a.id, i.id, p.id
FROM albums a, instruments i, people p
WHERE a.slug = 'powerage' and i.slug = 'backing-vocals' and p.slug = 'malcolm-young';

INSERT INTO album_musicians ( album_id, instrument_id, person_id)
SELECT a.id, i.id, p.id
FROM albums a, instruments i, people p
WHERE a.slug = 'powerage' and i.slug = 'lead-vocals' and p.slug = 'bon-scott';

INSERT INTO album_musicians ( album_id, instrument_id, person_id)
SELECT a.id, i.id, p.id
FROM albums a, instruments i, people p
WHERE a.slug = 'highway-to-hell' and i.slug = 'lead-vocals' and p.slug = 'bon-scott';

INSERT INTO album_musicians ( album_id, instrument_id, person_id)
SELECT a.id, i.id, p.id
FROM albums a, instruments i, people p
WHERE a.slug = 'highway-to-hell' and i.slug = 'lead-guitar' and p.slug = 'angus-young';

INSERT INTO album_musicians ( album_id, instrument_id, person_id)
SELECT a.id, i.id, p.id
FROM albums a, instruments i, people p
WHERE a.slug = 'highway-to-hell' and i.slug = 'drums' and p.slug = 'phil-rudd';

INSERT INTO album_musicians ( album_id, instrument_id, person_id)
SELECT a.id, i.id, p.id
FROM albums a, instruments i, people p
WHERE a.slug = 'highway-to-hell' and i.slug = 'bass-guitar' and p.slug = 'cliff-williams';

INSERT INTO album_musicians ( album_id, instrument_id, person_id)
SELECT a.id, i.id, p.id
FROM albums a, instruments i, people p
WHERE a.slug = 'highway-to-hell' and i.slug = 'backing-vocals' and p.slug = 'cliff-williams';

INSERT INTO album_musicians ( album_id, instrument_id, person_id)
SELECT a.id, i.id, p.id
FROM albums a, instruments i, people p
WHERE a.slug = 'highway-to-hell' and i.slug = 'rhythm-guitar' and p.slug = 'malcolm-young';

INSERT INTO album_musicians ( album_id, instrument_id, person_id)
SELECT a.id, i.id, p.id
FROM albums a, instruments i, people p
WHERE a.slug = 'highway-to-hell' and i.slug = 'backing-vocals' and p.slug = 'malcolm-young';

INSERT INTO album_musicians ( album_id, instrument_id, person_id)
SELECT a.id, i.id, p.id
FROM albums a, instruments i, people p
WHERE a.slug = 'blow-up-your-video' and i.slug = 'bass-guitar' and p.slug = 'cliff-williams';

INSERT INTO album_musicians ( album_id, instrument_id, person_id)
SELECT a.id, i.id, p.id
FROM albums a, instruments i, people p
WHERE a.slug = 'blow-up-your-video' and i.slug = 'backing-vocals' and p.slug = 'cliff-williams';

INSERT INTO album_musicians ( album_id, instrument_id, person_id)
SELECT a.id, i.id, p.id
FROM albums a, instruments i, people p
WHERE a.slug = 'blow-up-your-video' and i.slug = 'lead-guitar' and p.slug = 'angus-young';

INSERT INTO album_musicians ( album_id, instrument_id, person_id)
SELECT a.id, i.id, p.id
FROM albums a, instruments i, people p
WHERE a.slug = 'blow-up-your-video' and i.slug = 'rhythm-guitar' and p.slug = 'malcolm-young';

INSERT INTO album_musicians ( album_id, instrument_id, person_id)
SELECT a.id, i.id, p.id
FROM albums a, instruments i, people p
WHERE a.slug = 'blow-up-your-video' and i.slug = 'backing-vocals' and p.slug = 'malcolm-young';

INSERT INTO album_musicians ( album_id, instrument_id, person_id)
SELECT a.id, i.id, p.id
FROM albums a, instruments i, people p
WHERE a.slug = 'blow-up-your-video' and i.slug = 'drums' and p.slug = 'simon-wright';

INSERT INTO album_musicians ( album_id, instrument_id, person_id)
SELECT a.id, i.id, p.id
FROM albums a, instruments i, people p
WHERE a.slug = 'blow-up-your-video' and i.slug = 'lead-vocals' and p.slug = 'brian-johnson';

INSERT INTO album_musicians ( album_id, instrument_id, person_id)
SELECT a.id, i.id, p.id
FROM albums a, instruments i, people p
WHERE a.slug = 'let-there-be-rock' and i.slug = 'bass-guitar' and p.slug = 'mark-evans';

INSERT INTO album_musicians ( album_id, instrument_id, person_id)
SELECT a.id, i.id, p.id
FROM albums a, instruments i, people p
WHERE a.slug = 'let-there-be-rock' and i.slug = 'drums' and p.slug = 'phil-rudd';

INSERT INTO album_musicians ( album_id, instrument_id, person_id)
SELECT a.id, i.id, p.id
FROM albums a, instruments i, people p
WHERE a.slug = 'let-there-be-rock' and i.slug = 'lead-guitar' and p.slug = 'angus-young';

INSERT INTO album_musicians ( album_id, instrument_id, person_id)
SELECT a.id, i.id, p.id
FROM albums a, instruments i, people p
WHERE a.slug = 'let-there-be-rock' and i.slug = 'rhythm-guitar' and p.slug = 'malcolm-young';

INSERT INTO album_musicians ( album_id, instrument_id, person_id)
SELECT a.id, i.id, p.id
FROM albums a, instruments i, people p
WHERE a.slug = 'let-there-be-rock' and i.slug = 'backing-vocals' and p.slug = 'malcolm-young';

INSERT INTO album_musicians ( album_id, instrument_id, person_id)
SELECT a.id, i.id, p.id
FROM albums a, instruments i, people p
WHERE a.slug = 'let-there-be-rock' and i.slug = 'lead-vocals' and p.slug = 'bon-scott';

INSERT INTO album_musicians ( album_id, instrument_id, person_id)
SELECT a.id, i.id, p.id
FROM albums a, instruments i, people p
WHERE a.slug = 'dirty-deeds-done-dirt-cheap' and i.slug = 'rhythm-guitar' and p.slug = 'malcolm-young';

INSERT INTO album_musicians ( album_id, instrument_id, person_id)
SELECT a.id, i.id, p.id
FROM albums a, instruments i, people p
WHERE a.slug = 'dirty-deeds-done-dirt-cheap' and i.slug = 'backing-vocals' and p.slug = 'malcolm-young';

INSERT INTO album_musicians ( album_id, instrument_id, person_id)
SELECT a.id, i.id, p.id
FROM albums a, instruments i, people p
WHERE a.slug = 'dirty-deeds-done-dirt-cheap' and i.slug = 'drums' and p.slug = 'phil-rudd';

INSERT INTO album_musicians ( album_id, instrument_id, person_id)
SELECT a.id, i.id, p.id
FROM albums a, instruments i, people p
WHERE a.slug = 'dirty-deeds-done-dirt-cheap' and i.slug = 'lead-guitar' and p.slug = 'angus-young';

INSERT INTO album_musicians ( album_id, instrument_id, person_id)
SELECT a.id, i.id, p.id
FROM albums a, instruments i, people p
WHERE a.slug = 'dirty-deeds-done-dirt-cheap' and i.slug = 'bass-guitar' and p.slug = 'mark-evans';

INSERT INTO album_musicians ( album_id, instrument_id, person_id)
SELECT a.id, i.id, p.id
FROM albums a, instruments i, people p
WHERE a.slug = 'dirty-deeds-done-dirt-cheap' and i.slug = 'lead-vocals' and p.slug = 'bon-scott';

INSERT INTO album_musicians ( album_id, instrument_id, person_id)
SELECT a.id, i.id, p.id
FROM albums a, instruments i, people p
WHERE a.slug = 'the-razors-edge' and i.slug = 'bass-guitar' and p.slug = 'cliff-williams';

INSERT INTO album_musicians ( album_id, instrument_id, person_id)
SELECT a.id, i.id, p.id
FROM albums a, instruments i, people p
WHERE a.slug = 'the-razors-edge' and i.slug = 'backing-vocals' and p.slug = 'cliff-williams';

INSERT INTO album_musicians ( album_id, instrument_id, person_id)
SELECT a.id, i.id, p.id
FROM albums a, instruments i, people p
WHERE a.slug = 'the-razors-edge' and i.slug = 'lead-guitar' and p.slug = 'angus-young';

INSERT INTO album_musicians ( album_id, instrument_id, person_id)
SELECT a.id, i.id, p.id
FROM albums a, instruments i, people p
WHERE a.slug = 'the-razors-edge' and i.slug = 'rhythm-guitar' and p.slug = 'malcolm-young';

INSERT INTO album_musicians ( album_id, instrument_id, person_id)
SELECT a.id, i.id, p.id
FROM albums a, instruments i, people p
WHERE a.slug = 'the-razors-edge' and i.slug = 'backing-vocals' and p.slug = 'malcolm-young';

INSERT INTO album_musicians ( album_id, instrument_id, person_id)
SELECT a.id, i.id, p.id
FROM albums a, instruments i, people p
WHERE a.slug = 'the-razors-edge' and i.slug = 'drums' and p.slug = 'chris-slade';

INSERT INTO album_musicians ( album_id, instrument_id, person_id)
SELECT a.id, i.id, p.id
FROM albums a, instruments i, people p
WHERE a.slug = 'the-razors-edge' and i.slug = 'lead-vocals' and p.slug = 'brian-johnson';

INSERT INTO album_musicians ( album_id, instrument_id, person_id)
SELECT a.id, i.id, p.id
FROM albums a, instruments i, people p
WHERE a.slug = 'rock-or-bust' and i.slug = 'bass-guitar' and p.slug = 'cliff-williams';

INSERT INTO album_musicians ( album_id, instrument_id, person_id)
SELECT a.id, i.id, p.id
FROM albums a, instruments i, people p
WHERE a.slug = 'rock-or-bust' and i.slug = 'backing-vocals' and p.slug = 'cliff-williams';

INSERT INTO album_musicians ( album_id, instrument_id, person_id)
SELECT a.id, i.id, p.id
FROM albums a, instruments i, people p
WHERE a.slug = 'rock-or-bust' and i.slug = 'drums' and p.slug = 'phil-rudd';

INSERT INTO album_musicians ( album_id, instrument_id, person_id)
SELECT a.id, i.id, p.id
FROM albums a, instruments i, people p
WHERE a.slug = 'rock-or-bust' and i.slug = 'rhythm-guitar' and p.slug = 'stevie-young';

INSERT INTO album_musicians ( album_id, instrument_id, person_id)
SELECT a.id, i.id, p.id
FROM albums a, instruments i, people p
WHERE a.slug = 'rock-or-bust' and i.slug = 'lead-guitar' and p.slug = 'angus-young';

INSERT INTO album_musicians ( album_id, instrument_id, person_id)
SELECT a.id, i.id, p.id
FROM albums a, instruments i, people p
WHERE a.slug = 'rock-or-bust' and i.slug = 'lead-vocals' and p.slug = 'brian-johnson';

INSERT INTO album_musicians ( album_id, instrument_id, person_id)
SELECT a.id, i.id, p.id
FROM albums a, instruments i, people p
WHERE a.slug = 'for-those-about-to-rock-we-salute-you' and i.slug = 'rhythm-guitar' and p.slug = 'malcolm-young';

INSERT INTO album_musicians ( album_id, instrument_id, person_id)
SELECT a.id, i.id, p.id
FROM albums a, instruments i, people p
WHERE a.slug = 'for-those-about-to-rock-we-salute-you' and i.slug = 'backing-vocals' and p.slug = 'malcolm-young';

INSERT INTO album_musicians ( album_id, instrument_id, person_id)
SELECT a.id, i.id, p.id
FROM albums a, instruments i, people p
WHERE a.slug = 'for-those-about-to-rock-we-salute-you' and i.slug = 'bass-guitar' and p.slug = 'cliff-williams';

INSERT INTO album_musicians ( album_id, instrument_id, person_id)
SELECT a.id, i.id, p.id
FROM albums a, instruments i, people p
WHERE a.slug = 'for-those-about-to-rock-we-salute-you' and i.slug = 'backing-vocals' and p.slug = 'cliff-williams';

INSERT INTO album_musicians ( album_id, instrument_id, person_id)
SELECT a.id, i.id, p.id
FROM albums a, instruments i, people p
WHERE a.slug = 'for-those-about-to-rock-we-salute-you' and i.slug = 'drums' and p.slug = 'phil-rudd';

INSERT INTO album_musicians ( album_id, instrument_id, person_id)
SELECT a.id, i.id, p.id
FROM albums a, instruments i, people p
WHERE a.slug = 'for-those-about-to-rock-we-salute-you' and i.slug = 'lead-guitar' and p.slug = 'angus-young';

INSERT INTO album_musicians ( album_id, instrument_id, person_id)
SELECT a.id, i.id, p.id
FROM albums a, instruments i, people p
WHERE a.slug = 'for-those-about-to-rock-we-salute-you' and i.slug = 'lead-vocals' and p.slug = 'brian-johnson';

INSERT INTO album_musicians ( album_id, instrument_id, person_id)
SELECT a.id, i.id, p.id
FROM albums a, instruments i, people p
WHERE a.slug = 'flick-of-the-switch' and i.slug = 'lead-vocals' and p.slug = 'brian-johnson';

INSERT INTO album_musicians ( album_id, instrument_id, person_id)
SELECT a.id, i.id, p.id
FROM albums a, instruments i, people p
WHERE a.slug = 'flick-of-the-switch' and i.slug = 'drums' and p.slug = 'phil-rudd';

INSERT INTO album_musicians ( album_id, instrument_id, person_id)
SELECT a.id, i.id, p.id
FROM albums a, instruments i, people p
WHERE a.slug = 'flick-of-the-switch' and i.slug = 'bass-guitar' and p.slug = 'cliff-williams';

INSERT INTO album_musicians ( album_id, instrument_id, person_id)
SELECT a.id, i.id, p.id
FROM albums a, instruments i, people p
WHERE a.slug = 'flick-of-the-switch' and i.slug = 'backing-vocals' and p.slug = 'cliff-williams';

INSERT INTO album_musicians ( album_id, instrument_id, person_id)
SELECT a.id, i.id, p.id
FROM albums a, instruments i, people p
WHERE a.slug = 'flick-of-the-switch' and i.slug = 'lead-guitar' and p.slug = 'angus-young';

INSERT INTO album_musicians ( album_id, instrument_id, person_id)
SELECT a.id, i.id, p.id
FROM albums a, instruments i, people p
WHERE a.slug = 'flick-of-the-switch' and i.slug = 'rhythm-guitar' and p.slug = 'malcolm-young';

INSERT INTO album_musicians ( album_id, instrument_id, person_id)
SELECT a.id, i.id, p.id
FROM albums a, instruments i, people p
WHERE a.slug = 'flick-of-the-switch' and i.slug = 'backing-vocals' and p.slug = 'malcolm-young';

INSERT INTO band_members ( band_id, person_id, joined_date)
SELECT b.id, p.id, '1973-01-01'
FROM bands b, people p
WHERE b.slug = 'ac-dc' and p.slug = 'angus-young';

INSERT INTO band_members ( band_id, person_id, joined_date, left_date)
SELECT b.id, p.id, '1973-01-01', '2014-09-24'
FROM bands b, people p
WHERE b.slug = 'ac-dc' and p.slug = 'malcolm-young';

INSERT INTO band_members ( band_id, person_id, joined_date)
SELECT b.id, p.id, '2014-09-25'
FROM bands b, people p
WHERE b.slug = 'ac-dc' and p.slug = 'stevie-young';

INSERT INTO band_members ( band_id, person_id, joined_date, left_date)
SELECT b.id, p.id, '1974-01-01', '1980-02-19'
FROM bands b, people p
WHERE b.slug = 'ac-dc' and p.slug = 'bon-scott';

INSERT INTO band_members ( band_id, person_id, joined_date, left_date)
SELECT b.id, p.id, '1973-03-01', '1977-11-30'
FROM bands b, people p
WHERE b.slug = 'ac-dc' and p.slug = 'mark-evans';

INSERT INTO band_members ( band_id, person_id, joined_date)
SELECT b.id, p.id, '1977-12-01'
FROM bands b, people p
WHERE b.slug = 'ac-dc' and p.slug = 'cliff-williams';

INSERT INTO band_members ( band_id, person_id, joined_date, left_date)
SELECT b.id, p.id, '1975-01-01', '1983-04-15'
FROM bands b, people p
WHERE b.slug = 'ac-dc' and p.slug = 'phil-rudd';

INSERT INTO band_members ( band_id, person_id, joined_date, left_date)
SELECT b.id, p.id, '1993-10-01', '2015-04-03'
FROM bands b, people p
WHERE b.slug = 'ac-dc' and p.slug = 'phil-rudd';

INSERT INTO band_members ( band_id, person_id, joined_date, left_date)
SELECT b.id, p.id, '1983-07-01', '1989-10-30'
FROM bands b, people p
WHERE b.slug = 'ac-dc' and p.slug = 'simon-wright';

INSERT INTO band_members ( band_id, person_id, joined_date, left_date)
SELECT b.id, p.id, '1989-11-01', '1993-09-30'
FROM bands b, people p
WHERE b.slug = 'ac-dc' and p.slug = 'chris-slade';

INSERT INTO band_members ( band_id, person_id, joined_date)
SELECT b.id, p.id, '2015-04-04'
FROM bands b, people p
WHERE b.slug = 'ac-dc' and p.slug = 'chris-slade';

