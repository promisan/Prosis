
<cfparam name="url.idmenu" default="">

<cf_screentop height="100%" 
			  title="Background Call Sign" 
			  scroll="Yes" 
			  layout="webapp" 
			  label="Edit Call Sign" 
			  menuAccess="Yes" 
			  systemfunctionid="#url.idmenu#">
  
<cfquery name="Get" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT 	*
		FROM 	Ref_Contact
		WHERE 	Code = '#URL.ID1#'
</cfquery>

<script language="JavaScript">

function ask() {
	if (confirm("Do you want to remove this call sign?")) {	
	return true 	
	}	
	return false	
}	

</script>

<cfform action="RecordSubmit.cfm" method="POST" enablecab="Yes" name="dialog">

	<table width="92%" cellspacing="0" cellpadding="0" align="center" class="formpadding formspacing">
	
	    <cfoutput>
	    <TR>
	    <TD  class="labelmedium">Code:</TD>
	    <TD>
			<input type="Hidden" name="Code" id="Code" value="#get.Code#">
	  	    #get.Code#
	    </TD>
		</TR>
		
		<TR>
	    <TD class="labelmedium">Description:</TD>
	    <TD>
	  	   <cfinput type="Text" name="Description" message="Please enter a description" required="Yes" size="30" maxlength="50" class="regularxl" value="#get.Description#">
	    </TD>
		</TR>
		
		<TR>
	    <TD  class="labelmedium">Mask:</TD>
	    <TD>
	  	  	<cfinput type="Text" name="CallSignMask" message="Please enter a mask" required="No" size="20" maxlength="20" class="regularxl" value="#get.CallSignMask#">
	    </TD>
		</TR>
		
		<tr>
			<td></td>
			<td class="labelmedium"><i>Examples : A = [A-Za-z], A9 = [A-Za-z0-9], 9 = [0-9], ? = Any character</i></td>
		</tr>
		
		<TR>
	    <TD  class="labelmedium">Order:</TD>
	    <TD>
	  	  	<cfinput type="Text" name="ListingOrder" message="Please enter a numeric order" validate="integer" required="No" size="1" maxlength="3" class="regularxl" style="text-align:center;" value="#get.ListingOrder#">
	    </TD>
		</TR>
		
		</cfoutput>
	
		<tr><td colspan="2" height="3"></td></tr>
		<tr><td colspan="2" class="linedotted"></td></tr>
		<tr><td colspan="2" height="3"></td></tr>
	
		
		<tr>
		<td align="center" colspan="2" valign="bottom">
	    <input class="button10g" style="width:90" type="submit" name="Delete" value=" Delete " onclick="return ask()">
	    <input class="button10g" style="width:90" type="submit" name="Update" value=" Update ">
		</td>	
		</tr>
		
	</table>	

</cfform>

