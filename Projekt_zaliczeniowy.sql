USE [master]
GO

DROP DATABASE IF EXISTS [biblioteka]
GO

CREATE DATABASE [biblioteka]
GO

USE [biblioteka]
GO

--Tworzenie tabeli autor
CREATE TABLE [dbo].[autor](
	[id_autor] [int] IDENTITY(1,1) NOT NULL,
	[Imie] [nvarchar](50) NOT NULL,
	[Nazwisko] [nvarchar](100) NOT NULL,
	[Data_urodzenia] [date] NULL,
 CONSTRAINT [PK_autor] PRIMARY KEY CLUSTERED 
(
	[id_autor] ASC
)
)
GO

--Tworzenie tabeli klient
CREATE TABLE [dbo].[klient](
	[id_klient] [int] IDENTITY(1,1) NOT NULL,
	[Imie] [nvarchar](50) NOT NULL,
	[Nazwisko] [nvarchar](100) NOT NULL,
	[Adres] [nvarchar](150) NULL,
	[PESEL] [char](11) NOT NULL,
 CONSTRAINT [PK_klient] PRIMARY KEY CLUSTERED 
(
	[id_klient] ASC
)
)
GO

--Tworzenie tabeli ksi¹¿ki
CREATE TABLE [dbo].[ksiazki](
	[id_ksiazki] [int] IDENTITY(1,1) NOT NULL,
	[Gatunek] [varchar](50) NULL,
	[Tytul] [nvarchar](50) NOT NULL,
	[id_autor] [int] NOT NULL,
	[Rok_wydania] [int] NULL,
	[Opis] [nvarchar](255) NULL,
 CONSTRAINT [PK_ksiazki] PRIMARY KEY CLUSTERED 
(
	[id_ksiazki] ASC
)
)
GO

--Tworzenie tabeli pracownicy
CREATE TABLE [dbo].[pracownicy](
	[id_pracownika] [int] IDENTITY(1,1) NOT NULL,
	[Imie] [nvarchar](50) NOT NULL,
	[Nazwisko] [nvarchar](100) NOT NULL,
	[PESEL] [char](11) NOT NULL,
	[stanowisko] [nvarchar](100) NULL,
 CONSTRAINT [PK_pracownicy] PRIMARY KEY CLUSTERED 
(
	[id_pracownika] ASC
)
)
GO

--Tworzenie tabeli wypozyczenie
CREATE TABLE [dbo].[wypozyczenie](
	[id_wypozyczenie] [int] IDENTITY(1,1) NOT NULL,
	[id_pracownika] [int] NOT NULL,
	[id_klient] [int] NOT NULL,
	[id_ksiazki] [int] NOT NULL,
	[data] [date] NULL,
 CONSTRAINT [PK_wypozyczenie] PRIMARY KEY CLUSTERED 
(
	[id_wypozyczenie] ASC
)
)
GO

--Klucze obce
ALTER TABLE [dbo].[ksiazki]  WITH CHECK ADD  CONSTRAINT [FK_ksiazki_autor] FOREIGN KEY([id_autor])
REFERENCES [dbo].[autor] ([id_autor])
GO

ALTER TABLE [dbo].[ksiazki] CHECK CONSTRAINT [FK_ksiazki_autor]
GO

ALTER TABLE [dbo].[wypozyczenie]  WITH CHECK ADD  CONSTRAINT [FK_wypozyczenie_klient] FOREIGN KEY([id_klient])
REFERENCES [dbo].[klient] ([id_klient])
GO

ALTER TABLE [dbo].[wypozyczenie] CHECK CONSTRAINT [FK_wypozyczenie_klient]
GO

ALTER TABLE [dbo].[wypozyczenie]  WITH CHECK ADD  CONSTRAINT [FK_wypozyczenie_ksiazki] FOREIGN KEY([id_ksiazki])
REFERENCES [dbo].[ksiazki] ([id_ksiazki])
GO

ALTER TABLE [dbo].[wypozyczenie] CHECK CONSTRAINT [FK_wypozyczenie_ksiazki]
GO

