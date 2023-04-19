CREATE OR ALTER PROCEDURE login_to_account (
    @Login NVARCHAR(25) = NULL,
    @Password NVARCHAR(100) = NULL
)
AS
/* 
===================================================================================================================================
Author:  -
Creation Date: 15.04.2023
Desc: Procedure responsible for logging in system to the game
===================================================================================================================================
Sample
===================================================================================================================================
EXEC login_to_account 'test', 'test'
 
===================================================================================================================================
Change History
===================================================================================================================================
DATE            CHANGED BY          DESCRIPTION
2023/04/15      -                   Creation 

*/
BEGIN

    BEGIN TRY
        
        IF ISNULL(@Login, '') = '' OR ISNULL(@Password, '') = ''
            BEGIN
                RAISERROR('[Login] and [password] cannot be null or empty value!', 16, 1)
            END

        IF NOT EXISTS (
            SELECT
                AccId
            FROM Accounts
            WHERE LOWER(Acclogin) = LOWER(@Login)
        )
            BEGIN
                RAISERROR('Account with this login didn''t exists in the database!', 16, 1)
            END

        IF EXISTS (
            SELECT 
                AccID
            FROM Accounts 
            WHERE LOWER(Acclogin) = LOWER(@Login)
                AND AccPassword = HASHBYTES('SHA2_512', @Password)
                AND Disabled = 0
        )
            BEGIN
                TRUNCATE TABLE LoggedUser
                DECLARE @UserID INT = (SELECT AccID FROM Accounts WHERE LOWER(Acclogin) = LOWER(@Login) AND AccPassword = HASHBYTES('SHA2_512', @Password) AND Disabled = 0)

                INSERT INTO LoggedUser (
                    AccID
                ) 
                VALUES (
                    @UserID
                )
                
                SELECT 'Logged succesfuly' 'Message'

                EXEC display_available_characters

            END
        ELSE
            BEGIN
                RAISERROR ('You can''t login to the account that is disabled', 16, 1)
            END

    END TRY


    BEGIN CATCH

        SELECT
            ERROR_MESSAGE() 'Error message'

    END CATCH

END