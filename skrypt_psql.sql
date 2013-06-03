-- Database: "firma_sped"

-- DROP DATABASE "firma_sped";

CREATE DATABASE firma_sped;

CREATE TABLE adres (
  idadres serial PRIMARY KEY,
  ulica VARCHAR(30) NOT NULL,
  nr_domu VARCHAR(10) NOT NULL,
  miejscowosc VARCHAR(30) NOT NULL,
  kod_poczt CHAR(6) NOT NULL 
);

CREATE TABLE adres_docelowy (
  idadres_docelowy serial PRIMARY KEY,
  imie VARCHAR(20) NOT NULL,
  nazwisko VARCHAR(30) NOT NULL,
  ulica VARCHAR(30) NOT NULL,
  nr_domu VARCHAR(10) NOT NULL,
  miejscowosc VARCHAR(30) NOT NULL,
  kod_pocz CHAR(6) NOT NULL
);

CREATE TABLE klient (
  idklient serial PRIMARY KEY,
  idadres INT,
  CONSTRAINT idadres_fk FOREIGN KEY(idadres) REFERENCES adres(idadres) MATCH SIMPLE 
  ON UPDATE NO ACTION ON DELETE NO ACTION,
  imie VARCHAR(20) NOT NULL,
  nazwisko VARCHAR(30) NOT NULL,
  PESEL CHAR(11) UNIQUE NOT NULL,
  NIP CHAR(10) UNIQUE
);

CREATE TABLE filia (
  idfilia serial PRIMARY KEY,
  idadres INT,
  CONSTRAINT idadres_filii_fk FOREIGN KEY(idadres) REFERENCES adres(idadres) MATCH SIMPLE
  ON UPDATE NO ACTION ON DELETE NO ACTION
);

CREATE TABLE typ_pojazdu (
  idtyp_pojazdu serial PRIMARY KEY,
  typ VARCHAR(20) NOT NULL,
  cena_netto_km MONEY NOT NULL,
  opis VARCHAR(50) CHECK(LENGTH(opis)>10) NOT NULL
);

CREATE TABLE pojazd (
  idpojazd serial PRIMARY KEY,
  idtyp_pojazdu INT,
  CONSTRAINT idtyp_pojazdu_fk FOREIGN KEY(idtyp_pojazdu) REFERENCES typ_pojazdu(idtyp_pojazdu) MATCH SIMPLE
  ON UPDATE NO ACTION ON DELETE NO ACTION,
  marka VARCHAR(20) NOT NULL,
  model VARCHAR(20) NOT NULL,
  nr_rej VARCHAR(10) UNIQUE NOT NULL
);

CREATE TABLE stanowisko (
  idstanowisko serial PRIMARY KEY,
  stanowisko VARCHAR(25) NOT NULL,
  pensja_netto MONEY NOT NULL,
  opis VARCHAR(50) CHECK(LENGTH(opis)>10) NOT NULL
);

CREATE TABLE pracownik (
  idpracownik serial PRIMARY KEY,
  idfilia INT,
  CONSTRAINT idfilia_fk FOREIGN KEY(idfilia) REFERENCES filia(idfilia) MATCH SIMPLE
  ON UPDATE NO ACTION ON DELETE NO ACTION,

  idadres INT,
  CONSTRAINT idadres_pracow_fk FOREIGN KEY(idadres) REFERENCES adres(idadres) MATCH SIMPLE
  ON UPDATE NO ACTION ON DELETE NO ACTION,

  idstanowisko INT,
  CONSTRAINT idstanowisko_fk FOREIGN KEY(idstanowisko) REFERENCES stanowisko(idstanowisko) MATCH SIMPLE
  ON UPDATE NO ACTION ON DELETE NO ACTION,
  imie VARCHAR(20) NOT NULL,
  nazwisko VARCHAR(30) NOT NULL,
  PESEL CHAR(11) UNIQUE NOT NULL
);

