-- OPPGAVE 1
SELECT (p.firstname, p.lastname) AS navn, fc.filmcharacter FROM filmparticipation as fp

INNER JOIN film AS f
ON (f.title = 'Star Wars' AND f.filmid = fp.filmid)

INNER JOIN person AS p
ON (p.personid = fp.personid)

INNER JOIN filmcharacter AS fc
ON (fp.partid = fc.partid);

-- OPPGAVE 2
SELECT country, count(*) AS fpc
FROM filmcountry
GROUP BY country
ORDER BY fpc DESC;

-- OPPGAVE 3
SELECT country, avg(cast(time AS int)) AS r
FROM runningtime
WHERE time ~ '^\d+$' 
GROUP BY country
HAVING count(*) >= 200 AND 
NOT country IS NULL;

-- OPPGAVE 4
SELECT title, fg.filmid, count(*) AS kf
FROM filmgenre AS fg

JOIN film AS f USING (filmid)
JOIN filmitem AS fi USING (filmid)

WHERE filmtype = 'C'
GROUP BY fg.filmid, title
ORDER BY kf DESC, f.title
LIMIT 10;

-- OPPGAVE 5

SELECT fc.country, count(f.filmid) AS antallfilmer, avg(rank), jegerbest.genre 
FROM filmcountry AS fc

LEFT JOIN film AS f
ON (fc.filmid = f.filmid)
LEFT JOIN filmrating AS fr
ON (f.filmid = fr.filmid)

NATURAL JOIN (
    SELECT DISTINCT ON (country) country, genre, count(*) AS flest
    FROM filmcountry AS fc2

    LEFT JOIN filmgenre AS fg
    ON(fc2.filmid = fg.filmid)

    GROUP BY country, genre
    ORDER BY country, count(genre) DESC, genre
) AS jegerbest

GROUP BY fc.country, jegerbest.genre
ORDER BY antallfilmer DESC;


-- OPPGAVE 6

SELECT (p1.firstname, p1.lastname) AS navn1, (p2.firstname, p2.lastname) AS navn2
FROM filmitem AS fi

INNER JOIN filmparticipation AS fp1 USING (filmid)
INNER JOIN person AS p1
ON (fp1.personid = p1.personid)

INNER JOIN filmparticipation AS fp2 USING (filmid)
INNER JOIN person AS p2
ON (fp2.personid = p2.personid)

INNER JOIN filmcountry AS fc USING (filmid)

WHERE fi.filmtype = 'C' AND fc.country = 'Norway' AND
p1.personid < p2.personid AND fp1.filmid = fp2.filmid

GROUP BY navn1, navn2
HAVING count(*) > 40;

-- OPPGAVE 7

SELECT DISTINCT f.title, f.prodyear FROM film AS f 

LEFT JOIN filmgenre AS fg 
ON (f.filmid = fg.filmid)

LEFT JOIN filmcountry AS fc
ON (f.filmid = fc.filmid)

WHERE (f.title LIKE '%Dark%' OR f.title LIKE '%Night%') AND (fg.genre = 'Horror' OR fc.country LIKE 'Romania');

-- OPPGAVE 8
SELECT title, count(filmparticipation.personid) FROM film

LEFT JOIN filmparticipation
ON (film.filmid = filmparticipation.filmid)

WHERE prodyear >= 2010
GROUP BY title
HAVING count(filmparticipation.personid) <= 2;

-- OPPGAVE 9

SELECT count(f.filmid) FROM film AS f

WHERE f.filmid NOT IN(
    SELECT f2.filmid FROM film AS f2
    
    INNER JOIN filmgenre AS fg
    ON(f2.filmid = fg.filmid)

    WHERE fg.genre LIKE 'Horror' OR fg.genre LIKE 'Sci-Fi');


-- OPPGAVE 10 
/* 
Får 169 linjer nå
*/
(SELECT f.title, fr.rank, fr.votes, count(fl.language) AS spraak FROM film AS f

INNER JOIN filmitem AS fi USING (filmid)
LEFT JOIN filmlanguage AS fl USING (filmid)
INNER JOIN filmrating AS fr USING (filmid)

WHERE fr.rank >= 8.0 AND fr.votes > 1000 AND
fi.filmtype = 'C'

GROUP BY f.title, fr.rank, fr.votes
ORDER BY fr.rank DESC, fr.votes DESC
LIMIT 10)

UNION
(SELECT DISTINCT f.title, fr.rank, fr.votes, count(fl.language) AS spraak FROM film AS f

INNER JOIN filmitem AS fi USING (filmid)
INNER JOIN filmparticipation AS fp USING (filmid)
LEFT JOIN filmlanguage AS fl USING (filmid)

INNER JOIN person AS p
ON (fp.personid = p.personid)
INNER JOIN filmrating AS fr USING (filmid)

WHERE fr.rank >= 8.0 AND fr.votes > 1000 AND
p.firstname LIKE 'Harrison' AND p.lastname LIKE 'Ford' AND
fi.filmtype = 'C'
GROUP BY f.title, fr.rank, fr.votes)

UNION
(SELECT f.title, fr.rank, fr.votes, count(fl.language) AS spraak FROM film AS f

INNER JOIN filmitem AS fi USING (filmid)
INNER JOIN filmgenre AS fg USING (filmid)
LEFT JOIN filmlanguage AS fl USING (filmid)
INNER JOIN filmrating AS fr USING (filmid)

WHERE fr.rank >= 8.0 AND fr.votes > 1000 AND
(fg.genre LIKE 'Comedy' OR fg.genre LIKE 'Romance') AND
fi.filmtype = 'C'

GROUP BY f.title, fr.rank, fr.votes

ORDER BY title);