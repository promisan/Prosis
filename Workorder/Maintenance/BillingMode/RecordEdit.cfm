<cfparam name="url.idmenu" default="">

<cfquery name="Get" 
datasource="AppsWorkorder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	select *
	from Ref_BillingMode
	WHERE code = '#URL.ID1#'
</cfquery>

<script language="JavaScript">

function ask() {
	if (confirm("Do you want to remove this record ?")) {	
	return true 	
	}	
	return false	
}	

</script>

<cf_screentop height="100%" 
			  label="Billing Mode" 
			  layout="webapp" 
			  user="No" 
			  menuAccess="Yes" 
			  systemfunctionid="#url.idmenu#">

<!--- edit form --->

<table width="92%" cellspacing="4" cellpadding="4" align="center" class="formpadding formspacing">

<cfform action="RecordSubmit.cfm" method="POST" enablecab="Yes" name="dialog">

	<tr><td height="6"></td></tr>
    <cfoutput>
    <TR class="labelmedium">
    <TD>Code:</TD>
    <TD>
  	   <input type="text" name="Code" id="Code" value="#get.code#" size="20" maxlength="10" class="regularxl" <cfif #URL.OC# neq 0>disabled</cfif>>
	   <input type="hidden" name="CodeOld" id="CodeOld" value="#get.code#" size="20" maxlength="20" readonly>
    </TD>
	</TR>
	
	 <TR class="labelmedium">
    <TD>Description:</TD>
    <TD>
  	   <input type="text" name="Description" id="Description" value="#get.Description#" size="30" maxlength="50" class="regularxl">
	   
    </TD>
	</TR>
			
	</cfoutput>
	
	<tr><td colspan="2" class="line"></td></tr>
	
	<!--- <tr><td></td></tr> --->
	
	<tr>
		
	<td align="center" colspan="2" height="40">
	<input class="button10g" type="button" style="width:80" name="Cancel" id="Cancel" value="Cancel" onClick="window.close()">
    <cfif #URL.OC# eq 0><input class="button10g" type="submit" style="width:80" name="Delete" id="Delete" value="Delete" onclick="return ask()"></cfif>
    <input class="button10g" type="submit" style="width:80" name="Update" id="Update" value="Update">
	</td>	
	
	</tr>
	
</CFFORM>
	
</TABLE>

<cf_screenbottom layout="webapp">
	