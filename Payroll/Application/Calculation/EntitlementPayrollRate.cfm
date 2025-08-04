<!--
    Copyright © 2025 Promisan

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
-->

<!--- this component is always in the default currency, so no need to convert currencies here !! --->

<CF_DropTable dbName="AppsTransaction" tblName="sal#SESSION.thisprocess#EntitlementRateAmount">	

<!--- get rates but we have two types of entitlement ones that are rules by the entitlement group
and the ones that are not ruled by the entitlement group but the salary group --->

<cfsavecontent variable="sqlselect">

<cfoutput>

		   DISTINCT 
	       Ent.PersonNo, 
		   Ent.Line,
		   Ent.ServiceLocation,		
		   Ent.ContractScheduleSPA, 	
           Ent.ContractLocationSPA,  
		   Ent.EntitlementId,
		   Ent.DateEffective, 
		   Ent.DateExpiration, 		   	 
		   Ent.EntitlementDays,
		   Ent.EntitlementLWOP, 
		   Ent.EntitlementSuspend, 
		   Ent.EntitlementPointer,	
		   Ent.EntitlementGroup,		   
		   Ent.Status, 
		   Ent.ContractTime,		   
		   Ent.Currency as CurrencyEntitlement,
		   Ent.Amount   as AmountEntitlement,	
		   Ent.PayrollDaysCorrectionPointer,   
		   R.SalaryTrigger, 
		   R.TriggerGroup,
		   R.EntitlementGrade,  <!--- ADD to determine if this is going to be applied on the grade or SPA grade --->
		   R.EntitlementGradePointer,
		   '0' as PaymentBlock,
		   R.PayrollItem, 	  
		   R.ComponentName,
		   R.ParentComponent,
		   R.PaymentCurrency, <!--- schedule --->
		   R.Amount, 
		   R.Period,
		   R.Source,
		   R.SalaryMultiplier,
		   R.SalaryDays,
		   R.ScaleNo,
		   R.EntitlementPointer as RateEntitlementPointer,
		   R.EntitlementGroup   as RateEntitlementGroup,
		   CONVERT(float, 0)    as EntitlementAmountFTE,
		   CONVERT(float, 0)    as EntitlementAmountFull,
		   CONVERT(float, 0)    as EntitlementAmountDays,
		   CONVERT(float, 0)    as EntitlementAmountBase,
		   CONVERT(float, 0)    as EntitlementAmountWork,
		   CONVERT(float, 0)    as EntitlementAmount,
		   CONVERT(float, 0)    as PaymentAmountFTE,
		   CONVERT(float, 0)    as PaymentAmountFull,
		   CONVERT(float, 0)    as PaymentAmountDays,
		   CONVERT(float, 0)    as PaymentAmountBase,
		   CONVERT(float, 0)    as PaymentAmount,
		   #now()#              as TimeStamp
		   
</cfoutput>		   
		  
</cfsavecontent>  

