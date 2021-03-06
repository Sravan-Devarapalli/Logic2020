﻿CREATE VIEW dbo.v_MilestoneRevenueRetrospective--Day level Milestone Amount & hours
AS

	WITH MonthlyHours
	AS
	(
		SELECT C.MonthStartDate, C.MonthEndDate,C.MonthNumber, s.MilestoneId, SUM(HoursPerDay) AS HoursPerMonth
		FROM dbo.v_MilestonePersonSchedule AS s
		INNER JOIN dbo.Calendar C ON C.Date = s.Date 
		WHERE s.IsHourlyAmount = 0
		GROUP BY s.MilestoneId, C.MonthStartDate, C.MonthEndDate,C.MonthNumber
	),

	CTE
	AS
	(
	SELECT s.Date, s.MilestoneId, SUM(HoursPerDay) AS HoursPerDay
		FROM dbo.v_MilestonePersonSchedule AS s
		WHERE s.IsHourlyAmount = 0
		GROUP BY s.Date, s.MilestoneId
	)

	
	 SELECT m.MilestoneId,
			m.ProjectId,
			cal.Date,
			m.IsHourlyAmount,
			ISNULL((FMR.Amount/ NULLIF(MH.HoursPerMonth,0))* d.HoursPerDay,0) AS MilestoneDailyAmount,
			m.StartDate AS MilestoneStartDate,
			m.ProjectedDeliveryDate,
			p.Discount,
			HY.HoursInYear,
			d.HoursPerDay
		FROM dbo.FixedMilestoneMonthlyRevenue FMR
		JOIN Milestone M on M.MilestoneId=FMR.MilestoneId
		JOIN Project p on p.ProjectId=m.ProjectId
		INNER JOIN dbo.Calendar AS cal ON cal.Date BETWEEN FMR.StartDate AND FMR.EndDate
		JOIN MonthlyHours MH on MH.milestoneid=M.MilestoneId AND cal.Date BETWEEN MH.MonthStartDate AND MH.MonthEndDate
		INNER JOIN CTE AS d ON d.date = cal.Date and m.MilestoneId = d.MileStoneId
		INNER JOIN V_WorkinHoursByYear HY ON cal.date BETWEEN HY.[YearStartDate] AND HY.[YearEndDate]
	
	UNION ALL
	SELECT -- Milestones with a fixed amount
	DISTINCT m.MilestoneId,
		m.ProjectId,
		cal.Date,
		m.IsHourlyAmount,
		ISNULL((m.Amount/ NULLIF(MTHours.TotalHours,0))* d.HoursPerDay,0) AS MilestoneDailyAmount /* ((Milestone fixed amount/Milestone Total  Hours)* Milestone Total  Hours per day)  */,
		m.StartDate AS MilestoneStartDate,
		m.ProjectedDeliveryDate,
		p.Discount,
		HY.HoursInYear,
		d.HoursPerDay/* Milestone Total  Hours per day*/
	FROM dbo.Project AS p 
		INNER JOIN dbo.Milestone AS m ON m.ProjectId = p.ProjectId AND P.IsAdministrative = 0 AND P.ProjectId != 174 AND  m.IsHourlyAmount = 0
		INNER JOIN dbo.Calendar AS cal ON cal.Date BETWEEN m.StartDate AND m.ProjectedDeliveryDate
		INNER JOIN (
						SELECT s.MilestoneId, SUM(s.HoursPerDay) AS TotalHours
						FROM CTE AS s 
						GROUP BY s.MilestoneId
					) AS MTHours  ON MTHours.MilestoneId  = m.MilestoneId
		INNER JOIN CTE AS d ON d.date = cal.Date and m.MilestoneId = d.MileStoneId
		INNER JOIN V_WorkinHoursByYear HY ON cal.date BETWEEN HY.[YearStartDate] AND HY.[YearEndDate]
		LEFT JOIN (select distinct milestoneid from dbo.FixedMilestoneMonthlyRevenue) FMR on m.MilestoneId=FMR.MilestoneId
		WHERE FMR.MilestoneId IS NULL
	UNION ALL
	SELECT -- Milestones with a hourly amount
		   mp.MilestoneId,
		   mp.ProjectId,
		   mp.Date,
		   mp.IsHourlyAmount,
		   ISNULL(SUM(mp.Amount * mp.HoursPerDay), 0) AS MilestoneDailyAmount,
		   MAX(mp.StartDate) AS MilestoneStartDate,
		   MAX(mp.ProjectedDeliveryDate) AS ProjectedDeliveryDate,
           MAX(p.Discount) AS Discount,
		   MAX(HY.HoursInYear) AS HoursInYear,
	       SUM(mp.HoursPerDay) AS HoursPerDay/* Milestone Total  Hours per day*/
	  FROM dbo.v_MilestonePersonSchedule mp
	       INNER JOIN dbo.Project AS p ON mp.ProjectId = p.ProjectId AND mp.IsHourlyAmount = 1
		   INNER JOIN V_WorkinHoursByYear HY ON mp.date BETWEEN HY.[YearStartDate] AND HY.[YearEndDate]
	GROUP BY mp.MilestoneId, mp.ProjectId, mp.Date, mp.IsHourlyAmount
