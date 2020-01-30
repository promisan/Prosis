
<cfquery name="List" 
datasource="AppsPayroll" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT 	*,
			(SELECT Description FROM Ref_Designation WHERE Code = D.Designation) AS DesignationDescription
    FROM  	Ref_PayrollLocationDesignation D
	WHERE 	LocationCode = '#URL.ID1#'
	ORDER BY DateEffective ASC
</cfquery>

<table width="100%" border="0" cellspacing="0" cellpadding="0" align="left">
<tr>
<td colspan="2">
<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" class="formpadding navigation_table">

<tr><td colspan="2" class="labelmedium"><font color="808080">Define modalities of the payroll location, which affects the entitlements</td></tr>

<tr class="labelmedium line">
    
    <TD width="40%" class="labelmedium">Designation</TD>
    <TD align="center" class="labelmedium">Effective</TD>
	<td align="center" class="labelmedium">Expiration</td>
	<TD height="23" align="center" class="labelmedium">
		<cfoutput>
		<A href="javascript:editDesignation('#url.id1#','','')">
		<font color="0080FF">[add]</font></a>
		</cfoutput>
	</TD>
</TR>

<cfif list.recordcount eq 0>
	<tr>
		<td style="padding-top:10px" height="25" align="center" class="labelmedium" valign="middle" colspan="4">
		<font color="808080">No designations recorded</font>
		</td>
	</tr>
</cfif>
	
	<CFOUTPUT query="List">
	
		<TR class="navigation_row linedotted">
			
			<TD class="labelmedium">#DesignationDescription#</TD>
			<TD align="center" class="labelmedium">#lsDateFormat(dateEffective,'#CLIENT.DateFormatShow#')#</TD>		
			<TD align="center" class="labelmedium">#lsDateFormat(dateExpiration,'#CLIENT.DateFormatShow#')#</TD>
			<TD height="18" align="center">
				<table>
					<tr>
						<td>
							 <cf_img icon="edit" onclick="editDesignation('#url.id1#','#designation#','#lsDateFormat(dateEffective,'yyyy-mm-dd')#')">
						</td>
						<td>
							<cf_img icon="delete" onclick="deleteDesignation('#url.id1#','#designation#','#lsDateFormat(dateEffective,'yyyy-mm-dd')#')">
						</td>
					</tr>
				</table>		
			</TD>
		</TR>
	
	</CFOUTPUT>
	
</TABLE>

</td>
</tr>

</TABLE>
