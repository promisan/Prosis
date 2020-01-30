<cfparam name="url.idmenu" default="">

<cf_screentop height="100%" 
			  label="Add Unit Class" 
			  layout="webapp" 
			  user="No"
			  menuAccess="Yes" 
			  systemfunctionid="#url.idmenu#">

<!--- Entry form --->

<table width="95%" cellspacing="4" cellpadding="4" align="center">
	
	<cfform action="RecordSubmit.cfm" method="POST" enablecab="Yes" name="dialog">

	<tr><td height="6"></td></tr>
    <TR>
    <TD>Code:</TD>
    <TD>
  	   <cfinput type="Text" name="Code" value="" message="Please enter a code" required="Yes" size="20" maxlength="10" class="regular">
    </TD>
	</TR>
	
	<TR valign="top">
    <TD>Description:</TD>
    <TD>
	   <cf_LanguageInput
			TableCode		= "Ref_UnitClass"
			Mode            = "Edit"
			Name            = "Description"
			Id              = "Description"
			Type            = "Input"
			Value			= ""
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
  	   <cfinput type="Text" name="ListingOrder" value="" message="Please enter a number as a listing order" required="Yes" validate="integer" size="10" maxlength="3" class="regular">
    </TD>
	</TR>
	
	<tr><td colspan="2" class="line"></td></tr>
	
	<tr>
		
	<td align="center" colspan="2" height="30">
	<input class="button10g" type="button" name="Cancel" id="Cancel" value="Cancel" onClick="window.close()">
    <input class="button10g" type="submit" name="Save" id="Save" value="Save">
	</td>	
	
	</tr>
		
	</CFFORM>
	
</table>

<cf_screenbottom layout="innerbox">
