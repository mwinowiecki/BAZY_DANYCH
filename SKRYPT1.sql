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
  PESEL CHAR(6) UNIQUE NOT NULL,
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
  nr_rej VARCHAR UNIQUE NOT NULL
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
  PESEL CHAR(6) UNIQUE NOT NULL,
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

INSERT INTO adres(ulica,nr_domu,miejscowosc,kod_poczt) 
VALUES ('Sloneczna','4b/15','Sadki','56-632');

INSERT INTO adres VALUES ('Poziomkowa','5','Czersk','89-560');


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
