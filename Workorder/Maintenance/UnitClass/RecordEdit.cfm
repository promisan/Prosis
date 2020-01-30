<cfparam name="url.idmenu" default="">

<cfquery name="Get" 
datasource="AppsWorkorder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	select *
	from Ref_UnitClass
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
			  label="Unit Class" 
			  layout="webapp" 
			  user="No" 
			  menuAccess="Yes" 
			  systemfunctionid="#url.idmenu#">

<!--- edit form --->

<table width="95%" cellspacing="4" cellpadding="4" align="center">

<cfform action="RecordSubmit.cfm" method="POST" enablecab="Yes" name="dialog">

	<tr><td height="6"></td></tr>
    <cfoutput>
    <TR>
    <TD>Code:</TD>
    <TD>
  	   <input type="text" name="Code" id="Code" value="#get.code#" size="20" maxlength="10" class="regular" <cfif URL.OC neq 0>disabled</cfif>>
	   <input type="hidden" name="CodeOld" id="CodeOld" value="#get.code#" size="20" maxlength="20" readonly>
    </TD>
	</TR>
	
	 <TR>
    <TD>Description:</TD>
    <TD>
	   <cf_LanguageInput
			TableCode		= "Ref_UnitClass"
			Mode            = "Edit"
			Name            = "Description"
			Id              = "Description"
			Type            = "Input"
			Value			= "#get.Description#"
			Key1Value       = "#get.Code#"
			Required        = "Yes"
			Message         = "Please enter a description"
			MaxLength       = "50"
			Size            = "40"
			Class           = "regular">
	   
    </TD>
	</TR>
	
	<TR>
    <TD>Listing order:</TD>
    <TD>
		<cfinput type="Text" name="ListingOrder" value="#get.listingOrder#" message="Please enter a number as a listing order" required="Yes" validate="integer" size="10" maxlength="3" class="regular">	   
    </TD>
	</TR>
			
	</cfoutput>
	
	<tr><td colspan="2" class="line"></td></tr>
	
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
	