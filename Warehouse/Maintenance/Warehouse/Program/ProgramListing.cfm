<cf_screentop html="no">

<cfquery name="listing" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
    	SELECT 	WP.*,
				(SELECT ProgramName FROM Program.dbo.Program WHERE ProgramCode = WP.ProgramCode AND Mission = W.Mission) as ProgramName
    	FROM 	WarehouseProgram WP
				INNER JOIN Warehouse W
					ON W.Warehouse = WP.Warehouse
		WHERE	WP.Warehouse = '#url.warehouse#'
		ORDER BY WP.Created
</cfquery>

<cfset vColumns = 5>

<cf_tl id ="Yes" var = "vYes">

<cfoutput>

<table width="93%" align="center">

	<tr><td height="10"></td></tr>
	<tr><td colspan="5" class="labellarge"><font color="808080">Record explicit programs and projects supported by this warehouse</td></tr>
	<tr><td height="10"></td></tr>
	<tr class="labelmedium line">
		<td align="center" height="23" width="10%" >
			<a href="javascript: addProject('#url.warehouse#');" title="add new project">
				[<cf_tl id="add">]
			</a>
		</td>
		<td><cf_tl id="Project"></td>
		<td align="center"><cf_tl id="Operational"></td>
		<td><cf_tl id="Officer"></td>
		<td><cf_tl id="Created"></td>
	</tr>
	
	<cfif listing.recordCount eq 0>
	    <tr><td height="10"></td></tr>
		<tr><td align="center" height="25" colspan="#vColumns#" style="color:808080;" class="labellarge">[<cf_tl id="No program or projects recorded">]</td></tr>
		<tr><td height="10"></td></tr>
		<tr><td class="line" colspan="#vColumns#"></td></tr>
	</cfif>
	
	<cfloop query="listing">
		<tr onMouseOver="this.bgColor='FFFFCF'" onMouseOut="this.bgColor=''"class="labelmedium line" bgcolor="">
			<td height="23" align="center" style="padding-top:1px;">
				<table>
					<tr>
						<td style="width:30;align:center">
							<cf_img icon="edit" onclick="editProject('#url.warehouse#','#programCode#');">
						</td>
						<td style="width:30;align:center">
							<cf_img icon="delete" onclick="purgeProject('#url.warehouse#','#programCode#');">
						</td>
					</tr>
				</table>			
			</td>
			<td>[#ProgramCode#] #ProgramName#</td>
			<td align="center"><cfif Operational eq 0><b>No</b><cfelseif Operational eq 1>#vYes#</cfif></td>
			<td>#OfficerFirstName# #OfficerLastName#</td>
			<td>#dateFormat(created,CLIENT.DateFormatShow)#</td>
		</tr>		
	</cfloop>	
	
</table>
</cfoutput>