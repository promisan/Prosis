
<CF_DropTable dbName="AppsTransaction" tblName="sal#SESSION.thisprocess#Overtime">	

<!--- not a good idea we only do this in the begiining _init

<cfquery name="ResetOvertime" 
datasource="AppsPayroll" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">

	UPDATE  PersonOvertime
	SET     Status   = '3'
	FROM    PersonOvertime T	
	WHERE   OvertimeId NOT IN (SELECT ReferenceId 
	                           FROM   EmployeeSalaryLine
							   WHERE  ReferenceId = T.OvertimeId)
	AND     Status   = '5'
	AND     OvertimePayment = 1
			
</cfquery>

--->


<!--- --------------------------------- --->
<!--- 1 of 2 overtime records as a rate --->
<!--- --------------------------------- --->

<!--- reset overtime date based on the workflow --->

<cfquery name="Overtime" 
datasource="AppsPayroll" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	UPDATE  PersonOvertime
	
	SET     OvertimeDate = WorkFlow.DateApproval

	FROM    PersonOvertime AS O INNER JOIN
                   (SELECT    OO.ObjectKeyValue4, 
				              MIN(CASE WHEN OOA.ActionReferenceDate is NULL THEN OOA.OfficerActionDate ELSE OOA.ActionReferenceDate END) AS DateApproval
                    FROM      Organization.dbo.OrganizationObject AS OO INNER JOIN
                              Organization.dbo.OrganizationObjectAction AS OOA ON OO.ObjectId = OOA.ObjectId
                    WHERE     OO.EntityCode = 'EntOvertime'
                    GROUP BY  OO.ObjectKeyValue4) AS Workflow 
				 
				 ON O.OvertimeId = Workflow.ObjectKeyValue4 
				 AND O.OvertimeDate < Workflow.DateApproval  <!--- only bigger --->
						 
	WHERE   O.Mission = '#Form.Mission#'    
	<cfif Form.PersonNo neq "">			
	AND     PersonNo = '#Form.PersonNo#'									
	</cfif>
	
</cfquery>	
   

<cfquery name="Overtime" 
datasource="AppsPayroll" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">

	SELECT DISTINCT 
	       Ovt.PersonNo, 
		   Ovt.OvertimeId,
		   Ovt.OvertimeDate, 
		   OvtD.OvertimeHours, 
		   OvtD.OvertimeMinutes, 
		   Ovt.OvertimePayment, 
		   Ovt.Status, 
		   Pay.Line,
		   Pay.SalaryDayRate,
		   R.SalaryTrigger, 
		   R.SalarySchedule,
		   R.PayrollItem, 
		   R.SalaryMultiplier,
		   R.PaymentCurrency,
		   R.Amount, 
		   R.Period,
		   CONVERT(float, 0) as EntitlementAmount,
		   CONVERT(float, 0) as PaymentAmount
		   
	INTO   userTransaction.dbo.sal#SESSION.thisprocess#Overtime	 
	  
	FROM   PersonOvertime Ovt,
		   PersonOvertimeDetail OvtD,
	       userTransaction.dbo.sal#SESSION.thisprocess#Scale R,
		   userTransaction.dbo.sal#SESSION.thisprocess#Payroll Pay 
		   
	WHERE  Ovt.PersonNo        = Pay.PersonNo 
	AND    Ovt.PersonNo        = OvtD.PersonNo
	AND    Ovt.OvertimeId      = OvtD.OvertimeId

	AND    OvtD.SalaryTrigger  = R.SalaryTrigger   
	 
	<!--- always we take the SPA level likely we need to match the overtime to the period of the payroll --->
	 
	AND    R.SalarySchedule    = Pay.ContractScheduleSPA 
	AND    R.ServiceLocation   = Pay.ContractLocationSPA
	AND    R.ServiceLevel      = Pay.ContractLevelSPA
	AND    R.ServiceStep       = Pay.ContractStepSPA 	
	
	AND    Ovt.OvertimePeriodEnd   >= Pay.DateEffective  <!--- 25/5/07 had to be added for correct rate determination, retro calc --->
	AND    Ovt.OvertimePeriodEnd   <= Pay.DateExpiration 
	
	<!--- has been cleared and not processed yet in a prior month = not paid, we changed this from 2 into 3 9/17/2020  --->
	AND    Ovt.Status          IN ('3','5') 
	
	AND    Ovt.OvertimeId NOT IN (SELECT ReferenceId 
	                              FROM   EmployeeSalaryLine
					    		  WHERE  ReferenceId = Ovt.OvertimeId)
								  
	<!--- is defined to be payable --->
	AND    OvtD.BillingPayment = 1	
	AND    (OvtD.OvertimeHours > 0 OR OvtD.OvertimeMinutes > 0)
	
	<!--- we check if the overtime date allows for it to be settled as this should not
	occur if the current open settlement period has not reach the overtime date, this means
	that overtime usually needs an in-cycle calculation over the prior month once
	the right month arrives --->
	 
	AND    OvertimeDate    <=  #CALCEND#		
			
