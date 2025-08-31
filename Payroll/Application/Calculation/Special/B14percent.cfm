<!--
    Copyright © 2025 Promisan B.V.

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
<!--- entitlement is LAST salary+component (A) * (days since last payment) / 365 --->
		
<cfset name = replace("#ComponentName#"," ","","ALL")>

<CF_DropTable dbName="AppsTransaction" tblName="sal#SESSION.thisprocess#SalaryLine">
<CF_DropTable dbName="AppsTransaction" tblName="sal#SESSION.thisprocess##name#">	

<!--- check if component exists for this schedule+mission : likely an overkill--->

<cfquery name="Check" 
	datasource="AppsPayroll" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT S.ComponentName, I.PayrollItem 
		FROM   SalaryScheduleComponent S, Ref_PayrollItem I
		WHERE  S.PayrollItem     = I.PayrollItem
		AND    S.ComponentName   = '#ComponentName#'
		AND    S.ComponentName IN (
		               SELECT ComponentName 
		               FROM   SalaryScale S INNER JOIN SalaryScalePercentage P ON S.ScaleNo         = P.ScaleNo
					   WHERE  S.Mission        = '#Form.Mission#'
					   AND    S.SalarySchedule = '#Form.Schedule#'							
								  ) 
</cfquery>

<!--- we take the full history of the person for review, maybe we cna make this quicker !!!!
   to make query faster and not to rely on source table --->

