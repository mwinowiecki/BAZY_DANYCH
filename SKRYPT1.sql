--################### UTWORZENIE BAZY DANYCH ##########################

CREATE DATABASE firma_spedycyjna;

--####################### TWORZENIE TABEL #############################

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME='zamowienie')
DROP TABLE zamowienie;
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME='faktura')
DROP TABLE faktura;
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME='pojazd')
DROP TABLE pojazd;
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME='typ_pojazdu')
DROP TABLE typ_pojazdu;
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME='pracownik')
DROP TABLE pracownik;
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME='filia')
DROP TABLE filia;
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME='stanowisko')
DROP TABLE stanowisko;
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME='adres_docelowy')
DROP TABLE adres_docelowy;
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME='klient')
DROP TABLE klient;
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME='adres')
DROP TABLE adres;

GO

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
INSERT INTO adres_docelowy VALUES ('MARIAN','KOSMOS','KOCHANOWSKIEGO','14','GDANSK','80-200');


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
INSERT INTO faktura VALUES (6,1,2,75,123.52,0.23,123.52*1.23,'2009-09-24','2009-09-26');

--TAB zamowienie
INSERT INTO zamowienie VALUES(4,1);
INSERT INTO zamowienie VALUES(2,2);
INSERT INTO zamowienie VALUES(1,3);

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
JOIN typ_pojazdu t ON t.idtyp_pojazdu=po.idtyp_pojazdu
ORDER BY p.nazwisko, p.imie;
GO

--1) widok 1
-- DO JAKIEGO MIASTA I ILE RAZY REALIZOWANO USLUGE TRANSPORTU
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.VIEWS WHERE TABLE_NAME='ile_miasto')
DROP VIEW ile_miasto;
GO

CREATE VIEW ile_miasto AS
SELECT ad.miejscowosc, COUNT(ad.miejscowosc) AS 'ile_razy'
FROM klient k JOIN faktura f ON k.idklient=f.idklient
JOIN adres_docelowy ad ON ad.idadres_docelowy=f.idadres_docelowy
GROUP BY ad.miejscowosc;
GO

SELECT * FROM ile_miasto WHERE ile_razy>1;
GO

--2) widok 2
-- DANE PRACOWNIKA I SAMOCHODU Z NAJDLUZSZYM WYKONANYM POJEDYNCZYM ZADANIEM
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.VIEWS WHERE TABLE_NAME='najdalej')
DROP VIEW najdalej;
GO

CREATE VIEW najdalej AS
SELECT p.imie, p.nazwisko, p.PESEL, s.stanowisko, po.marka, po.model, po.nr_rej, t.typ, f.dystans_km AS 'dystans'
FROM pracownik p JOIN stanowisko s ON p.idstanowisko=s.idstanowisko
JOIN faktura f ON p.idpracownik=f.idpracownik
JOIN zamowienie z ON z.idfaktura=f.idfaktura 
JOIN pojazd po ON po.idpojazd=z.idpojazd
JOIN typ_pojazdu t ON t.idtyp_pojazdu=po.idtyp_pojazdu
GROUP BY p.imie, p.nazwisko, p.PESEL, s.stanowisko, po.marka, po.model, po.nr_rej, t.typ, f.dystans_km
HAVING f.dystans_km>0;
GO

SELECT * FROM najdalej 
WHERE dystans = (SELECT MAX(dystans) FROM najdalej);
GO

--3) funkcja 1

--4) funkcja 2

--5) funkcja 3

--6) funkcja 4

--7) procedura 1
-- PROCEDURA DODAWANIA NOWEGO PRACOWNIKA (NIE TRZEBA PAMIETAC id OSTATNIEGO ADRESU W TABELI adres)
IF EXISTS(SELECT * FROM SYS.objects WHERE type='P' AND name='dodaj_prac')
DROP PROCEDURE dodaj_prac;
GO
CREATE PROCEDURE dodaj_prac 
  @imie VARCHAR(20), @nazw VARCHAR(30), @PESEL CHAR(11), @ulica VARCHAR(30), @nr_domu VARCHAR(10), @miasto VARCHAR(30), @kod_pocz CHAR(6), @idfilia INT, 
	@idstanowisko INT
