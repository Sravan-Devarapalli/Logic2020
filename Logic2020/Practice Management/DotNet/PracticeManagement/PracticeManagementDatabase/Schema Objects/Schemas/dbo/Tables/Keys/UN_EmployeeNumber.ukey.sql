﻿ALTER TABLE [dbo].[Person]
    ADD CONSTRAINT [UN_EmployeeNumber] UNIQUE NONCLUSTERED ([EmployeeNumber] ASC) WITH (IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF) ON [PRIMARY];


