
<cfquery name="Ownership" 
		datasource="AppsSelection" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT *
		FROM Ref_ParameterOwner
		WHERE Owner = '#URL.Owner#'
</cfquery>

<cfset ht = "28">
<cfset wd = "28">
		
<cfloop query="Ownership">		

<table width="100%" height="100%" cellspacing="0" cellpadding="0">
	
<tr>
	
		<td style="padding:3px" height="10">
		
		<cfoutput>
		
		<select name="option" class="regularxl" onchange="ColdFusion.navigate('ParameterEditOwner'+this.value+'.cfm?owner=#url.owner#','mysubtarget_#url.owner#');">
			<option value="Pointer" selected>Bucket and Recruitment settings</option>
			<option value="Status">Roster Bucket Processing and Status</option>
		</select>
		
		</cfoutput>
		
		</td>
		
	</tr>
	
	<tr><td colspan="1" style="border-top:1px dotted e4e4e4"></td></tr>					 
	
	<tr><td height="100%">
	
		<table width="99%" height="100%" border="0" align="center" cellspacing="0" cellpadding="0">	
		    <tr><td height="100%" valign="top">						
				<cf_securediv id="mysubtarget_#url.owner#" bind="url:ParameterEditOwnerPointer.cfm?owner=#url.owner#">
			</td></tr>
		</table>
	
	</td></tr>
	
</table>

</cfloop>
	
	