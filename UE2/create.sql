create sequence seq_kommission;
create sequence seq_abteilung;
create sequence seq_praktikum;

create sequence seq_firma 
	increment by 10
	minvalue 10
	no cycle;

create table Kommission ( 

	Id INTEGER PRIMARY KEY DEFAULT nextval('seq_kommission'),
	Standort varchar(50),
	Name varchar(50),
	/* Ein Mitarbeiter kann nur eine Kommission koordinieren -> UNIQUE */
	Koordinator BIGINT UNIQUE,
	uebergeordnet INTEGER REFERENCES Kommission(Id) 
);

create table Mitarbeiter (

	SVNR BIGINT PRIMARY KEY,
	Name varchar(50),
	Anschrift varchar(255),
	Gehaltsklasse varchar(2) NOT NULL check (Gehaltsklasse in ('M1', 'M2', 'M3', 'C1', 'C2')),
	beschaeftigt_seit DATE NOT NULL,
	Kommission INTEGER REFERENCES Kommission(Id) DEFERRABLE INITIALLY DEFERRED

);

ALTER TABLE Kommission ADD CONSTRAINT Kommission_Koordinator_fkey FOREIGN KEY(Koordinator) REFERENCES Mitarbeiter(SVNR) DEFERRABLE INITIALLY DEFERRED;

create table Betreuer (

	SVNR BIGINT PRIMARY KEY REFERENCES Mitarbeiter(SVNR),
	Bonus NUMERIC(6, 2) NOT NULL check(Bonus > 0)

);

create table Austauschprogramm (

	Land varchar(3),
	Jahr integer,
	Name varchar(50),
	Bewerbungsfrist DATE NOT NULL check(EXTRACT(YEAR FROM Bewerbungsfrist) = Jahr),
	PRIMARY KEY (Land, Jahr, Name),
	Kommission INTEGER REFERENCES Kommission(Id)

);

create table Student (

	SVNR BIGINT PRIMARY KEY,
	Anschrift varchar(255),
	Name varchar(50),
	Studienkennzahl varchar(5),
	MatrNr varchar(7) UNIQUE

);

create table Student_shortlisted (

	SVNR BIGINT PRIMARY KEY REFERENCES Student(SVNR)

);

create table Student_matched (

	SVNR BIGINT PRIMARY KEY REFERENCES Student_shortlisted(SVNR)

);

create table Student_Austauschprogramm (

	/* Student */
	Student BIGINT NOT NULL REFERENCES Student(SVNR),

	/* Austauschprogramm */
	Land varchar(3) NOT NULL,
	Jahr integer NOT NULL,
	Name varchar(50) NOT NULL,
	FOREIGN KEY (Land, Jahr, Name) REFERENCES Austauschprogramm (Land, Jahr, Name),
	PRIMARY KEY(Student, Land, Jahr, Name)
	
);

create table Bewerbungsunterlagen (

	Student BIGINT PRIMARY KEY REFERENCES Student(SVNR),
	/* Annahme: Dokument wird via URI gespeichert */
	Dokument varchar(255)

);

create table Firma (

	FaNr INTEGER PRIMARY KEY DEFAULT nextval('seq_firma'),
	Name varchar(50),
	Standort varchar(50)

);

create Table Firma_Betreuer (

	Firma INTEGER REFERENCES Firma(FaNr) not null,
	Betreuer BIGINT REFERENCES Betreuer(SVNR) not null,
	PRIMARY KEY(Firma, Betreuer)

);

create table Abteilung (

	AbtNr INTEGER DEFAULT nextval('seq_abteilung'),
	Firma INTEGER REFERENCES Firma(FaNr),
	AbtName varchar(50),
	PRIMARY KEY(AbtNr, FIRMA)

);

create table Praktikum (

	PrNr INTEGER DEFAULT nextval('seq_praktikum'),
	Abteilung INTEGER,
	Firma INTEGER,
	Beschr varchar(200),
	AufgBereich varchar(100),
	von DATE NOT NULL ,
	bis DATE NOT NULL check(von < bis),
	FOREIGN KEY (Abteilung, Firma) REFERENCES Abteilung (AbtNr, Firma),
	PRIMARY KEY(PrNr, Abteilung, Firma)

);

create table Praktikum_shortlisted (

	Student BIGINT NOT NULL REFERENCES Student_shortlisted(SVNR),
	PrNr INTEGER NOT NULL,
	Abteilung INTEGER NOT NULL,
	Firma INTEGER NOT NULL,
	PraeferenzNr INTEGER NOT NULL check(PraeferenzNr in (1, 2)),
	FOREIGN KEY (PrNr, Abteilung, Firma) REFERENCES Praktikum (PrNr, Abteilung, Firma),
	UNIQUE (Student, PrNr, Abteilung, Firma),
	PRIMARY KEY(Student, PraeferenzNr)

);

create table Praktikum_Betreuer_matched (

	Student BIGINT NOT NULL,
	PrNr INTEGER NOT NULL,
	Abteilung INTEGER NOT NULL,
	Firma INTEGER NOT NULL,
	Betreuer BIGINT REFERENCES Betreuer(SVNR),
	FOREIGN KEY (Student, PrNr, Abteilung, Firma) REFERENCES Praktikum_shortlisted (Student, PrNr, Abteilung, Firma),
	PRIMARY KEY (Student, PrNr, Abteilung, Firma, Betreuer)	
);

create table Austauschprogramm_Praktikum (

	/* Austauschprogramm */
	Land varchar(3) NOT NULL,
	Jahr integer NOT NULL,
	Name varchar(50) NOT NULL,
	FOREIGN KEY (Land, Jahr, Name) REFERENCES Austauschprogramm (Land, Jahr, Name),

	/* Praktikum */
	PrNr INTEGER NOT NULL,
	Abteilung INTEGER NOT NULL,
	Firma INTEGER NOT NULL,
	FOREIGN KEY (PrNr, Abteilung, Firma) REFERENCES Praktikum (PrNr, Abteilung, Firma),

	PRIMARY KEY (Land, Jahr, Name, PrNr, Abteilung, Firma)
);


