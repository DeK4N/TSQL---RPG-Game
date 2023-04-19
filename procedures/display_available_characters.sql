CREATE OR ALTER PROCEDURE display_available_characters
/* 
===================================================================================================================================
Author:  -
Creation Date: 15.04.2023
Desc: Procedure responsible for displaying currently avaiable characters
===================================================================================================================================
Sample
===================================================================================================================================
EXEC display_available_characters 1
 
===================================================================================================================================
Change History
===================================================================================================================================
DATE            CHANGED BY          DESCRIPTION
2023/04/15      -                   Creation 

*/
AS
BEGIN
    DECLARE @UserID INT = (SELECT AccID FROM LoggedUser)

    BEGIN TRY

        IF (dbo.is_user_logged() = 0)
            RAISERROR('You must log into your account!', 16, 1)

        IF (dbo.has_characters(@UserID) = 0)
                RAISERROR('You don''t have any characters, please create one', 16, 1)
        ELSE
            BEGIN
                SELECT
                    ROW_NUMBER() OVER(ORDER BY cha.CharName) 'Character nr.',
                    cha.CharName 'Character name',
                    cha.LVL 'Level',
                    cls.ClassName 'Class'
                FROM AccountCharacters ac
                JOIN Characters cha
                    ON ac.CharID = cha.CharID
                JOIN Classes cls
                    ON cha.ClassID = cls.ClassID
                WHERE ac.AccID = @UserID

            END
    END TRY

    BEGIN CATCH
         SELECT 
            ERROR_MESSAGE() 'Message'
    END CATCH

END


