CREATE OR ALTER PROCEDURE select_character (
    @CharFakeID INT
)
/* 
===================================================================================================================================
Author:  -
Creation Date: 19.04.2023
Desc: Procedure responsible for picking character that user want's to play
===================================================================================================================================
Sample
===================================================================================================================================
EXEC select_character 1
 
===================================================================================================================================
Change History
===================================================================================================================================
DATE            CHANGED BY          DESCRIPTION
2023/04/18      -                   Creation 

*/
AS
BEGIN

    SET NOCOUNT ON;

    BEGIN TRY

        DECLARE @UserID INT,
                @CharRealID INT


        SET @UserID = (SELECT AccID FROM LoggedUser)

        IF (dbo.is_user_logged() = 0)
            RAISERROR('You must log into your account!', 16, 1)

        IF (dbo.has_characters(@UserID) = 0)
            RAISERROR('You don''t have any characters, please create one', 16, 1)

        IF ISNULL(@CharFakeID, 0) = 0
            RAISERROR('Please, can''t be an empty value!', 16, 1)


        DROP TABLE IF EXISTS #tempUserChars 
        
        CREATE TABLE #tempUserChars (
            CharRealID INT,
            CharFakeID INT,
        )

        INSERT INTO #tempUserChars (
            CharRealID,
            CharFakeID
        )
        SELECT
            cha.CharID,
            ROW_NUMBER() OVER (ORDER BY cha.CharName)
        FROM AccountCharacters ac
        JOIN Characters cha
            ON ac.CharID = cha.CharID
        WHERE ac.AccID = @UserID

        SET @CharRealID = (SELECT CharRealID FROM #tempUserChars WHERE CharFakeID = @CharFakeID)

        IF EXISTS (
            SELECT
                CharID
            FROM Characters
            WHERE CharID = @CharRealID
        )
        BEGIN
            UPDATE LoggedUser
                SET CharID = @CharRealID

            SELECT 'Success!' 'Message'
        END
            
        ELSE
            RAISERROR('There is no character with selected id!', 16, 1)



    END TRY

    BEGIN CATCH
        SELECT 
            ERROR_MESSAGE() 'Message'
    END CATCH

END