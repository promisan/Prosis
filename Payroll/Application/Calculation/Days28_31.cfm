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
<!--- define days --->

	<cfquery name="SetBaseDays" 
		datasource="AppsPayroll" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		UPDATE SalarySchedulePeriod
		SET    CalculationBaseDays = '#Form.SalaryDays#'
		WHERE  SalarySchedule      = '#Form.Schedule#'
		AND    Mission             = '#Form.Mission#'
		AND    PayrollStart        = #SALSTR#
	</cfquery>		
	
	<cfset CalculationBaseDays = DATEDIFF("d",PayrollStart,PayrollEnd)+1>

	<!--- default --->
	  
	<cfquery name="FullMonth" 
		datasource="AppsQuery" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		UPDATE userTransaction.dbo.sal#SESSION.thisprocess#Payroll
		SET   PayrollDays = '#Form.SalaryDays#', 
		      WorkDays    = '#Form.SalaryDays#'
		WHERE DateEffective  = #SALSTR#
		AND   DateExpiration = #SALEND#
	</cfquery>	
	
	<!--- 2. now focus on the execptions for on the people which have broken recorded 

	 calculation of payroll days 
		
	1. if a person starts later than the first of the month, he is paid for the days he work to a maximum of 21.75
	2. if a person ends before the last of the month, he is paid balance - days. --->
	
	<!--- A. update people that start on the firstday BUT end during the month --->
	
	<cfquery name="Select" 
		datasource="AppsQuery" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT *
		FROM  userTransaction.dbo.sal#SESSION.thisprocess#Payroll
		WHERE (DateEffective > #SALSTR# OR DateExpiration < #SALEND#)
		ORDER BY PersonNo,DateEffective
	</cfquery>	
	
	<!--- only records that have something irregular with start or end --->
	
	<cfloop query="select">
	
		<cfif DateEffective eq SALSTR>
		
		    <!--- person starts at the beginning but leaves earlier --->
			
			<cfset total = DATEDIFF('d',SALSTR,DateExpiration)+1>
					
			<cfif total gte Form.SalaryDays>
				<cfset t = Form.SalaryDays>
			<cfelse>
				<cfset t = total>
			</cfif>			
			
		<cfelseif DateExpiration lte SALEND>										
						
			<cfset total = DATEDIFF('d',DateEffective,DateExpiration)+1>
											
			<cfif total gte Form.SalaryDays>
				<cfset t = Form.SalaryDays>
			<cfelse>
				<cfset t = total>
			</cfif>							
									
		</cfif>	
		
		<cfquery name="Update" 
			datasource="AppsQuery" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			UPDATE userTransaction.dbo.sal#SESSION.thisprocess#Payroll
			SET    PayrollDays   = '#t#', 
			       WorkDays      = '#t#'
			WHERE  PersonNo      = '#PersonNo#'
			AND    DateEffective = '#DateEffective#' 
		</cfquery>					
		
	</cfloop>		
		