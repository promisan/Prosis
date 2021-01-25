<cfparam name="url.idmenu" default="">

<cfquery name="Get" 
datasource="AppsWorkorder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM   Ref_Frequency
	WHERE  Code = '#URL.ID1#'
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
			  label="Frequency" 
			  layout="webapp" 
			  user="No" 
			  menuAccess="Yes" 
			  systemfunctionid="#url.idmenu#">

<!--- edit form --->

<form action="RecordSubmit.cfm" method="POST" enablecab="Yes" name="dialog">

<table width="95%" class="formpadding" align="center">

	<tr><td height="6"></td></tr>
    <cfoutput>
    <TR class="labelmedium2">
    <TD>Code:</TD>
    <TD>
  	   <input type="text" name="Code" id="Code" value="#get.code#" size="20" maxlength="10" class="regularxxl" <cfif URL.OC neq 0>disabled</cfif>>
	   <input type="hidden" name="CodeOld" id="CodeOld" value="#get.code#" size="20" maxlength="20">
    </TD>
	</TR>
	
	 <TR class="labelmedium2">
    <TD>Description:</TD>
    <TD>
  	   <input type="text" name="Description" id="Description" value="#get.Description#" size="30" maxlength="50" class="regularxxl">
	   
    </TD>
	</TR>
			
	</cfoutput>
	
	<tr><td colspan="2" class="line"></td></tr>
	
	<tr>
		
	<td align="center" colspan="2" height="40">
	<input class="button10g" type="button" name="Cancel" id="Cancel" value="Cancel" onClick="window.close()">
    <cfif URL.OC eq 0><input class="button10g" type="submit" name="Delete" id="Delete" value="Delete" onclick="return ask()"></cfif>
    <input class="button10g" type="submit" name="Update" id="Update" value="Update">
	</td>	
	
	</tr>
	
</TABLE>

</FORM>

<cf_screenbottom layout="webapp">
	