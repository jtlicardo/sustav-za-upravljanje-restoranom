DROP DATABASE IF EXISTS restoran;
CREATE DATABASE restoran;
USE restoran;

CREATE TABLE osoba (
	id INTEGER PRIMARY KEY AUTO_INCREMENT,
    ime VARCHAR(50) NOT NULL,
    prezime VARCHAR(50) NOT NULL,
    broj_mob VARCHAR(10),
    email VARCHAR(30)
);

CREATE TABLE zanimanje (
	id INTEGER PRIMARY KEY AUTO_INCREMENT,
    naziv VARCHAR(50) NOT NULL,
    placa_hrk DECIMAL(10, 2) DEFAULT 3750.00,
    CHECK (placa_hrk >= 3750.00)
);

CREATE TABLE djelatnik (
	id INTEGER PRIMARY KEY AUTO_INCREMENT,
    id_osoba INTEGER NOT NULL,
    oib CHAR(11) NOT NULL UNIQUE,
    datum_rodenja DATE NOT NULL,
    datum_zaposlenja DATE NOT NULL,
    id_zanimanje INTEGER NOT NULL,
    FOREIGN KEY (id_osoba) REFERENCES osoba (id),
    FOREIGN KEY (id_zanimanje) REFERENCES zanimanje (id)
);

CREATE TABLE adresa (
	id INTEGER PRIMARY KEY AUTO_INCREMENT,
	drzava VARCHAR (50) NOT NULL,
	grad VARCHAR (50) NOT NULL,
	ulica VARCHAR (50) NOT NULL,
	post_broj VARCHAR(10) NOT NULL
);

CREATE TABLE dobavljac (
	id INTEGER PRIMARY KEY AUTO_INCREMENT,
    naziv VARCHAR(50) NOT NULL,
    id_adresa INTEGER NOT NULL,
    oib CHAR(11) NOT NULL UNIQUE,
    broj_mob VARCHAR(10) NOT NULL UNIQUE,
    vrsta_usluge VARCHAR(50) NOT NULL,
    FOREIGN KEY (id_adresa) REFERENCES adresa (id)
);
    
CREATE TABLE stol (
	id INTEGER PRIMARY KEY AUTO_INCREMENT,
    broj_stola VARCHAR(4) NOT NULL,
    rajon_stola VARCHAR(4) NOT NULL,
    broj_gostiju_kapacitet INTEGER
);

CREATE TABLE nacini_placanja (
	id INTEGER PRIMARY KEY AUTO_INCREMENT,
    naziv VARCHAR(10) NOT NULL
);
    
CREATE TABLE racun (
	id INTEGER PRIMARY KEY AUTO_INCREMENT,
	sifra VARCHAR(10) NOT NULL,
    id_nacin_placanja INTEGER NOT NULL,
	id_stol INTEGER NOT NULL,
	id_djelatnik INTEGER NOT NULL,
	vrijeme_izdavanja DATETIME NOT NULL,
	iznos_hrk DECIMAL(10, 2) DEFAULT 0.00,
    FOREIGN KEY (id_nacin_placanja) REFERENCES nacini_placanja (id),
    FOREIGN KEY (id_stol) REFERENCES stol (id),
    FOREIGN KEY (id_djelatnik) REFERENCES djelatnik (id)
);

