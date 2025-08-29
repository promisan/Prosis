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
<cfquery name="Trigger" 
	datasource="AppsEmployee"
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT   *
	    FROM     Payroll.dbo.Ref_PayrollTrigger
		WHERE    SalaryTrigger = '#url.salarytrigger#'		
</cfquery>

<cfquery name="Dependents" 
	datasource="AppsEmployee"
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT   *
	    FROM     PersonDependent
		WHERE    PersonNo = '#URL.ID#'
		AND      ActionStatus IN ('1','2')		
		<cfif trigger.TriggerDependentFilter neq "">
		AND      #preserveSingleQuotes(trigger.TriggerDependentFilter)#  
		</cfif>			
</cfquery>

	<cfif dependents.recordcount eq "0">
	
		<i><cf_tl id="No eligible dependents for this entitlement">
	
	<cfelse>
			
		<table>
		<cfoutput query = "dependents">		 
			<tr class="<cfif currentrow lt recordcount>line</cfif>">
				<td class="labelmedium">#FirstName# #LastName#</td> 			
				<td class="labelmedium" style="padding-left:7px">#Relationship#</td>
				<td class="labelmedium" style="padding-left:7px">#dateformat(birthdate,client.dateformatshow)# (#datediff("yyyy",BirthDate,now())#)</td>
							
				<cfquery name="GetPrior" 
				datasource="AppsPayroll"
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				    SELECT   *
				    FROM     PersonDependentEntitlement
					WHERE    PersonNo      = '#URL.ID#'
					AND      DependentId  = '#dependentid#'
					AND      SalaryTrigger = '#url.salarytrigger#'	
						
					AND      Status != '9'							
				</cfquery>
				
				<cfif getPrior.recordcount gte "1">
				    <td style="padding-left:10px"><input type="checkbox" name="dependents" value="#dependentid#" class="radiol" checked></td>
				<cfelse>
	    			<td style="padding-left:10px"><input type="checkbox" name="dependents" value="#dependentid#" class="radiol"></td>
				</cfif>	
			</tr>	
		</cfoutput>
		</table>
	
	</cfif>