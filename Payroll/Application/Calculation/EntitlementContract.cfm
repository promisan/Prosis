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

<!--- Generates the Salary based on the contract trigger and its associated components as a 1:N relationship 
	I.  Create data set of rates (YEARLY, MONTH, DAY )
	II. Create data set with rates to be used
--->

<CF_DropTable dbName="AppsTransaction" tblName="sal#SESSION.thisprocess#EntitlementContract">	

<!--- verify --->
<cfquery name="Verify" 
datasource="AppsTransaction" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">

	SELECT   P.PersonNo, 
	         P.ContractLevel, 
			 P.ContractStep, 
			 P.ServiceLocation,
			 Per.IndexNo, 
			 Per.LastName, 
			 Per.FirstName, 
			 Per.FullName, 
			 Per.Gender, 
			 Per.Nationality
	FROM     userTransaction.dbo.sal#SESSION.thisprocess#Payroll P INNER JOIN
	         Employee.dbo.Person Per ON P.PersonNo = Per.PersonNo LEFT OUTER JOIN
	         userTransaction.dbo.sal#SESSION.thisprocess#Scale R ON P.SalarySchedule = R.SalarySchedule AND P.ServiceLocation = R.ServiceLocation AND 
	         P.ContractLevel = R.ServiceLevel AND P.ContractStep = R.ServiceStep
	WHERE    P.SalarySchedule = '#Form.Schedule#'  <!--- only for the schedule selected as we may have other legs just to calculate the leg days --->		 
	GROUP BY P.PersonNo, 
	         P.ContractLevel, 
			 P.ServiceLocation, 
			 P.ContractStep, 
			 R.SalarySchedule, 
			 Per.IndexNo, 
			 Per.LastName, 
			 Per.FirstName, 
			 Per.FullName, 
			 Per.Gender, 
			 Per.Nationality
	HAVING   R.SalarySchedule IS NULL 
	ORDER BY P.ServiceLocation,P.ContractLevel  	
</cfquery>

<cfif verify.recordcount gte "1">

	<cfsavecontent variable="message">
	
	<table width="100%" border="0" cellspacing="0" cellpadding="0" bgcolor="ffffaf">
	<tr class="labelmedium"><td colspan="3" align="center"><cf_tl id="No contract rates found for the following employees"></font></td></tr>
	<tr class="labelmedium"><td colspan="3" align="center"><cf_tl id="Please check location and grade"></font></td></tr>
	<cfoutput query="verify">
	<tr class="labelmedium" bgcolor="ffffef"><td><a href="javascript:EditPerson('#PersonNo#')">#PersonNo#</a></td>
	    <td>#FullName#</td>
		<td>#ServiceLocation# : #ContractLevel#/#ContractStep#</td>
	</tr>
	</cfoutput>
	<tr class="labelmedium"><td colspan="3" align="center"><b><a href="javascript:goback()"><cf_tl id="Process interrupted">!</a></b></td></tr>
	</table>
	
	</cfsavecontent>
	
	<cfquery name="Update"
		 datasource="AppsPayroll" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
			    UPDATE CalculationLog 
				SET    ActionStatus = '9',
				       ActionMemo = '#Message#'				    
				WHERE  ProcessNo = '#LogNo#'
		</cfquery>
	
	<cfabort>

</cfif>

<!--- define entitlements triggered by the contract --->

<!--- pointer correction to the maximum available --->
<cfquery name="pointer" 
datasource="AppsPayroll" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT    MAX(EntitlementPointer) AS MaxPointer
    FROM      SalaryScaleComponent 
    WHERE     ScaleNo       = '#Scale.ScaleNo#'  
	AND       SalaryTrigger = 'Contract'       
</cfquery>

<!--- reset entitlement to take only the valid rate --->

<cfquery name="Clear" 
datasource="AppsPayroll" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	UPDATE userTransaction.dbo.sal#SESSION.thisprocess#Payroll
	SET    SalaryPointer = '#pointer.maxpointer#'
	WHERE  SalaryPointer > '#pointer.maxpointer#'