ALTER TABLE [dbo].[wypozyczenie]  WITH CHECK ADD  CONSTRAINT [FK_wypozyczenie_pracownicy] FOREIGN KEY([id_pracownika])
REFERENCES [dbo].[pracownicy] ([id_pracownika])
GO

ALTER TABLE [dbo].[wypozyczenie] CHECK CONSTRAINT [FK_wypozyczenie_pracownicy]
GO

--Constrainty typu CHECK
ALTER TABLE [dbo].[klient]
ADD CONSTRAINT CHK_klientPesel CHECK ([klient].pesel != '00000000000' AND [klient].pesel != '12345678910' AND [klient].pesel != '11111111116' AND [klient].pesel != '99999999999'
AND ((cast(substring([klient].pesel,1,1) as bigint)*9)
	+(cast(substring([klient].pesel,2,1) as bigint)*7)
	+(cast(substring([klient].pesel,3,1) as bigint)*3)
	+(cast(substring([klient].pesel,4,1) as bigint)*1)
	+(cast(substring([klient].pesel,5,1) as bigint)*9)
	+(cast(substring([klient].pesel,6,1) as bigint)*7)
	+(cast(substring([klient].pesel,7,1) as bigint)*3)
	+(cast(substring([klient].pesel,8,1) as bigint)*1)
	+(cast(substring([klient].pesel,9,1) as bigint)*9)
	+(cast(substring([klient].pesel,10,1) as bigint)*7) ) % 10
	= right([klient].pesel,1))
GO

ALTER TABLE [dbo].pracownicy
ADD CONSTRAINT CHK_pracownicyPesel CHECK ([pracownicy].pesel != '00000000000' AND [pracownicy].pesel != '12345678910' AND [pracownicy].pesel != '11111111116' AND [pracownicy].pesel != '99999999999'
AND ((cast(substring([pracownicy].pesel,1,1) as bigint)*9)
	+(cast(substring([pracownicy].pesel,2,1) as bigint)*7)
	+(cast(substring([pracownicy].pesel,3,1) as bigint)*3)
	+(cast(substring([pracownicy].pesel,4,1) as bigint)*1)
	+(cast(substring([pracownicy].pesel,5,1) as bigint)*9)
	+(cast(substring([pracownicy].pesel,6,1) as bigint)*7)
	+(cast(substring([pracownicy].pesel,7,1) as bigint)*3)
	+(cast(substring([pracownicy].pesel,8,1) as bigint)*1)
	+(cast(substring([pracownicy].pesel,9,1) as bigint)*9)
	+(cast(substring([pracownicy].pesel,10,1) as bigint)*7) ) % 10
	= right([pracownicy].pesel,1))
GO

ALTER TABLE [dbo].[autor]
ADD CONSTRAINT CHK_autorNazwisko CHECK ([autor].Nazwisko != 'Hitler' AND [autor].Nazwisko != 'Stalin' AND [autor].Nazwisko != 'Goebbels')
GO

ALTER TABLE [dbo].[wypozyczenie]
ADD CONSTRAINT CHK_wypozyczenieData CHECK ([wypozyczenie].data <= GETDATE())
GO

--Constrainty typu DEFAULT
ALTER TABLE [dbo].[pracownicy]
ADD CONSTRAINT DF_stanowisko
DEFAULT 'M³odszy bibliotekarz' FOR stanowisko
GO

ALTER TABLE [dbo].[ksiazki]
ADD CONSTRAINT DF_opis
DEFAULT 'Brak opisu' FOR Opis
GO

ALTER TABLE [dbo].[klient]
ADD CONSTRAINT DF_adres
DEFAULT 'Brak podanego adresu' FOR Adres
GO

--Indexy NONCLUSTERED INDEX
CREATE NONCLUSTERED INDEX tblKsiazki_Tytul
ON [dbo].[ksiazki](Tytul ASC)

CREATE NONCLUSTERED INDEX tblKlient_Pesel
ON [dbo].[klient](PESEL ASC)

CREATE NONCLUSTERED INDEX tblPracownicy_Nazwisko
ON [dbo].[pracownicy](Nazwisko ASC)

