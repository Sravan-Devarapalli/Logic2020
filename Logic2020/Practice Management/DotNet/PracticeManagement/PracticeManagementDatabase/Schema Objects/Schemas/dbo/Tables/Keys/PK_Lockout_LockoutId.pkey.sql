﻿ALTER TABLE [dbo].[Lockout]
	ADD CONSTRAINT [PK_Lockout_LockoutId]
	PRIMARY KEY CLUSTERED ([LockoutId] ASC) WITH (IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF);