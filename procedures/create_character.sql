CREATE OR ALTER PROCEDURE create_character (
    @Name NVARCHAR(50),
    @ClassID INT
)
/* 
===================================================================================================================================
Author:  -
Creation Date: 16.04.2023
Desc: Procedure responsible for creating new character
===================================================================================================================================
Sample
===================================================================================================================================
EXEC create_character 'test', 1
 
===================================================================================================================================
Change History
===================================================================================================================================
DATE            CHANGED BY          DESCRIPTION
2023/04/16      -                   Creation 

*/
AS
BEGIN

    BEGIN TRY

    DECLARE @UserID INT,
            @CharID INT

    IF (dbo.is_user_logged() = 1)
        BEGIN
            IF ISNULL(@name, '') = '' OR ISNULL(@ClassID, 0) = 0
                RAISERROR('[Name] and [ClassID] can''t be empty value', 16, 1)
            
            IF NOT EXISTS (SELECT ClassID FROM Classes WHERE ClassID = @ClassID)
                RAISERROR('Available classes are 1) Warrior, 2) Mage, 3) Archer, please pick correct class ID', 16, 1)

            IF EXISTS (SELECT CharID FROM Characters WHERE LOWER(CharName) = LOWER(@Name))
                RAISERROR('Character with this name already exists!', 16, 1)

            SET @UserID = (SELECT AccID FROM LoggedUser)

            INSERT INTO Characters (
                CharName,
                ClassID
            )
            VALUES (
                @Name,
                @ClassID
            )

            SET @CharID = @@IDENTITY

            INSERT INTO AccountCharacters (
                AccID,
                CharID
            )
            VALUES (
                @UserID,
                @CharID
            )

            SELECT CONCAT('Character ', @name, ' created succesfuly!')
        END
    ELSE
        RAISERROR ('You can''t create new character when you are not logged in!', 16, 1)

    END TRY

    BEGIN CATCH
        SELECT
            ERROR_MESSAGE() 'Message'
    END CATCH
    

END
