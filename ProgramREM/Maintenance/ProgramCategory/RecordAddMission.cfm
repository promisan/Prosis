
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
