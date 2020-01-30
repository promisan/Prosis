<cfparam name="url.idmenu" default="">

<cf_screentop title="Edit" 
			  height="100%" 
			  layout="webapp" 
			  label="Edit Tracking" 
			  menuAccess="Yes" 
			  systemfunctionid="#url.idmenu#">
  
<cfquery name="Get" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM Ref_Tracking
	WHERE Code = '#URL.ID1#'
</cfquery>

<script language="JavaScript">

function ask() {
	if (confirm("Do you want to remove this event ?")) {
		return true 
	}	
	return false	
}	

</script>

<!--- edit form --->

<cfform action="RecordSubmit.cfm" method="POST" enablecab="Yes" name="dialog">

<table width="96%" cellspacing="0" cellpadding="0" align="center" class="formpadding">

    <cfoutput>
    <TR>
    <TD class="labelit">Code:</TD>
    <TD class="labelit">
  	   <input type="text" name="Code" id="Code" value="#get.Code#" size="2" maxlength="2" class="regularxl">
	   <input type="hidden" name="CodeOld" id="CodeOld" value="#get.Code#">
    </TD>
	</TR>
	
	<TR>
    <TD class="labelit">Description:</TD>
    <TD class="labelit">
  	   <cfinput type="text" name="Description" value="#get.Description#" message="please enter a description" required=  "yes" size="30" 
	   maxlenght = "40" class= "regularxl">
    </TD>
	</TR>
	
	
	<TR>
    <TD class="labelit">Order:</TD>
    <TD class="labelit">
  	   <cfinput type="text" name="ListingOrder" value="#get.ListingOrder#" message="please enter a valid number" style="text-align: center;" required="yes" size="1" 
	   maxlenght = "1" class= "regularxl">
    </TD>
	</TR>
	
	</cfoutput>
	
	<tr><td colspan="2" align="center" height="4">
	<tr><td colspan="2" class="linedotted"></td></tr>
	<tr><td colspan="2" align="center" height="4">

	<tr><td colspan="2" align="center">
	<input class="button10g" type="button" name="Cancel" id="Cancel" value=" Cancel " onClick="window.close()">
    <input class="button10g" type="submit" name="Delete" id="Delete" value=" Delete " onclick="return ask()">
    <input class="button10g" type="submit" name="Update" id="Update" value=" Update ">
	</td>	
	</tr>
		
</TABLE>

</CFFORM>
	
