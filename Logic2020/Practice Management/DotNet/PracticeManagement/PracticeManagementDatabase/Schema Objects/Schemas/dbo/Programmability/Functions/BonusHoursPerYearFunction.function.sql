﻿CREATE FUNCTION [dbo].[BonusHoursPerYearFunction]()
RETURNS INT
WITH SCHEMABINDING
AS
BEGIN
	RETURN 2080
END
