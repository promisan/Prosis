
<cftry>

	<cfif url.action eq 1>

		<cfquery name="insert"
			datasource="appsEmployee" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    INSERT INTO Ref_WorkActionMission
					(
						ActionClass,
						Mission,
						OfficerUserId,
						OfficerLastName,
						OfficerFirstName
					)
				VALUES
					(
						'#url.id1#',
						'#url.mission#',
						'#SESSION.acc#',
						'#SESSION.last#',
						'#SESSION.first#'
					)
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
		ColdFusion.navigate('WorkActionMission.cfm?ID1=#url.id1#', 'divMission');
	</script>
</cfoutput>


<table width="100%" align="center">
	<tr>
		<td align="center" style="color:0080FF;" class="labelmedium">Saved</td>
	</tr>
</table>