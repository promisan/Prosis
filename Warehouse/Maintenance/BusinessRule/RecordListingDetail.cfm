<cfquery name="SearchResult"
	datasource="appsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
    	SELECT 	*
		FROM 	Ref_BusinessRule
		ORDER BY TriggerGroup ASC, Code
</cfquery>

<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" class="formpadding">

<tr>
    <TD width="8%"></TD>
    <TD><cf_tl id="Code"></TD>
	<TD><cf_tl id="Class"></TD>
    <TD><cf_tl id="Description"></TD>
	<TD align="center"><cf_tl id="Color"></TD>
	<TD align="center"><cf_tl id="Operational"></TD>
</TR>

<tr bgcolor="C0C0C0"><td height="1" colspan="6"></td></tr>
<tr><td height="10"></td></tr>

<cfif SearchResult.recordCount eq 0>

	<tr><td colspan="7" height="25" align="center"><font color="808080"><b><cf_tl id="No business rules defined"></b></font></td></tr>
	<tr bgcolor="e4e4e4"><td height="1" colspan="6"></td></tr>

</cfif>

<cfoutput query="SearchResult" group="TriggerGroup">

	<tr><td colspan="7"><b>#TriggerGroup#</b></td></tr>
	<tr><td height="5"></td></tr>
	<tr ><td height="1" colspan="6" class="line"></td></tr>
	
	<cfoutput>
	    
    <TR onMouseOver="this.bgColor='FFFFCF'" onMouseOut="this.bgColor=''"> 
	<td align="right">
		<table cellpadding="0" cellspacing="0" class="formpadding">
			<tr>
				<td style="padding:3px">
					<cf_img icon="edit" onclick="recordedit('#Code#');">
				</td>
				<td style="padding:3px;">
					<cf_img icon="delete" onclick="if(confirm('Do you want to remove this business rule ?')){ ColdFusion.navigate('RecordPurge.cfm?id1=#Code#&idmenu=#url.idmenu#','rulesListing'); }">
				</td>
			</tr>
		</table>
	</td>
	<TD>#Code#</TD>
	<TD>#RuleClass#</TD>
	<TD>#Description#</TD>
	<TD align="center">
		<table>
			<tr>
				<td width="17" height="17" bgcolor="#Color#" style="border:1px solid black;" title="#Color#"></td>
			</tr>
		</table>
	</TD>
	<TD align="center"><cfif Operational eq 0><b>No</b><cfelseif Operational eq 1>Yes</cfif></TD>
    </TR>
	
	<tr ><td colspan="6" class="line"></td></tr>
	
	</cfoutput>
	
	<tr><td height="10"></td></tr>
	
</CFOUTPUT>

</table>