CREATE TABLE faktura (
  idfaktura serial PRIMARY KEY,
  idadres_docelowy INT,
  CONSTRAINT idadr_doc_fk FOREIGN KEY(idadres_docelowy) REFERENCES adres_docelowy(idadres_docelowy) MATCH SIMPLE
  ON UPDATE NO ACTION ON DELETE NO ACTION,

  idpracownik INT,
  CONSTRAINT idpracownik_fk FOREIGN KEY(idpracownik) REFERENCES pracownik(idpracownik) MATCH SIMPLE
  ON UPDATE NO ACTION ON DELETE CASCADE,

  idklient INT,
  CONSTRAINT idklient_fk FOREIGN KEY(idklient) REFERENCES klient(idklient) MATCH SIMPLE
  ON UPDATE NO ACTION ON DELETE NO ACTION,
  dystans_km INT NOT NULL CHECK(dystans_km>0),
  cena_razem_netto MONEY NOT NULL,
  stawka_VAT FLOAT NOT NULL,
  cena_razem_brutto MONEY NOT NULL,
  data_wyjazdu DATE NOT NULL,
  data_przyjazdu DATE NOT NULL,
  CONSTRAINT spr_date CHECK(data_przyjazdu>=data_wyjazdu)
);

CREATE TABLE zamowienie (
  idpojazd INT,
  CONSTRAINT idpojazd_fk FOREIGN KEY(idpojazd) REFERENCES pojazd(idpojazd) MATCH SIMPLE
  ON UPDATE NO ACTION ON DELETE NO ACTION,

  idfaktura INT,
  CONSTRAINT idfaktura_fk FOREIGN KEY(idfaktura) REFERENCES faktura(idfaktura) MATCH SIMPLE
  ON UPDATE NO ACTION ON DELETE CASCADE,
  CONSTRAINT zamowienie_pk PRIMARY KEY(idpojazd,idfaktura)
);

--######################### WPISYWANIE DANYCH #########################

--### TAB adres
INSERT INTO adres VALUES (1,'SLONECZNA','4B/15','SADKI','89-110');
INSERT INTO adres VALUES (2,'POZIOMKOWA','5','CZERSK','89-560');
INSERT INTO adres VALUES (3,'MALINOWA','8','CHOJNICE','89-600');
INSERT INTO adres VALUES (4,'BOHATEROW WESTERPLATTE','3','TUCHOLA','89-501');
INSERT INTO adres VALUES (5,'CEGIELNIANA','6A/8','TUCHOLA','89-501');
INSERT INTO adres VALUES (6,'KORONOWSKA','9','BYDGOSZCZ','85-405');
INSERT INTO adres VALUES (7,'UCZNIOWSKA','4','GDANSK','80-530');

--### TAB adres_docelowy
INSERT INTO adres_docelowy VALUES (1,'JAN','KOWALSKI','GRUNWALDZKA','146','GDANSK','80-264');
INSERT INTO adres_docelowy VALUES (2,'MAREK','MARECKI','ULICZNA','23','WARSZAWA','05-077');
INSERT INTO adres_docelowy VALUES (3,'ANNA','NOWAK','DWORCOWA','2','SZCZECINEK','78-410');
INSERT INTO adres_docelowy VALUES (4,'PELAGIA','STOLARZ','KONSTYTUCJI 3 MAJA','10','TORUN','87-120');
INSERT INTO adres_docelowy VALUES (5,'GENOWEFA','PIGWA','AKACJOWA','5','KRAKOW','31-466');
INSERT INTO adres_docelowy VALUES (6,'MARIAN','KOSMOS','KOCHANOWSKIEGO','14','GDANSK','80-200');

--### TAB klient
INSERT INTO klient VALUES (1,1,'STEFAN','BURCZYMUCHA','90052443528','5934168314');
INSERT INTO klient VALUES (2,2,'KUNEGUNDA','TRAWKA','64111236829','6854235129');
INSERT INTO klient VALUES (3,3,'JADWIGA','KONIECZNA','53052945865','5746325684');
INSERT INTO klient VALUES (4,4,'MARIANNA','WELON','86012363547','5712365485');
INSERT INTO klient VALUES (5,5,'ZENON','INTERES','70022636894','9645232156');

--### TAB typ_pojazdu
INSERT INTO typ_pojazdu VALUES (1,'BUS',1,'PRZEWOZ DO 8 OSOB');
INSERT INTO typ_pojazdu VALUES (2,'DOSTAWCZY',2.5,'PRZEWOZ TOWAROW');
INSERT INTO typ_pojazdu VALUES (3,'CIEZAROWY',8,'PRZEWOZ DUZYCH TOWAROW');

--### TAB pojazd
INSERT INTO pojazd VALUES (1,1,'VOLKSWAGEN','TRANSPORTER','WE A567C');
INSERT INTO pojazd VALUES (2,2,'OPEL','VIVARO','WX 78645');
INSERT INTO pojazd VALUES (3,2,'FIAT','DUCATO','WE 80365');
INSERT INTO pojazd VALUES (4,3,'SCANIA','R420','WY 54564');
INSERT INTO pojazd VALUES (5,3,'MERCEDES','ACTROS','WY 88893');

