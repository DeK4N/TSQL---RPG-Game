CREATE OR ALTER FUNCTION is_user_logged ()
RETURNS BIT
/* 
===================================================================================================================================
Author:  -
Creation Date: 18.04.2023
Desc: Function responisble for checking if any user is logged into account
===================================================================================================================================

===================================================================================================================================
Change History
===================================================================================================================================
DATE            CHANGED BY          DESCRIPTION
2023/04/18      -                   Creation 

*/
AS

BEGIN

    DECLARE @Flag BIT = 0

    IF EXISTS (
        SELECT
            LoggedUserID
        FROM LoggedUser
    )
        SET @Flag = 1
    ELSE
        SET @Flag = 0

    RETURN @Flag
    
END