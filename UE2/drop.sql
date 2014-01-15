drop trigger t_before_Austauschprogramm_Praktikum on Austauschprogramm_Praktikum;
drop trigger t_before_Firma_Betreuer on Firma_Betreuer;

drop function check_Austauschprogramm_Praktikum();
drop function check_Firma_Betreuer();

drop function f_calc_salary(__SVNR BIGINT, check_date DATE);
drop function p_update_students();

drop table Austauschprogramm_Praktikum;
drop table Praktikum_Betreuer_matched;
drop table Praktikum_shortlisted;
drop table Praktikum;
drop table Abteilung;
drop table Firma_Betreuer;
drop table Firma;
drop table Bewerbungsunterlagen;
drop table Student_Austauschprogramm;
drop table Student_matched;
drop table Student_shortlisted;
drop table Student;
drop table Austauschprogramm;
drop table Betreuer;
ALTER TABLE Kommission drop CONSTRAINT Kommission_Koordinator_fkey;
drop table Mitarbeiter;
drop table Kommission;

drop sequence seq_firma;
drop sequence seq_praktikum;
drop sequence seq_abteilung;
drop sequence seq_kommission;
