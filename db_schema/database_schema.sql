IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'TSQLRPG')
    CREATE DATABASE [TSQLRPG]
GO

USE TSQLRPG

CREATE TABLE Accounts (
    AccID INT IDENTITY(1,1) PRIMARY KEY,
    AccLogin NVARCHAR(25),
    AccPassword BINARY(64),
    Disabled BIT DEFAULT 0
)

CREATE TABLE Characters (
    CharID INT IDENTITY(1,1) PRIMARY KEY,
    CharName NVARCHAR(50),
    HP INT DEFAULT 100,
    Mana INT DEFAULT 50,
    STR INT DEFAULT 0,
    DEX INT DEFAULT 0,
    [INT] INT DEFAULT 0,
    XP INT DEFAULT 0,
    LVL INT DEFAULT 1,
    ClassID INT NOT NULL,
    Removed BIT DEFAULT 0,
)

CREATE TABLE AccountCharacters (
    AccCharID INT IDENTITY(1,1) PRIMARY KEY,
    AccID INT NOT NULL,
    CharID INT NOT NULL,
)

CREATE TABLE Classes (
    ClassID INT IDENTITY(1,1) PRIMARY KEY,
    ClassName VARCHAR(10),
    WeaponTypeID INT NOT NULL,
)

CREATE TABLE WeaponTypes (
    WeaponTypeID INT IDENTITY(1,1) PRIMARY KEY,
    WeaponType VARCHAR(5)
)

CREATE TABLE LevelsTable (
    LevelID INT IDENTITY(1,1) PRIMARY KEY,
    XP DECIMAL(16,2)
)

CREATE TABLE LoggedUser (
    LoggedUserID INT IDENTITY(1,1) PRIMARY KEY,
    AccID INT,
    CharID INT DEFAULT NULL
)

CREATE TABLE Location (
    LocationID INT IDENTITY(1,1) PRIMARY KEY,
    LocationName NVARCHAR(50),
    MinLvl INT,
    MaxLvl INT
)

CREATE TABLE Enemy (
    EnemyID INT IDENTITY(1,1) PRIMARY KEY,
    EnemyName NVARCHAR(50),
    HP INT,
    STR INT,
    DEX INT,
    [INT] INT,
    LVL INT
)

CREATE TABLE LocationsEnemies (
    LocEneID INT IDENTITY(1,1) PRIMARY KEY,
    LocationID INT,
    EnemyID INT,
)


GO

ALTER TABLE AccountCharacters ADD CONSTRAINT FK_accchars_accounts
FOREIGN KEY (AccID) REFERENCES Accounts(accID)

ALTER TABLE AccountCharacters ADD CONSTRAINT FK_accchars_characters
FOREIGN KEY (CharID) REFERENCES Characters(CharID)

ALTER TABLE Classes ADD CONSTRAINT FK_classes_weapontypes
FOREIGN KEY (WeaponTypeID) REFERENCES WeaponTypes(WeaponTypeID)

ALTER TABLE LocationsEnemies ADD CONSTRAINT FK_locene_location
FOREIGN KEY (LocationID) REFERENCES Location(LocationID)

ALTER TABLE LocationsEnemies ADD CONSTRAINT FK_locene_enemy
FOREIGN KEY (EnemyID) REFERENCES Enemy(EnemyID)








DECLARE @name VARCHAR(128)
DECLARE @SQL VARCHAR(254)

SELECT @name = (SELECT TOP 1 [name] FROM sysobjects WHERE [type] = 'U' AND category = 0 ORDER BY [name])

WHILE @name IS NOT NULL
BEGIN
    SELECT @SQL = 'DROP TABLE [dbo].[' + RTRIM(@name) +']'
    EXEC (@SQL)
    PRINT 'Dropped Table: ' + @name
    SELECT @name = (SELECT TOP 1 [name] FROM sysobjects WHERE [type] = 'U' AND category = 0 AND [name] > @name ORDER BY [name])
END
GO