--Wprowadzanie danych do tabel
INSERT INTO [dbo].[autor] (Imie, Nazwisko, Data_urodzenia) VALUES
	('Jeff','Abbott', '19630101'),
	('Fiodor','Abramow', '19860211'),
	('Remigiusz','Mróz', '19870115'),
	('Andrzej','Sapkowski', '19480621'),
	('Adam','Mickiewicz', '17981224'),
	('Henryk','Sienkiewicz', '18460505'),
	('Stefan','¯eromski', '18641014'),
	('W³adys³aw','Reymont', '18670507'),
	('Boles³aw','Prus', '19470820'),
	('Eliza','Orzeszkowa', '18410606');
GO

INSERT INTO [dbo].[klient] (Imie, Nazwisko, Adres, PESEL) VALUES
	('Adrian','Adacki', 'Atramentowa 6', '00271388371'),
	('Barbara','Badacka', 'Brzozowa 12', '86052873243'),
	('Cezary','Cadacki', 'Czerwona 9', '47082328532'),
	('Danuta','Dadacka', 'D¹browa 456', '04292719323'),
	('Emigiusz','Edacki', 'Elaboratowa 34', '63102168115'),
	('Faustyna','Fadacka', 'Filharmonii 56', '55011857329'),
	('Grzegorz','Gadacki', NULL, '79101071673'),
	('Honorata','Hadacka', 'Habrowa 22', '89011934124'),
	('Ireneusz','Idacki', 'Informatyczna 1', '98020783913'),
	('Joanna','Jadacka', 'Jesienna 4', '95111597626');
GO

INSERT INTO [dbo].pracownicy(Imie, Nazwisko, PESEL, stanowisko) VALUES
	('Zuzanna','Zió³kowska', '98121655263', 'M³odszy bibliotekarz'),
	('W³adys³aw','Wiosenny', '66042286316', 'Kierownik'),
	('Konrad','Kuczyñski', '75082387471', 'M³odszy bibliotekarz'),
	('Oliwia','Owalna', '95041816745', 'Sta¿ysta'),
	('Nikodem','Nowodolski', '89062068753', 'Starszy bibliotekarz'),
	('Mariusz','Mó³', '68042091512', 'Dyrektor'),
	('Alan','WoŸniak', '76032034856', 'M³odszy bibliotekarz'),
	('Iga','Ostrowska', '89042279346', 'Bibliotekarz'),
	('Kamila','Krawczyk', '71073043825', 'Bibliotekarz'),
	('Rafa³','Szymañski', '01252481894', 'Sta¿ysta');
GO

INSERT INTO [dbo].ksiazki(Gatunek, Tytul, id_autor, Rok_wydania, Opis) VALUES
	('Fikcja','Adrenaline', 1, '2010', 'Sam Capra jest agentem operacyjnym CIA, stacjonuje w Londynie i zajmuje sie rozpracowywaniem miêdzynarodowych organizacji przestepczych.'),
	('Krymina³','The First Order', 1, '2016', NULL),
	('Fikcja','WiedŸmin - Ostatnie ¯yczenie', 4, '1993', 'zbiór opowiadañ fantasy z 1993 roku, napisanych przez Andrzeja Sapkowskiego i stanowi¹cych wstêp do cyklu o wiedŸminie Geralcie.'),
	('Thriller','Kasacja', 3, '2015', 'polski thriller prawniczy autorstwa Remigiusza Mroza, wydany po raz pierwszy przez Wydawnictwo Czwarta Strona w 2015.'),
	('Poezja Epicka','Pan Tadeusz', 5, '1834', 'Pan Tadeusz, czyli ostatni zajazd na Litwie – poemat epicki Adama Mickiewicza wydany w dwóch tomach w 1834 w Pary¿u przez Aleksandra Je³owickiego.'),
	('Fikcja','Ch³opi', 8, '1904', 'powieœæ spo³eczno-obyczajowa W³adys³awa Stanis³awa Reymonta publikowana w odcinkach w latach 1902–1908 w „Tygodniku Ilustrowanym”, wydana w latach 1904–1909 w Warszawie w wydawnictwie „Gebethner i Wolff”.'),
	('Fikcja','Syzyfowe Prace', 7, '1897', 'powieœæ Stefana ¯eromskiego, która po raz pierwszy ukaza³a siê w krakowskim dzienniku „Nowa Reforma” od 7 lipca do 24 wrzeœnia 1897.'),
	('Fikcja','Lalka', 9, '1889', 'powieœæ spo³eczno-obyczajowa Boles³awa Prusa publikowana w odcinkach w latach 1887–1889 w dzienniku „Kurier Codzienny”, wydana w 1890 w Warszawie w wydawnictwie „Gebethner i Wolff”.'),
	('Powieœæ','Faraon', 9, '1895', NULL),
	('Powieœæ','Nad Niemnem', 10, '1888', 'spo³eczno-obyczajowa powieœæ pozytywistyczna Elizy Orzeszkowej z 1888 roku. Trzytomowy utwór przedstawia panoramê polskiego spo³eczeñstwa drugiej po³owy XIX wieku, nawi¹zuj¹c równie¿ do czasów powstania styczniowego.');
