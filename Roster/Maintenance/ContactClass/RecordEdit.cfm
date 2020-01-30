
<cfparam name="url.idmenu" default="">

<cf_screentop height="100%" 
			  title="Background Contact" 
			  scroll="Yes" 
			  layout="webapp" 
			  label="Edit Contact" 
			  menuAccess="Yes" 
			  systemfunctionid="#url.idmenu#">
  
<cfquery name="Get" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT 	*
		FROM 	Ref_ContactClass
		WHERE 	Code = '#URL.ID1#'
</cfquery>

<script language="JavaScript">

function ask() {
	if (confirm("Do you want to remove this contact class?")) {	
	return true 	
	}	
	return false	
}	

</script>

<cfform action="RecordSubmit.cfm" method="POST" enablecab="Yes" name="dialog">

	<table width="93%" cellspacing="0" cellpadding="0" align="center" class="formpadding formspacing">
	
	    <cfoutput>
		
		<tr><td></td></tr>
	    <TR>
	    <TD class="labelmedium">Code:</TD>
	    <TD class="labelmedium">
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
	    <TD  class="labelmedium">Order:</TD>
	    <TD>
	  	  	<cfinput type="Text" name="ListingOrder" message="Please enter a numeric order" validate="integer" required="No" size="1" maxlength="3" class="regularxl" style="text-align:center;" value="#get.ListingOrder#">
	    </TD>
		</TR>
		
		</cfoutput>
	
		<tr><td colspan="2" height="6"></td></tr>
		<tr><td colspan="2" class="linedotted"></td></tr>
		<tr><td colspan="2" height="6"></td></tr>
	
		
		<tr>
		<td align="center" colspan="2" valign="bottom">
	    <input class="button10g" style="width:90" type="submit" name="Delete" value=" Delete " onclick="return ask()">
	    <input class="button10g" style="width:90" type="submit" name="Update" value=" Update ">
		</td>	
		</tr>
		
	</table>	

</cfform>

