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

<cfform action="RecordSubmit.cfm" method="POST" name="dialog">

<table width="96%" align="center" class="formspacing formpadding">

    <cfoutput>
    <TR class="labelmedium2">
    <TD>Code:</TD>
    <TD>
  	   <input type="text" name="Code" id="Code" value="#get.Code#" size="2" maxlength="2" class="regularxxl">
	   <input type="hidden" name="CodeOld" id="CodeOld" value="#get.Code#">
    </TD>
	</TR>
	
	<TR class="labelmedium2">
    <TD>Description:</TD>
    <TD>
  	   <cfinput type="text" name="Description" value="#get.Description#" message="please enter a description" required=  "yes" size="30" 
	   maxlenght = "40" class= "regularxxl">
    </TD>
	</TR>
	
	
	<TR class="labelmedium2">
    <TD>Order:</TD>
    <TD>
  	   <cfinput type="text" name="ListingOrder" value="#get.ListingOrder#" message="please enter a valid number" style="text-align: center;" required="yes" size="1" 
	   maxlenght="1" class= "regularxxl">
    </TD>
	</TR>
	
	</cfoutput>
		
	<tr class="line"><td colspan="2"></td></tr>
	
	<tr><td colspan="2" align="center">
	<input class="button10g" type="button" name="Cancel" id="Cancel" value=" Cancel " onClick="window.close()">
    <input class="button10g" type="submit" name="Delete" id="Delete" value=" Delete " onclick="return ask()">
    <input class="button10g" type="submit" name="Update" id="Update" value=" Update ">
	</td>	
	</tr>
		
</TABLE>

</CFFORM>
	
