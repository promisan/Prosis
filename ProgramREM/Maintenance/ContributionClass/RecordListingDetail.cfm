<cfquery name="SearchResult"
	datasource="appsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT 	C.*,
				(SELECT MissionName FROM Organization.dbo.Ref_Mission WHERE Mission = C.Mission) as MissionName
		FROM 	Ref_ContributionClass C
		ORDER BY C.Mission ASC
</cfquery>

<table width="97%" cellspacing="0" cellpadding="0" align="center" class="navigation_table" >

<tr class="labelmedium linedotted">
	<td width="20px"></td>
    <td width="25px"></td>
    <td><cf_tl id="Class"></td>
	<td><cf_tl id="Description"></td>
	<td><cf_tl id="Mode"></td>
    <td><cf_tl id="Entered"></td>
</tr>

<cfoutput query="SearchResult" group="mission">
    
	<tr><td colspan="5" class="labelmedium">#MissionName# <font size="-2">[#Mission#]</font></td></tr>
	
	<cfoutput>
	
	    <tr class="labelmedium linedotted navigation_row"> 
			<td align="left">
				<cfquery name="validate"
					datasource="appsProgram" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					    SELECT 	'1'
						FROM 	Contribution
						WHERE	ContributionClass = '#Code#'
				</cfquery>

				<cfif validate.recordCount eq 0>
					<cf_img icon="delete" onclick="recordpurge('#Code#');">
				</cfif>
			</td>
			<td align="left" class="navigation_action" onclick="recordedit('#Code#');">
				<cf_img icon="open" onclick="recordedit('#Code#');">
			</td>
			<td>#Code#</td>
			<td>#Description#</td>
			<td><cfif execution eq "0"><cf_tl id="Income"><cfelseif execution eq "1"><cf_tl id="Execution"><cfelse><cf_tl id="Income and Execution"></cfif></td>
			<td>#Dateformat(Created, "#CLIENT.DateFormatShow#")#</td>
	    </tr>
	
	</cfoutput>

</cfoutput>

</table>

<cfset AjaxOnLoad("doHighlight")>