</cfquery>

<!--- this is for the salary calculation which is one line per person, please note that payroll is always paid 
at the SPA level : amended 3/3/2014  --->

<cfquery name="Salary" 
datasource="AppsQuery" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">

	SELECT     S.*, 
	           R.ScaleNo,
			   R.ComponentName, 
			   R.Amount, 
			   R.Period, 
		       R.PayrollItem, 
			   R.SalaryMultiplier, 
			   R.SalaryDays,
			   CONVERT(float, 0) as EntitlementAmountFull,
			   CONVERT(float, 0) as EntitlementAmountDays,
			   CONVERT(float, 0) as EntitlementAmountBase,
			  -- CONVERT(float, 0) as EntitlementAmountWork,
			   CONVERT(float, 0) as EntitlementAmount,
			   
			   CONVERT(float, 0) as PaymentAmountFull,
			   CONVERT(float, 0) as PaymentAmountDays,
			   CONVERT(float, 0) as PaymentAmountBase,
			   CONVERT(float, 0) as PaymentAmount
			   
	INTO       userTransaction.dbo.sal#SESSION.thisprocess#EntitlementContract         <!--- generated rates for the items of the contract --->
	
	FROM       userTransaction.dbo.sal#SESSION.thisprocess#Payroll S INNER JOIN
	           userTransaction.dbo.sal#SESSION.thisprocess#Scale R 
			   		ON 	S.SalaryPointer        = R.EntitlementPointer  <!--- note we match the defined entitlement pointer with the MATCHING rate --->					    
					 					
					AND (CASE R.EntitlementGrade WHEN 'REGULAR' THEN S.SalarySchedule   ELSE S.ContractScheduleSPA  END) = R.SalarySchedule
					AND (CASE R.EntitlementGrade WHEN 'REGULAR' THEN S.ServiceLocation  ELSE S.ContractLocationSPA  END) = R.ServiceLocation
					AND (CASE R.EntitlementGrade WHEN 'REGULAR' THEN S.ContractLevel    ELSE S.ContractLevelSPA     END) = R.ServiceLevel
					AND (CASE R.EntitlementGrade WHEN 'REGULAR' THEN S.ContractStep     ELSE S.ContractStepSPA      END) = R.ServiceStep					
					AND S.SalaryGroup          = R.EntitlementGroup
	AND        R.TriggerGroup       = 'Contract' <!--- this multiplies a variety of entitlemente --->
	<!--- AND        R.Amount <> 0  --->
	AND        TriggerCondition = 'Dependent'  <!--- this determines if we apply a pointer for the rate --->
	
	UNION
	
	SELECT     S.*, 
			   R.ScaleNo,
	           R.ComponentName, 
			   R.Amount, 
			   R.Period, 
			   R.PayrollItem, 
			   R.SalaryMultiplier, 
			   R.SalaryDays,
			   CONVERT(float, 0) as EntitlementAmountFull,
			   CONVERT(float, 0) as EntitlementAmountDays,
			   CONVERT(float, 0) as EntitlementAmountBase,
			   -- CONVERT(float, 0) as EntitlementAmountWork,
			   CONVERT(float, 0) as EntitlementAmount,
			   
			   CONVERT(float, 0) as PaymentAmountFull,
			   CONVERT(float, 0) as PaymentAmountDays,
			   CONVERT(float, 0) as PaymentAmountBase,
			   CONVERT(float, 0) as PaymentAmount
			   
	FROM       userTransaction.dbo.sal#SESSION.thisprocess#Payroll S, userTransaction.dbo.sal#SESSION.thisprocess#Scale R 
	WHERE     (CASE R.EntitlementGrade WHEN 'REGULAR' THEN S.SalarySchedule   ELSE S.ContractScheduleSPA  END) = R.SalarySchedule
		  AND (CASE R.EntitlementGrade WHEN 'REGULAR' THEN S.ServiceLocation  ELSE S.ContractLocationSPA  END) = R.ServiceLocation
		  AND (CASE R.EntitlementGrade WHEN 'REGULAR' THEN S.ContractLevel    ELSE S.ContractLevelSPA     END) = R.ServiceLevel
		  AND (CASE R.EntitlementGrade WHEN 'REGULAR' THEN S.ContractStep     ELSE S.ContractStepSPA      END) = R.ServiceStep				 
		  AND  S.SalaryGroup          = R.EntitlementGroup
	AND        R.TriggerGroup         = 'Contract' 
	<!--- AND        R.Amount <> 0 --->
	AND        R.TriggerCondition = 'None' 
	