GO

INSERT INTO [dbo].wypozyczenie(id_pracownika, id_klient, id_ksiazki, data) VALUES
	(5,4,2,'20211001'),
	(1,1,5,'20210928'),
	(8,2,4,'20211115'),
	(8,2,5,'20211115'),
	(8,2,1,'20211115'),
	(9,6,6,'20211008'),
	(7,3,9,'20210927'),
	(2,7,10,'20211010'),
	(3,5,7,'20210827'),
	(10,10,8,'20211007'),
	(7,2,9,'20221103');
GO

--Widok z JOIN
CREATE VIEW [VIEW_Wypozyczone_Ksiazki] AS
SELECT [ksiazki].Tytul 'Tytu³ ksi¹¿ki',[autor].Imie + ' ' + [autor].Nazwisko 'Autor', [klient].PESEL 'PESEL klienta', [pracownicy].Imie + ' ' + [pracownicy].Nazwisko 'Pracownik', [wypozyczenie].data 'Data wypo¿yczenia'
FROM [biblioteka].[dbo].[wypozyczenie]
INNER JOIN [biblioteka].[dbo].[pracownicy] ON [wypozyczenie].[id_pracownika]=[pracownicy].[id_pracownika]
INNER JOIN [biblioteka].[dbo].[klient] ON [wypozyczenie].[id_klient]=[klient].[id_klient]
INNER JOIN [biblioteka].[dbo].[ksiazki] ON [wypozyczenie].[id_ksiazki]=[ksiazki].[id_ksiazki]
INNER JOIN [biblioteka].[dbo].[autor] ON [autor].[id_autor]=[ksiazki].[id_autor]
GO

--Widok z GROUP BY
CREATE VIEW [VIEW_Ilosc_ksiazek_By_Autor] AS
SELECT COUNT([ksiazki].id_ksiazki) 'Iloœæ ksi¹¿ek', [autor].Imie + ' ' + [autor].Nazwisko 'Autor'
FROM [biblioteka].[dbo].[ksiazki]
INNER JOIN [biblioteka].[dbo].[autor] ON [autor].[id_autor]=[ksiazki].[id_autor]
GROUP BY [autor].Imie + ' ' + [autor].Nazwisko;
GO

--Widok z OVER/PARTITION BY
CREATE VIEW [VIEW_Ilosc_Wypozyczonych_ksiazek] AS
SELECT DISTINCT [ksiazki].Tytul 'Tytu³', [autor].Imie + ' ' + [autor].Nazwisko 'Autor', COUNT([ksiazki].Tytul) OVER(PARTITION BY [ksiazki].Tytul) 'Iloœæ ksi¹¿ek'
FROM [biblioteka].[dbo].[wypozyczenie]
INNER JOIN [biblioteka].[dbo].[ksiazki] ON [wypozyczenie].[id_ksiazki]=[ksiazki].[id_ksiazki]
INNER JOIN [biblioteka].[dbo].[autor] ON [autor].[id_autor]=[ksiazki].[id_autor]
GO

