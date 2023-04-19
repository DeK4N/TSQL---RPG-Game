CREATE OR ALTER FUNCTION has_characters(
    @UserID INT = 0
)
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
            AccCharID
        FROM AccountCharacters
        WHERE AccID = @UserID
    )
        SET @Flag = 1
    ELSE
        SET @Flag = 0

    RETURN @Flag
    
END