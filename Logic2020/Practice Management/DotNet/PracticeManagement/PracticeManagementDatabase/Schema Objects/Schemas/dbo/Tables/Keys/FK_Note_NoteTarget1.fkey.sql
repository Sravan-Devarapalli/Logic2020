﻿ALTER TABLE [dbo].[Note]
    ADD CONSTRAINT [FK_Note_NoteTarget1] FOREIGN KEY ([NoteTargetId]) REFERENCES [dbo].[NoteTarget] ([NoteTargetId]) ON DELETE NO ACTION ON UPDATE NO ACTION;


