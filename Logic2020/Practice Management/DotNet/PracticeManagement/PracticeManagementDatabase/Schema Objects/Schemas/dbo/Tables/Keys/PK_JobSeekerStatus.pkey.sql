﻿ALTER TABLE [dbo].[JobSeekerStatus]
	ADD CONSTRAINT [PK_JobSeekerStatus]
	PRIMARY KEY CLUSTERED ([JobSeekerStatusId] ASC) WITH (IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF);