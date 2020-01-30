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
		SET   PayrollDays    = '#Form.SalaryDays#', 
		      WorkDays       = '#Form.SalaryDays#'
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
													
			<cfquery name="Prior" 
			datasource="AppsQuery" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT SUM(PayrollDays) as total
				FROM   userTransaction.dbo.sal#SESSION.thisprocess#Payroll
				WHERE  PersonNo = '#SELECT.PersonNo#'
			</cfquery>	
			
			<cfif prior.total gte "1">
		
		            <!--- this scenario applies if a person has a change of contract such as a grade or schedule change during a month --->																
				
				    <cfset total = DATEDIFF('d',DateEffective,DateExpiration)+1>	
																
				  	<cfset base = Form.SalaryDays-Prior.total>
					<cfif total gte base>
						<cfset t = base>
					<cfelse>
						<cfset t = total>	
					</cfif>
				  				
			<cfelse>
			
					<cfset total = DATEDIFF('d',DateEffective,DateExpiration)+1>
													
					<cfif total gte Form.SalaryDays>
						<cfset t = Form.SalaryDays>
					<cfelse>
						<cfset t = total>
					</cfif>							
			
			</cfif>	
						
		</cfif>	
		
		<cfquery name="Update" 
			datasource="AppsQuery" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			UPDATE userTransaction.dbo.sal#SESSION.thisprocess#Payroll
			SET    PayrollDays   = '#t#', 
			       Workdays      = '#t#'
			WHERE  PersonNo      = '#PersonNo#'
			AND    DateEffective = '#DateEffective#' 
		</cfquery>					
		
	</cfloop>		
		