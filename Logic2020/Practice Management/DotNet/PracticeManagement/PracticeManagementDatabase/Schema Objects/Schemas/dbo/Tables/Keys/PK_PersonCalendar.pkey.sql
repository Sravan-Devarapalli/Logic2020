﻿ALTER TABLE [dbo].[PersonCalendar]
    ADD CONSTRAINT [PK_PersonCalendar] PRIMARY KEY CLUSTERED ([Date] ASC, [PersonId] ASC) WITH (IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF);

