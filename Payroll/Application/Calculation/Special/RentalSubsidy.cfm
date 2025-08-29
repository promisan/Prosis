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
<!--- 

obtain the salary amount at real time
obtain the threshold : 25% on the salary amount 
	obtain the NET RENT from the user entry form	
	obtain the maximum rent allowed
take the lowest and define difference and apply percentage (80%)	
allowance is not higher than 40% of the NET RENT 

--->
	
<cfset basecode = "Rental">   
	   
<cfquery name="rentallist" 
	datasource="AppsPayroll" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	
    SELECT    PersonNo, 
	          Line,
			  ServiceLocation,
			  ContractTime,
			  PayrollItem,
	          DateEffective, 
			  
			  PayrollDaysCorrectionPointer,
			  
			  <!---  Attention Hanno! here I made the change person 8871 lwop made 2.75 days it should be 4 --->
			  CASE WHEN PayrollDaysCorrectionPointer = 1 THEN 			  
			  		    EntitlementDays - EntitlementLWOP
				   ELSE EntitlementDays
			  END AS EntitlementDays, 
			  
			  EntitlementLWOP, 
			  DateExpiration, 			  
			  EntitlementPointer,
			  EntitlementGroup, 
			  CurrencyEntitlement, <!--- rent expressed in currency --->
			  AmountEntitlement as AmountRent,   <!--- recorded amount for rent --->
			  PaymentCurrency, 
              Amount,
			  EntitlementAmount,  <!--- the rate found in the ssalary cale which reflects the maximum rent, coverted for the days --->
			  PaymentAmount,
			  					
			  ( 
			  	SELECT   ROUND(SUM(AmountCalculationFull),2) AS AmountIncome								
			    FROM     EmployeeSalaryLine				
			    WHERE    PayrollItem IN (SELECT PayrollItem 
				                         FROM   Ref_CalculationBaseItem 
									     WHERE  Code           = '#BaseCode#'
									     AND    SalarySchedule = '#Form.Schedule#') 									  
			    AND      PayrollStart = #SALSTR#
			    AND      PersonNo      = A.PersonNo
			    AND      PayrollCalcNo = A.Line	 						  
		 	    AND      SalarySchedule = '#Form.Schedule#' 
			    <!--- hardcoded STL to exclude transitional allowance to be considered --->
			    AND      PayrollItem != 'A11'
			  
			  ) as AmountIncome	,
			  
			   ( 
			  	SELECT   SalaryDays								
			    FROM     EmployeeSalary		
			    WHERE    PersonNo      = A.PersonNo  
			    AND      PayrollStart = #SALSTR#
			    AND      PersonNo      = A.PersonNo
			    AND      PayrollCalcNo = A.Line	 						  
		 	    AND      SalarySchedule = '#Form.Schedule#' 
			   			  
			  ) 
			  
			  as AmountDays		  
			  
	FROM      userTransaction.dbo.sal#SESSION.thisprocess#EntitlementRateAmount A
	WHERE     SalaryTrigger = 'RentalSubsidy'	
	AND       EntitlementDays > EntitlementLWOP
	ORDER BY PersonNo, PayrollItem
	
			
</cfquery>

<!--- exchange rate --->

<cfoutput query="rentallist" group="PersonNo">		

