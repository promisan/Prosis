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
<cfquery name="Schedule"
datasource="AppsPayroll" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT DISTINCT M.Mission, 
	                M.SalarySchedule, 
					S.SalaryCalculationPeriod, 
					M.DateEffective
	FROM SalarySchedule S, SalaryScheduleMission M
	WHERE S.SalarySchedule = M.SalarySchedule
	AND   M.Mission        = '#URL.Mission#'
</cfquery>		

<cfinvoke component="Service.Access"  
   method="payrollofficer" 
   mission="#URL.Mission#"
   returnvariable="accessPayroll">	
		
<cfloop query="Schedule">

	<cfquery name="Last"
	datasource="AppsPayroll" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT Max(PayrollEnd) as PayrollStart
		FROM  SalarySchedulePeriod 
		WHERE Mission        = '#URL.Mission#'
		AND   SalarySchedule = '#SalarySchedule#'
		AND   CalculationStatus IN ('1','2','3')
	</cfquery>	
			
	<cfset dt = "#Schedule.DateEffective-1#">
	
	<cfif Last.PayrollStart neq "">
	   <cfset dt = "#Last.PayrollStart#"> 
	 <cfelse>
	   <cfset dt = "#Schedule.DateEffective-1#">
	</cfif>
					
	<cfif Last.PayrollStart lt now()+31>
	
		<cfswitch expression="#SalaryCalculationPeriod#">
				
			<cfcase value="MONTH">
											
				<cfset st = DateAdd("d", "1", "#dt#")>
				<cfset end = DateAdd("d", "#DaysInMonth(st)-1#", "#st#")>
				
				<cftry>
				
					<cfquery name="Insert"
					datasource="AppsPayroll" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					    INSERT INTO SalarySchedulePeriod 
							(SalarySchedule, 
							 Mission, 
							 PayrollStart, 
							 PayrollEnd, 
							 OfficerUserId, 
							 OfficerLastName, 
							 OfficerFirstName)
						VALUES ('#SalarySchedule#', 
						        '#URL.Mission#',
								#st#,
								#end#,
								'#SESSION.acc#',
								'#SESSION.last#',
								'#SESSION.first#')
					</cfquery>
				
				<cfcatch></cfcatch>
				
				</cftry>
							
			</cfcase>
			
			<cfcase value="WEEK">
			
				<cfset st = DateAdd("d", "1", "#dt#")>
				<cfset end = DateAdd("d", "6", "#st#")>
				
				<cftry>
				
				<cfquery name="Insert"
				datasource="AppsPayroll" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				    INSERT INTO SalarySchedulePeriod 
						(SalarySchedule, 
						 Mission, 
						 PayrollStart, 
						 PayrollEnd, 
						 OfficerUserId, 
						 OfficerLastName, 
						 OfficerFirstName)
					VALUES ('#SalarySchedule#', 
					        '#URL.Mission#',
							#st#,
							#end#,
							'#SESSION.acc#',
							'#SESSION.last#',
							'#SESSION.first#')
				</cfquery>
				
				<cfcatch></cfcatch>
				
				</cftry>
			
			</cfcase>
			
			<cfcase value="BIWEEK">
			
			    <cfset st = DateAdd("d", "1", "#dt#")>
				<cfset end = DateAdd("d", "13", "#st#")>
				
				<cfquery name="Insert"
				datasource="AppsPayroll" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				    INSERT INTO SalarySchedulePeriod 
						(SalarySchedule, 
						 Mission, 
						 PayrollStart, 
						 PayrollEnd, 
						 OfficerUserId, 
						 OfficerLastName, 
						 OfficerFirstName)
					VALUES ('#SalarySchedule#', 
					        '#URL.Mission#',
							#st#,
							#end#,
							'#SESSION.acc#',
							'#SESSION.last#',
							'#SESSION.first#')
				</cfquery>
			
			</cfcase>
			
		</cfswitch>
			
	</cfif>
			
</cfloop>