WITH
    p1 AS (
        SELECT p.firstname, p.lastname, fp.filmid FROM person AS p

        NATURAL JOIN filmparticipation AS fp
        INNER JOIN filmcountry AS fc
        ON (fc.filmid = fp.filmid AND fc.country = 'Norway')
        INNER JOIN filmitem AS fi
        ON (fi.filmid = fp.filmid AND fi.filmtype = 'C')
   
    )
SELECT p1.firstname, p1.lastname, 
p2.firstname, p2.lastname FROM p1, ( 
    
    SELECT DISTINCT p.firstname, p.lastname, fp.filmid FROM person AS p

    INNER JOIN filmparticipation AS fp
    ON (p.personid = fp.personid)
    INNER JOIN filmcountry AS fc
    ON (fp.filmid = fc.filmid AND fc.country = 'Norway')
    INNER JOIN filmitem AS fi
    ON (fi.filmid = fc.filmid AND fi.filmtype = 'C')

    GROUP BY p.firstname, p.lastname
    HAVING count(*) > 40

) AS p2

WHERE p1.personid != p2.personid AND
p1.filmid = p2.filmid;