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

<cfquery name="Trigger" 
datasource="AppsPayroll"
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT    DISTINCT 
	          C.SalaryTrigger, 			  
			  T.Description,
			  T.TriggerSort
    FROM      Ref_PayrollTrigger T, 
	          Ref_PayrollComponent C, 
			  SalaryScheduleComponent S
	WHERE     (
		           (T.TriggerGroup  IN ('Entitlement','Insurance') AND TriggerCondition = 'NONE')
		            OR 	
		           T.TriggerGroup IN ('Housing')
			   )  
	AND       C.SalaryTrigger  = T.SalaryTrigger
	AND       C.Code           = S.ComponentName
	AND       T.EnableContract = 0
	AND       S.SalarySchedule = '#url.schedule#'
	
	AND   (
	
			EXISTS (
			
			<!--- show only components that are not associated to a location or components associated to a location for which the person
			has a contract recorded --->
	
			SELECT     'X'
			FROM       SalaryScheduleComponentLocation
			WHERE      SalarySchedule = '#url.schedule#'
			AND        ComponentName  = S.ComponentName
			AND        LocationCode IN (SELECT     ServiceLocation
                                        FROM       Employee.dbo.PersonContract
                                        WHERE      PersonNo = '#url.personno#' 
										AND        ActionStatus IN ('0','1')
										<!--- adding the portion for the SPA--->
										UNION 
										SELECT     PostServiceLocation as ServiceLocation
										FROM       Employee.dbo.PersonContractAdjustment
										WHERE      PersonNo = '#url.personno#' 
										AND        ActionStatus IN ('0','1')
										)																
										
			) OR
			
			<!--- show components that do not have any locations defined, then it is global --->		
			
			NOT EXISTS (
			
				SELECT     'X'
				FROM       Payroll.dbo.SalaryScheduleComponentLocation
				WHERE      SalarySchedule = '#url.schedule#'
				AND        ComponentName  = S.ComponentName	)
					
			)		
	
	ORDER BY  T.TriggerSort, T.Description 
	
</cfquery>

<table>
<tr>
<td>			
	<select name="SalaryTrigger" id="SalaryTrigger" class="enterastab regularxl" style="width:220px" 
	   onchange="settrigger(this.value);prior();_cf_loadingtexthtml='';ptoken.navigate('getEntitlementGroup.cfm?personno=<cfoutput>#url.personno#&schedule=#url.schedule#</cfoutput>&trigger='+this.value,'entgroup')">      	   
	    <cfoutput query="Trigger">
			<option value="#SalaryTrigger#">#Description#</option>
		</cfoutput>
	</select>
	
</td>
<td style="padding-left:6px" id="entgroup">
   <cfset url.trigger = trigger.salaryTrigger>
   <cfinclude template="getEntitlementGroup.cfm">
</td>
</tr>
</table>

<cfset ajaxOnload("prior")>