<cfoutput group="PayrollItem">

	<cfquery name="update" 
		datasource="AppsPayroll" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		UPDATE    EmployeeSalaryLine
		SET       AmountPayroll       = 0,  
	              PaymentCalculation  = 0, 
				  PaymentAmount       = 0 
				  
		WHERE     PersonNo      = '#PersonNo#' 
		AND       PayrollItem   = '#PayrollItem#' 
		AND       PayrollCalcNo = '#line#'
		AND       PayrollStart  = #SALSTR#
		AND       Mission       = '#form.Mission#'
	</cfquery>	

	<cfoutput>
		
		<!--- make calculation : Lebanon has lower percentage 22 and 23--->
		
		<cfquery name="getPointer" 
		datasource="AppsPayroll" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT  *     
			FROM    userTransaction.dbo.sal#SESSION.thisprocess#Entitlements
			WHERE   DependentId <> '00000000-0000-0000-0000-000000000000' 
			 <!--- hardcoded STL to exclude transitional allowance to be considered for the pointer percentage --->
			AND     SalaryTrigger IN ('FirstDepChild', 'DepSpouseAllow') 
			AND     Personno = '#PersonNo#'
		</cfquery>
		
		<cfif getPointer.recordcount gte "1">
			<cfset spousepointer = "1">
		<cfelse>
			<cfset spousepointer = "0">
		</cfif>	
		
		<cfquery name="getPointer" 
		datasource="AppsPayroll" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT   TOP 1 * 
			FROM     Ref_PayrollLocationPointer
			WHERE    LocationCode   = '#serviceLocation#'
			AND      DateEffective <= #SALSTR#
			AND      Element        = 'RR'
			AND      ElementPointer = '#spousepointer#'
			ORDER BY DateEffective DESC
					
		</cfquery>	
		
		<cfif getPointer.recordcount eq "1" and getPointer.ElementValue neq "">
			<cfset rperc = getPointer.ElementValue>
		</cfif>
		
		<!--- default --->
		
		<cfquery name="getYear" 
		datasource="AppsPayroll" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT   TOP 1 *
			FROM     PersonEntitlement
			WHERE    PersonNo            = '#PersonNo#'
			AND      SalarySchedule      = '#Form.Schedule#'
			AND      Status              = '2'		
			AND      SalaryTrigger       = 'RentalSubsidy' 
			ORDER BY DateEffective ASC <!--- the earliest year --->
		</cfquery>
		
		<cfset reimburse = "0.80">
			
		<cfif getYear.EntitlementDate neq "">
		
			<cfset mths = datediff("m",  getYear.EntitlementDate,  SALEND)>
			<cfset yrs = int(mths/12)>	
			<cfset yrs = yrs + 1>
			
			<cfquery name="getPointer" 
			datasource="AppsPayroll" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT   TOP 1 * 
				FROM     Ref_PayrollLocationPointer
				WHERE    LocationCode   = '#serviceLocation#'
				AND      DateEffective <= #SALSTR#
				AND      Element        = '#EntitlementGroup#'
				AND      ElementPointer = '#yrs#' 
				ORDER BY DateEffective DESC
			</cfquery>		
			
			<cfif getPointer.recordcount eq "1">
				<cfset reimburse = getPointer.ElementValue>
			</cfif>	
			
		</cfif>
		
		<!--- 3/8/2018, correction as the amountincome has to be expressed 
					along the same lines as the rent period for correct comparisn, as otherwise the RS might be too low 
		<cfif PayrollDaysCorrectionPointer  eq 1 > <!---- ATTENTION HANNO!!! here I made the change for person 8871, two LWOPs 2,75 days must be 4 days ---->
				
				<cfset Threshold = AmountIncome * (EntitlementDays/AmountDays ) * rperc> <!--- rperc is fair for a person to pay 23% of his income for rent --->
				<!--- <cfoutput><br> threshold (#Threshold#  = #AmountIncome# * (#EntitlementDays#/#AmountDays#) * #rperc#)    #line#</cfoutput>  --->
				
			<cfelse>
				<cfset Threshold = AmountIncome * (EntitlementDays/(AmountDays-entitlementLWOP) ) * rperc> <!--- rperc is fair for a person to pay 23% of his income for rent --->
				<!--- <cfoutput><br>-> threshold (#Threshold#  = #AmountIncome# * (#EntitlementDays#/#(AmountDays-entitlementlwop)#) * #rperc#)    
						#line#</cfoutput> --->
		</cfif> ---->
		
		<!--- if the person has a partial reimbursement of the entitlement we need to correct the amount income which is based on the FULL
		to a lower value reflecting only the period of the reimbursement for the Rental subsidy income. If the person has several
		legs this correction is not needed as each line will have its own portion of the rend --->
				
		<cfset Threshold = AmountIncome * (EntitlementDays/Form.SalaryDays ) * rperc>	
														
		<br>DATA:threshold #PaymentCurrency#:#Threshold#  (#form.salarydays#:#entitlementdays#-#AmountIncome# : #rperc#)		
						
		<!--- corrected amount of the rent for the leg as the amount is recorded as 2300 for the month --->		
		
		<cfset NetRent   = AmountRent * (EntitlementDays / Form.SalaryDays)>	
			
		<!---			
		<br>-> NetRent (#NetRent#  = #AmountRent# * (#EntitlementDays#/#Form.SalaryDays#))
		--->
		
		
									
		<cfif NetRent neq "0">
		
			<cfquery name="get" 
			datasource="AppsPayroll" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT *
				FROM   userTransaction.dbo.sal#SESSION.thisprocess#Exchange
				WHERE  Currency = '#CurrencyEntitlement#'
			</cfquery>		
			
							
			<!--- express the rent into the currency of the scale entitlement --->			
			
			<cfif CurrencyEntitlement neq PaymentCurrency>
			    <!--- if Eur the rent and schedule currency is USD, this will be like 0.85 (8/13/2017) 
				so the amount in USD of the schedule is higher --->
				<cfset NetRent = NetRent / get.exchangeRate>
				<cfset net = netrent>								
			<cfelse>		
				<cfset net = netRent>	
			</cfif>
									
			<!--- express the maximum into the USD curreny as well --->		
													
			<cfquery name="get" 
			datasource="AppsPayroll" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT *
				FROM   userTransaction.dbo.sal#SESSION.thisprocess#Exchange
				WHERE  Currency = 'USD'    <!--- currency of the rate which always is USD but we can adjust this --->
			</cfquery>		
										
			<cfset MaxRent   = EntitlementAmount / get.exchangeRate>  
																						
			<cfif NetRent gt MaxRent>			
				<cfset NetRent = MaxRent>
			</cfif>
											
			<!---
			<cfoutput><br>-> max rent USD #maxrent#</cfoutput>
			--->
															
			<cfset Excess = (NetRent - Threshold) * reimburse>		
												
			<br>-> Excess1 (#Excess# = (r:#NetRent# - t:#Threshold#)  * #reimburse#)   
										
			<cfset BaseLine = NetRent * 0.40>
			<!---			
			<cfoutput><br>-> baseline (#baseline#) 40% of netrent to be paid</cfoutput>
			--->
					
			<!--- <cfoutput><br>#SALSTR# pointer:#rperc# -- cur=#CurrencyEntitlement# (#get.exchangeRate#) net=#net# -- max:#maxrent# -- bsli:#BaseLine# -- income=#AmountIncome#  thrs (inc*perc):#Threshold# -- exce:#Excess#<br> </cfoutput> --->
				
			<cfif BaseLine lt Excess>			
				<cfset Excess = BaseLine>
			</cfif>
		
		
																
			<cfquery name="update" 
				datasource="AppsPayroll" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				UPDATE    EmployeeSalaryLine
				SET       AmountPayroll       = round(#Excess#,3),  
			              PaymentCalculation  = round(#Excess#,3), 
						  PaymentAmount       = round(#Excess#,3) 
						  
				WHERE     PersonNo      = '#PersonNo#' 
				AND       PayrollItem   = '#PayrollItem#' 
				AND       PayrollCalcNo = '#line#'
				AND       PayrollStart  = #SALSTR#
				AND       Mission       = '#form.Mission#'
				AND       EntitlementPeriod = '#entitlementDays#'			
			</cfquery>	
		
		</cfif>
				
		</cfoutput>
	
		<cfquery name="getTotal" 
			datasource="AppsPayroll" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT    SUM(AmountPayroll) as Total
			FROM      EmployeeSalaryLine					  
			WHERE     PersonNo       = '#PersonNo#' 			
			AND       SalarySchedule = '#Form.Schedule#'		 			
			AND       PayrollStart   = #SALSTR#	
			AND       PayrollItem    = '#PayrollItem#'		
			AND       Mission        = '#form.mission#'			
		</cfquery>	
			
		
		<cfif getTotal.total lte 10>
		
			<cfquery name="update" 
				datasource="AppsPayroll" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				UPDATE    EmployeeSalaryLine
				SET       AmountPayroll       = 0,  
			              PaymentCalculation  = 0, 
						  PaymentAmount       = 0 
						  
				WHERE     PersonNo       = '#PersonNo#' 				
				AND       SalarySchedule = '#Form.Schedule#'	 			
				AND       PayrollStart   = #SALSTR#
				AND       PayrollItem    = '#PayrollItem#'
				AND       Mission        = '#form.Mission#'
			</cfquery>	
			
		</cfif>
			
	</cfoutput>

</cfoutput>	


<!--- 

as part oft he process the entitlement month for a certain schedule

1.	identify RS entitlements that are valid for the entitlement month/schedule being calculated : pre - done
2.	obtain the salary amount from the defined base : real entitlement (days - slwop) or base entitlement (working days) or ????? 

==   obtain the number of qualifying dependents for that month : done
    (which is obtain already earlier in the calculation process which needs to be adjusted)

3. obtain the correct threshold percentage based on dependents y/n
		24 depedents = 0 or 23 dependetns > 0

4. obtain the NET RENT from entitlement (which is recorded as rent - utilities in the entitlement ENTRYFORM)	
	    obtain the maximum rent allowed from the scale rates based on the dependent match : pre done 
		  == (similar is done already, correct if dependent count > 2 to 2 to match the record. ===

take the lowest of NET rent versus MAXIMUM rent

apply percentage (80%) which will be driven by a custom table : year and NC/FM : 
				YEARS : to be derrived from (see question) 
				NC/FM : to be derrived from entitlement ENTRYFORM : EntitlementGroup
	
resulting amount if not higher than 40% of the NET RENT = RS, otherwise 40% of NET rent = RS.

the amount is prorated for the days if  the entitlement ends during the month (initial appointment or separation)

--->
	