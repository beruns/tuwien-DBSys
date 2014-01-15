/** Test Trigger 1 (und Praktikum Constaint) */

/* Fehler, bis Datum liegt vor von Datum */
insert into Praktikum (prnr, abteilung, firma, beschr, aufgbereich, von, bis) values
	(3,  1,  10, 'Praktikum3',  'Kaffeeholen',  '2009-01-01', '2008-12-31');
/* Korrekt */
insert into Praktikum (prnr, abteilung, firma, beschr, aufgbereich, von, bis) values
	(3,  1,  10, 'Praktikum3',  'Kaffeeholen',  '2009-01-01', '2009-06-05');

/* Fehler: Austauchprogrammjahr 2014, vor/bis Datum 2009 */
insert into Austauschprogramm_Praktikum values('AUT',  2014, 'Programm AUT', 3, 1, 10);

/* Korrekt */
insert into Austauschprogramm_Praktikum values('LUX', 2009, 'Programm LUX', 3, 1, 10);

/** Test Trigger 2 */

/* Fehler: Betreuer ist Kommissionskoordinator */
insert into Firma_Betreuer values (10, 1280081081);

/* Fehler: Kommission des Betreuers verwaltet kein Programm in dem die Firma ein Praktikum ausschreibt */
insert into Firma_Betreuer values (10, 1280081082);

/* Korrekt */
insert into Firma_Betreuer values (30, 1280081082);

/** Test Function */

/* Keine gültige SVNR */
select f_calc_salary(1234567890, '2007-10-10');

/* Mitarbeiter war zum Zeitpunkt noch nicht angestellt */
select f_calc_salary(1280081081, '2007-10-10');

/* Mitarbeiter mit Bonus */
select f_calc_salary(1280081081, '2011-10-10');

/* mitarbeiter ihne Bonus */
select f_calc_salary(1280081081, '2012-10-10');

/** Test Prozedur Hochstufung Studenten */

/* Erwarted: 
3 bleiben matched
3 von shortlisted nach matched
4 nach shortlisted
*/
select p_update_students();

/* Erwarted: 
6 bleiben matched
4 von shortlisted nach matched
*/
select p_update_students();

/* Erwarted: 
10 bleiben matched
*/
select p_update_students();

