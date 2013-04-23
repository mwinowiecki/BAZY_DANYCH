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
  stanowisko VARCHAR(25) NOT NULL,
  pensja_netto MONEY NOT NULL,
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
  idfaktura INT CONSTRAINT idfaktura_fk FOREIGN KEY(idfaktura) REFERENCES faktura(idfaktura),
  CONSTRAINT zamowienie_pk PRIMARY KEY(idpojazd,idfaktura)
);

--######################### WPISYWANIE DANYCH #########################

--### TAB adres ###
INSERT INTO adres VALUES ('SLONECZNA','4B/15','SADKI','89-110');
INSERT INTO adres VALUES ('POZIOMKOWA','5','CZERSK','89-560');
INSERT INTO adres VALUES ('MALINOWA','8','CHOJNICE','89-600');
INSERT INTO adres VALUES ('BOHATEROW WESTERPLATTE','3','TUCHOLA','89-501');
INSERT INTO adres VALUES ('CEGIELNIANA','6A/8','TUCHOLA','89-501');
INSERT INTO adres VALUES ('KORONOWSKA','9','BYDGOSZCZ','85-405');
INSERT INTO adres VALUES ('UCZNIOWSKA','4','GDANSK','80-530');

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

--### TAB typ_pojazdu
INSERT INTO typ_pojazdu VALUES ('BUS',1,'PRZEWOZ DO 8 OSOB');
INSERT INTO typ_pojazdu VALUES ('DOSTAWCZY',2.5,'PRZEWOZ TOWAROW');
INSERT INTO typ_pojazdu VALUES ('CIEZAROWY',8,'PRZEWOZ DUZYCH TOWAROW');

--### TAB pojazd
INSERT INTO pojazd VALUES (1,'VOLKSWAGEN','TRANSPORTER','WE A567C');
INSERT INTO pojazd VALUES (2,'OPEL','VIVARO','WX 78645');
INSERT INTO pojazd VALUES (2,'FIAT','DUCATO','WE 80365');
INSERT INTO pojazd VALUES (3,'SCANIA','R420','WY 54564');
INSERT INTO pojazd VALUES (3,'MERCEDES','ACTROS','WY 88893');

--### TAB stanowisko
INSERT INTO stanowisko VALUES ('KIEROWCA CIEZAROWY',3800,'PRAWO JAZDY KAT. B, KAT.C+E');
INSERT INTO stanowisko VALUES ('KIEROWCA SAM. DOSTAW.',3000,'PRAWO JAZDY KAT. B+E');
INSERT INTO stanowisko VALUES ('KIEROWCA SAM. DO 3,5T',2800,'PRAWO JAZDY KAT. B');
INSERT INTO stanowisko VALUES ('KSIEGOWY',5500,'PELNA KSIEGOWOSC');
INSERT INTO stanowisko VALUES ('OBSLUGA ZAMOWIEN',2500,'ODBIOR ZAMOWIEN OD KLIENTOW');

--TAB pracownik
INSERT INTO pracownik VALUES (1,4,1,'ZENON','WELON','83061152338');
INSERT INTO pracownik VALUES (2,6,4,'AGATA','MALYSZ','84032168446');
INSERT INTO pracownik VALUES (1,7,5,'WALDEMAR','PAWLAK','69121445298');
INSERT INTO pracownik VALUES (1,2,1,'DONALD','TRAWKA','65071538457');

--TAB faktura
INSERT INTO faktura VALUES (1,1,1,153,200,0.23,200*1.23,'2005-03-15','2005-03-18');
INSERT INTO faktura VALUES (5,4,3,30,50,0.23,50*1.23,'2009-09-21','2009-09-22');

--TAB zamowienie
INSERT INTO zamowienie VALUES(4,1);
INSERT INTO zamowienie VALUES(2,2);

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

--### SAMOCHODY
SELECT p.marka, p.model, p.nr_rej, t.typ, t.cena_netto_km, t.opis
FROM pojazd p JOIN typ_pojazdu t ON p.idtyp_pojazdu=t.idtyp_pojazdu
ORDER BY p.marka, p.model;

--### MIEJSCA PRACY PRACOWNIKOW
SELECT p.imie, p.nazwisko, a.ulica, a.nr_domu, a.miejscowosc
FROM pracownik p JOIN filia f ON p.idfilia=f.idfilia
JOIN adres a ON f.idadres=a.idadres
ORDER BY p.nazwisko, p.imie;

--### ADRESY ZAMIESZKANIA KLIENTOW
SELECT k.imie, k.nazwisko, k.PESEL, a.ulica, a.nr_domu, a.miejscowosc
FROM klient k JOIN adres a ON k.idadres=a.idadres
ORDER BY k.nazwisko, k.imie;

--### UTWORZONE FAKTURY
SELECT k.imie, k.nazwisko, ad.imie, ad.nazwisko, ad.ulica, ad.nr_domu, ad.miejscowosc, f.dystans_km, f.dystans_km, f.cena_razem_brutto
FROM klient k JOIN faktura f ON k.idklient=f.idklient
JOIN adres_docelowy ad ON ad.idadres_docelowy=f.idadres_docelowy
ORDER BY k.nazwisko, k.imie;

--### KTORY PRACOWNIK UZYWAL DANEGO POJAZDU
SELECT p.imie, p.nazwisko, p.PESEL, s.stanowisko, s.opis, s.pensja_netto, po.marka, po.model, po.nr_rej, t.typ, t.opis
FROM pracownik p JOIN stanowisko s ON p.idstanowisko=s.idstanowisko
JOIN faktura f ON p.idpracownik=f.idpracownik
JOIN zamowienie z ON z.idfaktura=f.idfaktura 
JOIN pojazd po ON po.idpojazd=z.idpojazd
JOIN typ_pojazdu t ON t.idtyp_pojazdu=po.idtyp_pojazdu;

--update adres set miejscowosc=UPPER(miejscowosc);
--SELECT * FROM filia JOIN adres ON filia.idadres=adres.idadres;
--DBCC CHECKIDENT (FAKTURA,RESEED,0);
