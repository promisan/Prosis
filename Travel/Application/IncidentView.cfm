<!--
 	IncidentEdit.cfm
	
	Generic Incident Edit form.
	Use to display incident details on upper part of form and persons associated with
	this incident in lower part of form.  There should be a button that will open a
	person search page which can display a list of matching persons.  Selecting a
	person from this search results page, will add that person to the bottom of the
	IncidentEdit page.
	
	Calls: 
	
	Modification History:

-->
<HTML><HEAD><TITLE>Incident - View</TITLE></HEAD>

<cf_preventCache>


<cfinclude template="Dialog.cfm">

<SCRIPT LANGUAGE = "JavaScript">
/* note: findperson() should call a Person Incquiry page which in turn calls a Search Results
// page.  for now, findperson() will call the Search Results page directly
function locCallPersonList(incid)   
{
	window.open("PersonSearchResults.cfm?ID=" + incid, "IndexWindow", "width=600, height=390, toolbar=yes, scrollbars=yes, resizable=no");
}
*/

function locClosePage() {
	// If this Incident Edit window was opened from the Incidents Listing page,
	//   refresh that page in case changes were made in the record.  Otherwise
	//   don't do anything.
	if (opener.location.name == "Disciplinary Incidents") {
	 	opener.location.reload()
	}	
	window.close()
}
</SCRIPT>

<cfquery name="qIncident" 
datasource="#CLIENT.Datasource#" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT I.*, IO.Description AS sInvestigatingOffice, D.Description AS sDecision
	FROM Incident I, InvestigatingOffice IO, IncidentPerson IP, Decision D
	WHERE I.Incident = #URL.ID#
	AND	  I.InvestigatingOffice = IO.InvestigatingOffice
	AND   I.Incident = IP.Incident
	AND	  IP.Decision = D.Decision
	ORDER BY I.OpenDate 
</cfquery>


<link rel="stylesheet" type="text/css" href="<cfoutput>#client.root#/#client.style#</cfoutput>"> 
<div class="screen">
<body class="dialog" onLoad="javascript:document.forms.incidentview.description.focus();" top="0", bottom="0">

<cfform action="IncidentEditSubmit.cfm" method="POST" name="incidentview" enablecab="no">

<!-- Start of main table -->
<table width="100%" border="1" cellspacing="0" cellpadding="0" bordercolor="#002350" frame="all">
<tr>
	<td align="left" height="30" valign="middle" bgcolor="002350">
	&nbsp;<font face="Tahoma" size="2" color="#FFFFFF"><strong>Incident View</strong></font>
	</td>
	<td align="right" height="30" valign="middle" bgcolor="002350">
	<cfoutput>
	<input type="hidden" name="incident" value="#qIncident.Incident#", size="5" maxlength="5" class="disabled" readonly>
	</cfoutput>		
	<input type="button" class="input.button1" name="Close" value=" Close " onClick="javascript:locClosePage()">	
	
	&nbsp;
	</td>
</tr> 	
  
<!-- Start data entry block -->   
<tr>
<td width="100%" colspan="2">
<table width="98%" border="0" cellspacing="0" cellpadding="0" align="center" bordercolor="#111111" style="border-collapse: collapse">
	<!-- space row -->
	<tr><td class="header" height="10"></td></tr>
	<!-- Description -->
	<tr>
	  <td class="header">&nbsp;Description*:</td>
	  <td><cfoutput>
		 <textarea cols="100" rows="3" name="description" class="regular" disabled="Yes">#qIncident.Description#</textarea>
	  </cfoutput></td>
	</tr>
	<!-- Field Mission -->
    <tr>
	  <td class="header">&nbsp;DPKO Field Mission*:</td>
	  <td class="regular">
	  <input class="regular" type="text"  disabled="yes" value="<cfoutput>#qIncident.Mission#</cfoutput>">
	  </td>
	</tr>
	<!-- Case number -->
	<tr>
	  <td class="header">&nbsp;Mission Case Number:</td>
	  <td>
	  <input type="Text" name="missioncasenumber"  disabled="Yes" value="<cfoutput>#qIncident.MissionCaseNumber#</cfoutput>" required="No" size="50" maxlength="50" class="regular">
	  </td>
	</tr>	
   <!--- Open date --->
    <tr> 
	<td class="header">&nbsp;Open Date (dd/mm/yy):</td>
	<td class="regular">
		<cfif #qIncident.OpenDate# NEQ "">
			<cfset disp_date = DateFormat(#qIncident.OpenDate#,"dd/mm/yy")>
		<cfelse>
			<cfset disp_date = "">		
		</cfif>
		<cfinput name="OpenDate" type="text" value="#disp_date#" class="regular" passThrough="disabled">	
	</td>
	</tr>
	<!--- Close date --->
    <tr> 
	<td class="header">&nbsp;Close Date (dd/mm/yy):</td>
	<td class="regular">
		<cfif #qIncident.CloseDate# NEQ "">
			<cfset disp_date = DateFormat(#qIncident.CloseDate#,"dd/mm/yy")>
		<cfelse>
			<cfset disp_date = "">		
		</cfif>
		<cfinput name="CloseDate" type="text" value="#disp_date#" class="regular" passThrough="disabled">	
	</td>
	</tr>
	<!--- Requested By --->
	<tr>
	  <td class="header">&nbsp;Requested By*:</td>
	  <td class="regular">		
	  <INPUT type="radio" name="requestedby" value="M" disabled="Yes" <cfif #qIncident.RequestedBy# eq "M"> checked</cfif>> Mission
	  <INPUT type="radio" name="requestedby" value="O" disabled="Yes" <cfif #qIncident.RequestedBy# eq "O"> checked</cfif>> Other		
	  </td>
	</tr>
	<!--- Investigating Office --->
	<tr>
	  <td class="header">&nbsp;Investigating Office*:</td>
	  <td class="regular">
	  <input class="regular" type="text" disabled="yes" value="<cfoutput>#qIncident.sInvestigatingOffice#</cfoutput>" disabled="Yes">
	  </td>
	</tr>

	<!-- spacer row -->
	<tr class="header" bgcolor="#FFFFFF"><td height="5" colspan="2"></td></tr>	
</table>
<!-- End of data entry block -->
</table>
<!-- End of main table -->

<!--- Start of Incident Person table at the lower half of page --->
<table width="100%" border="1" cellspacing="0" cellpadding="0" bordercolor="#002350" frame="all">

  <tr>
	<td height="18" align="left" valign="middle" bgcolor="002350">
	<font face="Times New Roman" size="2" color="FFFFFF">
	&nbsp;<b>Associated Persons</b>
	</font>	 
    <tr>
	<td width="100%" colspan="2">
    <table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" bordercolor="#111111" style="border-collapse: collapse">
	  <tr>
		<td>
		<cfinclude template="IncidentPersonList.cfm">
		</td>
	  </tr>	     
	</table>
    </td>
    </tr>
  </tr>	
  <tr><td height="5" colspan="2"></td></tr>	
</table>
<!--- End of Incident Person table --->

</CFFORM>
</body>
</div>
</html>