-- Database: "firma_sped"

-- DROP DATABASE "firma_sped";

CREATE DATABASE firma_sped;

DROP TABLE IF EXISTS zamowienie CASCADE;
DROP TABLE IF EXISTSfaktura CASCADE;
DROP TABLE IF EXISTS pojazd CASCADE;
DROP TABLE IF EXISTS typ_pojazdu CASCADE;
DROP TABLE IF EXISTS pracownik CASCADE;
DROP TABLE IF EXISTS filia CASCADE;
DROP TABLE IF EXISTSstanowisko CASCADE;
DROP TABLE IF EXISTS adres_docelowy CASCADE;
DROP TABLE IF EXISTS klient CASCADE;
DROP TABLE IF EXISTS adres CASCADE;

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
RETURNS FLOAT 
AS $$  
DECLARE suma FLOAT;
BEGIN  	
  suma:=0;
  SELECT (f.dystans_km) INTO suma FROM pracownik p JOIN faktura f
  ON p.idpracownik=f.idpracownik WHERE f.idpracownik=idp;
  RETURN suma;
END;
$$
LANGUAGE 'plpgsql';

SELECT suma_km(1) as SUMA_KILOMETROW;



--7) procedura 1
-- PROCEDURA DODAWANIA NOWEGO PRACOWNIKA (NIE TRZEBA PAMIETAC id OSTATNIEGO ADRESU W TABELI adres)
-- NALEZY PODAC DANE W ODPOWIEDNIEJ KOLEJNOSCI, A PROCEDURA SAMA ZADBA O POPRAWNE DODANIE REKORDOW

DROP FUNCTION IF EXISTS dodaj_prac;

CREATE FUNCTION dodaj_prac (INT,TEXT,TEXT,TEXT,TEXT,TEXT,TEXT,TEXT,INT,INT) RETURNS void AS
$$
DECLARE 
  idprac ALIAS FOR $1;
  imie1 ALIAS FOR $2;
  nazw1 ALIAS FOR $3;
  pesel1 ALIAS FOR $4;
  ulica1 ALIAS FOR $5;
  nr1 ALIAS FOR $6;
  miasto1 ALIAS FOR $7;
  kod1 ALIAS FOR $8;
  idfilia1 ALIAS FOR $9;
  idadres1 ALIAS FOR $10;

BEGIN
  INSERT INTO adres(idadres,ulica,nr_domu,miejscowosc,kod_poczt) VALUES (idadres1, ulica1,nr1,miasto1,kod1);
  INSERT INTO pracownik(idpracownik,idfilia,idadres,idstanowisko,imie,nazwisko,PESEL) 
        VALUES (idprac,idfilia1,idadres1,imie1,nazw1,pesel1);
END;
$$ LANGUAGE 'plpgsql';

SELECT dodaj_prac(5,'MARCIN','WOLNY','84563654598','SZYBKA','15C','BLISKIE','66-856',2,3);

SELECT * FROM pracownik;



--8) procedura 2
-- NOWE ZAMOWIENIE (TWORZENIE NOWEJ FAKTURY)
IF EXISTS(SELECT * FROM SYS.objects WHERE type='P' AND 

name='nowe_zamowienie')
DROP PROCEDURE nowe_zamowienie;
GO

CREATE PROCEDURE nowe_zamowienie
	@cel_imie VARCHAR(20), 

@cel_naz VARCHAR(30), @cel_ul VARCHAR(30), @cel_nr VARCHAR(10), @cel_miej VARCHAR(30), @cel_kodp CHAR(6),
	@idprac 

INT, @k_imie VARCHAR(20), @k_naz VARCHAR(30), @k_pesel CHAR(11), @k_nip CHAR(10), @k_ulica VARCHAR(30), 
	@k_nr 

VARCHAR(10), @k_miej VARCHAR(30), @k_kodp CHAR(6),
	@dystans INT, @cena FLOAT, @vat FLOAT, @data_wyj DATETIME, 

@data_przyj DATETIME,
	@idpoj INT	
AS
	INSERT INTO adres_docelowy VALUES 

(@cel_imie,@cel_naz,@cel_ul,@cel_nr,@cel_miej,@cel_kodp)
	DECLARE @max_adr_doc INT
	SET @max_adr_doc = (SELECT 

MAX(idadres_docelowy) FROM adres_docelowy)

	INSERT INTO adres VALUES (@k_ulica,@k_nr,@k_miej,@k_kodp)

	DECLARE 

@max_k_adr INT
	SET @max_k_adr=(SELECT MAX(idadres) FROM adres)	
	INSERT INTO klient VALUES 

(@max_k_adr,@k_imie,@k_naz,@k_pesel,@k_nip)

	DECLARE @max_id_k INT
	SET @max_id_k = (SELECT MAX(idklient) FROM klient)	

	INSERT INTO faktura VALUES (@max_adr_doc,@idprac,@max_id_k,@dystans,@cena,@vat,@cena*(@vat

+1),@data_wyj,@data_przyj)

	DECLARE @max_id_fak INT
	SET @max_id_fak = (SELECT MAX(idfaktura) FROM faktura)

	INSERT INTO 

