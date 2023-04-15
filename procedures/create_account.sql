CREATE OR ALTER PROCEDURE create_account (
    @Login NVARCHAR(25) = NULL,
    @Password NVARCHAR(100) = NULL
)
AS
/* 
===================================================================================================================================
Author:  -
Creation Date: 15.04.2023
Desc: Procedure responsible for creating new game account in database
===================================================================================================================================
Sample
===================================================================================================================================
EXEC create_account 'test', ''
 
===================================================================================================================================
Change History
===================================================================================================================================
DATE            CHANGED BY          DESCRIPTION
2023/04/15      -                   Creation 

*/

BEGIN
    SET NOCOUNT ON

    BEGIN TRY

        IF ISNULL(@Login, '') = '' OR ISNULL(@Password, '') = ''
        BEGIN
            RAISERROR('[Login] and [password] cannot be null or empty value!', 16, 1)
        END

        INSERT INTO Accounts (
            AccLogin,
            AccPassword
        )
        VALUES(
            @Login,
            HASHBYTES('SHA2_512', @Password)
        )

        PRINT("Account created succesfully!")

    END TRY

    BEGIN CATCH

        SELECT 
            ERROR_MESSAGE() 'Error message'

        IF XACT_STATE() = -1
            ROLLBACK TRANSACTION
        ELSE IF XACT_STATE() = 1
            COMMIT TRANSACTION
    END CATCH
END