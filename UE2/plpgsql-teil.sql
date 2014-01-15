create or replace function check_Austauschprogramm_Praktikum() returns trigger as $$

declare
	year_from INTEGER;
	year_to INTEGER;

begin

	SELECT extract(year from von), extract(year from bis) into year_from, year_to from Praktikum where PrNr = new.PrNr and Abteilung = new.Abteilung and Firma = new.Firma;

	if year_from < new.Jahr then
	
		raise exception 'Praktikumsbeginn darf nicht vor Austauschprogramm Jahr liegen!';	
	
	end if;

	/* Eigentlich unnötig, denn Praktikum.bis muss laut Constaint sowieso vor Praktikum.von liegen */
	if year_to < new.Jahr then

		raise exception 'Praktikumsende darf nicht vor Austauschprogramm Jahr liegen!';

	end if;

	return new;

end;

$$ LANGUAGE plpgsql;

create trigger t_before_Austauschprogramm_Praktikum before insert on Austauschprogramm_Praktikum for each row
execute procedure check_Austauschprogramm_Praktikum();

create or replace function check_Firma_Betreuer() returns trigger as $$
	
begin

	if EXISTS(SELECT id FROM Kommission where Koordinator = new.betreuer) then
		raise exception 'Kommissionskoordinatoren können keine Praktikumsbetreuer sein!';
	end if;

	if NOT EXISTS (SELECT 1 from Mitarbeiter inner join Kommission 	on Kommission.Id = Mitarbeiter.Kommission 
			inner join Austauschprogramm on Austauschprogramm.Kommission = Kommission.Id 
			inner join Austauschprogramm_Praktikum on Austauschprogramm_Praktikum.Jahr = Austauschprogramm.Jahr 
							and Austauschprogramm_Praktikum.Name = Austauschprogramm.Name 
							and Austauschprogramm_Praktikum.Land = Austauschprogramm.Land 
			where Mitarbeiter.SVNR = new.Betreuer and Austauschprogramm_Praktikum.Firma = new.Firma) then
		raise exception 'Praktikumsbetreuer muss in einer Kommission arbeiten, welche für die Verwaltung eines Austauschprogramms zuständig ist, für das der Praktikumsgeber wenigstens ein Praktikum ausgeschrieben hat.' ;
	end if;

	return new;

end;

$$ LANGUAGE plpgsql;
create trigger t_before_Firma_Betreuer before insert on Firma_Betreuer for each row
execute procedure check_Firma_Betreuer();


create or replace function f_calc_salary(__SVNR BIGINT, check_date DATE) returns NUMERIC(7, 2) as $$

declare 
	__Gehaltsklasse varchar(3);
	gehalt NUMERIC(7, 2);
	__bonus NUMERIC(7, 2);

begin

	if NOT EXISTS (SELECT 1 FROM MITARBEITER where SVNR = __SVNR) then
		raise exception 'Mitarbeiter mit svnr % nicht gefunden', __SVNR;
	end if;

	if NOT EXISTS (SELECT 1 FROM MITARBEITER where SVNR = __SVNR AND beschaeftigt_seit <= check_date) then
		raise exception 'Mitarbeiter mit svnr % war am % noch nicht angestellt', __SVNR, check_date;
	end if;


	SELECT Gehaltsklasse INTO __Gehaltsklasse from MITARBEITER where SVNR = __SVNR;
	
	gehalt := CASE __Gehaltsklasse	

		WHEN 'M1' then
			2000
		WHEN 'M2' then
			1500		
		WHEN 'M3' then
			1000
		WHEN 'C1' then
			3000
		ELSE
			2500
	END;

	if NOT EXISTS (SELECT 1 FROM Betreuer where SVNR = __SVNR) then
		return gehalt;
	end if;

	SELECT bonus into __bonus from Betreuer where SVNR = __SVNR;

	/* Wieviele Studenten hat der Betreuer zum angegeben Zeitpunkt betreut? (Angabe sagt pro Student, nicht pro Student pro Praktikum */
	gehalt := gehalt + __bonus * (
			select count(*) from (
				select DISTINCT student from praktikum_betreuer_matched inner join praktikum on praktikum_betreuer_matched.prnr = praktikum.prnr 
							and praktikum_betreuer_matched.abteilung = praktikum.abteilung 
							and praktikum_betreuer_matched.firma = praktikum.firma 
				where (betreuer = __SVNR 
					and Praktikum.von <= check_date 
					and Praktikum.bis >= check_date)
				) students
			);

	return gehalt;
end;

$$ LANGUAGE plpgsql;



create or replace function p_update_students() returns VOID as $$

declare 
	rowvar1 RECORD;
	cursor1 REFCURSOR;

begin

	/* ausgabe Studenten in Student_matched die gleich bleiben */
	OPEN cursor1 for SELECT * FROM Student_matched;

	FETCH cursor1 into rowvar1;

	WHILE found LOOP
		raise notice '% bleibt im status "matched"', rowvar1.SVNR;
		FETCH cursor1 into rowvar1;

	END LOOP;

	CLOSE cursor1;

	/* ausgabe (und aufstufung) Studenten in Student_shortlisted die auf matched aufgestuft werden */
	OPEN cursor1 for SELECT * FROM Student_shortlisted where NOT EXISTS (SELECT 1 FROM Student_matched where Student_matched.SVNR = Student_shortlisted.SVNR);

	FETCH cursor1 into rowvar1;

	WHILE found LOOP
		INSERT INTO Student_matched values(rowvar1.SVNR);
		raise notice '% von status "shortlisted" nach status "matched"', rowvar1.SVNR;
		FETCH cursor1 into rowvar1;

	END LOOP;

	CLOSE cursor1;

	/* ausgabe (und aufstufung) Studenten die auf shortlisted aufgestuft werden */
	OPEN cursor1 for SELECT * FROM Student where NOT EXISTS (SELECT 1 FROM Student_shortlisted where Student_shortlisted.SVNR = Student.SVNR);

	FETCH cursor1 into rowvar1;

	WHILE found LOOP
		INSERT INTO student_shortlisted values(rowvar1.SVNR);
		raise notice '% in den status "shortlisted" erhoben', rowvar1.SVNR;
		FETCH cursor1 into rowvar1;

	END LOOP;

	CLOSE cursor1;

end;
$$ LANGUAGE plpgsql;