--### TAB stanowisko
INSERT INTO stanowisko VALUES (1,'KIEROWCA CIEZAROWY',3800,'PRAWO JAZDY KAT. B, KAT.C+E');
INSERT INTO stanowisko VALUES (2,'KIEROWCA SAM. DOSTAW.',3000,'PRAWO JAZDY KAT. B+E');
INSERT INTO stanowisko VALUES (3,'KIEROWCA SAM. DO 3,5T',2800,'PRAWO JAZDY KAT. B');
INSERT INTO stanowisko VALUES (4,'KSIEGOWY',5500,'PELNA KSIEGOWOSC');
INSERT INTO stanowisko VALUES (5,'OBSLUGA ZAMOWIEN',2500,'ODBIOR ZAMOWIEN OD KLIENTOW');

--###TAB pracownik
INSERT INTO pracownik VALUES (1,1,4,1,'ZENON','WELON','83061152338');
INSERT INTO pracownik VALUES (2,2,6,4,'AGATA','MALYSZ','84032168446');
INSERT INTO pracownik VALUES (3,1,7,5,'WALDEMAR','PAWLAK','69121445298');
INSERT INTO pracownik VALUES (4,1,2,1,'DONALD','TRAWKA','65071538457');

--###TAB faktura
INSERT INTO faktura VALUES (1,1,1,1,153,200,0.23,200*1.23,'2005-03-15','2005-03-18');
INSERT INTO faktura VALUES (2,5,4,3,30,50,0.23,50*1.23,'2009-09-21','2009-09-22');
INSERT INTO faktura VALUES (3,6,1,2,75,123.52,0.23,123.52*1.23,'2009-09-24','2009-09-26');

--###TAB zamowienie
INSERT INTO zamowienie VALUES(4,1);
INSERT INTO zamowienie VALUES(2,2);
INSERT INTO zamowienie VALUES(1,3);

--### SAMOCHODY
SELECT p.marka, p.model, p.nr_rej, t.typ, t.cena_netto_km, t.opis
FROM pojazd p JOIN typ_pojazdu t 
ON p.idtyp_pojazdu=t.idtyp_pojazdu
ORDER BY p.marka, p.model;

--### MIEJSCA PRACY PRACOWNIKOW
SELECT p.imie, p.nazwisko, a.ulica, a.nr_domu, a.miejscowosc
FROM pracownik p JOIN filia f 
ON p.idfilia=f.idfilia JOIN adres a 
ON f.idadres=a.idadres
ORDER BY p.nazwisko, p.imie;

--### ADRESY ZAMIESZKANIA KLIENTOW
SELECT k.imie, k.nazwisko, k.PESEL, a.ulica, a.nr_domu, a.miejscowosc
FROM klient k JOIN adres a 
ON k.idadres=a.idadres
ORDER BY k.nazwisko, k.imie;

--### UTWORZONE FAKTURY
SELECT k.imie, k.nazwisko, ad.imie, ad.nazwisko, ad.ulica, ad.nr_domu, ad.miejscowosc, f.dystans_km, f.dystans_km, f.cena_razem_brutto
FROM klient k JOIN faktura f 
ON k.idklient=f.idklient JOIN adres_docelowy ad 
ON ad.idadres_docelowy=f.idadres_docelowy
ORDER BY k.nazwisko, k.imie;

--### KTORY PRACOWNIK UZYWAL DANEGO POJAZDU
SELECT p.imie, p.nazwisko, p.PESEL, s.stanowisko, s.opis, s.pensja_netto, po.marka, po.model, po.nr_rej, t.typ, t.opis
FROM pracownik p JOIN stanowisko s 
ON p.idstanowisko=s.idstanowisko JOIN faktura f 
ON p.idpracownik=f.idpracownik JOIN zamowienie z 
ON z.idfaktura=f.idfaktura JOIN pojazd po 
ON po.idpojazd=z.idpojazd JOIN typ_pojazdu t 
ON t.idtyp_pojazdu=po.idtyp_pojazdu
ORDER BY p.nazwisko, p.imie;

--1) widok 1
-- DO JAKIEGO MIASTA I ILE RAZY REALIZOWANO USLUGE TRANSPORTU
DROP VIEW IF EXISTS ile_miasto;