zamowienie VALUES (@idpoj,@max_id_fak)
GO

EXECUTE nowe_zamowienie 'ZENON','BIEDRONKA','PILSKA','10/3','ILAWA','80-

632',5,'MICHAL','OJCZENASZ',
		84032512532,NULL,'CEGIELNIANA','4E/55','TUCHOLA','89-501',260,400,0.23,'2010-10-

23','2010-10-25',3
GO





--9) procedura 3
--DODAWANIE NOWEGO SAMOCHODU
IF EXISTS (SELECT * FROM sys.objects WHERE type='P' AND name='dodaj_sam')
DROP 

PROCEDURE dodaj_sam;
GO

CREATE PROCEDURE dodaj_sam
	@marka VARCHAR(20), @model VARCHAR(20), @nr_rej VARCHAR(10), @typ 

VARCHAR(20), @cena_netto_km MONEY, 
	@opis VARCHAR(50)
AS
	INSERT INTO typ_pojazdu VALUES (@typ,@cena_netto_km,@opis)

	

DECLARE @max_idtyp INT
	SET @max_idtyp = (SELECT MAX(idtyp_pojazdu) FROM typ_pojazdu)

	INSERT INTO pojazd VALUES 

(@max_idtyp,@marka,@model,@nr_rej)
GO

EXECUTE dodaj_sam 'FIAT','DUCATO','WE 62345','DOSTAWCZY',6.5,'POJAZD O DMC 3,5T'
GO





--10) procedura 4
--ZWIEKSZANIE PENSJI NA DANYM STANOWISKU (O JAKIS PROCENT)
IF EXISTS (SELECT * FROM sys.objects WHERE 

type='P' AND name='zwieksz_pensje')
DROP PROCEDURE zwieksz_pensje;
GO

CREATE PROCEDURE zwieksz_pensje
	@id_stan INT, 

@ile_proc FLOAT
AS
	DECLARE @proc FLOAT
	SET @proc=(@ile_proc/100)+1
	UPDATE stanowisko SET 

pensja_netto=pensja_netto*@proc WHERE idstanowisko=@id_stan
GO

SELECT * FROM stanowisko;
EXECUTE zwieksz_pensje 3,10.0;	-- 

ZWIEKSZAMY PENSJE NA STANOWISKU O id = 2 O 10 PROCENT 
SELECT * FROM stanowisko;




--11) wyzwalacz 1
-- WYSWIETLA DANE OSTATNIO DODANEGO SAMOCHODU (PLUS WYKORZYSTANIE WCZESNIEJ NAPISANEJ PROCEDURY)
IF EXISTS 

(SELECT * FROM sys.objects WHERE type='TR' AND name='dodano_samochod')
DROP TRIGGER dodano_samochod;
GO

CREATE TRIGGER 

dodano_samochod ON pojazd
AFTER INSERT
AS
BEGIN
	DECLARE @id INT
	SET @id = (SELECT MAX(idpojazd) FROM pojazd)

	SELECT 

'DODANO NOWY SAMOCHOD!'
	SELECT * FROM pojazd WHERE idpojazd=@id
END
GO

EXECUTE dodaj_sam 'RENAULT','KANGOO','WE 

12852','OSOBOWY',1.8,'PRZEWOZ OSOB I DROBNYCH TOWAROW'
GO




--12) wyzwalacz 2

--WYZWALACZ TEN "PILNUJE", ABYSMY NIE ZDUBLOWALI KTOREGOS Z ADRESOW DOCELOWYCH
IF EXISTS (SELECT * FROM sys.objects WHERE 

type='TR' AND name='duplikat_adresu_doc')
DROP TRIGGER duplikat_adresu_doc;
GO

CREATE TRIGGER duplikat_adresu_doc ON 

adres_docelowy
INSTEAD OF INSERT
AS
BEGIN
	DECLARE @imie VARCHAR(20), @naz VARCHAR(30), @ul VARCHAR(30), @nr VARCHAR(10), 

@miej VARCHAR(30), @kod CHAR(6)

	SELECT @imie=imie, @naz=nazwisko, @ul=ulica, @nr=nr_domu, 
		@miej=miejscowosc, 

@kod=kod_pocz FROM inserted

	SET NOCOUNT ON
	IF NOT EXISTS (
	SELECT *
	FROM adres_docelowy a, inserted i
	

WHERE (a.imie=i.imie) AND (a.nazwisko=i.nazwisko) AND (a.ulica=i.ulica) AND (a.nr_domu=i.nr_domu) 
	AND 

(a.miejscowosc=i.miejscowosc) AND (a.kod_pocz=i.kod_pocz))
	BEGIN
		INSERT INTO adres_docelowy VALUES 

(@imie,@naz,@ul, @nr, @miej, @kod)
	END
	ELSE
		BEGIN
			RAISERROR('NIE MOZNA DODAC NOWEGO 

ADRESU! ADRES JUZ ISTNIEJE...',1,2)	
			ROLLBACK
		END		
END
GO

INSERT INTO 

adres_docelowy VALUES('ZENON','BIEDRONKA','PILSKA','10/3','ILAWA','80-632')




--13) wyzwalacz 3