</cfquery>

<!--- update amount in case salary is manually entered --->

<cfquery name="Schedule" 
datasource="AppsPayroll" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT * 
	FROM   SalarySchedule 
	WHERE  SalarySchedule = '#Form.Schedule#'
</cfquery>

<!--- ---------------------------------------------------------------------------- --->
<!--- correction for suspension to be included only where this is prudent to do so --->
<!--- ---------------------------------------------------------------------------- 

embedded in the structure of the calculation 23/1/2018

<cfquery name="Correction" 
	datasource="AppsQuery" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		UPDATE  dbo.sal#SESSION.thisprocess#EntitlementContract 
		SET     PayrollSuspend = 0
		FROM    dbo.sal#SESSION.thisprocess#EntitlementContract  P
		WHERE   EXISTS (SELECT 'X' 
		                FROM  Payroll.dbo. SalaryScaleComponent
						WHERE ScaleNo        = P.ScaleNo
						AND   ComponentName  = P.ComponentName 	
						AND   SalaryDays    != '3')
</cfquery>

--->
	
<cfif Schedule.SalaryBaseRate eq "0" and Schedule.SalaryBasePayrollItem neq "">

	<cfquery name="Manual" 
	datasource="AppsQuery" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	
		UPDATE  userTransaction.dbo.sal#SESSION.thisprocess#EntitlementContract 
		SET     Amount        = ContractSalaryAmount
		WHERE   PayrollItem = '#Schedule.SalaryBasePayrollItem#' 	
		
	</cfquery>

</cfif>	

