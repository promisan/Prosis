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
<cfquery name="Init"
datasource="AppsPayroll" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	   SELECT  *
	   FROM    SalaryScheduleMission
	   WHERE   Mission        = '#URL.Mission#'
	   AND     SalarySchedule = '#SalarySchedule#'		
</cfquery>		

<cfquery name="myLast"
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
			WHERE   (DateEffective < '#mylast.PayrollStart#') AND (Created >= '#mylast.PayrollStart#' and Created <= '#mylast.PayrollEnd#') AND Status IN ('2')
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
			WHERE   (OvertimeDate < '#mylast.PayrollStart#') AND (Created >= '#mylast.PayrollStart#' and Created <= '#mylast.PayrollEnd#') AND Status IN ('2')
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
			WHERE   (DateEffective < '#mylast.PayrollStart#') AND (Created >= '#mylast.PayrollStart#' and Created <= '#mylast.PayrollEnd#') AND Status IN ('2')
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
			WHERE   (DateEffective < '#mylast.PayrollStart#') 
			AND     (Created >= '#mylast.PayrollStart#' and Created <= '#mylast.PayrollEnd#')
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
		
		<tr class="line">
		     <td class="labelmedium" colspan="11" align="center">It is recommended that you recalculate as of #dateformat(dt,CLIENT.DateFormatShow)# (<cfloop query="check">#class#<cfif currentrow neq recordcount>,</cfif></cfloop>)</td>
		</tr>
				
	</cfoutput>

</cfif>