--WYZWALACZ WYSWIETLAJACY ZMODYFIKOWANE WIERSZE PO ZMIANIE DANYCH KLIENTA
--DZIEKI NIEMU WIEMY CO SIE ZMIENILO I Z CZEGO, 

WIEC NIE BEDZIE 
IF EXISTS (SELECT * FROM sys.objects WHERE type='TR' AND name = 'zmiana_danych')
DROP TRIGGER 

zmiana_danych;
GO

CREATE TRIGGER zmiana_danych ON klient
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
	SELECT 'ZMODYFIKOWANO 

WIERSZY: '+STR(@@ROWCOUNT)
	SELECT 'USUNIETO WIERSZE: '
	SELECT * FROM deleted
	SELECT 'DODANO WIERSZE: '
	

SELECT * FROM inserted
END
GO

UPDATE klient SET imie='WOJTEK' WHERE idklient=1;



--14) wyzwalacz 4

--WYZWALACZ TWORZACY "KOPIE ZAPASOWA" USUNIETYCH REKORDOW Z TABELI pracownik  W TABELI pracownik_kopia
IF EXISTS (SELECT * 

FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME='pracownik_kopia')
DROP TABLE pracownik_kopia;
GO



CREATE TABLE pracownik_kopia (
  idpracownik INT IDENTITY(1,1) PRIMARY KEY,
  idfilia INT CONSTRAINT idfilia_fk2 FOREIGN KEY

(idfilia) REFERENCES filia(idfilia),
  idadres INT CONSTRAINT idadres_pracow_fk2 FOREIGN KEY(idadres) REFERENCES adres

(idadres),
  idstanowisko INT CONSTRAINT idstanowisko_fk2 FOREIGN KEY(idstanowisko) REFERENCES stanowisko(idstanowisko),
  

imie VARCHAR(20) NOT NULL,
  nazwisko VARCHAR(30) NOT NULL,
  PESEL CHAR(11) CONSTRAINT unikalny_pesel2 UNIQUE NOT NULL,
);

IF 

EXISTS (SELECT * FROM sys.objects WHERE type='TR' AND name='kopia_zapas')
DROP TRIGGER kopia_zapas;
GO

CREATE TRIGGER 

kopia_zapas ON pracownik
AFTER DELETE
AS
BEGIN
	SET IDENTITY_INSERT pracownik_kopia ON
	ALTER TABLE pracownik_kopia DROP 

CONSTRAINT unikalny_pesel2
	IF EXISTS (SELECT * FROM deleted)
	BEGIN
		INSERT INTO pracownik_kopia 

(idpracownik,idfilia,idadres,idstanowisko,imie,nazwisko,PESEL)
		SELECT * FROM deleted
	END
	ALTER TABLE 

pracownik_kopia ADD CONSTRAINT unikalny_pesel2 UNIQUE (PESEL)
	SET IDENTITY_INSERT pracownik_kopia OFF
END
GO

SELECT * FROM 

pracownik;
DELETE FROM pracownik WHERE idpracownik = 3;
SELECT * FROM pracownik_kopia;

--15) pivot 1
--TABELA PRZESTAWNA 

UKAZUJACA PRZYCHOD DANEGO KIEROWCY W WYBRANYCH LATACH LATACH
SELECT p.idpracownik, p.imie, p.nazwisko, [2009],[2010]
FROM 
(
	

SELECT p.idpracownik, p.imie, p.nazwisko, YEAR(data_wyjazdu) AS przychod_pracow, cena_razem_brutto
	FROM faktura f JOIN 

pracownik p ON f.idpracownik=p.idpracownik
) tabela
PIVOT
(
	SUM(cena_razem_brutto)
	FOR przychod_pracow IN ([2009],

[2010])
)
AS p
ORDER BY idpracownik;

SELECT * FROM faktura;

--16) pivot 2
--TABELA PRZESTAWNA UKAZUJACA ILE KILOMERTOW W ROKU 

PRZEJECHAL DANY POJAZD

EXECUTE nowe_zamowienie 'ANDRZEJ','SLABY','KROTKA','2','POZNAN','25-522',4,'PIOTR','KROL',
		

84031512862,6325451685,'DLUGA','30','SZCZECIN','36-451',365,426.55,0.23,'2009-03-10','2009-03-12',2
GO

SELECT p.idpojazd, 

p.marka, p.model, p.nr_rej, [2009], [2010]
FROM 
(
	SELECT p.idpojazd, p.marka, p.model, p.nr_rej, YEAR(f.data_wyjazdu) 

AS suma_km, dystans_km 
	FROM 
	faktura f JOIN zamowienie z ON f.idfaktura=z.idfaktura
	JOIN pojazd p ON 

z.idpojazd=p.idpojazd
) tabela
PIVOT
(
	SUM(dystans_km)
	FOR suma_km IN ([2009],[2010])
)
AS p
ORDER BY idpojazd;

SELECT * FROM 

faktura;

