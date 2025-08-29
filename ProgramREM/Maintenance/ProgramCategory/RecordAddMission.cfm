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
<cfquery name="MissionList" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT *, '' as selected
	FROM Ref_ParameterMission L
	WHERE Mission IN (SELECT Mission 
	                  FROM Organization.dbo.Ref_MissionModule 
					  WHERE SystemModule = 'Program')
</cfquery>

<cfif url.par eq "">
	
	<table cellspacing="0" width="90%" cellpadding="0">
		
		<cfset cnt = 0>
		<cfoutput query="MissionList">
		
		    <cfset cnt = cnt+1>
			<cfif cnt eq "1">
			<tr>
			</cfif>
				<td class="labelit">#Mission#</td>
				<td><input type="checkbox" class="Radiol" name="missionselect" value="#mission#" <cfif selected neq "" or url.mission eq mission>checked</cfif>></td>
			<cfif cnt eq "3">	
			</tr>
			<cfset cnt = 0>
			</cfif>
		
		</cfoutput>
		
	</table>	
	
	<script>
		document.getElementById('lineentity').className = "regular"
	</script>
	
<cfelse>

	<script>
		 document.getElementById('lineentity').className = "hide"
	</script>

</cfif>