<cfquery name="YearRates" 
datasource="AppsQuery" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">

	UPDATE userTransaction.dbo.sal#SESSION.thisprocess#EntitlementContract 
	
	SET    EntitlementAmountFull = round((Amount/12)*SalaryMultiplier*(ContractTime/100),3),   <!--- reflects the amount for a NORMAL month : no leave, no expiration --->	
		   EntitlementAmountDays = round(((PayrollDays)/#Form.SalaryDays#)*(Amount/12)*SalaryMultiplier*(ContractTime/100),3), <!--- payable days + PLUS SLWOP + PLUS Suspend --->		     
		   EntitlementAmountBase = round(((PayrollDays-PayrollSLWOP)/#Form.SalaryDays#)*(Amount/12)*SalaryMultiplier*(ContractTime/100),3), <!--- payable days PLUS temp. suspension days --->		     
		   EntitlementAmount     = round(((PayrollDays-PayrollSuspend-PayrollSLWOP)/#Form.SalaryDays#)*(Amount/12)*SalaryMultiplier*(ContractTime/100),3), <!--- reflects payable days --->
		   
		   PaymentAmountFull     = round((Amount/12)*SalaryMultiplier*(ContractTime/100),3),	
		   PaymentAmountDays     = round(((PayrollDays)/#Form.SalaryDays#)*(Amount/12)*SalaryMultiplier*(ContractTime/100),3), <!--- payable days + PLUS SLWOP + PLUS Suspend --->		 
		   PaymentAmountBase     = round(((PayrollDays-PayrollSLWOP)/#Form.SalaryDays#)*(Amount/12)*SalaryMultiplier*(ContractTime/100),3),	
		   PaymentAmount         = round(((PayrollDays-PayrollSLWOP-PayrollSuspend)/#Form.SalaryDays#)*(Amount/12)*SalaryMultiplier*(ContractTime/100),3) <!--- reflects payable days --->
		   
	WHERE  Period = 'YEAR'
	
</cfquery>

<cfquery name="MonthRates" 
datasource="AppsQuery" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">

	UPDATE  userTransaction.dbo.sal#SESSION.thisprocess#EntitlementContract 
	
	SET     EntitlementAmountFull = round(Amount*SalaryMultiplier*(ContractTime/100),3),     <!--- reflects the amount for a NORMAL month : no leave, no expiration --->
			EntitlementAmountDays = round(((PayrollDays)/#Form.SalaryDays#)*Amount*SalaryMultiplier*(ContractTime/100),3), <!--- payable days PLUS temp. suspension days --->						
			EntitlementAmountBase = round(((PayrollDays-PayrollSLWOP)/#Form.SalaryDays#)*Amount*SalaryMultiplier*(ContractTime/100),3), <!--- payable days PLUS temp. suspension days --->			
			EntitlementAmount     = round(((PayrollDays-PayrollSLWOP-PayrollSuspend)/#Form.SalaryDays#)*Amount*SalaryMultiplier*(ContractTime/100),3), <!--- reflects payable days --->
			
			PaymentAmountFull     = round((Amount)*SalaryMultiplier*(ContractTime/100),3),	
			PaymentAmountDays     = round(((PayrollDays)/#Form.SalaryDays#)*Amount*SalaryMultiplier*(ContractTime/100),3), <!--- payable days PLUS temp. suspension days --->									
		    PaymentAmountBase     = round(((PayrollDays-PayrollSLWOP)/#Form.SalaryDays#)*Amount*SalaryMultiplier*(ContractTime/100),3),
		    PaymentAmount         = round(((PayrollDays-PayrollSLWOP-PayrollSuspend)/#Form.SalaryDays#)*Amount*SalaryMultiplier*(ContractTime/100),3) <!--- reflects payable days --->
			
	WHERE   Period = 'MONTH'
	
</cfquery>

<cfquery name="DayRates" 
datasource="AppsQuery" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">

	UPDATE  userTransaction.dbo.sal#SESSION.thisprocess#EntitlementContract 
	
	SET     EntitlementAmountFull = round(PayrollDays*Amount*SalaryMultiplier*(ContractTime/100),3),  <!--- reflects the amount for a NORMAL month : no leave, no expiration --->
			EntitlementAmountDays = round((PayrollDays)*Amount*SalaryMultiplier*(ContractTime/100),3), <!--- payable days PLUS SLWOP and SUSPEND --->
			EntitlementAmountBase = round((PayrollDays-PayrollSLWOP)*Amount*SalaryMultiplier*(ContractTime/100),3), <!--- payable days PLUS temp. suspension days --->
	        EntitlementAmount     = round((PayrollDays-PayrollSLWOP-PayrollSuspend)*Amount*SalaryMultiplier*(ContractTime/100),3),  <!--- reflects payable days --->
			
			PaymentAmountFull     = round(PayrollDays*Amount*SalaryMultiplier*(ContractTime/100),3),
			PaymentAmountDays     = round((PayrollDays)*Amount*SalaryMultiplier*(ContractTime/100),3), <!--- payable days PLUS SLWOP and SUSPEND --->			
		    PaymentAmountBase     = round((PayrollDays-PayrollSLWOP)*Amount*SalaryMultiplier*(ContractTime/100),3),
		    PaymentAmount         = round((PayrollDays-PayrollSLWOP-PayrollSuspend)*Amount*SalaryMultiplier*(ContractTime/100),3) <!--- reflects payable days --->
			
	WHERE   Period = 'DAY'
	
</cfquery>

<!--- ATTENTION to read from SalaryScaleComponent file --->
<!--- SPECIAL SALARY DAY RATES : Bono SAT aniversario --->

<cfquery name="DayRate" 
datasource="AppsPayroll" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT    *
	FROM      SalaryScheduleComponent
	WHERE     Period         = 'DAY'
	AND       SalarySchedule = '#Form.Schedule#'
	AND       ComponentName IN (SELECT  ComponentName
		  	                    FROM    SalaryScheduleComponentDate
								WHERE   SalarySchedule = '#Form.Schedule#') 
</cfquery>                    

<cfloop query="DayRate">
	
	<cfquery name="Date" 
	datasource="AppsPayroll" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT  TOP 1 *
		FROM    SalaryScheduleComponentDate
		WHERE   SalarySchedule = '#Form.Schedule#' 
		AND     ComponentName  = '#ComponentName#'
		AND     EntitlementDate > #SALSTR# 
		AND     EntitlementDate < #SALEND#
	</cfquery>	
	
	<cfif date.recordcount eq "0">
		
		<cfquery name="clean" 
		datasource="AppsPayroll" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			DELETE FROM userTransaction.dbo.sal#SESSION.thisprocess#EntitlementContract 
			WHERE  ComponentName = '#ComponentName#' 
		</cfquery>		
				
	<cfelse>
	
		<cfquery name="DayRates" 
		datasource="AppsPayroll" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			DELETE FROM userTransaction.dbo.sal#SESSION.thisprocess#EntitlementContract 
			WHERE  ComponentName = '#ComponentName#'
			AND    (DateEffective > '#dateformat(Date.EntitlementDate,client.dateSQL)#'
					            OR
				   DateExpiration < '#dateformat(Date.EntitlementDate,client.dateSQL)#')		
		</cfquery>
		
	</cfif> 
	
	<cfquery name="DayRates" 
	datasource="AppsQuery" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		UPDATE userTransaction.dbo.sal#SESSION.thisprocess#EntitlementContract 
		SET    EntitlementAmountBase = round(Amount*(ContractTime/100),3),
		       EntitlementAmount     = round(Amount*(ContractTime/100),3),
			   PaymentAmountBase     = round(Amount*(ContractTime/100),3),
			   PaymentAmount         = round(Amount*(ContractTime/100),3)
		WHERE  Period                = 'DAY' 
		AND    ComponentName         = '#ComponentName#'
	</cfquery>

</cfloop>

<cftransaction>

	<cfquery name="Insert" 
	datasource="AppsPayroll" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		INSERT INTO EmployeeSalary
		
				(PersonNo, 
				 PayrollStart, 
				 PayrollEnd, 
				 PayrollCalcNo,
				 Mission, 
				 PositionParentId,
				 PositionNo,

				 PostType,
				 PostClass,
				 FunctionDescription,
				 ContractTime,
				 ContractLevel,
				 ContractStep,

				 OrgUnit, 
				 SalarySchedule, 
				 
				 ServiceSchedule,
				 ServiceLevel, 
				 ServiceStep, 
				 ServiceLocation, 
				 
				 SalaryCalculatedStart, 
			     SalaryCalculatedEnd, 
				 SalaryDays, 				
				 SalarySLWOP, 		
				 SalarySUSPEND,	
				 PaymentCurrency, 	
				 OfficerUserId, 
				 OfficerLastName, 
				 OfficerFirstName)
			 
		SELECT   PersonNo, 
				 #SALSTR#, 
				 #SALEND#, 
				 Line,
				 Mission, 
				 PositionParentId,	
				 PositionNo,
				
				 PostType,
				 PostClass,
				 FunctionDescription,
				 ContractTime,
				 ContractLevel,
				 ContractStep,

				 OrgUnit, 
				 SalarySchedule, 
				 
				 ContractScheduleSPA,
				 ContractLevelSPA, 
				 ContractStepSPA, 
				 ContractLocationSPA, 
				 
				 DateEffective, 
			     DateExpiration, 
				 PayrollDays, 				
				 PayrollSLWOP,		
				 PayrollSUSPEND,	 
				 PaymentCurrency, 	
				 '#SESSION.acc#', 
				 '#SESSION.last#', 
				 '#SESSION.first#' 
				 
		FROM   userTransaction.dbo.sal#SESSION.thisprocess#Payroll 
		WHERE  SalarySchedule = '#Form.Schedule#'
		
	</cfquery>
	
	<cfloop index="itm" list="0,1,2,3" delimiters=",">
		
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
					 ComponentName,
					 PayrollItem, 
					 EntitlementSalarySchedule,
					 EntitlementWorkday,
					 EntitlementPeriod, 
					 EntitlementSLWOP,
					 EntitlementSuspend,
					 EntitlementSickleave,
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
					 
					 Reference, 
					 ReferenceId, 
					 CalculationSource,
					 OfficerUserId, 
					 OfficerLastName, 
					 OfficerFirstName)
					 
			SELECT   SalarySchedule,
					 PersonNo, 
					 #SALSTR#, 
					 '#form.Mission#',
					 Line,
					 ComponentName,
					 PayrollItem,
					 ContractScheduleSPA,
					 WorkDays,
					 PayrollDays,
					 PayrollSLWOP,
					 PayrollSuspend, 
					 PayrollSickLeave,
					 'DAY',
					 PaymentCurrency, 					 
					 
					 <!--- the below  amounts are used for successive calculation processing for other component --->					 
					 EntitlementAmountFull, <!--- EntitlementAmountBase corrected 9/22/2017 Hanno after Karin reported percentages for overtime were not applied correctly --->												  
					 EntitlementAmountDays,
					 EntitlementAmountBase,						 					 
					 EntitlementAmount,
					 <!--- these amounts are used for payment processing depends on the setting 
					                                           of this component which amount to take --->				 					  
					 <cfif itm eq "3">					 
					 <!--- (3) Entitlement days -/- LWOP -/- Suspended) --->					 
						 EntitlementAmount, 	
						 PaymentAmount, 
						 PaymentCurrency, 
						 ROUND(EntitlementAmount, #roundsettle#), 
						 ROUND(PaymentAmount, #roundsettle#), 
					  <cfelseif itm eq "0">
					 <!--- (0) Entitlement days -/- LWOP --->
						 EntitlementAmountBase, 	
						 PaymentAmountBase, 
						 PaymentCurrency, 
						 ROUND(EntitlementAmountBase, #roundsettle#), 
						 ROUND(PaymentAmountBase, #roundsettle#),  	 
					 <cfelseif itm eq "1">
					 <!--- (1) Entitlement days --->
						 EntitlementAmountDays, 	
						 PaymentAmountDays, 
						 PaymentCurrency, 
						 ROUND(EntitlementAmountDays, #roundsettle#), 
						 ROUND(PaymentAmountDays, #roundsettle#), 	 			 
					 <cfelse>
					 <!--- (2) Apply full rate, regardless of days (like Medical insurance) --->
						 EntitlementAmountFull, 	
						 PaymentAmountBase, 
						 PaymentCurrency, 
						 ROUND(EntitlementAmountFull, #roundsettle#), 
						 ROUND(PaymentAmountFull, #roundsettle#), 	 
					 </cfif>	
					  
					 'Contract',
				     ContractId, 
					 'Salary',
					 '#SESSION.acc#', 
					 '#SESSION.last#', 
					 '#SESSION.first#'
			FROM     userTransaction.dbo.sal#SESSION.thisprocess#EntitlementContract 	
			WHERE    SalarySchedule = '#Form.Schedule#'
			AND      SalaryDays = #itm#
			
			<!--- AND      PaymentAmount != '0' 17/1 corrected as we need the records for calculation purposes in case of percentages on the total amount --->
		</cfquery>	
	
	</cfloop>

</cftransaction>
