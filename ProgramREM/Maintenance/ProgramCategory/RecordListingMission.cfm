
<cfoutput>

<cfquery name="MissionList"
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT DISTINCT Mission
	FROM   Ref_ParameterMissionCategory
	WHERE  Category = '#Code#'
</cfquery>

<cfif MissionList.recordcount eq "0">
	
	<table width="100%"><tr class="labelmediumn2"><td>
		NO entities associated to this activity class.
	</td></tr>
	</table>

<cfelse>
	
	<table>
		<tr class="labelmedium2">
			<td>
			<cfloop query="MissionList">
			   #mission# <cfif currentrow neq recordcount>,</cfif>
			</cfloop>
			</td>
		</tr>
	</table>

</cfif>

</cfoutput>