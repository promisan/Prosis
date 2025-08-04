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

<!--- determine of the person is currently in the mode of the personalised schedule --->

<cf_verifyOnboard personNo = "#URL.ID#">

<cfset go = "1">

<cfif orgunit neq "">
	
	<cfquery name="Check" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">		
		SELECT  *
		FROM    Organization
		WHERE   OrgUnit = '#orgunit#'					
	</cfquery>

	<cfif check.workschema eq "1">
	
		<cfset go = "0">
	
	</cfif>

</cfif>

<cfquery name="ClearProvision" 
   datasource="AppsPayroll" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
	   DELETE Employee.dbo.PersonWorkDetail
	   FROM Employee.dbo.PersonWorkDetail D 	 				   
	   WHERE  Source   = 'Overtime'
	   AND    NOT EXISTS (SELECT 'X'
	                      FROM PersonOvertime
						  WHERE PersonNo   = D.PersonNo
						  AND   OvertimeId = D.SourceId )					    			   
</cfquery>


<cfif go eq "0" and 1 eq 0>

	<table align="center">
	<tr class="labelmedium">
		<td style="font-weight:200;font-size:25px;padding-top:40" align="center"><cf_tl id="Sorry but your unit operates under a work schedule"></td>
	</tr>
	</table>

<cfelse>
	
	<cfquery name="Check" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">		
		SELECT  *
		FROM    PersonWorkSchedule
		WHERE   PersonNo = '#url.id#'		
		AND     Mission IN (SELECT  DISTINCT P.Mission
				    		FROM    PersonAssignment PA INNER JOIN
					    	        Position P ON PA.PositionNo = P.PositionNo
						    WHERE   PA.PersonNo = '#url.id#')							
						
	</cfquery>
	
	<cfif check.recordcount gte "1">	
	    <cfinclude template="OvertimeEntrySchedule.cfm">				
	<cfelse>
		<cfinclude template="OvertimeEntryStandard.cfm">
	</cfif>

</cfif>