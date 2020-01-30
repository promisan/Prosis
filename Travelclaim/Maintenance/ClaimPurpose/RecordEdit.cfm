
<cfparam name="url.idmenu" default="">

<HTML><HEAD>
	<TITLE>Edit Form</TITLE>
</HEAD><body bgcolor="#FFFFFF" onLoad="window.focus()">
<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">

<cf_PreventCache>
  
<cfquery name="Get" 
datasource="AppsTravelClaim" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
FROM Ref_ClaimPurpose
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


<cfform action="RecordSubmit.cfm" method="POST" enablecab="Yes" name="dialog">

<cf_screentop height="100%" 
			  scroll="Yes" 
			  layout="webapp" 
			  label="Edit" 
			  banner="yellow" 
			  menuAccess="Yes" 
			  systemfunctionid="#url.idmenu#">

<!--- edit form --->

<table width="92%">

    <cfoutput>
    <TR>
    <TD class="regular">Code:</TD>
    <TD class="regular">
  	   <input type="text" name="Code" value="#get.Code#" size="2" maxlength="2"class="regular">
	   <input type="hidden" name="CodeOld" value="#get.Code#">
    </TD>
	</TR>
	
	<TR>
    <TD class="regular">Description:</TD>
    <TD class="regular">
  	   <cfinput type="text" name="Description" value="#get.Description#" message="please enter a description" required=  "yes" size="40" 
	   maxlenght = "40" class= "regular">
    </TD>
	</TR>
	
	
	<TR>
    <TD class="regular">Order:</TD>
    <TD class="regular">
  	   <cfinput type="text" name="ListingOrder" value="#get.ListingOrder#" message="please enter a valid number" style="text-align: center;" required="yes" size="1" 
	   maxlenght = "1" class= "regular">
    </TD>
	</TR>
	
	
	</cfoutput>
	
	
</TABLE>

<hr>

<table width="100%">	
		
	<td align="center">
	<input class="button10g" type="button" name="Cancel" value=" Cancel " onClick="window.close()">
    <input class="button10g" type="submit" name="Delete" value=" Delete " onclick="return ask()">
    <input class="button10g" type="submit" name="Update" value=" Update ">
	</td>	
	
</TABLE>
	
</CFFORM>


</BODY></HTML>