</cfquery>


<cfset ovt = "OvertimeHours + (CAST(OvertimeMinutes AS Float) / 60)"> 

<cfif Schedule.SalaryBaseRate eq "1">

	<cfquery name="HourRates" 
	datasource="AppsPayroll" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		UPDATE  userTransaction.dbo.sal#SESSION.thisprocess#Overtime
		SET     EntitlementAmount = (#ovt#)*Amount,
			    PaymentAmount     = (#ovt#)*Amount
		WHERE   Period = 'HOUR'
	</cfquery>
	
	<cfquery name="DayRates" 
	datasource="AppsPayroll" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		UPDATE  userTransaction.dbo.sal#SESSION.thisprocess#Overtime
		SET     EntitlementAmount = (#ovt#)*Amount/8,
			    PaymentAmount     = (#ovt#)*Amount/8
		WHERE   Period = 'DAY' 
	</cfquery>

<cfelse>

    <!--- payment is based on negotiated salary --->

   <cfquery name="DayRates" 
	datasource="AppsPayroll" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		UPDATE  userTransaction.dbo.sal#SESSION.thisprocess#Overtime
		SET     EntitlementAmount = (#ovt#)*(SalaryDayRate/8)*SalaryMultiplier,
			    PaymentAmount     = (#ovt#)*(SalaryDayRate/8)*SalaryMultiplier
		WHERE   Period = 'HOUR'  
	</cfquery>

</cfif>

<cfquery name="InsertLine" 
datasource="AppsPayroll" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	INSERT INTO EmployeeSalaryLine
	(SalarySchedule,
	 PersonNo, 
	 PayrollStart, 
	 Mission,
	 PayrollCalcNo,
	 PayrollItem, 
	 EntitlementSalarySchedule,
	 EntitlementPeriod, 
	 EntitlementPeriodUoM, 
	 Currency, 
	 AmountCalculation, 
	 AmountCalculationBase,
	 AmountPayroll, 
	 PaymentCurrency, 
	 PaymentCalculation, 
	 PaymentAmount, 
     Reference, 
	 ReferenceId, 
	 CalculationSource,
	 OfficerUserId, 
	 OfficerLastName, 
	 OfficerFirstName)
	SELECT '#Form.Schedule#',
		 PersonNo, 
		 #SALSTR#, 
		 '#form.Mission#',
		 Line,
		 PayrollItem,
		 SalarySchedule,
		 OvertimeHours, 
		 Period,
		 PaymentCurrency, 
		 EntitlementAmount, 
		 EntitlementAmount, 
		 PaymentAmount, 
		 PaymentCurrency, 
		 ROUND(EntitlementAmount, #roundsettle#), 
		 ROUND(PaymentAmount, #roundsettle#), 
		 'Overtime',
	     OvertimeId, 
		 'RateOvertime',
		 '#SESSION.acc#', 
		 '#SESSION.last#', 
		 '#SESSION.first#'
	FROM userTransaction.dbo.sal#SESSION.thisprocess#Overtime P
	WHERE EXISTS (SELECT 'X' 
	              FROM  EmployeeSalary
			      WHERE PersonNo = P.PersonNo
				  AND   PayrollCalcNo  = P.Line
				  AND   SalarySchedule = '#Form.Schedule#'
				  AND   PayrollStart   = #SALSTR#)	
</cfquery>


<!--- --------------------------------------- --->
<!--- 2 of 2 overtime records as a percentage --->
<!--- --------------------------------------- --->

<CF_DropTable dbName="AppsTransaction" tblName="sal#SESSION.thisprocess#OvertimePercent">	

<cfquery name="Overtime" 
datasource="AppsPayroll" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT DISTINCT 
	       Ovt.PersonNo, 
		   Ovt.OvertimeId,
		   Ovt.OvertimeDate, 
		   OvtD.OvertimeHours, 
		   OvtD.OvertimeMinutes, 
		   Ovt.OvertimePayment, 
		   Ovt.Status, 
		   Pay.Line,
		   Pay.SalaryDayRate,		   
		   R.SalarySchedule,
		   R.SalaryTrigger, 
		   R.CalculationBase,
		   R.PayrollItem, 		   
		   R.PaymentCurrency,
		   R.Percentage, 
		   R.ScaleNo, 		   
		   R.SalaryMultiplier,
		   
		   CONVERT(float, 0) as EntitlementAmount,
		   CONVERT(float, 0) as PaymentAmount
		   
	INTO   userTransaction.dbo.sal#SESSION.thisprocess#OvertimePercent	   
	FROM   PersonOvertime       Ovt,
		   PersonOvertimeDetail OvtD,
	       userTransaction.dbo.sal#SESSION.thisprocess#Percentage R,
		   userTransaction.dbo.sal#SESSION.thisprocess#Payroll Pay 
		   
	WHERE  Ovt.PersonNo        = Pay.PersonNo 
	AND    Ovt.PersonNo        = OvtD.PErsonNo
	AND    Ovt.OvertimeId      = OvtD.OvertimeId

	AND    OvtD.SalaryTrigger  = R.SalaryTrigger   
			
	AND    R.SalarySchedule    = Pay.ContractScheduleSPA 
	AND    (R.ServiceLocation  = Pay.ContractLocationSPA OR R.ServiceLocation = 'All')
	
	AND    Ovt.OvertimePeriodEnd   >= Pay.DateEffective  <!--- 25/5/07 had to be added for correct rate determination, retro calc --->	
	AND    Ovt.OvertimePeriodEnd   <= Pay.DateExpiration 
	<!--- sometime overtime is paid in the next month, so May overtime needs to be paid in June, in that case this will do it --->
	AND    OvertimeDate    <=  #CALCEND#	
	
		
	<!--- we look at the overtime date to determine what to select STL provision 
			
	AND    CASE WHEN ovt.OvertimeDate < '2018-02-01' THEN
	         Ovt.OvertimeDate ELSE Ovt.OvertimePeriodEnd
			END >= Pay.DateEffective
	AND    CASE WHEN ovt.OvertimeDate < '2018-02-01' THEN
	         Ovt.OvertimeDate  ELSE Ovt.OvertimePeriodEnd
		   END <= Pay.DateExpiration		
		   
	--->	   	   
		
	<!--- has been cleared and not processed yet in a prior month = not paid --->
	AND    Ovt.Status          IN ('3','5') 
	
	AND    Ovt.OvertimeId NOT IN (SELECT ReferenceId 
	                              FROM   EmployeeSalaryLine
					    		  WHERE  ReferenceId = Ovt.OvertimeId)
								  
	<!--- is defined on the detailed level now as dominant factor --->
	AND    OvtD.BillingPayment = 1
	AND    (OvtD.OvertimeHours > 0 or OvtD.OvertimeMinutes > 0)
			
</cfquery>

<cfquery name="Base" 
datasource="AppsPayroll" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT    *, 0 as OrderProcess
	FROM      Ref_CalculationBase
	<!--- has indeed been used --->
	WHERE     Code IN ( SELECT      SP.CalculationBase
						FROM        SalaryScaleComponent AS SC INNER JOIN
			                        SalaryScalePercentage AS SP ON SC.ScaleNo = SP.ScaleNo AND SC.ComponentName = SP.ComponentName
						WHERE  SC.SalaryTrigger IN (SELECT SalaryTrigger 
					                               FROM   userTransaction.dbo.sal#SESSION.thisprocess#OvertimePercent)
					    )
	
	
	<!--- does not have a percentage defined in itself --->				   
	AND       Code NOT IN (
					SELECT    R.Code
					FROM      Ref_CalculationBaseItem R INNER JOIN
			                  userTransaction.dbo.sal#SESSION.thisprocess#OvertimePercent S ON R.SalarySchedule = S.SalarySchedule AND R.PayrollItem = S.PayrollItem
					WHERE     S.SalarySchedule = '#Form.Schedule#' )
					
	UNION
	
	SELECT    *, 1 as OrderProcess
	FROM      Ref_CalculationBase
	WHERE     Code IN ( SELECT SP.CalculationBase
						FROM   SalaryScaleComponent AS SC INNER JOIN
			                   SalaryScalePercentage AS SP ON SC.ScaleNo = SP.ScaleNo AND SC.ComponentName = SP.ComponentName
						WHERE  SC.SalaryTrigger IN (SELECT SalaryTrigger 
					                               FROM   userTransaction.dbo.sal#SESSION.thisprocess#OvertimePercent) )
						
	AND 	  Code IN (
					   SELECT R.Code
					   FROM   Ref_CalculationBaseItem R INNER JOIN
			                  userTransaction.dbo.sal#SESSION.thisprocess#OvertimePercent S ON R.SalarySchedule = S.SalarySchedule AND R.PayrollItem = S.PayrollItem
					   WHERE  S.SalarySchedule = '#Form.Schedule#'
					  )	
	
	ORDER BY 	OrderProcess	
	
		   
</cfquery>

<cfset mySchedule = Form.Schedule>

<cfloop query = "base">

	<cfset calcprocessmode = "overtime">
	
	<cfinclude template="EntitlementCalculationBase.cfm">

	<cfset ovt = "OvertimeHours + (CAST(OvertimeMinutes AS Float) / 60)"> 

	<!--- update the base amount in the temp calculation base set --->
		
	<cfquery name="SetAmountBase" 
	datasource="AppsPayroll" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		UPDATE  userTransaction.dbo.sal#SESSION.thisprocess#OvertimePercent 
		
		SET     EntitlementAmount = (#ovt#)*(S.AmountCalculation)*(Percentage/100),
			    PaymentAmount     = (#ovt#)*(S.AmountCalculation)*(Percentage/100)
					      
		FROM    userTransaction.dbo.sal#SESSION.thisprocess#OvertimePercent T,	
		        userTransaction.dbo.sal#SESSION.thisprocess#CalculationBase#code# S
		WHERE   S.PersonNo            = T.PersonNo
		-- AND     S.AmountCalculation <> 0
		<cfif BaseAmount eq "1">
		AND     S.PayrollCalcNo       = 1	
		AND     S.PayrollCalcNo       = T.Line	  
		<cfelse> 
		AND     S.PayrollCalcNo       = T.Line	  		<!--- adjusted 23/12/2017 ronmell observation that we took the wrong calcNo --->
		</cfif>
		AND     T.CalculationBase     = '#code#' 		
	</cfquery>
	
</cfloop>		
	
<cfquery name="InsertLine" 
datasource="AppsPayroll" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">

	INSERT INTO EmployeeSalaryLine
	
			(SalarySchedule,
			 PersonNo, 
			 PayrollStart, 
			 Mission,
			 PayrollCalcNo,
			 PayrollItem, 
			 EntitlementSalarySchedule,
			 EntitlementPeriod, 
			 EntitlementPeriodUoM, 
			 Currency, 
			 AmountCalculation, 
			 AmountCalculationWork,
			 AmountCalculationBase,
			 AmountCalculationDays,
			 AmountCalculationFull,
			 AmountPayroll, 
			 PaymentCurrency, 
			 PaymentCalculation, 
			 PaymentAmount, 
		     Reference, 
			 ReferenceId, 
			 CalculationSource,
			 OfficerUserId, 
			 OfficerLastName, 
			 OfficerFirstName)
	 
	SELECT   '#Form.Schedule#',
			 PersonNo, 
			 #SALSTR#, 
			 '#Form.Mission#',
			 Line,
			 PayrollItem,
			 SalarySchedule,
			 OvertimeHours, 
			 'HOUR',
			 PaymentCurrency, 
			 EntitlementAmount, 
			 EntitlementAmount,
			 EntitlementAmount, 
			 EntitlementAmount,
			 EntitlementAmount, 
			 PaymentAmount, 
			 PaymentCurrency, 
			 ROUND(EntitlementAmount, #roundsettle#), 
			 ROUND(PaymentAmount, #roundsettle#), 
			 'Overtime',
		     OvertimeId, 
			 'PercentOvertime',
			 '#SESSION.acc#', 
			 '#SESSION.last#', 
			 '#SESSION.first#'
			 
	FROM  userTransaction.dbo.sal#SESSION.thisprocess#OvertimePercent P	
	
	WHERE EXISTS (SELECT 'X' 
	              FROM  EmployeeSalary
			      WHERE PersonNo        = P.PersonNo
				  AND   PayrollCalcNo   = P.Line
				  AND   SalarySchedule  = '#Form.Schedule#'
				  AND   PayrollStart    = #SALSTR#)	
				  
</cfquery>
