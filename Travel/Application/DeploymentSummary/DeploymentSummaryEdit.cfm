<!--
 	IncidentEdit.cfm
	
	Generic Incident Edit form.
	Use to display incident details on upper part of form and persons associated with
	this incident in lower part of form.  There should be a button that will open a
	person search page which can display a list of matching persons.  Selecting a
	person from this search results page, will add that person to the bottom of the
	IncidentEdit page.
	
	Calls: 
	PersonInquiry.cfm - page for locating persons to associate to this incident record
	
	Modification History:
	09Mar04 - added code to handle CloseDate and ApprovalDate which are now optional fields
	09Mar04 - added code to handle new radio button Status
	03Oct05 - change query "qMission" record filter 
			  from: WHERE MissionCategory IN ('SPECIAL','ESTABLISHED','DPA-LED')
			  to:   WHERE MissionType = 'Peacekeeping'
-->
<HTML><HEAD><TITLE>Incident - Edit</TITLE></HEAD>

<!---
<body background="../Images/background.gif" bgcolor="#FFFFFF">
--->
<link rel="stylesheet" type="text/css" href="../../<cfoutput>#client.style#</cfoutput>"> 

<body class="dialog" onLoad="javascript:document.forms.incidentedit.description.focus();">

<cf_preventCache>


<cfinclude template="Dialog.cfm">

<cfset CLIENT.Datasource="AppsTravel">

<script language = "JavaScript">
function listing()
{
 	window.open("", "Listing", "width=400, height=400, toolbar=no, scrollbars=yes, resizable=no");
}

// Open a Person Inquiry page
function locCallPersonInquiry(incid)   
{
	window.open("PersonInquiry.cfm?ID=" + incid, "IndexWindow", "width=800, height=500, toolbar=no, scrollbars=yes, resizable=no");
}

function locClosePage()
{
	// If this Incident Edit window was opened from the Incidents Listing page,
	//   refresh that page in case changes were made in the record.  Otherwise
	//   don't do anything.
	if (opener.location.name == "Disciplinary Incidents") {
		opener.history.go()
	}	
	window.close()
}


// check if passed field is empty or is null. display warning msg.
function IsFieldEmpty(fld) {
	alert("inside is FieldEmpty func")
	if ((fld.value) == "" || (fld.value == null)) {
		alert("Field (" + fld.name + ") requires a valid entry!");
		return true;
	}
	else {
		alert("fld is not empty")
		return false;
	}
}

// for each field specified, call rtn that checks if required fields are entry.
function locChkFields() {
	alert("inside chkfields1")
	
	if (IsFieldEmpty(document.incidentedit.Description)) {
		alert("desc is empty")
		return false;
	}
	if (IsFieldEmpty(document.incidentedit.OpenDate)) {
		alert("opendate is empty")
		return false;
	}
	if (IsFieldEmpty(document.incidentedit.CloseDate)) {
		alert("closedate is empty")	
		return false;
	}
	if (IsFieldEmpty(document.incidentedit.ApprovalDate)) {
		return false;
	}
	return true;
}
</script>

<cfquery name="qMission" datasource="AppsOrganization" username="#SESSION.login#" password="#SESSION.dbpw#">
	SELECT DISTINCT Mission	FROM Ref_Mission
	WHERE MissionType = 'Peacekeeping'
	ORDER BY Mission
</cfquery>

<cfquery name="qDecision" datasource="#CLIENT.Datasource#" username="#SESSION.login#" password="#SESSION.dbpw#">
	SELECT Decision, Description AS sDecision FROM Decision
	WHERE Decision > 0
	ORDER BY Description
</cfquery>

<cfquery name="qInvestigatingOffice" datasource="#CLIENT.Datasource#" username="#SESSION.login#" password="#SESSION.dbpw#">
	SELECT InvestigatingOffice, Description AS sInvestigatingOffice FROM InvestigatingOffice
	WHERE InvestigatingOffice > 0
	ORDER BY Description
</cfquery>

<cfquery name="qIncident" datasource="#CLIENT.Datasource#" username="#SESSION.login#" password="#SESSION.dbpw#">
	SELECT * FROM Incident
	WHERE Incident = #URL.ID#
	ORDER BY OpenDate 
</cfquery>

<!--- <cfform action="IncidentEditSubmit.cfm" method="POST" target="Listing" enablecab="No" name="incidentedit" onSubmit="javascript:listing()"> --->
<cfform action="IncidentEditSubmit.cfm" method="POST" name="incidentedit" enablecab="no">

