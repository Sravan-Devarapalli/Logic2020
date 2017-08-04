﻿CREATE PROC [dbo].[FinancialsRetrospectiveBudget]
(
	@ProjectId INT
)
AS

SELECT  PBPE.ProjectId,
			PBPE.MilestoneId,
			PBPE.StartDate,
			PBPE.EndDate,
			PBPE.HoursPerDay,
			PBPE.Amount,
			PBPE.PersonId
	INTO #ProjectResources
	FROM ProjectBudgetPersonEntry PBPE
	WHERE PBPE.ProjectId = @ProjectId
	

	CREATE CLUSTERED INDEX cix_ProjectResources ON #ProjectResources(ProjectId,MilestoneId)

	SELECT PBH.ProjectId,
		   PBH.Discount
	INTO #ProjectBudgetDiscount
	FROM ProjectBudgetHistory PBH
	WHERE PBH.ProjectId=@ProjectId AND PBH.IsActive = 1 AND PBH.MilestoneId IS NULL

	CREATE CLUSTERED INDEX CIX_ProjectBudgetDiscount ON #ProjectBudgetDiscount(ProjectId)

	SELECT  ProjectId,
			MilestoneId,
			MIN(StartDate) as StartDate,
			MAX(EndDate) as EndDate
	INTO #CTEMilestoneId
	FROM #ProjectResources
	GROUP BY ProjectId,MilestoneId


	CREATE CLUSTERED INDEX CIX_CTEMilestoneId ON #CTEMilestoneId(ProjectId,Milestoneid)


	SELECT CM.ProjectId,
		   CM.MilestoneId,
		   CASE WHEN PBH.ProjectId IS NULL THEN M.IsHourlyAmount ELSE PBH.IsHourlyAmount END as IsHourlyAmount,
		   CASE WHEN PBH.ProjectId IS NULL THEN M.Amount ELSE  PBH.Revenue END as Amount,
		   CM.StartDate,
		   CM.EndDate
	INTO #CTEBudgetMilestones
	FROM #CTEMilestoneId CM
	LEFT JOIN ProjectBudgetHistory PBH on PBH.MilestoneId = CM.MilestoneId and PBH.isactive=1 and pbh.milestoneid IS NOT NULL
	JOIN Milestone M on M.MilestoneId = CM.MilestoneId

	


	CREATE CLUSTERED INDEX CIX_CTEBudgetMilestones ON #CTEBudgetMilestones(Milestoneid,ProjectId)

	SELECT  m.ProjectId,
			m.MilestoneId,
			m.PersonId,
			cal.Date,
			m.Amount,
			BM.IsHourlyAmount,	
			SUM(m.HoursPerDay) AS ActualHoursPerDay,
			SUM(CONVERT(DECIMAL(4,2),CASE WHEN cal.DayOff = 0  THEN m.HoursPerDay -- No Time-off and no company holiday
				WHEN cal.companydayoff = 1 OR ISNULL(cal.TimeoffHours,8) = 8 THEN 0 -- only company holiday OR person complete dayoff
				ELSE m.HoursPerDay * (1-(cal.TimeoffHours/8)) --person partial day off
			END)) AS HoursPerDay,
			SUM(CONVERT(DECIMAL(4,2),CASE WHEN cal.DayOff = 0  THEN m.HoursPerDay -- No Time-off and no company holiday
				WHEN cal.companydayoff = 1 OR ISNULL(cal.TimeoffHours,8) = 8 THEN 0 -- only company holiday OR person complete dayoff
				ELSE m.HoursPerDay * (1-(cal.TimeoffHours/8)) --person partial day off
			END) * m.Amount) AS PersonMilestoneDailyAmount
	INTO #MileStoneEntries
	FROM #ProjectResources m 
	JOIN #CTEBudgetMilestones BM on m.Milestoneid=BM.MilestoneId and m.Projectid=BM.ProjectId
	INNER JOIN dbo.PersonCalendarAuto AS cal ON cal.Date BETWEEN m.Startdate AND m.EndDate AND cal.PersonId = m.PersonId 
	GROUP BY  m.ProjectId,m.MilestoneId,m.PersonId,cal.Date,BM.IsHourlyAmount, m.Amount

	CREATE CLUSTERED INDEX CIX_MileStoneEntries ON #MileStoneEntries(ProjectId,MilestoneId,PersonId,Date,IsHourlyAmount,Amount)

	SELECT PBFM.StartDate, PBFM.EndDate, s.MilestoneId, SUM(HoursPerDay) AS HoursPerMonth
	INTO #MonthlyHours
	FROM #MileStoneEntries AS s
	INNER JOIN dbo.Calendar C ON C.Date = s.Date 
	JOIN dbo.ProjectBudgetFFMilestoneMonthlyRevenue PBFM on s.MilestoneId = PBFM.MilestoneId AND C.Date between PBFM.StartDate AND PBFM.EndDate
	WHERE s.IsHourlyAmount = 0
	GROUP BY s.MilestoneId,PBFM.StartDate, PBFM.EndDate


	CREATE CLUSTERED INDEX CIX_MonthlyHours ON #MonthlyHours(MilestoneId, StartDate, EndDate )

	SELECT s.Date, s.MilestoneId, SUM(HoursPerDay) AS HoursPerDay
	INTO #CTE
	FROM #MileStoneEntries AS s
	WHERE s.IsHourlyAmount = 0
	GROUP BY s.Date, s.MilestoneId


	CREATE CLUSTERED INDEX CIX_CTE ON #CTE(Date, MilestoneId)


	SELECT * INTO #MilestoneRevenueRetrospective FROM (

	SELECT p.ProjectId,
		m.MilestoneId,
		cal.Date,
		m.IsHourlyAmount,
		ISNULL((FMR.Amount/ NULLIF(MH.HoursPerMonth,0))* d.HoursPerDay,0) AS MilestoneDailyAmount,
		p.Discount,
		d.HoursPerDay
	FROM dbo.ProjectBudgetFFMilestoneMonthlyRevenue FMR
	JOIN #CTEBudgetMilestones M on M.MilestoneId=FMR.MilestoneId
	JOIN #ProjectBudgetDiscount p on p.ProjectId=m.ProjectId
	INNER JOIN dbo.Calendar AS cal ON cal.Date BETWEEN FMR.StartDate AND FMR.EndDate
	JOIN #MonthlyHours MH on MH.milestoneid=M.MilestoneId AND cal.Date BETWEEN MH.StartDate AND MH.EndDate
	INNER JOIN #CTE AS d ON d.date = cal.Date and m.MilestoneId = d.MileStoneId

	UNION ALL

	SELECT -- Milestones with a fixed amount
		p.ProjectId,
		m.MilestoneId,
		cal.Date,
		m.IsHourlyAmount,
		ISNULL((m.Amount/ NULLIF(MTHours.TotalHours,0))* d.HoursPerDay,0) AS MilestoneDailyAmount /* ((Milestone fixed amount/Milestone Total  Hours)* Milestone Total  Hours per day)  */,
		p.Discount,
		d.HoursPerDay/* Milestone Total  Hours per day*/
	FROM #ProjectBudgetDiscount AS p 
		INNER JOIN #CTEBudgetMilestones AS m ON m.ProjectId = p.ProjectId AND  P.ProjectId != 174 AND  m.IsHourlyAmount = 0
		INNER JOIN dbo.Calendar AS cal ON cal.Date BETWEEN m.StartDate AND m.endDate
		INNER JOIN (
						SELECT s.MilestoneId, SUM(s.HoursPerDay) AS TotalHours
						FROM #CTE AS s 
						GROUP BY s.MilestoneId
					) AS MTHours  ON MTHours.MilestoneId  = m.MilestoneId
		INNER JOIN #CTE AS d ON d.date = cal.Date and m.MilestoneId = d.MileStoneId
		LEFT JOIN (select distinct milestoneid from dbo.ProjectBudgetFFMilestoneMonthlyRevenue  WHERE ProjectId= @ProjectId) FMR on m.MilestoneId=FMR.MilestoneId
	WHERE FMR.MilestoneId IS NULL

	UNION ALL

	SELECT -- Milestones with a hourly amount
		mp.ProjectId,
		mp.MilestoneId,
		mp.Date,
		mp.IsHourlyAmount,
		ISNULL(SUM(mp.Amount * mp.HoursPerDay), 0) AS MilestoneDailyAmount,
		MAX(p.Discount) AS Discount,
		SUM(mp.HoursPerDay) AS HoursPerDay/* Milestone Total  Hours per day*/
	FROM #MileStoneEntries mp
		INNER JOIN #ProjectBudgetDiscount AS p ON mp.ProjectId = p.ProjectId AND mp.IsHourlyAmount = 1
	GROUP BY mp.ProjectId,mp.MilestoneId, mp.Date, mp.IsHourlyAmount
	) A

	CREATE CLUSTERED INDEX CIX_MilestoneRevenueRetrospective ON #MilestoneRevenueRetrospective(ProjectId,Milestoneid,[Date],IsHourlyAmount) 

	SELECT	r.ProjectId,
		    ME.MilestoneId,
			c.Date,
			ME.PersonId,
			ME.HoursPerDay AS PersonHoursPerDay,
			ME.ActualHoursPerDay,
			CASE
				WHEN ME.IsHourlyAmount = 1 OR r.HoursPerDay = 0
				THEN ME.PersonMilestoneDailyAmount
				ELSE ISNULL(r.MilestoneDailyAmount * ME.HoursPerDay / r.HoursPerDay, r.MilestoneDailyAmount)
			END AS PersonMilestoneDailyAmount,--Person Level Daily Amount
			CASE
				WHEN ME.IsHourlyAmount = 1 OR r.HoursPerDay = 0
				THEN ISNULL(ME.PersonMilestoneDailyAmount * r.Discount / 100, 0)
				ELSE ISNULL(r.MilestoneDailyAmount * ME.HoursPerDay * r.Discount / (r.HoursPerDay * 100), r.MilestoneDailyAmount * r.Discount / 100)
			END AS PersonDiscountDailyAmount, --Entry Level Daily Discount Amount
			CASE
				WHEN ME.IsHourlyAmount = 1
				THEN ME.Amount
				WHEN ME.IsHourlyAmount = 0 AND r.HoursPerDay = 0
				THEN 0
				ELSE r.MilestoneDailyAmount / r.HoursPerDay
			END AS BillRate,
			CASE 
			WHEN p.Timescale = 4
			THEN p.HourlyRate * 0.01 * ME.Amount
			ELSE p.HourlyRate
			END AS PayRate, 	-- new payrate that takes into account that % unit is used in the Amount instead of $ unit
			p.BonusRate,
			SUM(CASE o.OverheadRateTypeId
							-- Multipliers
							WHEN 2 THEN
								(CASE
										WHEN r.IsHourlyAmount = 1
										THEN ME.Amount
										WHEN r.IsHourlyAmount = 0 OR r.HoursPerDay = 0
										THEN 0
										ELSE r.MilestoneDailyAmount / r.HoursPerDay
									END) * o.Rate / 100 
							WHEN 4 THEN p.HourlyRate * o.Rate / 100
							-- Fixed
							WHEN 3 THEN (o.Rate * 12 / (C.DaysInYear * 8)) 
							ELSE o.Rate
						END) AS OverheadRate,
				ISNULL(p.HourlyRate * MLFO.Rate / 100,0) MLFOverheadRate,
			(CASE WHEN p.Timescale = 2
					THEN ISNULL(p.HourlyRate * p.VacationDays * ME.HoursPerDay,0)/(C.DaysInYear * 8)
			ELSE 0 END)  VacationRate,
			r.Discount,
			ME.IsHourlyAmount
	INTO #cteFinancialsRetrospective
	FROM  #MileStoneEntries AS ME
	INNER JOIN dbo.Calendar C ON c.Date = ME.Date
	INNER JOIN dbo.GetFutureDateTable() FD ON 1=1 
	LEFT JOIN dbo.[v_PersonPayRetrospective] AS p ON p.PersonId = ME.PersonId AND p.Date = c.Date
	LEFT JOIN v_MLFOverheadFixedRateTimescale MLFO ON MLFO.TimescaleId = p.Timescale AND c.Date BETWEEN MLFO.StartDate AND ISNULL(MLFO.EndDate,FD.FutureDate)
	LEFT JOIN dbo.v_OverheadFixedRateTimescale AS o ON p.Date BETWEEN o.StartDate AND ISNULL(o.EndDate, FD.FutureDate) AND o.TimescaleId = p.Timescale
	LEFT JOIN #MilestoneRevenueRetrospective AS r ON ME.MilestoneId = r.MilestoneId AND c.Date = r.Date
	GROUP BY r.ProjectId,Me.MilestoneId, ME.PersonId,c.Date,C.DaysInYear,ME.IsHourlyAmount,ME.HoursPerDay,ME.PersonMilestoneDailyAmount,
		p.Timescale,p.HourlyRate,p.BonusRate,p.VacationDays,
		r.HoursPerDay,r.MilestoneDailyAmount,r.Discount,MLFO.Rate,ME.Amount, ME.ActualHoursPerDay
			
	CREATE CLUSTERED INDEX cix_cteFinancialsRetrospective ON #cteFinancialsRetrospective(ProjectId,[Date],PersonHoursPerDay,PayRate) 

	SELECT f.ProjectId,
		   f.Date, 
		   f.PersonMilestoneDailyAmount,
		   f.PersonDiscountDailyAmount,
		   (ISNULL(f.PayRate, 0) + ISNULL(f.OverheadRate, 0)+ISNULL(f.BonusRate,0)+ISNULL(f.VacationRate,0)) SLHR,
		   ISNULL(f.PayRate,0) PayRate,
		   f.MLFOverheadRate,
		   f.PersonHoursPerDay,
		   f.PersonId,
		   f.Discount,
		   f.IsHourlyAmount,
		   f.ActualHoursPerDay,
		   f.BillRate
	FROM #cteFinancialsRetrospective f
	
	DROP TABLE #ProjectResources
	DROP TABLE #CTEMilestoneId
	DROP TABLE #CTEBudgetMilestones
	DROP TABLE #MileStoneEntries
	DROP TABLE #MonthlyHours
	DROP TABLE #CTE
	DROP TABLE #MilestoneRevenueRetrospective
	DROP TABLE #cteFinancialsRetrospective	
	DROP TABLE #ProjectBudgetDiscount