AS
	INSERT INTO adres VALUES(@ulica,@nr_domu,@miasto,@kod_pocz)
	DECLARE @max_id_adr INT
	SET @max_id_adr=(SELECT MAX(idadres) FROM adres)
	INSERT INTO pracownik VALUES (@idfilia,@max_id_adr,@idfilia,@imie,@nazw,@PESEL);
GO

EXECUTE dodaj_prac 'MARCIN','WOLNY','8456365459','SZYBKA','15C','BLISKIE','66-856',2,3;
GO

SELECT * FROM pracownik;
GO

--8) procedura 2
-- NOWE ZAMOWIENIE (TWORZENIE NOWEJ FAKTURY)
IF EXISTS(SELECT * FROM SYS.objects WHERE type='P' AND name='nowe_zamowienie')
DROP PROCEDURE nowe_zamowienie;
GO

CREATE PROCEDURE nowe_zamowienie
	@cel_imie VARCHAR(20), @cel_naz VARCHAR(30), @cel_ul VARCHAR(30), @cel_nr VARCHAR(10), @cel_miej VARCHAR(30), @cel_kodp CHAR(6),
	@idprac INT, @k_imie VARCHAR(20), @k_naz VARCHAR(30), @k_pesel CHAR(11), @k_nip CHAR(10), @k_ulica VARCHAR(30), 
	@k_nr VARCHAR(10), @k_miej VARCHAR(30), @k_kodp CHAR(6),
	@dystans INT, @cena FLOAT, @vat FLOAT, @data_wyj DATETIME, @data_przyj DATETIME,
	@idpoj INT	
AS
	INSERT INTO adres_docelowy VALUES (@cel_imie,@cel_naz,@cel_ul,@cel_nr,@cel_miej,@cel_kodp)
	DECLARE @max_adr_doc INT
	SET @max_adr_doc = (SELECT MAX(idadres_docelowy) FROM adres_docelowy)
	
	INSERT INTO adres VALUES (@k_ulica,@k_nr,@k_miej,@k_kodp)
	
	DECLARE @max_k_adr INT
	SET @max_k_adr=(SELECT MAX(idadres) FROM adres)	
	INSERT INTO klient VALUES (@max_k_adr,@k_imie,@k_naz,@k_pesel,@k_nip)
	
	DECLARE @max_id_k INT
	SET @max_id_k = (SELECT MAX(idklient) FROM klient)	
	
	INSERT INTO faktura VALUES (@max_adr_doc,@idprac,@max_id_k,@dystans,@cena,@vat,@cena*(@vat+1),@data_wyj,@data_przyj)
	
	DECLARE @max_id_fak INT
	SET @max_id_fak = (SELECT MAX(idfaktura) FROM faktura)
	
	INSERT INTO zamowienie VALUES (@idpoj,@max_id_fak)
GO

EXECUTE nowe_zamowienie 'MARIAN','ZUK','PUSTA','10/3','ILAWA','80-632',5,'MICHAL','KTOPYTAL',
		84032512532,NULL,'CICHA','3','UJSCIE','12-345',260,400,0.23,'2010-10-23','2010-10-25',3
GO

--9) procedura 3
--DODAWANIE NOWEGO SAMOCHODU
IF EXISTS (SELECT * FROM sys.objects WHERE type='P' AND name='dodaj_sam')
DROP PROCEDURE dodaj_sam;
GO

CREATE PROCEDURE dodaj_sam
	@marka VARCHAR(20), @model VARCHAR(20), @nr_rej VARCHAR(10), @typ VARCHAR(20), @cena_netto_km MONEY, 
	@opis VARCHAR(50)
AS
	INSERT INTO typ_pojazdu VALUES (@typ,@cena_netto_km,@opis)
	
	DECLARE @max_idtyp INT
	SET @max_idtyp = (SELECT MAX(idtyp_pojazdu) FROM typ_pojazdu)
	
	INSERT INTO pojazd VALUES (@max_idtyp,@marka,@model,@nr_rej)
GO

EXECUTE dodaj_sam 'FIAT','DUCATO','WE 62345','DOSTAWCZY',6.5,'POJAZD O DMC 3,5T'
GO

