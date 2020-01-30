
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

<table width="100%"
       border="0"
       cellspacing="0"
       cellpadding="0"
       bordercolor="D2D2D2"
       frame="above"><tr class="cellcontent"><td>
			<font face="Verdana" size="1" color="808080"><i>There are NO entities associated to this activity class.</font>
</td></tr>
</table>

<cfelse>

<table cellspacing="0" cellpadding="0">
	<tr class="cellcontent">
		<td>
		<cfloop query="MissionList">
		   #mission# <cfif currentrow neq recordcount>,</cfif>
		</cfloop>
		</td>
	</tr>
</table>

</cfif>

</cfoutput>