--Funkcja skalarna
CREATE FUNCTION FUNC_Get_Data_By_IdKlienta_IdKsiazki
(
	@idKlienta int,
	@idKsiazki int
)
RETURNS DATE
AS
BEGIN
	RETURN (SELECT [wypozyczenie].data FROM [biblioteka].[dbo].[wypozyczenie]
	WHERE [wypozyczenie].[id_klient] = @idKlienta AND [wypozyczenie].[id_ksiazki] = @idKsiazki)
END
GO

SELECT [biblioteka].[dbo].FUNC_Get_Data_By_IdKlienta_IdKsiazki(3, 9);

--Funkcja tabelaryczna
CREATE FUNCTION FUNC_Get_Ksiazki_Pomiedzy_Latami
(
	@StartDate int,
	@EndDate int
)
RETURNS TABLE
AS
RETURN
(
	SELECT [id_ksiazki]
      ,[Gatunek]
      ,[Tytul]
      ,[autor].Imie + ' ' + [autor].Nazwisko 'Autor'
      ,[Rok_wydania]
      ,[Opis] FROM [biblioteka].[dbo].[ksiazki]
	INNER JOIN [biblioteka].[dbo].[autor] ON [autor].[id_autor]=[ksiazki].[id_autor]
	WHERE [Rok_wydania] BETWEEN @StartDate AND @EndDate
)
GO

--Widok z funkcj¹ tabelaryczn¹
CREATE VIEW [VIEW_Ksiazki_Pomiedzy_Latami_1800_1900] AS
SELECT * FROM [biblioteka].[dbo].FUNC_Get_Ksiazki_Pomiedzy_Latami(1800, 1900);
GO

--Procedura sk³adowana
CREATE OR ALTER PROCEDURE InsertWypozyczenie
      @id_pracownika AS INT
      ,@id_klient AS INT
      ,@id_ksiazki AS INT
      ,@data AS DATE = NULL
AS
BEGIN
SET @data = ISNULL(@data, GETDATE())
  DECLARE @ClientMessage NVARCHAR(100);
  BEGIN TRY
    IF NOT EXISTS(SELECT 1 FROM [biblioteka].[dbo].[pracownicy] 
      WHERE [pracownicy].id_pracownika = @id_pracownika)
      BEGIN
        SET @ClientMessage = 'id pracownika ' 
            + CAST(@id_pracownika AS VARCHAR) + ' jest niepoprawne';
        THROW 50000, @ClientMessage, 0;
      END
    IF NOT EXISTS(SELECT 1 FROM [biblioteka].[dbo].[klient]
        WHERE [klient].id_klient = @id_klient)
      BEGIN
        SET @ClientMessage = 'id klienta ' 
           + CAST(@id_klient AS VARCHAR) + ' jest niepoprawne';
        THROW 50000, @ClientMessage, 0;
      END;
    IF NOT EXISTS(SELECT 1 FROM [biblioteka].[dbo].[ksiazki]
        WHERE [ksiazki].id_ksiazki = @id_ksiazki)
      BEGIN
        SET @ClientMessage = 'id ksiazki ' 
           + CAST(@id_ksiazki AS VARCHAR) + ' jest niepoprawne';
        THROW 50000, @ClientMessage, 0;
      END;
    --Insert do bazy
    INSERT [biblioteka].[dbo].[wypozyczenie] ([id_pracownika] ,[id_klient] ,[id_ksiazki] ,[data])
    VALUES (@id_pracownika ,@id_klient ,@id_ksiazki ,@data);
  END TRY
  BEGIN CATCH
    THROW;
  END CATCH;
END;

--Wywo³anie procedury
EXEC [biblioteka].[dbo].InsertWypozyczenie
      @id_pracownika = 5
      ,@id_klient = 3
      ,@id_ksiazki = 7;

EXEC [biblioteka].[dbo].InsertWypozyczenie
      @id_pracownika = 1
      ,@id_klient = 2
      ,@id_ksiazki = 3
	  ,@data = '20201026';

EXEC [biblioteka].[dbo].InsertWypozyczenie
      @id_pracownika = 1
      ,@id_klient = 2
      ,@id_ksiazki = 23;