<cfquery name="Entitlement" 
		datasource="AppsPayroll" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT  *
			INTO    userTransaction.dbo.sal#SESSION.thisprocess#SalaryLine
			FROM    EmployeeSalaryLine L
			WHERE   1 = 1
			<cfif Form.PersonNo neq "">
		    AND     PersonNo = '#Form.PersonNo#'
			<cfelse>
			AND     PersonNo NOT IN (#preservesingleQuotes(selper)#)   
			</cfif>
			AND       Mission        = '#Form.Mission#'
</cfquery>

<cfif check.recordcount gte "1">
		
	<!--- identify people that are in payroll for this component --->
		
	<cfquery name="base" 
		datasource="AppsPayroll" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT    TOP 1 *
			FROM      SalarySchedulePeriod
			WHERE     SalarySchedule = '#Form.Schedule#'
			AND       Mission        = '#Form.Mission#'
			ORDER BY  PayrollStart 
	</cfquery>
	
	<CF_DateConvert Value="#DateFormat(Base.PayrollStart,CLIENT.DateFormatShow)#">
	<cfset edt = dateValue>	
		
	<cfquery name="CalculationBaseTable" 
	datasource="AppsPayroll" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT DISTINCT 
		       Ent.PersonNo, 
			   Ent.EntitlementId,
			   Ent.DateEffective, 
			   Ent.DateExpiration, 
			   Ent.Status, 
			   Ent.Line,
			   R.SalaryTrigger, 
			   R.PayrollItem, 
			   R.PaymentCurrency,
			   R.Percentage, 
			   Ent.ContractTime,
			   R.CalculationBase,
			   R.SalaryMultiplier,
			   #edt# as EntitlementStart,
			   CONVERT(float, 0) as EntitlementDays,
			   CONVERT(float, 0) as EntitlementBase,
			   CONVERT(float, 0) as EntitlementAmount,
			   CONVERT(float, 0) as PaymentAmount
		INTO   userTransaction.dbo.sal#SESSION.thisprocess##name#   
		FROM   userTransaction.dbo.sal#SESSION.thisprocess#Entitlements Ent,
		       userTransaction.dbo.sal#SESSION.thisprocess#Percentage R,			   
			   <!--- take the last rate as basis --->
			   (SELECT PersonNo, MAX(Line) as Line FROM userTransaction.dbo.sal#SESSION.thisprocess#Entitlements GROUP BY PersonNo ) as X
			   
		WHERE  Ent.SalaryTrigger    = R.SalaryTrigger
		AND    R.SalarySchedule     = Ent.SalarySchedule 
		AND    R.ServiceLocation    = Ent.ServiceLocation
		AND    Ent.EntitlementClass = 'Percentage' 
		AND    R.ComponentName      = '#ComponentName#'
		AND    Ent.PersonNo         = X.PersonNo
		AND    Ent.Line             = X.Line
	</cfquery>			
	<!--- define the base amount for the percentage to be applied to --->
	
	<cfquery name="CalculationBase" 
	datasource="AppsPayroll" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT DISTINCT CalculationBase as Code 
		FROM   userTransaction.dbo.sal#SESSION.thisprocess##name#   
	</cfquery>
	
	<cfif calculationbase.recordcount eq "0">
	  <!--- we skip the loop this is performed under ---> 
	  <cfexit method="EXITTEMPLATE">
	</cfif>
	
	<!--- retrieve the prior period --->
	
	<cfquery name="prior" 
		datasource="AppsPayroll" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT    TOP 1 *
			FROM      SalarySchedulePeriod
			WHERE     SalarySchedule = '#Form.Schedule#'
			AND       Mission        = '#Form.Mission#'
			AND       PayrollStart < #SALSTR# 
			ORDER BY  PayrollStart DESC   
		</cfquery>
	
	<CF_DropTable dbName="AppsTransaction" tblName="sal#SESSION.thisprocess##name#PriorPeriod">	
	
		<!--- determine the found PRIOR period for that specific employee 
		  in order to obtain the prior month salary --->
		
		<cfquery name="TakePeriodForSalaryBase" 
			datasource="AppsPayroll" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT     PersonNo, 			           
				           MIN(PayrollStart) AS TakePeriod
				INTO       userTransaction.dbo.sal#SESSION.thisprocess##name#PriorPeriod
				FROM       EmployeeSalary
				WHERE      Mission = '#Form.Mission#'
				AND        PersonNo IN (SELECT PersonNo 
				                        FROM   userTransaction.dbo.sal#SESSION.thisprocess##name#)			
				AND        PayrollStart <= #SALSTR#
				AND        PayrollStart >= '#dateformat(prior.PayrollStart,dateSQL)#'  						
				GROUP BY   PersonNo					
		</cfquery>		
	
		<cfset comp = ComponentName>
	
		<!--- should have just one record --->
	
		<cfloop query = "CalculationBase">
		
			<CF_DropTable dbName="AppsTransaction" tblName="sal#SESSION.thisprocess#CalculationBase#Code#">	
						
			<!--- define the period that will be the basis for the amount --->
												
			<cfquery name="calcbase" 
			datasource="AppsPayroll" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT    *
				FROM      Ref_CalculationBase
				WHERE     Code = '#Code#'
			</cfquery>
			
			<!--- determine the total Aguinaldo 
			  entitlement amount of the PRIOR period for that person : NOT SURE which to take here DAYS--->
						
			<cfquery name="calculationbaseamount" 
			datasource="AppsPayroll" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT    L.PersonNo, 			  
						  <cfif calcbase.BaseAmount eq "0">
						  	round(SUM(AmountCalculation),2) AS AmountCalculation
						  <cfelse>
						  	round(SUM(AmountCalculationBase),2) AS AmountCalculation
						  </cfif>
				INTO      userTransaction.dbo.sal#SESSION.thisprocess#CalculationBase#code#
				FROM      userTransaction.dbo.sal#SESSION.thisprocess#SalaryLine   L,
						  userTransaction.dbo.sal#SESSION.thisprocess##name#PriorPeriod F
				WHERE     L.PayrollItem IN (SELECT PayrollItem 
				                            FROM   Ref_CalculationBaseItem 
										    WHERE  Code           = '#Code#'
										    AND    SalarySchedule = '#Form.Schedule#')
				AND       L.PersonNo     = F.PersonNo						  
				AND       L.PayrollStart = F.TakePeriod 
				AND       L.PersonNo IN (SELECT PersonNo 
				                         FROM userTransaction.dbo.sal#SESSION.thisprocess##name#)
				GROUP BY  L.PersonNo			 
			</cfquery>
						
		</cfloop>	
	
	<!--- now we know what was last salary over which it was calculated = A --->
	
	<CF_DropTable dbName="AppsTransaction" tblName="sal#SESSION.thisprocess##name#StartDate">			
								
		<!--- now we define the last settlement for this component --->	
	
	   <cfquery name="LastPayment" 
		datasource="AppsPayroll" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT     R.PersonNo, 
			           MAX(P.PayrollStart) AS LastPayment,
					   'LastPayment' as Mode
			INTO       userTransaction.dbo.sal#SESSION.thisprocess##name#StartDate  
			FROM       userTransaction.dbo.sal#SESSION.thisprocess##name# R LEFT OUTER JOIN
		       	       EmployeeSettlementLine P ON R.PersonNo = P.PersonNo 
				   AND P.PayrollItem = '#Check.PayrollItem#' <!--- last time for Aguinaldo payment --->
				   AND P.PayrollStart < #SALSTR#
			GROUP BY   R.PersonNo							
	   </cfquery>
		
	   <!--- In case person was never paid aguinaldo yet, 
	     then we take first date of any payment = contract start : 
		 ATTENTION : this maybe needs some provision to prevent 2 years of aguinaldo --->
	   
			   <cfquery name="TakeStartDate" 
					datasource="AppsPayroll" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						SELECT     PersonNo, MIN(PayrollStart) AS TakeFirst				
						FROM       EmployeeSalary
						WHERE      PersonNo IN (SELECT PersonNo 
					                            FROM   userTransaction.dbo.sal#SESSION.thisprocess##name#StartDate
											    WHERE  LastPayment is NULL)
						AND        PayrollStart <= #SALSTR#
						GROUP BY   PersonNo	
				</cfquery>		
						
				<cfquery name="UpdateFromStart" 
					datasource="AppsPayroll" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						UPDATE     userTransaction.dbo.sal#SESSION.thisprocess##name#StartDate  
						SET        LastPayment = E.TakeFirst,
						           Mode        = 'Contract'
								   
						FROM       userTransaction.dbo.sal#SESSION.thisprocess##name#StartDate L,
						           
								   (SELECT     PersonNo, 
								               MIN(PayrollStart) AS TakeFirst				
									FROM       EmployeeSalary
									WHERE      PayrollStart <= #SALSTR#
									AND        PersonNo IN (SELECT PersonNo 
								                            FROM   userTransaction.dbo.sal#SESSION.thisprocess##name#StartDate
														    WHERE  LastPayment is NULL)
									GROUP BY   PersonNo	
									) as E
									
						WHERE      L.PersonNo = E.PersonNo		  		   				
				</cfquery>	
		
		<!--- end of provision --->
		
		
		<!--- define the days of entitlement for aguinaldo in the prior month 
			ATTENTION : Much better to be combine with loop on line 155 --->
				
		<CF_DropTable dbName="AppsTransaction" tblName="sal#SESSION.thisprocess##name#DaysBase">	
						
		<cfquery name="TakeSalaryDays" 
			datasource="AppsPayroll" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT     S.PersonNo, 
						   B.CalculationBaseDays,
				           SUM(SalaryDays) as SalaryDays					   
				INTO       userTransaction.dbo.sal#SESSION.thisprocess##name#DaysBase
				FROM       EmployeeSalary S,
				           userTransaction.dbo.sal#SESSION.thisprocess##name#PriorPeriod P,
						   SalarySchedulePeriod B	
				WHERE      S.PersonNo IN (SELECT PersonNo FROM userTransaction.dbo.sal#SESSION.thisprocess##name#)				   
				AND        S.Mission        = B.Mission
				AND        S.SalarySchedule = B.SalarySchedule
				AND        S.PayrollStart   = B.PayrollStart      
				AND        S.PayrollStart   = P.TakePeriod
				AND        S.PersonNo       = P.PersonNo				
				GROUP BY   S.PersonNo, 
				           B.CalculationBaseDays	
						  
		</cfquery>
				
		<!--- Now we get the days of entitlement SINCE the last payment --->		
		
		<CF_DropTable dbName="AppsTransaction" tblName="sal#SESSION.thisprocess##name#DaysEntitlement">		
		
		<cfquery name="EntitlementDays" 
			datasource="AppsPayroll" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#"> 
			SELECT    L.PersonNo, 
					  sum(S.SalaryDays) AS EntitlementDays 
			INTO      userTransaction.dbo.sal#SESSION.thisprocess##name#DaysEntitlement     
			FROM      EmployeeSalary S,
			          userTransaction.dbo.sal#SESSION.thisprocess##name#StartDate L
			WHERE     S.PersonNo      = L.PersonNo
			AND       S.Mission = '#Form.Mission#'
			AND       S.PayrollStart >= L.LastPayment  <!--- maybe this has to be > not >= --->
			AND       S.PayrollStart <= #SALSTR# 	   <!--- maybe this has to be < not <= --->		
			GROUP BY  L.PersonNo  
		</cfquery>			
						
		<cfif Schedule.SalaryBasePeriodDays eq "21.75">
		
			<cfset base = 12*21.75>
			
		<cfelseif Schedule.SalaryBasePeriodDays eq "30fix">	
		
			<cfset base = 360>
		
		<cfelse>
		
			<!--- based on fact aguinaldo starts in dec : 
			Attention : we need to change this into month of 30 days so it will be 360 --->
		
			<cfif month(SALSTR) eq "12">
				<cfset base = DaysInYear(SALSTR+50)>
			<cfelse>		
				<cfset base = DaysInYear(SALSTR)>
			</cfif>		
			
		</cfif>		
						
		<!--- calculated total entitlement until today --->												
							
		<cfquery name="Update" 
		datasource="AppsPayroll" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			UPDATE  userTransaction.dbo.sal#SESSION.thisprocess##name#
			SET     EntitlementDays    = B.SalaryDays, 
				    EntitlementBase    = '#base#',				   			
			        EntitlementAmount  = round((S.AmountCalculation)*(D.EntitlementDays/#base#)*(B.CalculationBaseDays/B.SalaryDays),2),
				    PaymentAmount      = round((S.AmountCalculation)*(D.EntitlementDays/#base#)*(B.CalculationBaseDays/B.SalaryDays)*T.SalaryMultiplier,2)
			FROM    userTransaction.dbo.sal#SESSION.thisprocess##name# T,	
			        userTransaction.dbo.sal#SESSION.thisprocess#CalculationBase#CalculationBase.code# S,
					userTransaction.dbo.sal#SESSION.thisprocess##name#DaysEntitlement D,
					userTransaction.dbo.sal#SESSION.thisprocess##name#DaysBase B
			WHERE   S.PersonNo         = T.PersonNo
			AND     D.PersonNo         = T.PersonNo
			AND     B.PersonNo         = T.PersonNo
			AND     T.CalculationBase  = '#CalculationBase.code#'   
		</cfquery>	
				
			
		<CF_DropTable dbName="AppsTransaction" tblName="sal#SESSION.thisprocess#RecordedEntitlement">	
		
		<!--- already recorded entitlement amounts since defined start date --->
		
		<!--- should not look into the future --->
	
		<cfquery name="PriorEntitlement" 
			datasource="AppsPayroll" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT   L.PersonNo, sum(AmountCalculation) as Total 
				INTO     userTransaction.dbo.sal#SESSION.thisprocess#RecordedEntitlement
				FROM     userTransaction.dbo.sal#SESSION.thisprocess#SalaryLine L,
	     			     userTransaction.dbo.sal#SESSION.thisprocess##name#StartDate S 
				WHERE    L.SalarySchedule = '#Form.Schedule#'
				AND      L.PayrollItem    = '#Check.PayrollItem#' 
				AND      L.PayrollStart   >= S.LastPayment
				<!--- should not look into the future 30/4/2009 --->
				AND      L.PayrollStart   <= #SALSTR#
				AND      L.PersonNo       = S.PersonNo		
				GROUP BY L.PersonNo	
		</cfquery>
		
		<!--- define the difference --->
	
		<cfquery name="IncrementalEntitlement" 
			datasource="AppsPayroll" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				UPDATE  userTransaction.dbo.sal#SESSION.thisprocess##name#
				SET     EntitlementAmount  = EntitlementAmount - P.Total,
					    PaymentAmount      = abs(EntitlementAmount - P.Total)*SalaryMultiplier
				FROM    userTransaction.dbo.sal#SESSION.thisprocess##name# T,	
				        userTransaction.dbo.sal#SESSION.thisprocess#RecordedEntitlement P
				WHERE   P.PersonNo         = T.PersonNo
				AND     T.CalculationBase  = '#CalculationBase.code#'  
		</cfquery>		
					
	<!--- insert new lines --->
	
	<cfquery name="InsertLine" 
	datasource="AppsPayroll" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		INSERT INTO EmployeeSalaryLine
			(SalarySchedule,PersonNo,  
			 PayrollStart, 
			 Mission,
			 PayrollCalcNo,
			 PayrollItem, 
			 EntitlementPeriod,
			 EntitlementPeriodUoM,
			 Currency, 
			 AmountCalculation, 
			 AmountPayroll, 
			 PaymentCurrency, 
			 PaymentCalculation, 
			 PaymentAmount, 
		     Reference, 
			 ReferenceId, 
			 OfficerUserId, 
			 OfficerLastName, 
			 OfficerFirstName)
		SELECT    '#Form.Schedule#',PersonNo, 
				  #SALSTR#, 
				  '#form.mission#',
				  '1',
				  PayrollItem,
				  EntitlementDays,
				  'Percentage',
				  PaymentCurrency,
				  EntitlementAmount, 
				  PaymentAmount, 
				  PaymentCurrency, 
				  ROUND(EntitlementAmount, 2), 
				  ROUND(PaymentAmount, 2), 
				  'Entitlement',
			      EntitlementId, 
				  '#SESSION.acc#', 
				  '#SESSION.last#', 
				  '#SESSION.first#'
			FROM  userTransaction.dbo.sal#SESSION.thisprocess##name# P
			WHERE EntitlementAmount != '0'
			AND   EXISTS (SELECT 'X' 
		                  FROM  EmployeeSalary
				          WHERE PersonNo       = P.PersonNo
					      AND   PayrollCalcNo  = P.Line
					      AND   SalarySchedule = '#Form.Schedule#'
					      AND   PayrollStart   = #SALSTR#)	
	</cfquery>	

</cfif>