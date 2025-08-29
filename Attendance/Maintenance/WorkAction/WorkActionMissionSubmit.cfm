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
<cftry>

	<cfif url.action eq 1>

		<cfquery name="insert"
			datasource="appsEmployee" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    INSERT INTO Ref_WorkActionMission (
						ActionClass,
						Mission,
						OfficerUserId,
						OfficerLastName,
						OfficerFirstName )
				VALUES ('#url.id1#',
						'#url.mission#',
						'#SESSION.acc#',
						'#SESSION.last#',
						'#SESSION.first#' )
		</cfquery>
	
	</cfif>
	
	<cfif url.action eq 0>
	
		<cfquery name="delete"
			datasource="appsEmployee" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    DELETE 
				FROM 	Ref_WorkActionMission
				WHERE	ActionClass = '#url.id1#'
				AND		Mission = '#url.mission#'
		</cfquery>
		
	</cfif>

	<cfcatch></cfcatch>
</cftry>

<cfoutput>
	<script>
		ptoken.navigate('WorkActionMission.cfm?ID1=#url.id1#', 'divMission');
	</script>
</cfoutput>


<table width="100%" align="center">
	<tr>
		<td align="center" style="color:0080FF;" class="labelmedium">Saved</td>
	</tr>
</table>