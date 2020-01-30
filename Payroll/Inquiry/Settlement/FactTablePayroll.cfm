
<cfquery name="Param" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT * 
	FROM   Program.dbo.Ref_ParameterMission
	WHERE  Mission = '#url.Mission#'	
</cfquery> 

<cfquery name="getSchedule" 
	datasource="AppsPayroll" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT     S.SalarySchedule, S.Description, S.PaymentCurrency
		FROM       SalaryScheduleMission P INNER JOIN
		           SalarySchedule S ON P.SalarySchedule = S.SalarySchedule
		WHERE      P.Mission = '#url.mission#'  
		AND        S.Operational = 1		
		AND        S.SalarySchedule IN (SELECT DISTINCT SalarySchedule FROM EmployeeSettlement)	
		ORDER BY   S.ListingOrder																	
</cfquery>

<cfsavecontent variable="ProgramMaster">
    <cfoutput>
	SELECT Px.ProgramCode, Px.ProgramName, Pex.PeriodHierarchy, Pex.Period
	FROM   Program.dbo.Program Px INNER JOIN Program.dbo.ProgramPeriod Pex ON Px.ProgramCode = Pex.ProgramCode
	AND    Px.Mission = '#URL.Mission#'
	</cfoutput>
</cfsavecontent>

<cfloop query="GetSchedule">

	<cf_droptable dbname="AppsQuery" tblname="#SalarySchedule#_#Table1#"> 	

	<cfquery name= "PayrollSettlement"
		Datasource="AppsPayroll"
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		
		SELECT 	newid()              as FactTableId,				
				-- S.Mission         as Mission_dim, 				
				Month(S.PaymentDate) as PaymentMonth_dim, 
				Month(S.PaymentDate) as PaymentMonth_ord,
				Year(S.PaymentDate)  as PaymentYear_dim,
				
				CASE Month(S.PaymentDate)
							WHEN 1 THEN 'January'
							WHEN 2 THEN 'February'
							WHEN 3 THEN 'March'
							WHEN 4 THEN 'April'
							WHEN 5 THEN 'May'
							WHEN 6 THEN 'June'
							WHEN 7 THEN 'July'
							WHEN 8 THEN 'August'
							WHEN 9 THEN 'September'
							WHEN 10 THEN 'October'
							WHEN 11 THEN 'November'
							WHEN 12 THEN 'December'
				END                  as PaymentMonth_nme,
								
				I.PayrollItem           as Item_dim,
				I.PrintDescription      as Item_nme, 
				L.GLAccount             as GLAccount_dim,
				-- L.GLAccountLiability    as GLAccountCredit_dim,
				I.Source                as ItemClass_dim,
				O.OrgUnitCode           as OrgUnit_dim, 
				LEFT(OrgUnitName,60)    as OrgUnit_nme,
				F.Fund                  as Fund_dim,
				
				PP.ProgramCode          as ProgramParent_dim,
				LEFT(PP.ProgramName,60) as ProgramParent_nme,			
				PP.PeriodHierarchy      as ProgramParent_ord,
				
				Pe.Reference            as ProgramUnit_dim,
				M.ProgramName           as ProgramUnit_nme,
				Pe.PeriodHierarchy      as ProgramUnit_ord,
				
				L.PaymentId,
				S.PaymentDate,
				P.IndexNo,
				P.PersonNo, 
				P.Gender as Gender_dim,
				
				(SELECT TOP 1 ISNULL(PG.PostGradeBudget,'NA')
						 FROM   Employee.dbo.PersonContract PC INNER JOIN Employee.dbo.Ref_PostGrade PG ON PC.ContractLevel = PG.PostGrade
						 WHERE  Mission          = '#url.mission#'
						 AND    PersonNo         = P.PersonNo
						 AND    Status IN ('0','1')						 
						 AND    DateEffective   <= S.PaymentDate
						 ORDER BY DateEffective DESC) as ContractLevel_dim,
					 
				(SELECT TOP 1 ISNULL(PG.PostOrderBudget,'99')
						 FROM   Employee.dbo.PersonContract PC INNER JOIN Employee.dbo.Ref_PostGrade PG ON PC.ContractLevel = PG.PostGrade
						 WHERE  Mission          = '#url.mission#'
						 AND    PersonNo         = P.PersonNo
						 AND    Status IN ('0','1')						 
						 AND    DateEffective   <= S.PaymentDate
						 ORDER BY DateEffective DESC) as ContractLevel_ord,
				 
				P.FirstName,                   
				P.LastName,
				L.PayrollStart, 
				L.PayrollEnd, 
				L.Currency,
				L.PaymentAmount * F.Percentage as AmountPay#PaymentCurrency#,
				<cfif PaymentCurrency neq Param.BudgetCurrency>
					L.DocumentAmount*F.Percentage as AmountPay#Param.BudgetCurrency#,
				</cfif>
				L.Amount * F.Percentage        as Amount	
				 											
				
		INTO    UserQuery.dbo.#SalarySchedule#_#Table1#
		
		FROM    EmployeeSettlement S
				INNER JOIN EmployeeSettlementLine L        ON S.PersonNo = L.PersonNo AND S.SalarySchedule = L.SalarySchedule AND S.Mission = L.Mission AND S.PaymentDate = L.PaymentDate
				INNER JOIN EmployeeSettlementLineFunding F ON L.PaymentId = F.PaymentId	 
				INNER JOIN Program.dbo.ProgramPeriod AS Pe INNER JOIN
                         Program.dbo.Ref_Period AS R ON Pe.Period = R.Period ON F.ProgramCode = Pe.ProgramCode AND YEAR(R.DateEffective) = L.PaymentYear	
						 
				<!--- find the root programcode for this one --->
			
				LEFT OUTER JOIN (#preservesinglequotes(ProgramMaster)#) as PP ON SUBSTRING(Pe.PeriodHierarchy,charindex('_',Pe.PeriodHierarchy)+1,
					       CASE charindex('.',Pe.PeriodHierarchy) WHEN 0 THEN len(Pe.PeriodHierarchy) ELSE (charindex('.',Pe.PeriodHierarchy)-1) END 
						   -(charindex('_',Pe.PeriodHierarchy))) = PP.ProgramCode 
						   AND Pe.Period = PP.Period			 
						 
				INNER JOIN Program.dbo.Program M           ON F.ProgramCode = M.ProgramCode		 
					
				INNER JOIN SalarySchedule SS               ON S.SalarySchedule = SS.SalarySchedule
				INNER JOIN SalaryScheduleMission SM        ON S.SalarySchedule = SM.SalarySchedule AND S.Mission = SM.Mission
				INNER JOIN Ref_PayrollItem I               ON L.PayrollItem = I.PayrollItem
				INNER JOIN Employee.dbo.Person P           ON S.PersonNo = P.PersonNo
				INNER JOIN Organization.dbo.Organization O ON L.Mission = O.Mission AND L.Orgunit = O.OrgUnit							
				
				
		WHERE   S.Mission        = '#URL.Mission#'				
		AND     S.SalarySchedule = '#SalarySchedule#'		
		AND     SM.DateEffectivePortal >= S.PaymentDate  
				
	</cfquery>		
	
	<cfset "SESSION.table#currentrow#_ds" = "#SalarySchedule#_#Table1#">	
	
</cfloop>