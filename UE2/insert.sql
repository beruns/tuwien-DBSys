begin;

delete from Austauschprogramm_Praktikum;
delete from Praktikum_Betreuer_matched;
delete from Praktikum_shortlisted;
delete from Praktikum;
delete from Abteilung;
delete from Firma_Betreuer;
delete from Firma;
delete from Bewerbungsunterlagen;
delete from Student_Austauschprogramm;
delete from Student_matched;
delete from Student_shortlisted;
delete from Student;
delete from Austauschprogramm;
delete from Betreuer;
delete from Mitarbeiter;
delete from Kommission;

commit;

ALTER SEQUENCE seq_kommission RESTART WITH 1;
ALTER SEQUENCE seq_abteilung RESTART WITH 1;
ALTER SEQUENCE seq_praktikum RESTART WITH 1;
ALTER SEQUENCE seq_firma RESTART WITH 10;

begin;

insert into Kommission (Standort, Name, Koordinator, uebergeordnet) values 
	('Standort1', 'Kommission1', 1280081081, NULL),
	('Standort1', 'Kommission2', 2320080180, NULL),
	('Standort2', 'Kommission3', 4010020179, NULL),
	('Standort2', 'Kommission1.1', 3237300568, 1),
	('Standort3', 'Kommission2.1', 2827080783, 2);


insert into Mitarbeiter (SVNR, Name, Anschrift, Gehaltsklasse, beschaeftigt_seit, Kommission) values
	(1280081081, 'Mitarbeiter1', 'Anschrift1', 'M1', '2009-09-01', 5),
	(2320080180, 'Mitarbeiter2', 'Anschrift2', 'M2', '2012-08-02', 4),
	(4010020179, 'Mitarbeiter3', 'Anschrift3', 'M3', '2011-07-03', 3),
	(3237300568, 'Mitarbeiter4', 'Anschrift4', 'C1', '2010-06-04', 2),
	(2827080783, 'Mitarbeiter5', 'Anschrift5', 'C2', '2009-05-05', 1),
	(1280081082, 'Mitarbeiter6', 'Anschrift1', 'M1', '2013-09-01', 1),
	(2327080180, 'Mitarbeiter7', 'Anschrift2', 'M2', '2012-08-02', 2),
	(4015023179, 'Mitarbeiter8', 'Anschrift3', 'M3', '2011-07-03', 3),
	(3207301568, 'Mitarbeiter9', 'Anschrift4', 'C1', '2010-06-04', 4),
	(2027081283, 'Mitarbeiter10', 'Anschrift5', 'C2', '2009-05-05', 5);

commit;

insert into Betreuer (SVNR, Bonus) values
	(1280081081, 120.55),
	(3237300568, 201.25),
	(1280081082, 85.75),
	(4015023179, 76.23),
	(2027081283, 99.89);

insert into Austauschprogramm (Land, Jahr, Name, Bewerbungsfrist, Kommission) values
	('AUT', 2013, 'Programm AUT', '2013-10-10', 1),
	('FIN', 2012, 'Programm FIN', '2012-08-10', 2),
	('GRC', 2011, 'Programm GRC', '2011-07-07', 3),
	('HRV', 2010, 'Programm HRV', '2010-02-04', 4),
	('LUX', 2009, 'Programm LUX', '2009-06-05', 5),
	('AUT', 2014, 'Programm AUT', '2014-10-10', 1),
	('FIN', 2013, 'Programm FIN', '2013-08-10', 1),
	('GRC', 2012, 'Programm GRC', '2012-07-07', 2),
	('HRV', 2011, 'Programm HRV', '2011-02-04', 2),
	('LUX', 2010, 'Programm LUX', '2010-06-05', 2);

insert into Student (SVNR, Anschrift, Name, Studienkennzahl, MatrNr) values 
	(121201011986, 'Anschrift 1', 'Student 1', 'E308', '0487765'),
	(121201011991, 'Anschrift 2', 'Student 2', 'E128', '1076563'),
	(121201011992, 'Anschrift 3', 'Student 3', 'E100', '1167879'),
	(121201011993, 'Anschrift 4', 'Student 4', 'E234', '1209887'),
	(121201011994, 'Anschrift 5', 'Student 5', 'E736', '1308777'),
	(121301011986, 'Anschrift 6', 'Student 6', 'E308', '0487865'),
	(121301011991, 'Anschrift 7', 'Student 7', 'E128', '1076463'),
	(121301011992, 'Anschrift 8', 'Student 8', 'E100', '1167379'),
	(121301011993, 'Anschrift 9', 'Student 9', 'E234', '1209187'),
	(121301011994, 'Anschrift 10', 'Student 10', 'E736', '1300877');

insert into Student_shortlisted (SVNR) values
	(121201011986),
	(121201011992),
	(121301011986),
	(121301011991),
	(121301011993),
	(121301011994);

insert into Student_matched (SVNR) values
	(121301011991),
	(121301011993),
	(121301011994); 

