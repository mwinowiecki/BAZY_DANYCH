--################### UTWORZENIE BAZY DANYCH ##########################

CREATE DATABASE firma_spedycyjna;

--####################### TWORZENIE TABEL #############################

CREATE TABLE adres (
  idadres INT IDENTITY(1,1) PRIMARY KEY,
  ulica VARCHAR(30) NOT NULL,
  nr_domu VARCHAR(10) NOT NULL,
  miejscowosc VARCHAR(30) NOT NULL,
  kod_poczt CHAR(6) NOT NULL,
);

CREATE TABLE adres_docelowy (
  idadres_docelowy INT IDENTITY(1,1) PRIMARY KEY,
  imie VARCHAR(20) NOT NULL,
  nazwisko VARCHAR(30) NOT NULL,
  ulica VARCHAR(30) NOT NULL,
  nr_domu VARCHAR(10) NOT NULL,
  miejscowosc VARCHAR(30) NOT NULL,
  kod_pocz CHAR(6) NOT NULL,
);

CREATE TABLE klient (
  idklient INT IDENTITY(1,1) PRIMARY KEY,
  idadres INT CONSTRAINT idadres_fk FOREIGN KEY(idadres) REFERENCES adres(idadres),
  imie VARCHAR(20) NOT NULL,
  nazwisko VARCHAR(30) NOT NULL,
  PESEL CHAR(11) UNIQUE NOT NULL,
  NIP CHAR(10) UNIQUE
);

CREATE TABLE filia (
  idfilia INT IDENTITY(1,1) PRIMARY KEY,
  idadres INT CONSTRAINT idadres_filii_fk FOREIGN KEY(idadres) REFERENCES adres(idadres)
);

CREATE TABLE typ_pojazdu (
  idtyp_pojazdu INT IDENTITY(1,1) PRIMARY KEY,
  typ VARCHAR(20) NOT NULL,
  cena_netto_km MONEY NOT NULL,
  opis VARCHAR(50) CHECK(LEN(opis)>10) NOT NULL,
);

CREATE TABLE pojazd (
  idpojazd INT IDENTITY(1,1) PRIMARY KEY,
  idtyp_pojazdu INT CONSTRAINT idtyp_pojazdu_fk FOREIGN KEY(idtyp_pojazdu) REFERENCES typ_pojazdu(idtyp_pojazdu),
  marka VARCHAR(20) NOT NULL,
  model VARCHAR(20) NOT NULL,
  nr_rej VARCHAR(10) UNIQUE NOT NULL
);

CREATE TABLE stanowisko (
  idstanowisko INT IDENTITY(1,1) PRIMARY KEY,
  stanowisko VARCHAR(15) NOT NULL,
  pensja MONEY NOT NULL,
  opis VARCHAR(50) CHECK(LEN(opis)>10) NOT NULL,
);

CREATE TABLE pracownik (
  idpracownik INT IDENTITY(1,1) PRIMARY KEY,
  idfilia INT CONSTRAINT idfilia_fk FOREIGN KEY(idfilia) REFERENCES filia(idfilia),
  idadres INT CONSTRAINT idadres_pracow_fk FOREIGN KEY(idadres) REFERENCES adres(idadres),
  idstanowisko INT CONSTRAINT idstanowisko_fk FOREIGN KEY(idstanowisko) REFERENCES stanowisko(idstanowisko),
  imie VARCHAR(20) NOT NULL,
  nazwisko VARCHAR(30) NOT NULL,
  PESEL CHAR(11) UNIQUE NOT NULL,
);

CREATE TABLE faktura (
  idfaktura INT IDENTITY(1,1) PRIMARY KEY,
  idadres_docelowy INT CONSTRAINT idadr_doc_fk FOREIGN KEY(idadres_docelowy) REFERENCES adres_docelowy(idadres_docelowy),
  idpracownik INT CONSTRAINT idpracownik_fk FOREIGN KEY(idpracownik) REFERENCES pracownik(idpracownik),
  idklient INT CONSTRAINT idklient_fk FOREIGN KEY(idklient) REFERENCES klient(idklient),
  dystans_km INT NOT NULL CHECK(dystans_km>0),
  cena_razem_netto MONEY NOT NULL,
  stawka_VAT FLOAT NOT NULL,
  cena_razem_brutto MONEY NOT NULL,
  data_wyjazdu DATETIME NOT NULL,
  data_przyjazdu DATETIME NOT NULL,
  CONSTRAINT spr_date CHECK(data_przyjazdu>=data_wyjazdu)
);

CREATE TABLE zamowienie (
  idpojazd INT CONSTRAINT idpojazd_fk FOREIGN KEY(idpojazd) REFERENCES pojazd(idpojazd),
  idfaktura INT CONSTRAINT idfaktura_fk FOREIGN KEY(idfaktura) REFERENCES faktura(idfaktura)
);

--######################### WPISYWANIE DANYCH #########################

--### TAB adres ###
INSERT INTO adres VALUES ('SLONECZNA','4B/15','SADKI','89-110');
INSERT INTO adres VALUES ('POZIOMKOWA','5','CZERSK','89-560');
INSERT INTO adres VALUES ('MALINOWA','8','CHOJNICE','89-600');
INSERT INTO adres VALUES ('BOHATEROW WESTERPLATTE','3','TUCHOLA','89-501');
INSERT INTO adres VALUES ('CEGIELNIANA','6A/8','TUCHOLA','89-501');
INSERT INTO adres VALUES ('KORONOWSKA','9','BYDGOSZCZ','85-405');


--### TAB adres_docelowy
INSERT INTO adres_docelowy VALUES ('JAN','KOWALSKI','GRUNWALDZKA','146','GDANSK','80-264');
INSERT INTO adres_docelowy VALUES ('MAREK','MARECKI','ULICZNA','23','WARSZAWA','05-077');
INSERT INTO adres_docelowy VALUES ('ANNA','NOWAK','DWORCOWA','2','SZCZECINEK','78-410');
INSERT INTO adres_docelowy VALUES ('PELAGIA','STOLARZ','KONSTYTUCJI 3 MAJA','10','TORUN','87-120');
INSERT INTO adres_docelowy VALUES ('GENOWEFA','PIGWA','AKACJOWA','5','KRAKOW','31-466');

--### TAB klient
INSERT INTO klient VALUES (1,'STEFAN','BURCZYMUCHA','90052443528','5934168314');
INSERT INTO klient VALUES (2,'KUNEGUNDA','TRAWKA','64111236829','6854235129');
INSERT INTO klient VALUES (3,'JADWIGA','KONIECZNA','53052945865','5746325684');
INSERT INTO klient VALUES (4,'MARIANNA','WELON','86012363547','5712365485');
INSERT INTO klient VALUES (5,'ZENON','INTERES','70022636894','9645232156');

--### TAB filia
INSERT INTO filia VALUES (6);
INSERT INTO filia VALUES (3);

--update adres set miejscowosc=UPPER(miejscowosc);
--######################## WYSWIETLENIE TABEL #########################

SELECT * FROM adres;
SELECT * FROM adres_docelowy;
SELECT * FROM klient;
SELECT * FROM filia;
SELECT * FROM typ_pojazdu;
SELECT * FROM pojazd;
SELECT * FROM stanowisko;
SELECT * FROM pracownik;
SELECT * FROM faktura;
SELECT * FROM zamowienie;

--SELECT * FROM filia JOIN adres ON filia.idadres=adres.idadres;
--DBCC CHECKIDENT ( adres,RESEED,0);
