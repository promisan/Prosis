<!--
    Copyright © 2025 Promisan

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

<cf_screentop html="No" jquery="Yes">

<table width="98%" height="100%" align="center">

<cfset Page         = "0">
<cfset add          = "1">
<cfset save         = "0">
<cfset Header       = "Payroll location">
 
<tr style="height:10px"><td><cfinclude template = "../HeaderPayroll.cfm"></td></tr>

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

<tr>
<td colspan="1">

	<table width="100%" align="center" class="formpadding navigation_table">
	
	<tr><td colspan="2" class="labelmedium"><font color="808080">Define modalities of the payroll location, which affects the entitlements</td></tr>
	
	<tr class="labelmedium2 line">
	    
	    <TD width="40%">Designation</TD>
	    <TD align="center">Effective</TD>
		<td align="center">Expiration</td>
		<TD height="23" align="center">
			<cfoutput>
			<A href="javascript:editDesignation('#url.id1#','','')">[add]</a>
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
		
			<TR class="navigation_row linedotted labelmedium2">
				
				<TD>#DesignationDescription#</TD>
				<TD align="center">#lsDateFormat(dateEffective,'#CLIENT.DateFormatShow#')#</TD>		
				<TD align="center">#lsDateFormat(dateExpiration,'#CLIENT.DateFormatShow#')#</TD>
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
