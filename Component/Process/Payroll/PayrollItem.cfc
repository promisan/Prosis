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
<!---  Name: /Component/Process/Procurement/PurchaseLine.cfc
       Description: Purchase Line procedures      
---> 

<cfcomponent>

    <cfproperty name="name" type="string">
    <cfset this.name = "Payroll Routines">
	
	<cffunction name="PayrollItem"
        access="public"
        returntype="string"
        displayname="get access to payroll Item">
		
		<cfargument name="Mission"         type="string" required="false"   default="">	
				
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
			
			<!--- no limitation was placed --->
									
			<cfif check.recordcount eq "0" or getAdministrator("*") eq "1">
			
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
		
		<cfreturn itm>		
		 
   </cffunction>	
   
   
</cfcomponent>	 