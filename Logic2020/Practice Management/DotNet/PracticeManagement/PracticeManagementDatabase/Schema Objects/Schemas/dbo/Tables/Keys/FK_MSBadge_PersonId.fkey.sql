﻿ALTER TABLE [dbo].[MSBadge]
	ADD CONSTRAINT [FK_MSBadge_PersonId] FOREIGN KEY (PersonId) REFERENCES [dbo].[Person] ([PersonId]) ON DELETE NO ACTION ON UPDATE NO ACTION;