insert into Student_Austauschprogramm (Student, Land, Jahr, Name) values
	(121201011986, 'AUT', 2013, 'Programm AUT'),
	(121201011986, 'AUT', 2014, 'Programm AUT'),
	(121201011991, 'FIN', 2012, 'Programm FIN'),
	(121201011991, 'FIN', 2013, 'Programm FIN'),
	(121201011992, 'GRC', 2011, 'Programm GRC'),
	(121201011992, 'GRC', 2012, 'Programm GRC'),
	(121201011993, 'HRV', 2010, 'Programm HRV'),
	(121201011993, 'HRV', 2011, 'Programm HRV'),
	(121201011994, 'LUX', 2009, 'Programm LUX'),
	(121201011994, 'LUX', 2010, 'Programm LUX'),
	(121301011986, 'AUT', 2014, 'Programm AUT'),
	(121301011991, 'FIN', 2013, 'Programm FIN'),
	(121301011992, 'GRC', 2012, 'Programm GRC'),
	(121301011993, 'HRV', 2011, 'Programm HRV'),
	(121301011994, 'LUX', 2010, 'Programm LUX');


insert into Bewerbungsunterlagen(Student, Dokument) values
	(121201011986, 'http://docserver.org/?type=doc&user=121201011986'),	
	(121201011991, 'http://docserver.org/?type=doc&user=121201011991'),	
	(121201011994, 'http://docserver.org/?type=doc&user=121201011994'),	
	(121201011992, 'http://docserver.org/?type=doc&user=121201011992');

insert into Firma (Name, Standort) values 
	('Firma1', 'Standort1'),
	('Firma2', 'Standort1'),
	('Firma3', 'Standort2'),
	('Firma4', 'Standort3'),
	('Firma5', 'Standort1'),
	('Firma6', 'Standort4'),
	('Firma7', 'Standort2'),
	('Firma8', 'Standort5'),
	('Firma9', 'Standort7'),
	('Firma10', 'Standort9');

insert into Firma_Betreuer (Firma, Betreuer) values 
	(10, 4015023179),
	(20, 2027081283),
	(30, 2027081283),
	(40, 4015023179),
	(40, 2027081283),
	(50, 1280081082),
	(60, 1280081082),
	(70, 1280081082),
	(80, 4015023179),
	(90, 2027081283),
	(100, 2027081283);

insert into Abteilung (AbtNr, Firma, AbtName) values 
	(1, 10, 'Abteilung1'),
	(2, 10, 'Abteilung2'),
	(3, 10, 'Abteilung3'),
	(1, 20, 'Abteilung1'),
	(1, 30, 'Abteilung1'),
	(1, 40, 'Abteilung1'),
	(1, 50, 'Abteilung1'),
	(2, 50, 'Abteilung2'),
	(1, 60, 'Abteilung1'),
	(1, 70, 'Abteilung1'),
	(1, 80, 'Abteilung1'),
	(1, 90, 'Abteilung1'),
	(1, 100, 'Abteilung1');


insert into Praktikum (PrNr, Abteilung, Firma, Beschr, AufgBereich, von, bis) values 
	(1, 1, 10, 'Praktikum 1', 'Kaffeeholen', '2009-01-01', '2009-12-31'),
	(2, 1, 10, 'Praktikum 2', 'Kaffeeholen', '2010-01-01', '2010-12-31'),
	(1, 2, 10, 'Praktikum 1', 'Kaffeeholen', '2011-01-01', '2011-12-31'),
	(1, 1, 20, 'Praktikum 1', 'Kaffeeholen', '2012-01-01', '2012-12-31'),
	(1, 1, 30, 'Praktikum 1', 'Kaffeeholen', '2013-01-01', '2013-12-31'),
	(1, 1, 40, 'Praktikum 1', 'Kaffeeholen', '2014-01-01', '2014-12-31');


insert into Austauschprogramm_Praktikum (Land, Jahr, Name, PrNr, Abteilung, Firma) values
	('AUT', 2014, 'Programm AUT', 1, 1, 40),
	('AUT', 2013, 'Programm AUT', 1, 1, 30),
	('FIN', 2013, 'Programm FIN', 1, 1, 30),
	('FIN', 2012, 'Programm FIN', 1, 1, 20),
	('GRC', 2012, 'Programm GRC', 1, 1, 20),
	('GRC', 2011, 'Programm GRC', 1, 2, 10),
	('HRV', 2011, 'Programm HRV', 1, 2, 10),
	('HRV', 2010, 'Programm HRV', 2, 1, 10),
	('LUX', 2010, 'Programm LUX', 2, 1, 10),
	('LUX', 2009, 'Programm LUX', 1, 1, 10);


insert into Praktikum_shortlisted (Student, PrNr, Abteilung, Firma, PraeferenzNr) values 
	(121201011986, 1, 1, 30, 1),
	(121201011986, 1, 1, 40, 2),
	(121201011992, 1, 2, 10, 1),
	(121201011992, 1, 1, 20, 2),
	(121301011986, 1, 1, 40, 1),
	(121301011991, 1, 1, 30, 1),
	(121301011993, 1, 2, 10, 1),
	(121301011994, 2, 1, 10, 1);
	
	
insert into Praktikum_Betreuer_matched (Student, PrNr, Abteilung, Firma, Betreuer) values
	(121301011991, 1, 1, 30, 1280081082),
	(121301011993, 1, 2, 10, 1280081081),
	(121301011994, 2, 1, 10, 1280081081);
	
