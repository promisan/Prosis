<cfparam name="url.idmenu" default="">

<cf_screentop height="100%" 
			  scroll="Yes" 
			  banner="yellow" 
			  layout="webapp" 
			  label="Assignment Class" 
			  menuAccess="Yes" 
			  systemfunctionid="#url.idmenu#">
  
<cfquery name="Get" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
FROM Ref_AssignmentClass
WHERE AssignmentClass = '#URL.ID1#'
</cfquery>

<script language="JavaScript">

function ask() {
	if (confirm("Do you want to remove this assignment Class ?")) {	
	return true 
	}	
	return false	
}	

</script>

<!--- edit form --->

<cfform action="RecordSubmit.cfm" method="POST" enablecab="Yes" name="dialog">
	
<table width="92%" cellspacing="0" cellpadding="0" align="center" class="formpadding formspacing">

	<tr><td height="5"></td></tr>
	 
    <cfoutput>
    <TR>
    <TD class="labelmedium">Code:</TD>
    <TD>
  	   <input type="text" name="AssignmentClass" value="#get.assignmentClass#" size="10" maxlength="10" class="regularxl">
	   <input type="hidden" name="AssignmentClassOld" value="#get.assignmentClass#" size="10" maxlength="10" readonly>
    </TD>
	</TR>
	
	<TR>
    <TD class="labelmedium">Label:</TD>
    <TD>
  	   <cfinput type="Text" name="Description" value="#get.description#" message="Please enter a description" required="Yes" size="20" maxlength="20" class="regularxl">
    </TD>
	</TR>
	
	<tr>
	<td class="labelmedium">Incumbency</td>
	<td class="labelmedium">
	<input type="radio" name="Incumbency" value="100" <cfif get.Incumbency eq "100">checked</cfif>>100%
	<input type="radio" name="Incumbency" value="50" <cfif get.Incumbency eq "50">checked</cfif>>50%
	<input type="radio" name="Incumbency" value="0" <cfif get.Incumbency eq "0">checked</cfif>>0%	
	</td>	
	</tr>
	
	<TR>
    <TD class="labelmedium">Operational:</TD>
    <TD>
		<input type="checkbox" name="Operational" value="1" <cfif get.operational eq "1">checked</cfif>>
  	 </TD>
	</TR>
	
	<TR>
    <TD class="labelmedium">Order:</TD>
    <TD>
  	   <cfinput type="Text" name="ListingOrder" value="#get.listingorder#" message="Please enter an number" validate="integer" required="Yes" size="1" maxlength="2" class="regularxl">
    </TD>
	</TR>
	
	<tr><td colspan="2"><cf_dialogBottom option="edit"></td></tr>
			
	</cfoutput>
			
</TABLE>

</CFFORM>

<cf_screenbottom layout="innerbox">