

<!--- ------------------------------------------------------------------------ --->
<!--- we verify the access to payroll item based on the fact access is granted --->

<cfset itm = "">

<cfquery name="Entitlement" 
datasource="AppsPayroll"
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT   *
    FROM     Ref_PayrollItem
	WHERE    Source IN ('Miscellaneous','Deduction')
	AND      Operational = 1
	ORDER BY Source DESC
	<!---
	AND  PayrollItem IN (SELECT PayrollItem
	                     FROM 	SalarySchedulePayrollItem
						 WHERE  Operational = 1 
						 AND    SalarySchedule IN (SELECT SalarySchedule 
						                           FROM   Employee.dbo.PersonContract
												   WHERE  PersonNo = '#URL.ID#'))	
												   --->
</cfquery>

<cfloop query="Entitlement">

	<cfquery name="check" 
	datasource="AppsPayroll"
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT     *
		FROM       Ref_PayrollItemRoleLevel 
		WHERE      PayrollItem = '#payrollitem#'
	</cfquery>
	
	<cfif check.recordcount eq "0">
	
	    <cfif itm eq "">
		    <cfset itm = "'#payrollItem#'">
		<cfelse>
			<cfset itm = "#itm#,'#payrollItem#'">
		</cfif>	
		
	<cfelse>
	
		<cfquery name="check" 
		datasource="AppsPayroll"
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT     R.*
			FROM       Ref_PayrollItemRoleLevel AS R INNER JOIN
			           Organization.dbo.OrganizationAuthorization AS OA ON R.Role = OA.Role AND R.AccessLevel = OA.AccessLevel
			WHERE      UserAccount = '#session.acc#'
			and        PayrollItem = '#payrollitem#'
		</cfquery>
		
		<cfif check.recordcount gte "1">
		
		    <cfif itm eq "">
			    <cfset itm = "'#payrollItem#'">
			<cfelse>
				<cfset itm = "#itm#,'#payrollItem#'">
			</cfif>	
		
		</cfif>

	</cfif>		

</cfloop>
