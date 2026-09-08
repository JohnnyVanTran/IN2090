--OPPGAVE 2
--a)
SELECT navn
FROM planet
WHERE planet.stjerne = 'Proxima Centauri';

--b)
SELECT DISTINCT oppdaget FROM planet
WHERE planet.stjerne = 'TRAPPIST-1' OR
      planet.stjerne = 'Kepler-154';

--c) 
SELECT count(*) FROM planet
WHERE masse IS NULL;

--d)
SELECT navn, masse FROM Planet,
    (SELECT avg(masse) AS avg FROM Planet) AS snitt
WHERE Planet.masse > snitt AND
    Planet.oppdaget = 2020;

--e)
SELECT (max(Planet.oppdaget) - min(Planet.oppdaget)) AS diff 
FROM Planet;

--OPPGAVE 3
--a)
SELECT Planet.navn FROM Planet, Materie
WHERE Materie.planet = Planet.navn AND
    Materie.molekyl = 'H2O' AND
    Planet.masse <= 10 AND
    Planet.masse >= 3;

--b)
SELECT Planet.navn FROM Planet, Stjerne, Materie
WHERE Materie.molekyl LIKE '%H%' AND
    Materie.planet = Planet.navn AND
    Planet.stjerne = Stjerne.navn AND
    Stjerne.masse * 12 > Stjerne.avstand;

--c)
--Tror ikke denne er like effektiv
SELECT p.navn FROM
planet AS p
INNER JOIN stjerne AS s
ON (p.stjerne = s.navn)
INNER JOIN planet AS p2
ON p.stjerne = p2.stjerne
WHERE p.navn != p2.navn AND 
    p.masse > 10 AND p2.masse > 10 AND
    s.avstand < 50;
    
--Som denne
SELECT p1.navn FROM Planet AS p1, Stjerne,
    (SELECT Planet.navn, Planet.stjerne, Planet.masse FROM Planet) AS p2
WHERE p1.stjerne = p2.stjerne AND
    p1.masse > 10 AND
    p2.masse > 10 AND
    p1.navn != p2.navn AND
    p1.stjerne = Stjerne.navn AND
    Stjerne.avstand < 50;

--OPPGAVE 4
--Nils sin SQL-spørring funker ikke siden han kjører «NATURAL JOIN» mellom planet og stjerne.
--«NATURAL JOIN» vil slå sammen kolonnene som har likt navn i planet og stjerne. Under
--sammenslåingen vil bare verdiene som er like mellom kolonnene bli lagt til i den sammenslåtte 
--kolonnen og ettersom planet og stjerne deler samme kolonnenavn vil den ikke legge til noe.
--Navn til stjerne forteller navnet til stjernen og navn til planet forteller navnet til planeten.
--Masse til stjerne forteller massen til stjernen og massen til planet forteller massen til
--planeten.

--OPPGAVE 5
--a)
johnnyvt => INSERT INTO stjerne
VALUES ('Sola', 0, 1);

--b)
johnnyvt => INSERT INTO planet
VALUES ('Jorda', 0,003146, NULL, 'Sola');

--OPPGAVE 6
CREATE TABLE observasjon(
    observasjons_id int UNIQUE NOT NULL,
    timestamp date,
    planet text NOT NULL,
    kommentar text
);