--10) procedura 4
--ZWIEKSZANIE PENSJI NA DANYM STANOWISKU (O JAKIS PROCENT)
IF EXISTS (SELECT * FROM sys.objects WHERE type='P' AND name='zwieksz_pensje')
DROP PROCEDURE zwieksz_pensje;
GO

CREATE PROCEDURE zwieksz_pensje
	@id_stan INT, @ile_proc FLOAT
AS
	DECLARE @proc FLOAT
	SET @proc=(@ile_proc/100)+1
	UPDATE stanowisko SET pensja_netto=pensja_netto*@proc WHERE idstanowisko=@id_stan
GO

EXECUTE zwieksz_pensje 2,10.0;	-- ZWIEKSZAMY PENSJE NA STANOWISKU Z id = 2 O 10 PROCENT 

SELECT * FROM stanowisko;

--11) wyzwalacz 1
--WYZWALACZ DO PROCEDURY dodaj_sam
IF EXISTS (SELECT * FROM sys.objects WHERE type='TR' AND name='dodano_samochod')
DROP TRIGGER dodano_samochod;
GO

CREATE TRIGGER dodano_samochod ON pojazd
AFTER INSERT
AS
BEGIN
	DECLARE @id INT
	SET @id = (SELECT MAX(idpojazd) FROM pojazd)
	
	PRINT 'DODANO NOWY SAMOCHOD!'
	SELECT * FROM pojazd WHERE idpojazd=@id
END
GO
	
EXECUTE dodaj_sam 'RENAULT','KANGOO','WE 96325','OSOBOWY',1.5,'PRZEWOZ OSOB I DROBNYCH TOWAROW'
GO

--12) wyzwalacz 2
IF EXISTS (SELECT * FROM sys.objects WHERE type='TR' AND name='duplikat_adresu')
DROP TRIGGER duplikat_adresu;
GO
--DOPRACOWAC...
CREATE TRIGGER duplikat_adresu ON adres
INSTEAD OF INSERT
AS
BEGIN
	SET NOCOUNT ON
	IF NOT EXISTS (SELECT a.ulica, a.nr_domu, a.miejscowosc, a.kod_poczt
		FROM adres a, inserted i
		WHERE a.ulica=i.ulica AND a.nr_domu=i.nr_domu AND a.miejscowosc=i.miejscowosc
			AND a.kod_poczt=i.kod_poczt)
		INSERT INTO adres
			SELECT ulica,nr_domu,miejscowosc,kod_poczt
			FROM inserted
	ELSE
		DECLARE @id INT
		SET @id = (SELECT a.idadres FROM adres a, inserted i 
					WHERE a.ulica=i.ulica AND a.nr_domu=i.nr_domu AND a.miejscowosc=i.miejscowosc
					AND a.kod_poczt=i.kod_poczt)
		
		PRINT 'DUPLIKAT ADRESU'
		RAISERROR('NIE MOZNA DODAC NOWEGO ADRESU!',1,2) 
		ROLLBACK	
END
GO

INSERT INTO adres VALUES('CEGIELNIANA','6A/1','TUCHOLA','89-501')

SELECT * FROM adres;

--13) wyzwalacz 3
--WYZWALACZ WYSWIETLAJACY ZMODYFIKOWANE WIERSZE PO ZMIANIE DANYCH KLIENTA
--DZIEKI NIEMU WIEMY CO SIE ZMIENILO I Z CZEGO, WIEC NIE BEDZIE 
IF EXISTS (SELECT * FROM sys.objects WHERE type='TR' AND name = 'zmiana_danych')
DROP TRIGGER zmiana_danych;
GO

CREATE TRIGGER zmiana_danych ON klient
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
	SELECT 'ZMODYFIKOWANO WIERSZY: '+STR(@@ROWCOUNT)
	SELECT 'USUNIETO WIERSZE: '
	SELECT * FROM deleted
	SELECT 'DODANO WIERSZE: '
	SELECT * FROM inserted
END
GO

UPDATE klient SET imie='WOJTEK' WHERE idklient=1;

--14) wyzwalacz 4

--15) pivot 1

--16) pivot 2