CREATE TABLE alergen (
	id INTEGER PRIMARY KEY AUTO_INCREMENT,
	naziv VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE meni (
    id INTEGER PRIMARY KEY AUTO_INCREMENT,
    naziv_stavke VARCHAR(70) NOT NULL,
    cijena_hrk DECIMAL(10, 2) NOT NULL,
    aktivno CHAR(1) DEFAULT "D",
    CHECK (aktivno IN ("D", "N"))
);
    
CREATE TABLE sadrzi_alergen (
	id INTEGER PRIMARY KEY AUTO_INCREMENT,
    id_meni INTEGER NOT NULL,
    id_alergen INTEGER NOT NULL,
    FOREIGN KEY (id_meni) REFERENCES meni (id),
    FOREIGN KEY (id_alergen) REFERENCES alergen (id)
);

CREATE TABLE kategorija_namirnica (
    id INTEGER PRIMARY KEY AUTO_INCREMENT,
    naziv VARCHAR(50) NOT NULL
);
    
CREATE TABLE namirnica (
    id INTEGER PRIMARY KEY AUTO_INCREMENT,
    naziv VARCHAR(50) NOT NULL,
    id_kategorija INTEGER NOT NULL,
    kolicina_na_zalihi INTEGER NOT NULL,
    mjerna_jedinica VARCHAR(20) NOT NULL,
    FOREIGN KEY (id_kategorija) REFERENCES kategorija_namirnica (id)
);

CREATE TABLE stavka_meni (
    id INTEGER PRIMARY KEY AUTO_INCREMENT,
    id_namirnica INTEGER NOT NULL,
    kolicina DECIMAL (10, 2),
    id_meni INTEGER NOT NULL,
	FOREIGN KEY (id_namirnica) REFERENCES namirnica (id),
    FOREIGN KEY (id_meni) REFERENCES meni (id)
);

CREATE TABLE stavka_racun (
	id INTEGER PRIMARY KEY AUTO_INCREMENT,
    id_racun INTEGER NOT NULL,
    id_meni INTEGER NOT NULL,
    kolicina INTEGER NOT NULL,
    cijena_hrk DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (id_racun) REFERENCES racun (id),
    FOREIGN KEY (id_meni) REFERENCES meni (id),
    UNIQUE (id_racun, id_meni)
);

CREATE TABLE rezervacija (
	id INTEGER PRIMARY KEY AUTO_INCREMENT,
	id_stol INTEGER NOT NULL,
	id_gost INTEGER NOT NULL,
    zeljeni_datum DATE NOT NULL,
    vrijeme_od TIME NOT NULL,
    vrijeme_do TIME NOT NULL,
	broj_gostiju INTEGER NOT NULL,
	FOREIGN KEY (id_stol) REFERENCES stol (id),
	FOREIGN KEY (id_gost) REFERENCES osoba (id)
);

CREATE TABLE catering_narucitelj (
    id INTEGER PRIMARY KEY AUTO_INCREMENT,
    id_osoba INTEGER NOT NULL,
    oib CHAR(11) NOT NULL UNIQUE,
    FOREIGN KEY (id_osoba) REFERENCES osoba (id)
);

CREATE TABLE catering_zahtjev (
    id INTEGER PRIMARY KEY AUTO_INCREMENT,
    id_narucitelj INTEGER NOT NULL,
    id_adresa INTEGER NOT NULL,
    opis TEXT,
    zeljeni_datum DATE NOT NULL,
    datum_zahtjeva DATE NOT NULL,
    FOREIGN KEY (id_narucitelj) REFERENCES catering_narucitelj (id),
    FOREIGN KEY (id_adresa) REFERENCES adresa (id)
);

CREATE TABLE catering (
    id INTEGER PRIMARY KEY AUTO_INCREMENT,
    id_zahtjev INTEGER NOT NULL,
    cijena_hrk DECIMAL(10, 2) DEFAULT 0.00,
    datum_izvrsenja DATE,
    opis TEXT,
    uplaceno CHAR(1) NOT NULL,
    FOREIGN KEY (id_zahtjev) REFERENCES catering_zahtjev (id),
    CHECK (uplaceno IN ("D", "N"))
);
    
CREATE TABLE catering_stavka (
    id INTEGER PRIMARY KEY AUTO_INCREMENT,
    id_catering INTEGER NOT NULL,
    id_meni INTEGER NOT NULL,
    kolicina INTEGER NOT NULL,
    cijena_hrk DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (id_catering) REFERENCES catering (id),
    FOREIGN KEY (id_meni) REFERENCES meni (id)
);

CREATE TABLE djelatnici_catering (
	id INTEGER PRIMARY KEY AUTO_INCREMENT,
    id_catering INTEGER NOT NULL,
    id_djelatnik INTEGER NOT NULL,
    FOREIGN KEY (id_catering) REFERENCES catering (id),
    FOREIGN KEY (id_djelatnik) REFERENCES djelatnik (id)
);
    
CREATE TABLE nabava (
    id INTEGER PRIMARY KEY AUTO_INCREMENT,
    id_dobavljac INTEGER NOT NULL,
    opis TEXT,
    iznos_hrk DECIMAL(10, 2) DEFAULT 0.00,
    podmireno CHAR(1) NOT NULL,
    datum DATE NOT NULL,
    FOREIGN KEY (id_dobavljac) REFERENCES dobavljac (id),
    CHECK (podmireno IN ("D", "N"))
);

CREATE TABLE nabava_stavka (
    id INTEGER PRIMARY KEY AUTO_INCREMENT,
    id_nabava INTEGER NOT NULL,
    id_namirnica INTEGER NOT NULL,
    kolicina INTEGER NOT NULL,
    cijena_hrk DECIMAL(10, 2) NOT NULL,
	FOREIGN KEY (id_nabava) REFERENCES nabava (id),
	FOREIGN KEY (id_namirnica) REFERENCES namirnica (id)
); 

CREATE TABLE otpis (
    id INTEGER PRIMARY KEY AUTO_INCREMENT,
    datum DATE NOT NULL,
    opis TEXT
);    

CREATE TABLE otpis_stavka (
	id INTEGER PRIMARY KEY AUTO_INCREMENT,
	id_otpis INTEGER NOT NULL,
    id_namirnica INTEGER NOT NULL,
	kolicina INTEGER NOT NULL,
	FOREIGN KEY (id_otpis) REFERENCES otpis (id),
	FOREIGN KEY (id_namirnica) REFERENCES namirnica (id)
);    

CREATE TABLE kategorija_rezije (
	id INTEGER PRIMARY KEY AUTO_INCREMENT,
    naziv VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE rezije (
	id INTEGER PRIMARY KEY AUTO_INCREMENT,
    iznos_hrk DECIMAL(10, 2) NOT NULL,
    datum DATE NOT NULL,
    id_kategorija INTEGER NOT NULL,
    placeno CHAR(1) NOT NULL,
    FOREIGN KEY (id_kategorija) REFERENCES kategorija_rezije (id),
    CHECK (placeno IN ("D", "N"))
);

CREATE TABLE smjena (
	id INTEGER PRIMARY KEY AUTO_INCREMENT,
    naziv VARCHAR (50) NOT NULL, 
    pocetak_radnog_vremena TIME NOT NULL,
    kraj_radnog_vremena TIME NOT NULL
);    
    
CREATE TABLE djelatnik_smjena (
	id INTEGER PRIMARY KEY AUTO_INCREMENT,
	id_djelatnik INTEGER NOT NULL,
	id_smjena INTEGER NOT NULL, 
	datum DATE NOT NULL,
    FOREIGN KEY (id_djelatnik) REFERENCES djelatnik (id),
    FOREIGN KEY (id_smjena) REFERENCES smjena (id)
);    

CREATE TABLE dostava (
	id INTEGER PRIMARY KEY AUTO_INCREMENT,
	id_gost INTEGER NOT NULL,
	id_adresa INTEGER NOT NULL, 
	datum DATE NOT NULL, 
	cijena_hrk DECIMAL(10, 2) DEFAULT 0.00,
	izvrsena CHAR(1) NOT NULL,
    FOREIGN KEY (id_gost) REFERENCES osoba (id),
    FOREIGN KEY (id_adresa) REFERENCES adresa (id),
    CHECK (izvrsena IN ("D", "N"))
);

CREATE TABLE dostava_stavka (
	id INTEGER PRIMARY KEY AUTO_INCREMENT,
	id_dostava INTEGER NOT NULL,
	id_meni INTEGER NOT NULL,
	kolicina INTEGER NOT NULL, 
	cijena_hrk DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (id_dostava) REFERENCES dostava (id),
    FOREIGN KEY (id_meni) REFERENCES meni (id)
); 





-- TRIGGERI

-- Trigger za izračun iznosa stavke računa i ukupnog iznosa računa
DELIMITER //
CREATE TRIGGER bi_stavka_racun
    BEFORE INSERT ON stavka_racun
    FOR EACH ROW
BEGIN	
	DECLARE l_cijena_stavke DECIMAL (10, 2);
    
    SELECT cijena_hrk INTO l_cijena_stavke
		FROM meni
        WHERE meni.id = new.id_meni;
        
	SET new.cijena_hrk = l_cijena_stavke * new.kolicina;
    
    UPDATE racun
		SET iznos_hrk = iznos_hrk + new.cijena_hrk
		WHERE id = new.id_racun;
END//
DELIMITER ;

-- Trigger za izračun iznosa stavke cateringa i ukupnog iznosa cateringa
DELIMITER //
CREATE TRIGGER bi_catering_stavka
    BEFORE INSERT ON catering_stavka
    FOR EACH ROW
BEGIN	
	DECLARE l_cijena_stavke DECIMAL (10, 2);
    
    SELECT cijena_hrk INTO l_cijena_stavke
		FROM meni
        WHERE meni.id = new.id_meni;
        
	SET new.cijena_hrk = l_cijena_stavke * new.kolicina; 
    
    UPDATE catering
		SET cijena_hrk = cijena_hrk + new.cijena_hrk
		WHERE id = new.id_catering;
END//
DELIMITER ;

-- Trigger za izračun ukupnog iznosa nabave
DELIMITER //
CREATE TRIGGER bi_nabava_stavka
    BEFORE INSERT ON nabava_stavka
    FOR EACH ROW
BEGIN	
    UPDATE nabava
		SET iznos_hrk = iznos_hrk + new.cijena_hrk
		WHERE id = new.id_nabava;
END//
DELIMITER ;
  
-- Trigger za izračun iznosa stavke dostave i ukupnog iznosa dostave
DELIMITER //
CREATE TRIGGER bi_dostava_stavka
    BEFORE INSERT ON dostava_stavka
    FOR EACH ROW
BEGIN	
	DECLARE l_cijena_stavke DECIMAL (10, 2);
    
    SELECT cijena_hrk INTO l_cijena_stavke
		FROM meni
        WHERE meni.id = new.id_meni;
        
	SET new.cijena_hrk = l_cijena_stavke * new.kolicina;
    
    UPDATE dostava
		SET cijena_hrk = cijena_hrk + new.cijena_hrk
		WHERE id = new.id_dostava;
END//
DELIMITER ;





-- INSERTOVI

-- id, ime, prezime, broj_mob, email
INSERT INTO osoba VALUES
	(1, "Ana", "Anić", "0975698542", "anaanic@gmail.com"),
    (2, "Milena", "Kakoli", "0911122334", "kakolisepreziva@mojamilena.com"),
    (3, "Marko", "Afrić", "092785425", "mafric@gmail.com"),
    (4, "Ive", "Kacavida", "099456585", "krizna_glava@gmail.com"),
    (5, "Slavica", "Sladić", "098452457", "1s_s1@hotmail.com"),
    (6, "Gertruda", "Bitić", "097456285", "bitic.g@yahoo.com"),
    (7, "Jasmina", "Starvos", "09874525", "mawa_crnka@net.hr"),
    (8, "David", "Bekam", "0913322554", "dbek47@gmail.com"),
    (9, "Roberto", "Fagioli", "0925544125", "fagioli.r@outlook.com"),
    (10, "Serđo", "Valić", "09236525", "rimonika885@gmail.com"),
    (11, "Melisa", "Fabijanić", "099542618", "melyf@gmail.com"),
    (12, "Lejla", "Ačimović", "091556512", "laci1@gmail.com"),
    (13, "Vanesa", "Gojtanić", "09745524", "vanesag@gmail.com"),
    (14, "Marina", "Lakošeljac", "01556442", "marina111@hotmail.com"),
    (15, "Ana", "Belac", "0984525", "ana_baana@gmail.com"),
    (16, "Igor", "Mijandrušić", "0994526", "igorm54@gmail.com"),
    (17, "Žarko", "Miletić", "09145265", "zac@hotmail.com"),
    (18, "Natanel", "Vitasović", "092665522", "vitan@net.hr"),
    (19, "Ivan", "Bernobić", "09733526", "bero69@gmail.com"),
    (20, "Nikola", "Krajcar", "099263255", "nix@outlook.com"),
    (21, "Franko", "Peruško", "0994525", "frankop33@gmail.com"),
    (22, "Šime", "Lanča", "095566221", "slanaca@gmail.com"),
    (23, "Kate", "Matošević", "098325625", "mato_sevic@gmail.com"),
    (24, "Marija", "Švić", "092889897", "maricka@yahoo.com"),
    (25, "Lorena", "Kocijančić", "0915006002", "lory89@gmail.com"),
    (26, "Dimitri", "Grgeta", "0912236544", "ultron1@gmail.com"),
    (27, "Leon", "Maružin", "098001145", "leon.m@gmail.com"),
    (28, "Erik", "Višković", "09755226", "eviskovic1@gmail.com"),
    (29, "Mirko", "Mikac", "091330311", "mik_mik@gmail.com"),
    (30, "Slavko", "Mikac", "091330312", "smik_smik@gmail.com"),
    (31, "Frane", "Kosir", "0916471320", "f.kosir@gmail.com"),
    (32, "Vesna", "Petrović", "0991233211", "vpetrovic@tvnova.hr"),
    (33, "Igor", "Pamić", "0915554444", "boskarin@outlook.com"),
    (34, "Rino", "Pavletić", "0951234444", "rpavletic@gmail.com"),
    (35, "Zlatan", "Ibrahimović", "0990001111", "ibro@gmail.com"),
    (36, "Drago", "Orlić", "0943331212", "orlic.drago@gmail.com"),
    (37, "Dragan", "Matika", "0976661233", "matika@hotmail.com"),
    (38, "Tone", "Štraca", "0912223333", "tonestraca@gmail.com"),
    (39, "Daniele", "Portafoglio", "0995551111", "daniele@gmail.com"),
    (40, "Zorica", "Rankun", "0910997777", "zoryy@gmail.com");
    

-- id, naziv, placa_hrk
INSERT INTO zanimanje VALUES   
	(1, "kuhar", 9054.45),
	(2, "konobar", 8640.85),
    (3, "pomoćni kuhar", 4654.45),
    (4, "pomoćni konobar", 4654.45),
    (5, "servir", 4551.23),
    (6, "operater na posuđu", 6054.45),
    (7, "barmen", 6054.45),
    (8, "poslovođa", 16054.75),
    (9, "skladištar", 7453.65),
    (10, "dostavljač", 8135.24),
    (11, "blagajnik", 7500.00);

-- id, id_osoba, oib, datum_rodenja, datum_zaposlenja, id_zanimanje
INSERT INTO djelatnik VALUES
	(1, 1, "56214852651", STR_TO_DATE('22.11.1988.', '%d.%m.%Y.'), STR_TO_DATE('19.05.2021.', '%d.%m.%Y.'), 2),
	(2, 2, "42685138412", STR_TO_DATE('13.05.1978.', '%d.%m.%Y.'), STR_TO_DATE('15.03.2018.', '%d.%m.%Y.'), 1),
	(3, 3, "87426514895", STR_TO_DATE('11.11.1999.', '%d.%m.%Y.'), STR_TO_DATE('17.04.2021.', '%d.%m.%Y.'), 3),
    (4, 4, "93571964576", STR_TO_DATE('04.09.1970.', '%d.%m.%Y.'), STR_TO_DATE('04.04.2015.', '%d.%m.%Y.'), 1),
    (5, 5, "48654207991", STR_TO_DATE('11.11.1991.', '%d.%m.%Y.'), STR_TO_DATE('24.01.2017.', '%d.%m.%Y.'), 2),
    (6, 6, "24600726742", STR_TO_DATE('21.01.1986.', '%d.%m.%Y.'), STR_TO_DATE('19.08.2019.', '%d.%m.%Y.'), 2),
    (7, 7, "39839635272", STR_TO_DATE('18.10.2003.', '%d.%m.%Y.'), STR_TO_DATE('22.06.2016.', '%d.%m.%Y.'), 11),
    (8, 8, "22911268228", STR_TO_DATE('08.04.1988.', '%d.%m.%Y.'), STR_TO_DATE('22.03.2017.', '%d.%m.%Y.'), 3),
    (9, 9, "37746108986", STR_TO_DATE('05.03.1973.', '%d.%m.%Y.'), STR_TO_DATE('22.03.2017.', '%d.%m.%Y.'), 4),
    (10, 10, "27772129672", STR_TO_DATE('16.01.1980.', '%d.%m.%Y.'), STR_TO_DATE('07.01.2016.', '%d.%m.%Y.'), 3),
    (11, 11, "11299270874", STR_TO_DATE('04.11.1982.', '%d.%m.%Y.'), STR_TO_DATE('15.11.2019.', '%d.%m.%Y.'), 4),
    (12, 12, "57834292478", STR_TO_DATE('01.09.1992.', '%d.%m.%Y.'), STR_TO_DATE('19.08.2019.', '%d.%m.%Y.'), 3),
    (13, 13, "36828047884", STR_TO_DATE('18.05.1989.', '%d.%m.%Y.'), STR_TO_DATE('28.06.2020.', '%d.%m.%Y.'), 4),
    (14, 14, "91290805782", STR_TO_DATE('21.07.1982.', '%d.%m.%Y.'), STR_TO_DATE('10.03.2019.', '%d.%m.%Y.'), 5),
    (15, 15, "10740162574", STR_TO_DATE('02.12.1990.', '%d.%m.%Y.'), STR_TO_DATE('16.07.2018.', '%d.%m.%Y.'), 6),
    (16, 16, "38596616074", STR_TO_DATE('23.04.1992.', '%d.%m.%Y.'), STR_TO_DATE('14.06.2016.', '%d.%m.%Y.'), 11),
    (17, 17, "07998924475", STR_TO_DATE('01.03.1980.', '%d.%m.%Y.'), STR_TO_DATE('28.01.2017.', '%d.%m.%Y.'), 5),
    (18, 18, "49803937625", STR_TO_DATE('25.11.2000.', '%d.%m.%Y.'), STR_TO_DATE('22.05.2017.', '%d.%m.%Y.'), 11),
    (19, 19, "23060440711", STR_TO_DATE('18.07.2001.', '%d.%m.%Y.'), STR_TO_DATE('16.09.2020.', '%d.%m.%Y.'), 6),
    (20, 20, "26189778531", STR_TO_DATE('12.02.1992.', '%d.%m.%Y.'), STR_TO_DATE('23.12.2015.', '%d.%m.%Y.'), 6),
    (21, 21, "54869054022", STR_TO_DATE('13.05.1975.', '%d.%m.%Y.'), STR_TO_DATE('18.07.2015.', '%d.%m.%Y.'), 1),
    (22, 22, "45283348931", STR_TO_DATE('01.04.1970.', '%d.%m.%Y.'), STR_TO_DATE('18.07.2015.', '%d.%m.%Y.'), 7),
    (23, 23, "40089923150", STR_TO_DATE('14.09.1993.', '%d.%m.%Y.'), STR_TO_DATE('16.07.2018.', '%d.%m.%Y.'), 7),
    (24, 24, "65542493102", STR_TO_DATE('28.02.1987.', '%d.%m.%Y.'), STR_TO_DATE('14.03.2021.', '%d.%m.%Y.'), 8),
    (25, 25, "70204223826", STR_TO_DATE('06.06.1986.', '%d.%m.%Y.'), STR_TO_DATE('29.08.2018.', '%d.%m.%Y.'), 8),
    (26, 26, "81795403405", STR_TO_DATE('14.02.2002.', '%d.%m.%Y.'), STR_TO_DATE('10.03.2019.', '%d.%m.%Y.'), 3),
    (27, 27, "65412651204", STR_TO_DATE('26.06.1988.', '%d.%m.%Y.'), STR_TO_DATE('22.02.2021.', '%d.%m.%Y.'), 7),
    (28, 28, "02369844521", STR_TO_DATE('16.05.2000.', '%d.%m.%Y.'), STR_TO_DATE('23.04.2021.', '%d.%m.%Y.'), 10),
    (29, 29, "36554789521", STR_TO_DATE('01.01.2001.', '%d.%m.%Y.'), STR_TO_DATE('14.07.2021.', '%d.%m.%Y.'), 10),
    (30, 30, "33655478895", STR_TO_DATE('01.01.2001.', '%d.%m.%Y.'), STR_TO_DATE('14.07.2021.', '%d.%m.%Y.'), 9);

-- id, drzava, grad, ulica, post_broj
INSERT INTO adresa VALUES
	(1, "Hrvatska", "Pula", "Rovinjska ulica 14", "52100"),
    (2, "Hrvatska", "Lanišće", "Podgaće 15", "52422"),
    (3, "Hrvatska", "Pazin", "Kršikla 85", "52000"),
    (4, "Hrvatska", "Labin", "Marceljani 8", "52220"),
    (5, "Hrvatska", "Pula", "Kolhiđanska 12", "52100"),
    (6, "Hrvatska", "Bale", "Bobići 6", "52211"),
    (7, "Hrvatska", "Vodnjan", "Antifašističkih boraca 28", "52215"),
    (8, "Hrvatska", "Galižana", "Toro 49", "52216"),
    (9, "Hrvatska", "Poreč", "Jasenova 145", "52440"),
    (10, "Hrvatska", "Raša", "Istarska 88", "52223"),
    (11, "Hrvatska", "Lupoglav", "Brajuhi 4", "52426"),
    (12, "Hrvatska", "Umag", "Kvarnerska 1", "52470"),
    (13, "Hrvatska", "Nova Vas", "Brčići 14", "52446"),
    (14, "Hrvatska", "Oprtalj", "Škeri 9", "52428"),
    (15, "Hrvatska", "Cerovlje", "Jerončići 3", "52402"),
    (16, "Hrvatska", "Pula", "Coppova 5", "52100"),
    (17, "Hrvatska", "Pazin", "Jukani 109", "52000"),
    (18, "Hrvatska", "Poreč", "Pionirska 8", "52440"),
    (19, "Hrvatska", "Umag", "Komunela 70", "52470"),
    (20, "Hrvatska", "Vrsar", "Jadranska 9", "52450"),
    (21, "Hrvatska", "Žminj", "Hrušteti 84", "52341"),
    (22, "Hrvatska", "Pazin", "Sergovići 88", "52000"),
    (23, "Hrvatska", "Motovun", "Kanal 3", "52424"),
    (24, "Hrvatska", "Nedešćina", "Vrećari 116", "52231"),
    (25, "Hrvatska", "Funtana", "Coki 2A", "52452"),
    (26, "Hrvatska", "Buzet", "Paladini 98", "52420"),
    (27, "Hrvatska", "Buzet", "Marinci 57", "52420"),
    (28, "Hrvatska", "Labin", "Šćiri 39", "52220"),
    (29, "Hrvatska", "Ližnjan", "Muntić 16", "52203"),
    (30, "Hrvatska", "Krnica", "Suhača 9", "52208");
        
-- id, naziv, id_adresa, oib, broj_mob, vrsta_usluge        
INSERT INTO dobavljac VALUES
	(1, 'Velpro', 1, "74125621458", "0912345678", "namirnice"),
	(2, 'Ljubica', 1, "51254785214", "09852415", "salata");

-- id, broj_stola, rajon_stola, broj_gostiju_kapacitet
INSERT INTO stol VALUES
	(1, "1", "1", 6),
    (2, "2", "1", 6),
    (3, "3", "1", 4),
    (4, "4", "1", 4),
    (5, "5", "1", 8),
    (6, "6", "1", 6),
    (7, "7", "1", 6),
    (8, "8", "1", 6),
    (9, "9", "1", 4),
    (10, "10", "1", 8),
    (11, "1", "2", 6),
    (12, "2", "2", 4),
    (13, "3", "2", 8),
    (14, "4", "2", 8),
    (15, "5", "2", 8),
    (16, "1", "3", 4),
    (17, "2", "3", 4),
    (18, "3", "3", 6),
    (19, "4", "3", 8),
    (20, "5", "3", 6),
    (21, "6", "3", 4),
    (22, "7", "3", 10),
    (23, "8", "3", 8),
    (24, "1", "4", 4),
    (25, "2", "4", 6),
    (26, "3", "4", 4),
    (27, "4", "4", 6),
    (28, "5", "4", 6),
    (29, "6", "4", 4),
    (30, "7", "4", 4);

-- id, naziv    
INSERT INTO nacini_placanja VALUES
	(1, "gotovina"),
    (2, "kartica"),
    (3, "crypto");

-- id, sifra, id_nacin_placanja, id_stol, id_djelatnik, vrijeme_izdavanja, iznos_hrk
-- iznos_hrk ne dodajemo -> po defaultu ide na 0.00 kn, kasnije se automatski izračuna prilikom inserta u tablicu stavka_racun
-- id-evi djelatnika koji su blagajnici: 18, 7, 16
INSERT INTO racun (id, sifra, id_nacin_placanja, id_stol, id_djelatnik, vrijeme_izdavanja) VALUES
	(1, "000001", 3, 5, 7, STR_TO_DATE('18.12.2017. 12:00:00', '%d.%m.%Y. %H:%i:%s')),
    (2, "000002", 1, 13, 7, STR_TO_DATE('18.12.2017. 13:30:00', '%d.%m.%Y. %H:%i:%s')),
    (3, "000003", 1, 19, 18, STR_TO_DATE('18.12.2017. 15:00:00', '%d.%m.%Y. %H:%i:%s')),
    (4, "000004", 1, 26, 18, STR_TO_DATE('18.12.2017. 16:00:00', '%d.%m.%Y. %H:%i:%s')),
    (5, "000005", 1, 1, 7, STR_TO_DATE('18.12.2017. 17:00:00', '%d.%m.%Y. %H:%i:%s')),
    (6, "000006", 2, 4, 16, STR_TO_DATE('19.12.2017. 11:00:00', '%d.%m.%Y. %H:%i:%s')),
    (7, "000007", 1, 6, 16, STR_TO_DATE('19.12.2017. 12:00:00', '%d.%m.%Y. %H:%i:%s')),
    (8, "000008", 1, 15, 7, STR_TO_DATE('19.12.2017. 13:00:00', '%d.%m.%Y. %H:%i:%s')),
    (9, "000009", 1, 21, 16, STR_TO_DATE('19.12.2017. 14:00:00', '%d.%m.%Y. %H:%i:%s')),
    (10, "000010", 1, 28, 7, STR_TO_DATE('20.12.2017. 10:00:00', '%d.%m.%Y. %H:%i:%s')),
    (11, "000011", 1, 12, 18, STR_TO_DATE('20.12.2017. 11:00:00', '%d.%m.%Y. %H:%i:%s')),
    (12, "000012", 1, 22, 7, STR_TO_DATE('20.12.2017. 12:00:00', '%d.%m.%Y. %H:%i:%s')),
    (13, "000013", 2, 24, 18, STR_TO_DATE('20.12.2017. 13:00:00', '%d.%m.%Y. %H:%i:%s')),
    (14, "000014", 1, 10, 18, STR_TO_DATE('20.12.2017. 14:00:00', '%d.%m.%Y. %H:%i:%s')),
    (15, "000015", 2, 9, 16, STR_TO_DATE('21.12.2017. 10:00:00', '%d.%m.%Y. %H:%i:%s')),
    (16, "000016", 1, 16, 16, STR_TO_DATE('21.12.2017. 11:00:00', '%d.%m.%Y. %H:%i:%s')),
    (17, "000017", 1, 21, 16, STR_TO_DATE('21.12.2017. 12:00:00', '%d.%m.%Y. %H:%i:%s')),
    (18, "000018", 1, 29, 7, STR_TO_DATE('21.12.2017. 13:00:00', '%d.%m.%Y. %H:%i:%s')),
    (19, "000019", 1, 23, 7, STR_TO_DATE('21.12.2017. 14:00:00', '%d.%m.%Y. %H:%i:%s')),
    (20, "000020", 1, 7, 7, STR_TO_DATE('21.12.2017. 15:00:00', '%d.%m.%Y. %H:%i:%s')),
    (21, "000021", 2, 27, 7, STR_TO_DATE('21.12.2017. 16:00:00', '%d.%m.%Y. %H:%i:%s')),
    (22, "000022", 2, 30, 7, STR_TO_DATE('21.12.2017. 16:30:00', '%d.%m.%Y. %H:%i:%s')),
    (23, "000023", 1, 25, 7, STR_TO_DATE('21.12.2017. 17:00:00', '%d.%m.%Y. %H:%i:%s')),
    (24, "000024", 2, 7, 7, STR_TO_DATE('22.12.2017. 10:00:00', '%d.%m.%Y. %H:%i:%s')),
    (25, "000025", 3, 18, 7, STR_TO_DATE('22.12.2017. 10:30:00', '%d.%m.%Y. %H:%i:%s')),
    (26, "000026", 1, 24, 7, STR_TO_DATE('22.12.2017. 11:00:00', '%d.%m.%Y. %H:%i:%s')),
    (27, "000027", 2, 7, 7, STR_TO_DATE('22.12.2017. 11:30:00', '%d.%m.%Y. %H:%i:%s')),
    (28, "000028", 1, 3, 7, STR_TO_DATE('22.12.2017. 12:30:00', '%d.%m.%Y. %H:%i:%s')),
    (29, "000029", 1, 17, 7, STR_TO_DATE('22.12.2017. 13:00:00', '%d.%m.%Y. %H:%i:%s')),
    (30, "000030", 2, 9, 7, STR_TO_DATE('22.12.2017. 13:00:00', '%d.%m.%Y. %H:%i:%s')),
    (31, "000031", 2, 8, 7, STR_TO_DATE('22.12.2017. 13:30:00', '%d.%m.%Y. %H:%i:%s')),
    (32, "000032", 1, 28, 7, STR_TO_DATE('22.12.2017. 14:00:00', '%d.%m.%Y. %H:%i:%s')),
    (33, "000033", 1, 30, 7, STR_TO_DATE('22.12.2017. 14:30:00', '%d.%m.%Y. %H:%i:%s')),
    (34, "000034", 1, 11, 7, STR_TO_DATE('23.12.2017. 11:30:00', '%d.%m.%Y. %H:%i:%s')),
    (35, "000035", 2, 10, 7, STR_TO_DATE('23.12.2017. 13:00:00', '%d.%m.%Y. %H:%i:%s')),
    (36, "000036", 1, 2, 7, STR_TO_DATE('23.12.2017. 13:30:00', '%d.%m.%Y. %H:%i:%s')),
    (37, "000037", 2, 19, 7, STR_TO_DATE('23.12.2017. 14:30:00', '%d.%m.%Y. %H:%i:%s')),
    (38, "000038", 1, 20, 7, STR_TO_DATE('23.12.2017. 15:30:00', '%d.%m.%Y. %H:%i:%s')),
    (39, "000039", 1, 11, 7, STR_TO_DATE('23.12.2017. 17:00:00', '%d.%m.%Y. %H:%i:%s'));

-- id, naziv    
INSERT INTO alergen VALUES
	(1, "Riba"),
    (2, "Mlijeko"),
    (3, "Pšenica"), 
    (4, "Jaja"), 
    (5, "Kikiriki"), 
    (6, "Cimet"), 
    (7, "Rakovi"), 
    (8, "Školjke"), 
    (9, "Soja"), 
    (10, "Celer"), 
    (11, "Gorušnica"), 
    (12, "Sezam"), 
    (13, "Lupina");  
    
    
-- id, naziv_stavke, cijena_hrk, aktivno (po defaultu "D") 
INSERT INTO meni (id, naziv_stavke, cijena_hrk) VALUES
	(1, "Jadranska orada sa žara s gratiniranim povrćem", 95),
    (2, "Vino Teran 0.1 l", 38),
    (3, "Vino Malvazija 0.1 l", 28),
    (4, "Salata od jadranske hobotnice s krumpirom i rajčicom", 95),
    (5, "Juha od rajčice", 35),
    (6, "Istarski fuži s jadranskim kozicama i tartufima", 98),
    (7, "Dalmatinska pašticada s domaćim njokima", 96),
    (8, "Spaghetti Carbonara", 43),
    (9, "Spaghetti Bolognese", 43),
    (10, "Pečena teletina s gratiniranim krumpirom", 125),
    (11, "Biftek s gratiniranim krumpirom i povrćem sa žara", 185),
    (12, "Pečena teletina s gratiniranim krumpirom", 125),
    (13, "Goveđa juha", 30),
    (14, "Soparnik", 42),
    (15, "Njoki u umaku od sira", 50),
    (16, "Rumpsteak sa šparogama i krumpir ploškama", 90),
    (17, "Lignje na žaru", 47),
    (18, "Pohani oslić", 50),
    (19, "Miješana salata", 17),
    (20, "Pileča plata za 4 osobe", 150),
    (21, "Grill plata za 4 osobe", 160),
    (22, "Pommes frites", 17),
    (23, "Jaja na oko", 15),
    (24, "Miješano meso", 60),
    (25, "Čokoladni soufle", 20);
    

-- id, id_meni, id_alergen
INSERT INTO sadrzi_alergen VALUES
	(1, 1, 1);

-- id, naziv    
INSERT INTO kategorija_namirnica VALUES
	(1, "Riba"),
    (2, "Meso"),
    (3, "Voće"),
    (4, "Povrće"),
    (5, "Piće");

-- id, naziv, id_kategorija, kolicina_na_zalihi, mjerna_jedinica    
INSERT INTO namirnica VALUES
	(1, "Orada", 1, 30, "komad"),
    (2, "Biftek", 2, 50, "komad"),
    (3, "Jagoda", 3, 4, "kilogram"),
    (4, "Vino Teran", 5, 60, "litra"),
    (5, "Vino Malvazija", 5, 60, "litra");

-- id, id_namirnica, kolicina, id_meni    
INSERT INTO stavka_meni VALUES
	(1, 1, 1, 1),
    (2, 4, 0.1, 2),
    (3, 5, 0.1, 3);

-- id, id_racun, id_meni, kolicina, cijena_hrk
-- cijena_hrk ne dodajemo -> automatski se izračuna
INSERT INTO stavka_racun (id, id_racun, id_meni, kolicina) VALUES
    (1, 1, 1, 1),
    (2, 1, 3, 2),
    (3, 2, 1, 1),
    (4, 2, 15, 3),
    (5, 2, 3, 1),
    (6, 3, 7, 2),
    (7, 3, 5, 1),
    (8, 4, 15, 1),
    (9, 4, 14, 2),
    (10, 5, 13, 1),
    (11, 5, 1, 1),
    (12, 6, 10, 3),
    (13, 7, 13, 1),
    (14, 7, 7, 3),
    (15, 7, 1, 3),
    (16, 8, 10, 1),
    (17, 8, 4, 5),
    (18, 8, 2, 1),
    (19, 8, 1, 1),
    (20, 9, 2, 5),
    (21, 9, 4, 6),
    (22, 9, 7, 2),
    (23, 9, 5, 3),
    (24, 10, 8, 2),
    (25, 11, 2, 2),
    (26, 11, 3, 2),
    (27, 11, 4, 2),
    (28, 12, 1, 2),
    (29, 12, 4, 2),
    (30, 13, 9, 1),
    (31, 14, 11, 3),
    (32, 14, 9, 5),
    (33, 15, 12, 5),
    (34, 15, 10, 2),
    (35, 16, 2, 1),
    (36, 17, 3, 3),
    (37, 17, 8, 5),
    (38, 17, 14, 2),
    (39, 18, 14, 1),
    (40, 19, 10, 2),
    (41, 20, 4, 2),
    (42, 20, 5, 2);

-- id, id_stol, id_gost, zeljeni_datum, vrijeme_od, vrijeme_do, broj_gostiju
INSERT INTO rezervacija VALUES
	(1, 1, 1, STR_TO_DATE('01.01.2021.', '%d.%m.%Y.'), "18:00", "23:00", 4);

-- id, id_osoba, oib
INSERT INTO catering_narucitelj VALUES
	(1, 1, "12345678901");

-- id, id_narucitelj, id_adresa, opis, zeljeni_datum, datum_zahtjeva
INSERT INTO catering_zahtjev VALUES
	(1, 1, 1, NULL, STR_TO_DATE('01.01.2021.', '%d.%m.%Y.'), STR_TO_DATE('15.12.2020.', '%d.%m.%Y.'));

-- id, id_zahtjev, cijena_hrk, datum_izvrsenja, opis, uplaceno
-- cijena_hrk ne dodajemo -> po defaultu ide na 0.00 kn, kasnije se automatski izračuna prilikom inserta u tablicu catering_stavka
INSERT INTO catering (id, id_zahtjev, datum_izvrsenja, opis, uplaceno) VALUES
	(1, 1, STR_TO_DATE('01.01.2021.', '%d.%m.%Y.'), NULL, "D");
    
-- id, id_catering, id_meni, kolicina, cijena_hrk
-- cijena_hrk -> automatski se izračunava
INSERT INTO catering_stavka (id, id_catering, id_meni, kolicina) VALUES
	(1, 1, 1, 10),
    (2, 1, 2, 10);

-- id, id_catering, id_djelatnik
INSERT INTO djelatnici_catering VALUES
	();

-- id, id_dobavljac, opis, iznos_hrk, podmireno, datum
-- iznos_hrk ne dodajemo -> po defaultu ide na 0.00 kn, kasnije se automatski izračuna prilikom inserta u tablicu nabava_stavka
INSERT INTO nabava (id, id_dobavljac, opis, podmireno, datum) VALUES
	(1, 1, "Nabavka 10 orada", "D", STR_TO_DATE('01.01.2021.', '%d.%m.%Y.'));

-- id, id_nabava, id_namirnica, kolicina, cijena_hrk
INSERT INTO nabava_stavka VALUES
	(1, 1, 1, 10, 250.00);

-- id, datum, opis
INSERT INTO otpis VALUES
	();

-- id, id_otpis, id_namirnica, kolicina
INSERT INTO otpis_stavka VALUES
	();

-- id, naziv
INSERT INTO kategorija_rezije VALUES
	(1, "struja");

-- id, iznos_hrk, datum, id_kategorija, placeno
INSERT INTO rezije VALUES
	(1, 5000.00, STR_TO_DATE('01.05.2021.', '%d.%m.%Y.'), 1, "D");

-- id, naziv, pocetak_radnog_vremena, kraj_radnog_vremena
INSERT INTO smjena VALUES
	(1, "kuhinja - prijepodne", "07:00", "15:00"),
    (2, "kuhinja - poslijepodne", "15:00", "23:00");

-- id, id_djelatnik, id_smjena, datum
INSERT INTO djelatnik_smjena VALUES
	();

-- id, id_gost, id_adresa, datum, cijena_hrk, izvrsena
-- cijena_hrk ne dodajemo -> po defaultu ide na 0.00 kn, kasnije se automatski izračuna prilikom inserta u tablicu dostava_stavka
INSERT INTO dostava (id, id_gost, id_adresa, datum, izvrsena) VALUES
	(1, 31, 22, STR_TO_DATE('01.05.2021.', '%d.%m.%Y.'), "D");

-- id, id_dostava, id_meni, kolicina, cijena_hrk
-- cijena_hrk ne dodajemo -> automatski se izračunava
INSERT INTO dostava_stavka (id, id_dostava, id_meni, kolicina) VALUES
	(1, 1, 1, 2);







    
    
    
    
    
    
    
    
    
    