<!-- Start of main table -->
<table width="100%" border="1" cellspacing="0" cellpadding="0" bordercolor="#002350" frame="all">
<tr>
	<td align="left" height="30" valign="middle" bgcolor="002350">
	&nbsp;<font face="Tahoma" size="2" color="#FFFFFF"><strong>Incident Edit</strong></font>
	</td>
	<td align="right" height="30" valign="middle" bgcolor="002350">
	<cfoutput>
	<input type="hidden" name="incident" value="#qIncident.Incident#", size="5" maxlength="5" class="disabled" readonly>
	<input type="button" class="input.button1" name="Add" value=" Add person " onClick="javascript:locCallPersonInquiry('#qIncident.Incident#')">
	</cfoutput>		
	<input type="submit" class="input.button1" name="Submit" value=" Save " onClick="javascript:return locChkFields1()">
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
		 <textarea cols="60" rows="5" name="description" wrap="virtual">#qIncident.Description#</textarea>
	  </cfoutput></td>
	</tr>
	<!-- Field Mission -->
    <tr>
	  <td class="header">&nbsp;DPKO Field Mission*:</td>
	  <td>
		<font color="#0000FF" face="Lucida Console" size="1">
 		    <cfselect name="mission" required="Yes">
	    	<cfoutput query="qMission">
			<option value="#Mission#" <cfif #Mission# eq #qIncident.Mission#> selected</cfif>>
			#Mission#
			</option>
			</cfoutput>
		    </cfselect>			
	  </td>
	</tr>
	<!-- Case number -->
	<tr>
	  <td class="header">&nbsp;Mission Case Number:</td>
	  <td>
	  <cfinput type="Text" name="missioncasenumber" value="#qIncident.MissionCaseNumber#" required="No" size="50" maxlength="50" class="regular">
	  </td>
	</tr>	
   <!--- Open date --->
    <tr> 
	<td class="header">&nbsp;Open date (dd/mm/yy)*:</td>
	<td class="regular">
		<cf_intelliCalendarDate
		FormName="incidentedit"
		FieldName="opendate" 
		DateFormat="#CLIENT.DateFormatShow#"
		Default="#Dateformat(qIncident.OpenDate, CLIENT.DateFormatShow)#"
		AllowBlank="True">	
	</td>
	</tr>
	<!--- Close date --->
	<tr>
    <td class="header">&nbsp;Close date (dd/mm/yy):</td>
	<td class="regular">
	  	<cf_intelliCalendarDate
		FormName="incidentedit"
		FieldName="closedate" 
		DateFormat="#CLIENT.DateFormatShow#"
		Default="#Dateformat(qIncident.CloseDate, CLIENT.DateFormatShow)#"
		AllowBlank="True">	
	</td>
	</tr>
	<!--- Requested By --->
	<tr>
	  <td class="header">&nbsp;Requested By*:</td>
	  <td class="regular">		
	  <INPUT type="radio" name="requestedby" value="M" <cfif #qIncident.RequestedBy# eq "M"> checked</cfif>> Mission
	  <INPUT type="radio" name="requestedby" value="O" <cfif #qIncident.RequestedBy# eq "O"> checked</cfif>> Other		
	  </td>
	</tr>
	<!--- Investigating Office --->
	<tr>
	  <td class="header">&nbsp;Investigating Office*:</td>
	  <td class="regular">	
	  <cfselect name="investigatingoffice" required="Yes">
	  <cfoutput query="qInvestigatingOffice">
	    <option value="#InvestigatingOffice#" <cfif #InvestigatingOffice# eq #qIncident.InvestigatingOffice#>selected</cfif>>#sInvestigatingOffice#</option> 
	  </cfoutput>
	  </cfselect>	
	  </td>
	</tr>
	<!--- Decision 
	<tr>
	  <td class="header">&nbsp;Decision*:</td>
	  <td class="regular">	
	  <cfselect name="decision" required="Yes">
	  <cfoutput query="qDecision">
	    <option value="#Decision#" <cfif #Decision# eq #qIncident.Decision#>selected</cfif>>#sDecision#</option> 
	  </cfoutput>
	  </cfselect>	
	  </td>
	</tr>
	<!--- Approval date --->
	<tr>
    <td class="header">&nbsp;Approval date (dd/mm/yy):</td>
	<td class="regular">
		<cf_intelliCalendarDate
		FormName="incidentedit"
		FieldName="approvaldate" 
		DateFormat="#CLIENT.DateFormatShow#"
		Default="#Dateformat(qIncident.ApprovalDate, CLIENT.DateFormatShow)#"
		AllowBlank="True">	
	</td>
	</tr>
	--->
	
	<tr>
	  <td class="header">&nbsp;Status:</td>
	  <td class="regular">		
	  <INPUT type="radio" name="status" value="0" <cfif #qIncident.Status# eq "0"> checked</cfif>> Pending
	  <INPUT type="radio" name="status" value="1" <cfif #qIncident.Status# eq "1"> checked</cfif>> Closed		
	  </td>
	</tr>	
	<!-- Add incident button -->
	<tr>
  	  <td class="header">&nbsp;	
	  	<input type="submit" class="input.button1" name="Submit" value=" Save " onClick="javascript:return locChkFields1()">

	  </td>
	  <td colspan="2">
	  &nbsp;
	  <font face="tahoma" color="#000000" size="1.5">Note: An asterisk (*) after the field label indicates a mandatory field.</font>
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
</BODY>
</HTML>