CREATE VIEW ile_miasto AS
SELECT ad.miejscowosc, COUNT(ad.miejscowosc) AS ile_razy
FROM klient k JOIN faktura f 
ON k.idklient=f.idklient JOIN adres_docelowy ad 
ON ad.idadres_docelowy=f.idadres_docelowy
GROUP BY ad.miejscowosc;

SELECT * FROM ile_miasto WHERE ile_razy>1;

--2) widok 2
-- DANE PRACOWNIKA I SAMOCHODU Z NAJDLUZSZYM WYKONANYM POJEDYNCZYM ZADANIEM
DROP VIEW IF EXISTS najdalej;

CREATE VIEW najdalej AS
SELECT p.imie, p.nazwisko, p.PESEL, s.stanowisko, po.marka, po.model, po.nr_rej, t.typ, f.dystans_km AS dystans
FROM pracownik p JOIN stanowisko s 
ON p.idstanowisko=s.idstanowisko JOIN faktura f 
ON p.idpracownik=f.idpracownik JOIN zamowienie z 
ON z.idfaktura=f.idfaktura JOIN pojazd po 
ON po.idpojazd=z.idpojazd JOIN typ_pojazdu t 
ON t.idtyp_pojazdu=po.idtyp_pojazdu
GROUP BY p.imie, p.nazwisko, p.PESEL, s.stanowisko, po.marka, po.model, po.nr_rej, t.typ, f.dystans_km
HAVING f.dystans_km>0;

SELECT * FROM najdalej 
WHERE dystans = (SELECT MAX(dystans) FROM najdalej);

--3) funkcja 1
--FUNKCJA PODAJE NAM ILE RAZY DANY KLIENT KORZYSTAL Z NASZYCH USLUG. IM WIECEJ TYM WIEKSZY MOZE DOSTAC RABAT
DROP FUNCTION IF EXISTS akt_klienta(INT);

CREATE FUNCTION akt_klienta(id_klient INT) 
RETURNS INTEGER AS $$
BEGIN
  RETURN (SELECT COUNT(*) FROM klient k	JOIN faktura f 
  ON k.idklient=f.idklient WHERE k.idklient=id_klient);
END;
$$
LANGUAGE 'plpgsql';

SELECT akt_klienta(6) AS ile_transportow;

--4) funkcja 2
--FUNKCJA KTORA WYPISUJE ILOSC TRANSPORTOW WYKONANYCH W DANYM ROKU. 
--PRZYDATNE, GDY CHCEMY SPRAWDZIC JAK PROSPEROWALA FIRMA W POSZCZEGOLNYCH LATACH
DROP FUNCTION IF EXISTS raport_roczny(DATE,DATE);

CREATE FUNCTION raport_roczny(rok_od DATE, rok_do DATE)
RETURNS INTEGER AS $$
BEGIN
  RETURN(SELECT COUNT(*) FROM faktura 
  WHERE data_wyjazdu BETWEEN rok_od AND rok_do);
END;
$$
LANGUAGE 'plpgsql';

SELECT raport_roczny('2009-01-01','2010-01-01') AS ILOSC_WYJAZDOW;

--5) funkcja 3
--FUNKCJA PODAJE NAM SREDNIA DLUGOSC POKONANYCH TRAS
--FIRMA MOZE SPRAWDZAC W JAKIEJ ODLEGLOSCI
DROP FUNCTION IF EXISTS sred_dystans();

CREATE FUNCTION sred_dystans() 
RETURNS FLOAT AS $$
BEGIN
  RETURN(SELECT AVG(dystans_km) FROM faktura);
END;
$$
LANGUAGE 'plpgsql';

SELECT sred_dystans() AS SREDNIA_DLUGOSC_TRASY_km;

--6) funkcja 4
--FUNKCJA PODAJE NAM SUME KILOMETROW PRZEJECHANYCH PRZEZ DANEGO KIEROWCE
DROP FUNCTION IF EXISTS suma_km(INT);

CREATE FUNCTION suma_km(idp INT) 
RETURNS FLOAT AS $$
DECLARE suma FLOAT;
BEGIN		
  suma:=0;
  SELECT suma=suma+f.dystans_km FROM pracownik p JOIN faktura f
  ON p.idpracownik=f.idpracownik WHERE f.idpracownik=idp;
  RETURN suma;
END;
$$
LANGUAGE 'plpgsql';

SELECT suma_km(1) as SUMA_KILOMETROW;       --tu cos do poprawki jest--
