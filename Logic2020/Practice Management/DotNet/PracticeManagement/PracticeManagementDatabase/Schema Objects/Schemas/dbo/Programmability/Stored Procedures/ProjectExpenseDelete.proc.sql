﻿-- =============================================
-- Author:		Nikita Goncharenko
-- Create date: 2010-04-20
-- =============================================
CREATE PROCEDURE dbo.ProjectExpenseDelete 
    @ExpenseId int
AS
BEGIN
	SET NOCOUNT ON;

	exec DeleteProjectMonthlyExpenses @ExpenseId= @ExpenseId

	DELETE FROM [dbo].[ProjectExpense]
	WHERE Id = @ExpenseId
end 

