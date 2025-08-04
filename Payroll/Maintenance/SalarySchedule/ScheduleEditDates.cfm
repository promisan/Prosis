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
<cfquery name="Dates"
	datasource="AppsPayroll" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT *
	FROM   SalaryScheduleComponentDate D, SalaryScheduleComponent C
	WHERE  D.SalarySchedule = C.SalarySchedule
	AND    D.ComponentName  = C.ComponentName
	AND    ComponentId      = '#URL.ComponentId#'
</cfquery>
		
<table width="90%" align="center" border="0" cellspacing="0" cellpadding="0">

	<cfset row = 1>

	<cfoutput query="Dates">
			
		<cfif row eq 1>
		    <tr>	
		    <td width="100" class="labelit"><cf_tl id="Pay only on">:</td>
		</cfif>	
			
		<td class="labelit">&nbsp;
				
			<input type="Text"
		      name="c#url.ComponentId#"
		      value="#dateformat(EntitlementDate,CLIENT.DateFormatShow)#"		            
			  onchange="savedates('#URL.ComponentId#')"
			  class="regularxl"
		      visible="Yes"
		      enabled="Yes"
		      size="9"
		      style="text-align:center">
			  
		</td>
		
		<cfset row = row + 1>
		<cfif row eq "6">
		     </tr>
		     <cfset row = 1>
	    </cfif>
	
	</cfoutput>
	<tr>
	<td width="100" class="labelit"><cf_tl id="Pay only on">:</td>
	<td class="labelit">&nbsp;
	<cfoutput>
	    
	
		<input type="Text"
	      name="c#url.ComponentId#"
	      value=""	            
	      visible="Yes"
		  onchange="savedates('#URL.ComponentId#')"
		  class="regularxl"
	      enabled="Yes"
	      size="9"
	      style="text-align:center">
		  
	</cfoutput>	  
	</td>
	</tr>
	
</table>
