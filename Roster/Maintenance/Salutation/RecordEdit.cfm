<cfparam name="url.idmenu" default="">

<cf_screentop height="100%" 
			  title="Salutation" 
			  scroll="Yes" 
			  layout="webapp" 
			  label="Edit Salutation" 
			  menuAccess="Yes" 
			  systemfunctionid="#url.idmenu#">

<cfquery name="Get" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
FROM Ref_Salutation
WHERE Code = '#URL.ID1#'
</cfquery>

<script language="JavaScript">

function ask() {
	if (confirm("Do you want to remove this salutation?")) {
	
	return true 
	
	}
	
	return false
	
}	

</script>

<cfform action="RecordSubmit.cfm" method="POST" name="dialog">

<table width="94%" align="center" cellspacing="0" cellpadding="0" class="formpadding">

    <cfoutput>
	
	<tr><td></td></tr>
	
	<TR>
    <TD class="labelmedium" width="25%">Code:</TD>
    <TD class="labelmedium">
		<b>#get.Code#</b>
  	   <cfinput type="hidden" name="Code" value="#get.Code#" message="Please enter a code" required="Yes" size="10" maxlength="10" class="regularxl">
    </TD>
	</TR>

	
	<TR>
    <TD class="labelmedium">Description:</TD>
    <TD>
  	   <cfinput type="Text" name="Description" value="#get.Description#" message="Please enter a description" required="Yes" size="20" maxlength="20" class="regularxl">
    </TD>
	</TR>
	
	<TR>
    <TD class="labelmedium">Abbreviation:</TD>
    <TD>
  	   <cfinput type="Text" name="Abbreviation" value="#get.Abbreviation#" message="Please enter an abbreviation" required="Yes" size="10" maxlength="10" class="regularxl">
    </TD>
	</TR>
	
	<TR>
    <TD class="labelmedium">Order:</TD>
    <TD>
  	   <cfinput type="Text" name="ListingOrder" value="#get.ListingOrder#" message="Please enter a ListingOrder" required="Yes" validate="integer" size="5" maxlength="3" class="regularxl">
    </TD>
	</TR>
	
	</cfoutput>
	

	<tr><td colspan="2" height="6"></td></tr>
	<tr><td colspan="2" class="linedotted"></td></tr>
	<tr><td colspan="2" height="6"></td></tr>
	
	
	<tr><td colspan="2" valign="bottom" align="center">
    <input class="button10g" type="submit" name="Delete" value=" Delete " onclick="return ask()">
    <input class="button10g" type="submit" name="Update" value=" Save ">
	</td></tr>
	
</table>

</cfform>
