<cfparam name="url.idmenu" default="">

<cf_screentop height="100%" 
			  scroll="Yes" 
			  layout="webapp" 
			  label="Edit Vacancy Class" 
			  menuAccess="Yes" 
			  jquery="Yes"		  
			  systemfunctionid="#url.idmenu#">
 
<cfquery name="Get" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM Ref_VacancyActionClass
	WHERE Code = '#URL.ID1#'
</cfquery>

<cf_colorScript>

<script language="JavaScript">

function ask() {
	if (confirm("Do you want to remove this Class ?")) {
		return true 
	}
	return false	
}	

</script>

<table width="100%"><tr><td style="padding-top:7px">

<cfform action="RecordSubmit.cfm" method="POST" enablecab="Yes" name="dialog">

<!--- edit form --->

<table width="94%" align="center">
		
    <cfoutput>
    <TR style="height:33px">
    <TD width="120" class="labelmedium">Code:</TD>
    <TD>
  	   <input type="text" name="Code" value="#get.Code#" size="10" maxlength="10"class="regularxxl">
	   <input type="hidden" name="CodeOld" value="#get.Code#" size="10" maxlength="10" readonly>
    </TD>
	</TR>
	
	<TR style="height:33px">
    <TD class="labelmedium">Description:</TD>
    <TD><cfinput type="Text" name="Description" value="#get.description#" message="Please enter a description" required="Yes" size="25" maxlength="40" class="regularxxl"></TD>
	</TR>
	
	<TR style="height:33px">	
    <TD class="labelmedium">Trigger Track:</TD>
    <TD><input type="checkbox" class="radiol" name="TriggerTrack" value="1" <cfif get.TriggerTrack eq "1">checked</cfif>></TD>
	</TR>
			
	<TR style="height:33px">
    <TD class="labelmedium" style="padding-right:5px">Presentation Color:</TD>
    <TD><cf_color name="PresentationColor" value="#get.PresentationColor#" mode="limited"></TD>
	</TR>
	
	<TR style="height:33px">	
    <TD class="labelmedium">Show Vacancy:</TD>
    <TD><input type="checkbox" class="radiol" name="ShowVacancy" value="1" <cfif get.ShowVacancy eq "1">checked</cfif>></TD>
	</TR>
	
	<TR style="height:33px">
    <TD class="labelmedium">Order:</TD>
    <TD><cfinput type="Text" name="ListingOrder" value="#get.ListingOrder#" message="Please enter a Listing Order" required="No" size="2" maxlength="2" class="regularxxl"></TD>
	</TR>
	
	<TR style="height:35px">	
    <TD class="labelmedium">Operational:</TD>
    <TD><input type="checkbox" class="radiol" name="Operational" value="1" <cfif get.operational eq "1">checked</cfif>></TD>
	</TR>	
	
	</cfoutput>
	
	<tr><td height="3"></td></tr>
	<tr><td style="padding:0px" colspan="2" class="line"></td></tr>
	<tr><td height="3"></td></tr>
	
	<cfquery name="CountRec" 
      datasource="AppsEmployee" 
      username="#SESSION.login#" 
      password="#SESSION.dbpw#">
      SELECT TOP 1 *
      FROM Position
      WHERE VacancyActionClass  = '#get.Code#' 
    </cfquery>
	
	<tr>
		
	<td align="center" colspan="2">	
	<cfif CountRec.recordcount eq "0">
    <input class="button10g" type="submit" name="Delete" value=" Delete " onclick="return ask()">
	</cfif>
    <input class="button10g" type="submit" name="Update" value=" Update ">
	</td>	

	</tr>
	
</TABLE>
	
</CFFORM>

</td></tr></table>