<cfquery name="RateAmount" 
datasource="AppsPayroll" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">

	<!--- apply the regular grade --->
	
	SELECT #preservesinglequotes(sqlselect)#
		   
	INTO   userTransaction.dbo.sal#SESSION.thisprocess#EntitlementRateAmount   
	
	FROM   userTransaction.dbo.sal#SESSION.thisprocess#Entitlements Ent,
	       userTransaction.dbo.sal#SESSION.thisprocess#Scale R
	
	WHERE  Ent.SalaryTrigger    = R.SalaryTrigger	
		
	AND    R.EntitlementGrade   = 'REGULAR'
	AND    R.SalarySchedule     = Ent.SalarySchedule 	
	AND    R.ServiceLocation    = Ent.ServiceLocation
	AND    R.ServiceLevel       = Ent.ContractLevel 	
	AND    R.ServiceStep        = Ent.ContractStep 
	
	<!--- 15/11/2012 rule by the entitlement group --->
	AND    R.TriggerCondition   = 'Dependent'
	AND    R.EntitlementGroup   = Ent.EntitlementGroup
		
	AND    R.EntitlementClass   = 'Rate'
	<!--- added 10/10/2010 
	AND    Ent.EntitlementClass = 'Rate'
	--->
	AND    R.SettleUntilPeriod  = '#settle#' 	
	
	UNION ALL
	
	<!--- apply the SPA grade --->
	
	SELECT #preservesinglequotes(sqlselect)#
		
	FROM   userTransaction.dbo.sal#SESSION.thisprocess#Entitlements Ent,
	       userTransaction.dbo.sal#SESSION.thisprocess#Scale R
	
	WHERE  Ent.SalaryTrigger    = R.SalaryTrigger	
	
	AND    R.EntitlementGrade   = 'SPA'	
	AND    R.SalarySchedule     = Ent.ContractScheduleSPA 	
	AND    R.ServiceLocation    = Ent.ContractLocationSPA
	AND    R.ServiceLevel       = Ent.ContractLevelSPA 	
	AND    R.ServiceStep        = Ent.ContractStepSPA 
	
	<!--- 15/11/2012 rule by the entitlement group --->
	AND    R.TriggerCondition   = 'Dependent'
	AND    R.EntitlementGroup   = Ent.EntitlementGroup
		
	AND    R.EntitlementClass   = 'Rate'
	<!--- added 10/10/2010 --->
	AND    Ent.EntitlementClass = 'Rate'
	AND    R.SettleUntilPeriod  = '#settle#' 
					
	UNION ALL
	
	<!--- apply the regular grade --->
	
	SELECT #preservesinglequotes(sqlselect)#  
	
	FROM   userTransaction.dbo.sal#SESSION.thisprocess#Entitlements Ent,
	       userTransaction.dbo.sal#SESSION.thisprocess#Scale R
	
	WHERE  Ent.SalaryTrigger    = R.SalaryTrigger
	
	AND    R.EntitlementGrade   = 'REGULAR'
	
	AND    R.SalarySchedule     = Ent.SalarySchedule 	
	AND    R.ServiceLocation    = Ent.ServiceLocation
	AND    R.ServiceLevel       = Ent.ContractLevel 
	AND    R.ServiceStep        = Ent.ContractStep 	
	
	<!--- 15/11/2012 ruled by the payroll group --->
	AND    R.TriggerCondition   = 'None'
	AND    R.EntitlementGroup   = Ent.EntitlementGroup
	
	AND    R.EntitlementClass   = 'Rate'	
	<!--- added 10/10/2010 --->
	AND    Ent.EntitlementClass = 'Rate'
	AND    R.SettleUntilPeriod  = '#settle#' 
		
	UNION ALL
	
	<!--- apply the SPA grade --->
	
	SELECT #preservesinglequotes(sqlselect)#      
	
	FROM   userTransaction.dbo.sal#SESSION.thisprocess#Entitlements Ent,
	       userTransaction.dbo.sal#SESSION.thisprocess#Scale R
	
	WHERE  Ent.SalaryTrigger    = R.SalaryTrigger
	
	AND    R.EntitlementGrade   = 'SPA'
	
	AND    R.SalarySchedule     = Ent.ContractScheduleSPA 	
	AND    R.ServiceLocation    = Ent.ContractLocationSPA
	AND    R.ServiceLevel       = Ent.ContractLevelSPA 
	AND    R.ServiceStep        = Ent.ContractStepSPA 
	
	<!--- 15/11/2012 ruled by the payroll group --->
	AND    R.TriggerCondition   = 'None'
	AND    R.EntitlementGroup   = Ent.EntitlementGroup
	
	AND    R.EntitlementClass   = 'Rate'	
	<!--- added 10/10/2010 --->
	AND    Ent.EntitlementClass = 'Rate'
	AND    R.SettleUntilPeriod  = '#settle#' 
	
		
</cfquery>

<!--- -------------------- IMPORT FILETRING THE VALID RATE ------------------- --->
<!--- -------------reset entitlement to take only the existing rates---------- --->
<!--- ------------------------------------------------------------------------ --->


<cfquery name="CorrectPointerToValidValues" 
datasource="AppsPayroll" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	UPDATE userTransaction.dbo.sal#SESSION.thisprocess#EntitlementRateAmount
	SET    EntitlementPointer = P.MaxPointer
	FROM   userTransaction.dbo.sal#SESSION.thisprocess#EntitlementRateAmount R, 	
	
		   (SELECT   SalaryTrigger, ScaleNo, MAX(EntitlementPointer) AS MaxPointer	
			FROM     SalaryScaleComponent			
			GROUP BY SalaryTrigger,ScaleNo) as P
	
	WHERE  R.SalaryTrigger = P.SalaryTrigger AND R.ScaleNo = P.ScaleNo
	AND    R.EntitlementPointer > P.MaxPointer     
