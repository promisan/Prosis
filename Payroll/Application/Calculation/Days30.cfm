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
		
	1. if a person starts later than the first of the month, he is paid for the days he work to a maximum of 30 days
	2. if a person ends before the last day of the month, he is paid the days --->
	
	<!--- we get the legs that need to be inspected --->
		
	<cfquery name="SelectList" 
		datasource="AppsQuery" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT   *
		FROM     userTransaction.dbo.sal#SESSION.thisprocess#Payroll
		WHERE    DateEffective > #SALSTR# OR DateExpiration < #SALEND#
		ORDER BY PersonNo,DateEffective
	</cfquery>	
	
	<!--- only records that have something irregular with start or end --->
	
	<cfoutput query="selectlist" group="personno">
	
	<cfoutput>
		
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
				WHERE  PersonNo = '#PersonNo#'
			</cfquery>	
			
			<!--- we do this logic now at the end of the person grouping
			
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
			
			--->
			
					<cfset total = DATEDIFF('d',DateEffective,DateExpiration)+1>
													
					<cfif total gte Form.SalaryDays>
						<cfset t = Form.SalaryDays>
					<cfelse>
						<cfset t = total>
					</cfif>							
			
			<!---
			</cfif>	
			--->
						
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
		
	</cfoutput>
	
	<!--- check the total on the level of the person only relevant in case of a contining inirtial appointment --->
	
	<cfquery name="getTotal" 
		datasource="AppsQuery" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT MIN(DateEffective)  as DateEffective, 
		       MAX(DateExpiration) as DateExpiration,
			   SUM(PayrollDays)    as Days
		FROM   userTransaction.dbo.sal#SESSION.thisprocess#Payroll		
		WHERE  PersonNo      = '#PersonNo#'				
	</cfquery>	
	
	<cfif getTotal.days gt Form.SalaryDays or 
	     (getTotal.DateEffective eq "#SALSTR#" and getTotal.DateExpiration eq "#SALEND#")>
		 
		 <!--- 7/3/2021 : we prefer to correct a leg that does not have LWOP (leave record) recorded --->
		 
		 <cfquery name="getLeg" 
			datasource="AppsQuery" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT * 
			FROM   userTransaction.dbo.sal#SESSION.thisprocess#Payroll					
			WHERE  PersonNo      = '#PersonNo#'		
			<cfif Schedule.SalaryBasePeriodDays eq "30fix">					
			ORDER BY LeaveId ASC	
			<cfelse>
			ORDER BY LeaveId DESC	
			</cfif>
		</cfquery>			
						 	
		<cfset diff = getTotal.days - Form.SalaryDays> 
	
		<cfquery name="getTotal" 
			datasource="AppsQuery" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			UPDATE userTransaction.dbo.sal#SESSION.thisprocess#Payroll	
			
			SET    PayrollDays   = PayrollDays - #diff#						   
			WHERE  PersonNo    = '#PersonNo#'						
			AND    Line        = '#getLeg.Line#'		
		</cfquery>		
							
	</cfif>			
		
	
</cfoutput>			
		