--DROP TABLE adres_docelowy;

CREATE TABLE adres (
  idadres INT IDENTITY(1,1) PRIMARY KEY,
  ulica VARCHAR NOT NULL,
  nr_domu VARCHAR NOT NULL,
  miejscowosc VARCHAR NOT NULL,
  kod_poczt CHAR(6) NOT NULL,
);

CREATE TABLE adres_docelowy (
  idadres_docelowy INT IDENTITY(1,1) PRIMARY KEY,
  imie VARCHAR NOT NULL,
  nazwisko VARCHAR NOT NULL,
  ulica VARCHAR NOT NULL,
  nr_domu VARCHAR NOT NULL,
  miejscowosc VARCHAR NOT NULL,
  kod_pocz CHAR(6) NOT NULL,
);

CREATE TABLE klient (
  idklient INT IDENTITY(1,1) PRIMARY KEY,
  idadres INT CONSTRAINT idadres_fk FOREIGN KEY(idadres) REFERENCES adres(idadres),
  imie VARCHAR NOT NULL,
  nazwisko VARCHAR NOT NULL,
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
  marka VARCHAR NOT NULL,
  model VARCHAR NOT NULL,
  nr_rej VARCHAR UNIQUE NOT NULL
);

CREATE TABLE stanowisko (
  idstanowisko INT IDENTITY(1,1) PRIMARY KEY,
  stanowisko VARCHAR NOT NULL,
  pensja MONEY NOT NULL,
  opis VARCHAR(50) CHECK(LEN(opis)>10) NOT NULL,
);

CREATE TABLE pracownik (
  idpracownik INT IDENTITY(1,1) PRIMARY KEY,
  idfilia INT CONSTRAINT idfilia_fk FOREIGN KEY(idfilia) REFERENCES filia(idfilia),
  idadres INT CONSTRAINT idadres_pracow_fk FOREIGN KEY(idadres) REFERENCES adres(idadres),
  idstanowisko INT CONSTRAINT idstanowisko_fk FOREIGN KEY(idstanowisko) REFERENCES stanowisko(idstanowisko),
  imie VARCHAR NOT NULL,
  nazwisko VARCHAR NOT NULL,
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
  data_przyjazdu DATETIME NOT NULL
);

SELECT GETDATE();

ALTER TABLE faktura ADD CONSTRAINT sprawdz_date CHECK(data_przyjazdu>=data_wyjazdu);

CREATE TABLE zamowienie (
  idpojazd INT CONSTRAINT idpojazd_fk FOREIGN KEY(idpojazd) REFERENCES pojazd(idpojazd),
  idfaktura INT CONSTRAINT idfaktura_fk FOREIGN KEY(idfaktura) REFERENCES faktura(idfaktura)
);


--#####################################################################################


SET IDENTITY_INSERT faktura ON;

INSERT INTO faktura(idfaktura,idadres_docelowy,idpracownik,idklient,dystans_km,cena_razem_netto,stawka_VAT,cena_razem_brutto,data_wyjazdu,data_przyjazdu) 
VALUES (2,NULL,NULL,NULL,10,15,0.23,15*1.23,'2005-10-13','2005-10-15');

SET IDENTITY_INSERT faktura OFF;

SELECT * FROM faktura;

DELETE FROM faktura;
--SELECT 'ALTER TABLE ' + so.TABLE_NAME + ' DROP CONSTRAINT ' + so.CONSTRAINT_NAME FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS so; 

--ALTER TABLE faktura DROP CONSTRAINT PK__faktura__0065E14F43F60EC8;
--ALTER TABLE faktura DROP CONSTRAINT CK__faktura__dystans__48BAC3E5;

--ALTER TABLE faktura DROP CONSTRAINT idadr_doc_fk;
--ALTER TABLE faktura DROP CONSTRAINT idpracownik_fk;
--ALTER TABLE faktura DROP CONSTRAINT idklient_fk;

DROP TABLE faktura;



--ALTER TABLE zamowienie DROP CONSTRAINT idfaktura_fk;
--ALTER TABLE zamowienie ADD CONSTRAINT idfaktura_fk FOREIGN KEY(idfaktura) REFERENCES faktura(idfaktura);

SELECT * FROM klient;
SELECT * FROM pracownik;
SELECT * FROM faktura;