</cfquery>

<!--- ----------------------------------------------------------- --->
<!--- remove entitlements lines which do not match the determined 
     pointer setting --->
<!--- ----------------------------------------------------------- --->	 
	 
<cfquery name="MatchPointer" 
datasource="AppsPayroll" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	DELETE  FROM userTransaction.dbo.sal#SESSION.thisprocess#EntitlementRateAmount
	WHERE   EntitlementPointer <> RateEntitlementPointer 
</cfquery>


<!--- Attention : Annual leave payment is NOT relevant for this calculation at all !! --->

<cfquery name="YearRates" 
datasource="AppsPayroll" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">

	UPDATE  userTransaction.dbo.sal#SESSION.thisprocess#EntitlementRateAmount 
	SET     EntitlementAmountFTE  = round((Amount/12)*SalaryMultiplier,3),
			EntitlementAmountFull = round((Amount/12)*SalaryMultiplier*(ContractTime/100),3), <!--- reflects the amount for a NORMAL month : no leave, no expiration --->
			EntitlementAmountDays = round(((EntitlementDays)/#Form.SalaryDays#)*(Amount/12)*SalaryMultiplier*(ContractTime/100),3),
	        EntitlementAmountBase = round(((EntitlementDays-EntitlementLWOP)/#Form.SalaryDays#)*(Amount/12)*SalaryMultiplier*(ContractTime/100),3),
	        EntitlementAmount     = round(((EntitlementDays-EntitlementLWOP-EntitlementSuspend)/#Form.SalaryDays#)*(Amount/12)*SalaryMultiplier*(ContractTime/100),3),
			
			PaymentAmountFTE      = round((Amount/12)*SalaryMultiplier,3),
		    PaymentAmountFull     = round((Amount/12)*SalaryMultiplier*(ContractTime/100),3),	
			PaymentAmountDays     = round((EntitlementDays/#Form.SalaryDays#)*(Amount/12)*SalaryMultiplier*(ContractTime/100),3),		   
		    PaymentAmountBase     = round(((EntitlementDays-EntitlementLWOP)/#Form.SalaryDays#)*(Amount/12)*SalaryMultiplier*(ContractTime/100),3),
		    PaymentAmount         = round(((EntitlementDays-EntitlementLWOP-EntitlementSuspend)/#Form.SalaryDays#)*(Amount/12)*SalaryMultiplier*(ContractTime/100),3)
			
	WHERE   Period = 'YEAR'
		
	<!--- --------------- to be reviewed ------------- --->
	<!--- do no apply if record is for final pay 24/9/ --->
	<!--- -------------------------------------------- 
	
	AND     EnforceFinalPay = 0
	
	--->
</cfquery>

<cfquery name="MonthRates" 
datasource="AppsPayroll" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">

	UPDATE  userTransaction.dbo.sal#SESSION.thisprocess#EntitlementRateAmount 	
	SET     EntitlementAmountFTE  = round((EntitlementDays/#Form.SalaryDays#)*Amount*SalaryMultiplier,3),
			EntitlementAmountFull = round(Amount*SalaryMultiplier*(ContractTime/100),3), <!--- reflects the amount for a NORMAL month : no leave, no expiration --->
	        EntitlementAmountDays = round(((EntitlementDays)/#Form.SalaryDays#)*Amount*SalaryMultiplier*(ContractTime/100),3),
	        EntitlementAmountBase = round(((EntitlementDays-EntitlementLWOP)/#Form.SalaryDays#)*Amount*SalaryMultiplier*(ContractTime/100),3),			
	        EntitlementAmount     = round(((EntitlementDays-EntitlementLWOP-EntitlementSuspend)/#Form.SalaryDays#)*Amount*SalaryMultiplier*(ContractTime/100),3),
			
			PaymentAmountFTE      = round((EntitlementDays/#Form.SalaryDays#)*Amount*SalaryMultiplier,3),
		    PaymentAmountFull     = round((Amount)*SalaryMultiplier*(ContractTime/100),3),	
			PaymentAmountDays     = round((EntitlementDays/#Form.SalaryDays#)*Amount*SalaryMultiplier*(ContractTime/100),3),
		    PaymentAmountBase     = round(((EntitlementDays-EntitlementLWOP)/#Form.SalaryDays#)*Amount*SalaryMultiplier*(ContractTime/100),3),
		    PaymentAmount         = round(((EntitlementDays-EntitlementLWOP-EntitlementSuspend)/#Form.SalaryDays#)*Amount*SalaryMultiplier*(ContractTime/100),3)
			
	WHERE   Period = 'MONTH'	
	<!--- --------------- to be reviewed ------------- --->
	<!--- do no apply if record is for final pay 24/9/ --->
	<!--- -------------------------------------------- 
	AND     EnforceFinalPay = 0	
	--->	
	
</cfquery>

<cfquery name="DayRates" 
datasource="AppsPayroll" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">

	UPDATE  userTransaction.dbo.sal#SESSION.thisprocess#EntitlementRateAmount 	
	SET     EntitlementAmountFTE  = round(EntitlementDays*Amount*SalaryMultiplier,3),
	        EntitlementAmountFull = round(EntitlementDays*Amount*SalaryMultiplier*(ContractTime/100),3),
			EntitlementAmountDays = round((EntitlementDays)*Amount*SalaryMultiplier*(ContractTime/100),3),
	        EntitlementAmountBase = round((EntitlementDays-EntitlementLWOP)*Amount*SalaryMultiplier*(ContractTime/100),3),
	        EntitlementAmount     = round((EntitlementDays-EntitlementLWOP-EntitlementSuspend)*Amount*SalaryMultiplier*(ContractTime/100),3),
			
			PaymentAmountFTE      = round(EntitlementDays*Amount*SalaryMultiplier,3),
		    PaymentAmountFull     = round(EntitlementDays*Amount*SalaryMultiplier*(ContractTime/100),3),
			PaymentAmountDays     = round(EntitlementDays*Amount*SalaryMultiplier*(ContractTime/100),3),
		    PaymentAmountBase     = round((EntitlementDays-EntitlementLWOP)*Amount*SalaryMultiplier*(ContractTime/100),3),
		    PaymentAmount         = round((EntitlementDays-EntitlementLWOP-EntitlementSuspend)*Amount*SalaryMultiplier*(ContractTime/100),3)
			
	WHERE   Period = 'DAY'	
	<!--- --------------- to be reviewed ------------- --->
	<!--- do no apply if record is for final pay 24/9/ --->
	<!--- -------------------------------------------- 
	AND     EnforceFinalPay = 0	
	--->	
	
</cfquery>

<!--- adjusted to assign the entitlement to the last line instead of the first
line, to cater for a scenario that a person returns in the month that he
also receives a final payment earlier 

disabled 16/3/2018, I don't think this is needed anymore to make such provision 

checked for overtime : can be removed

hanno 16/10/2019 : ready for removal 
			
			<cfquery name="CorrectionSplitContract" 
			  datasource="AppsQuery" 
			  username="#SESSION.login#" 
			  password="#SESSION.dbpw#">
			  
				UPDATE  userTransaction.dbo.sal#SESSION.thisprocess#EntitlementRateAmount	
				SET     EntitlementAmountFull = 0,	      	      
						PaymentAmountFull     = 0		  
				FROM    userTransaction.dbo.sal#SESSION.thisprocess#EntitlementRateAmount B INNER JOIN 	
				
						(  SELECT   PersonNo, MAX(Line) as Line
						   FROM     userTransaction.dbo.sal#SESSION.thisprocess#EntitlementRateAmount 
						   WHERE    EntitlementAmountBase <> 0
						   GROUP BY PersonNo ) as L 
						 
				 ON B.Personno = L.PersonNo 
				<!--- reset the lines other than the last line --->
				AND     B.Line <> L.Line 			
				
			</cfquery>

--->

<!--- added 18/10/2018 we adjust the deduction based on the calculated subsidy which is dependent on working days and SLWOP --->

  
<cfquery name="ResetMedicalContributionFromSubsidy" 
	datasource="AppsPayroll" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
			
	UPDATE  userTransaction.dbo.sal#SESSION.thisprocess#EntitlementRateAmount
	
	SET     EntitlementAmountFTE   =  EntitlementAmountFTE  - S.AmountBase,
	        EntitlementAmountFull  =  EntitlementAmountFull - S.AmountFull, 	
			EntitlementAmountDays  =  EntitlementAmountDays - S.AmountDays,
			EntitlementAmountBase  =  EntitlementAmountBase - S.AmountBase, 
			EntitlementAmount      =  EntitlementAmount     - S.Amount, 
			PaymentAmountFTE       =  EntitlementAmountFTE  - S.AmountBase,
	        PaymentAmountFull      =  EntitlementAmountFull - S.AmountFull, 	
			PaymentAmountDays      =  EntitlementAmountDays - S.AmountDays,
			PaymentAmountBase      =  EntitlementAmountBase - S.AmountBase, 
			PaymentAmount          =  EntitlementAmount     - S.Amount		
							  
    FROM    userTransaction.dbo.sal#SESSION.thisprocess#EntitlementRateAmount AS P 
	        INNER JOIN        (SELECT       PersonNo, 
			                                Line, 
											ParentComponent, 
											EntitlementAmountFTE  as AmountFTE,
											EntitlementAmountFull as AmountFull,
											EntitlementAmountDays as AmountDays,											
											EntitlementAmountBase as AmountBase,											
											EntitlementAmount     as Amount
                               FROM         userTransaction.dbo.sal#SESSION.thisprocess#EntitlementRateAmount
                               WHERE        Source = 'Contribution'   <!--- subsidy --->
							   AND          ParentComponent IS NOT NULL) AS S 
							   
		    ON P.PersonNo = S.PersonNo AND P.Line = S.Line AND P.ComponentName = S.ParentComponent

    WHERE   P.Source = 'Deduction' 
	
	AND     EXISTS (SELECT 'X' 
	                FROM   userTransaction.dbo.sal#SESSION.thisprocess#EntitlementRateAmount AS V
                    WHERE  PersonNo        = P.PersonNo 
			        AND    Line            = P.Line 
				    AND    ParentComponent = P.ComponentName) 		
					
			 
</cfquery>	

 
<!--- ----------------------------------------------------------------- --->
<!--- ------if the payment is a deduction we need to correct it-------- --->
<!--- ----------------------------------------------------------------- --->

<cfquery name="MultiplierCorrection" 
datasource="AppsPayroll" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	UPDATE  userTransaction.dbo.sal#SESSION.thisprocess#EntitlementRateAmount 
	SET     PaymentAmount      = -PaymentAmount,
			PaymentAmountDays  = -PaymentAmountDays,
	        PaymentAmountBase  = -PaymentAmountBase,
			PaymentAmountFull  = -PaymentAmountFull,
			PaymentAmountFTE   = -PaymentAmountFTE
	WHERE   PayrollItem IN (SELECT PayrollItem 
	                        FROM   Ref_PayrollItem 							
							WHERE  PaymentMultiplier = '-1')		
</cfquery>

<!--- ------------------------------------------------------------------------------------------------ --->
<!--- 11/10/2017 correction if entitlenent is calculated under REGULAR but person has a different SPA schedule set
for this period 
then based on the pointer the Payment will not be honored amounts only to use for calculation purposes --->
<!--- ------------------------------------------------------------------------------------------------ --->

<cfquery name="UpdatePayment" 
datasource="AppsPayroll" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	UPDATE  userTransaction.dbo.sal#SESSION.thisprocess#EntitlementRateAmount 
	SET     PaymentBlock            = '1'
	WHERE   EntitlementGrade        = 'REGULAR' 
	AND     EntitlementGradePointer = 1
	AND     ContractScheduleSPA    != '#Form.Schedule#'  		
</cfquery>


<cfloop index="itm" list="0,1,2,3,4" delimiters=",">
	
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
				 ComponentName,
				 EntitlementSalarySchedule,
				 EntitlementPointer,				
				 EntitlementPeriod,
				 EntitlementPeriodUoM,
				 Currency, 
				 AmountCalculationFull,
				 AmountCalculationDays,
				 AmountCalculationBase,
				 AmountCalculationWork,		
				 AmountCalculation, 
				 AmountPayroll, 						 	 
				 PaymentCurrency, 
				 PaymentCalculation,
				 PaymentAmount, 
				 PaymentBlock,
			     Reference, 
				 ReferenceId, 
				 CalculationSource,
				 OfficerUserId, 
				 OfficerLastName, 
				 OfficerFirstName)
				 
		SELECT   '#Form.Schedule#', 
		         PersonNo, 
				 #SALSTR#, 
				 '#form.Mission#',
				 Line,
				 PayrollItem,
				 ComponentName,
				 ContractScheduleSPA,
				 EntitlementPointer,
				 EntitlementDays-EntitlementLWOP,
				 Period,
				 PaymentCurrency,
				 EntitlementAmountFull,
				 EntitlementAmountDays,		
				 EntitlementAmountBase,		
				 EntitlementAmount,				 
				 <!--- the actual amount to be paid for this component --->				 
				  <cfif itm eq "3">
					 EntitlementAmount, 	<!--- net days - lwop - suspend --->
					 PaymentAmount, 
					 PaymentCurrency, 
					 (CASE WHEN PaymentBlock = '0' THEN ROUND(EntitlementAmount, #roundsettle#)     ELSE 0 END), 
					 (CASE WHEN PaymentBlock = '0' THEN ROUND(PaymentAmount, #roundsettle#)         ELSE 0 END), 
				  <cfelseif itm eq "0">
				  	 EntitlementAmountBase, <!--- net days - lwop --->	
					 PaymentAmountBase, 
					 PaymentCurrency, 
					 (CASE WHEN PaymentBlock = '0' THEN ROUND(EntitlementAmountBase, #roundsettle#) ELSE 0 END), 
					 (CASE WHEN PaymentBlock = '0' THEN ROUND(PaymentAmountBase, #roundsettle#)     ELSE 0 END), 	 									 
				 <cfelseif itm eq "1">					 
					 EntitlementAmountDays, <!--- net days --->	
					 PaymentAmountDays, 
					 PaymentCurrency, 
					 (CASE WHEN PaymentBlock = '0' THEN ROUND(EntitlementAmountDays, #roundsettle#) ELSE 0 END), 
					 (CASE WHEN PaymentBlock = '0' THEN ROUND(PaymentAmountDays, #roundsettle#)     ELSE 0 END), 
				<cfelseif itm eq "4">	
					 EntitlementAmountFTE, <!--- FTE rate --->	
					 PaymentAmountFTE, 
					 PaymentCurrency, 
					 (CASE WHEN PaymentBlock = '0' THEN ROUND(EntitlementAmountFTE, #roundsettle#)  ELSE 0 END), 
					 (CASE WHEN PaymentBlock = '0' THEN ROUND(PaymentAmountFTE, #roundsettle#)      ELSE 0 END), 	 	 						 
				 <cfelse>
					 EntitlementAmountFull, <!--- full rate --->	
					 PaymentAmountFull, 
					 PaymentCurrency, 
					 (CASE WHEN PaymentBlock = '0' THEN ROUND(EntitlementAmountFull, #roundsettle#) ELSE 0 END), 
					 (CASE WHEN PaymentBlock = '0' THEN ROUND(PaymentAmountFull, #roundsettle#)     ELSE 0 END), 	 
				 </cfif>	
				 PaymentBlock,	 								 		
				 'Entitlement',
			     EntitlementId, 
				 'RateAmount',
				 '#SESSION.acc#', 
				 '#SESSION.last#', 
				 '#SESSION.first#'
				 
		FROM    userTransaction.dbo.sal#SESSION.thisprocess#EntitlementRateAmount P		
		
		WHERE   SalaryDays = #itm#		
		<cfif itm eq "2">
		AND Line = '1' 
		</cfif>
		<!--- disabled as we need the amount for calculations later on the percentages 
		<cfif itm eq "0" or itm eq "3">						
		AND     EntitlementAmount <> 0 		 
		<cfelseif itm eq "1">		
		AND     EntitlementAmountBase <> 0 		 
		<cfelse>		
		AND     EntitlementAmountFull <> 0		 
		</cfif> 		
		--->
		<!--- added to prevent double 3/1/2016 --->		
		AND     TriggerGroup <> 'Contract'		
		
		AND      EXISTS (SELECT 'X' 
	                FROM  EmployeeSalary
				    WHERE PersonNo       = P.PersonNo
				    AND   PayrollCalcNo  = P.Line
				    AND   SalarySchedule = '#Form.Schedule#'
				    AND   PayrollStart   = #SALSTR# )
									
	</cfquery>
	
</cfloop>
