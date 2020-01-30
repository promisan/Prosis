<cfparam name="url.idmenu" default="">

<cf_screentop height="100%" 
			  label="Service Class" 
			  option="Service Item Class Maintenance" 
			  scroll="Yes" 
			  layout="webapp" 
			  banner="blue" 
			  menuAccess="Yes" 
			  systemfunctionid="#url.idmenu#">

<CFFORM action="RecordSubmit.cfm" method="post" enablecab="yes" name="dialog">

<!--- Entry form --->

<table width="95%" cellspacing="2" cellpadding="2" align="center" class="formpadding">

    <tr><td></td></tr>
   <!--- Field: Id --->
    <TR>
    <TD class="labelmedium">Code:</TD>
    <TD>
		<cfinput type="Text" name="Code" value="" message="Please enter a code" required="Yes" size="10" maxlength="10"
		class="regularxl">
	</TD>
	</TR>
	
	   <!--- Field: Description --->
    <TR valign="top">
    <TD class="labelmedium">Description:</TD>
    <TD>
		<cf_LanguageInput
			TableCode		= "ServiceItem"
			Mode            = "Edit"
			Name            = "Description"
			Id              = "Description"
			Type            = "Input"
			Value			= ""
			Required        = "Yes"
			Message         = "Please enter a description"
			MaxLength       = "100"
			Size            = "30"
			Class           = "regularxl">
	</TD>
	</TR>		 		 	 
	
	   <!--- Field: Listing Order --->
    <TR>
    <TD class="labelmedium">Listing Order:</TD>
    <TD>
		<cfinput type="Text" name="ListingOrder" value="" message="Please enter numeric Listing Order" required="Yes" size="2" maxlength="2" validate="integer" class="regularxl">
	</TD>
	</TR>
	
	 <!--- Field: Operational --->
    <tr class="labelmedium">
		<td>Operational:&nbsp;</td>
		<td colspan="3">
		<input type="radio" class="radiol" name="operational" id="operational" value="0">No
		<input type="radio" class="radiol" name="operational" id="operational" value="1" checked>Yes
		</td>
	</tr>	
		
	<tr><td height="3"></td></tr>
	
	<tr><td colspan="2" class="line"></td></tr>
	<tr>	
		<td align="center" colspan="2" height="30">
		<input class="button10g" type="button" name="Cancel" id="Cancel" value=" Cancel " onClick="window.close()">
		<input class="button10g" type="submit" name="Insert" id="Insert" value=" Save ">
		</td>
	</tr>
	    
</TABLE>

</CFFORM>
