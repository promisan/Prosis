
<!--- define the last calculated month --->

<cfquery name="Init"
datasource="AppsPayroll" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	   SELECT  *
	   FROM    SalaryScheduleMission
	   WHERE   Mission        = '#URL.Mission#'
	   AND     SalarySchedule = '#SalarySchedule#'		
</cfquery>		

<cfquery name="Last"
datasource="AppsPayroll" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT TOP 1 *
	FROM     SalarySchedulePeriod
	WHERE    Mission        = '#URL.Mission#'
	AND      SalarySchedule = '#SalarySchedule#'
	AND      CalculationStatus IN ('1') 
	ORDER BY PayrollStart 
</cfquery>	

<!--- define a recommended start date for the entitlement calculation --->	

<cfquery name="Check"
         datasource="AppsPayroll"
         maxrows=1
         username="#SESSION.login#"
         password="#SESSION.dbpw#">   <!--- entitlements --->
					 
			SELECT  'Entitlement' as Class, MIN(DateEffective) as CalcDate
			FROM    PersonEntitlement
			WHERE   (DateEffective < '#last.PayrollStart#') AND (Created >= '#last.PayrollStart#' and Created <= '#last.PayrollEnd#') AND Status IN ('2')
			AND     PersonNo IN (SELECT PersonNo 
			                     FROM   Employee.dbo.PersonContract 
								 WHERE  SalarySchedule = '#SalarySchedule#' 
								 AND    ActionStatus != '9'
								 AND    Mission = '#URL.Mission#')
			HAVING MIN(DateEffective) is not NULL
			
			UNION
			
			SELECT  'Overtime' as Class, 
			        MIN(OvertimeDate) as CalcDate
			FROM    PersonOvertime
			WHERE   (OvertimeDate < '#last.PayrollStart#') AND (Created >= '#last.PayrollStart#' and Created <= '#last.PayrollEnd#') AND Status IN ('2')
			AND     PersonNo IN (SELECT PersonNo 
			                     FROM   Employee.dbo.PersonContract 
								 WHERE  SalarySchedule = '#SalarySchedule#' 
								 AND    ActionStatus != '9'
								 AND    Mission = '#URL.Mission#')
			HAVING MIN(OvertimeDate) is not NULL
			
			UNION
			
			SELECT  'Miscellaneous' as Class, 
			        MIN(DateEffective) as CalcDate
			FROM    PersonMiscellaneous
			WHERE   (DateEffective < '#last.PayrollStart#') AND (Created >= '#last.PayrollStart#' and Created <= '#last.PayrollEnd#') AND Status IN ('2')
			AND     PersonNo IN (SELECT PersonNo 
			                     FROM   Employee.dbo.PersonContract 
								 WHERE  SalarySchedule = '#SalarySchedule#' 
								 AND    ActionStatus != '9'
								 AND    Mission = '#URL.Mission#')
			HAVING MIN(DateEffective) is not NULL
			
			UNION
			
			SELECT  'Leave' as Class, 
			        MIN(DateEffective) as CalcDate
			FROM    Employee.dbo.PersonLeave
			WHERE   (DateEffective < '#last.PayrollStart#') 
			AND     (Created >= '#last.PayrollStart#' and Created <= '#last.PayrollEnd#')
			AND     LeaveType IN (SELECT LeaveType 
			                      FROM   Employee.dbo.Ref_LeaveType 
								  WHERE  LeaveParent = 'LWOP')
			AND     PersonNo IN (SELECT PersonNo 
			                     FROM   Employee.dbo.PersonContract 
								 WHERE  SalarySchedule = '#SalarySchedule#' 
								 AND    ActionStatus != '9'
								 AND    Mission = '#URL.Mission#')
			HAVING MIN(DateEffective) is not NULL
			
			ORDER BY CalcDate

</cfquery>

<cfif check.calcdate lt init.dateeffective>
 <cfset dt = init.dateeffective>
<cfelse>
 <cfset dt = check.calcdate>
</cfif>

<cfif Check.recordcount gte "1">
	
	<cfoutput>
		
		<tr class="line"><td class="labelmedium" colspan="11" align="center">It is recommended that you recalculate as of #dateformat(dt,CLIENT.DateFormatShow)# (<cfloop query="check">#class#<cfif currentrow neq recordcount>,</cfif></cfloop>)</td></tr>
				
	</cfoutput>

</cfif>





