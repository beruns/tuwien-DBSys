/* Query 1 */
# TODO Write Query 1 here

SELECT 	s.svnr,
	s.name,
	s.matrnr 

FROM student s 

inner join bewirbt_ap a 
ON s.svnr = a.svnr 

GROUP BY s.svnr,
	 s.name, 
 	s.matrnr 

HAVING count(*) = (SELECT count(*) FROM austauschprogramm);

/* Query 2 */
# TODO Write Query 2 here

WITH RECURSIVE t(id, name, standort, uebergeordnet, stufe) AS 
  (
        SELECT	id,
		name, 
		standort, 
		uebergeordnet,
		0

        FROM kommission 

	      WHERE id = 4

     UNION ALL

	SELECT 	k.id, 
		k.name,
		k.standort,
		k.uebergeordnet,
		stufe+1

	FROM kommission k inner join t ON k.id = t.uebergeordnet
        
)
SELECT * FROM t;

/* Query 3 */
# TODO Write Query 3 here

SELECT	p.prnr,
	p.abtnr,
	p.fanr,
	p.aufgbereich,
	p.von,
	p.bis

FROM praktikum p inner join
  (SELECT prnr, abtnr, fanr

  FROM ausgeschrieben
  WHERE prnr in (

    SELECT prnr 

    FROM bewirbt_pa 
    GROUP BY prnr 
    HAVING count(*) = 

      (SELECT max(c) FROM 

	(SELECT prnr, count(*) as c FROM bewirbt_pa GROUP BY prnr ) sub1

      )

  )

  GROUP BY prnr, abtnr, fanr

  HAVING count(*) = 

    (SELECT min(c) FROM

      (SELECT prnr, count(*) as c FROM ausgeschrieben GROUP BY prnr) sub2

    )

) sub ON 

p.prnr = sub.prnr 
AND p.abtnr = sub.abtnr 
AND p.fanr = sub.fanr

ORDER BY p.von DESC, p.bis DESC, p.aufgbereich asc;
