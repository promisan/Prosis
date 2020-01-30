<!--
 	IncidentPersonEdit.cfm
	
	For for editing fields in the IncidentPerson table.
	
	These fields include: Decision, Approval Date, and Remarks.  The person itself is entered in the IncidentPerson table
	via the IncidentPersonList and IncidentPersonListSubmit templates.
	
	Calls: 
	IncidentPersonEditSubmit.cfm
	
	Modification History:
	17Mar04 - created by MM

-->
<HTML><HEAD><TITLE>Incident Person - Edit</TITLE></HEAD>

<link rel="stylesheet" type="text/css" href="../../<cfoutput>#client.style#</cfoutput>"> 

<body class="dialog" onLoad="javascript:document.forms.IncidentPersonEdit.Decision.focus();">

<cf_preventCache>


<cfinclude template="Dialog.cfm">

<script language = "JavaScript">
function locClosePage() {
	opener.history.go();
	window.close();
}
</script>

<cfquery name="qDecision" datasource="#CLIENT.Datasource#" username="#SESSION.login#" password="#SESSION.dbpw#">
	SELECT Decision, Description AS sDecisionDesc FROM Decision
	WHERE Decision > 0
	ORDER BY Description
</cfquery>

<cfquery name="qIncidentPerson" datasource="#CLIENT.Datasource#" username="#SESSION.login#" password="#SESSION.dbpw#">
	SELECT * FROM IncidentPerson
	WHERE Incident = #URL.ID#
	AND   PersonNo = '#URL.ID1#'
</cfquery>

<cfquery name="qPerson" datasource="AppsEmployee" username="#SESSION.login#" password="#SESSION.dbpw#">
	SELECT *, FirstName + ' ' + Upper(LastName) As PersonName
	FROM Person
	WHERE PersonNo = '#URL.ID1#'
</cfquery>

<!--- <cfform action="IncidentEditSubmit.cfm" method="POST" target="Listing" enablecab="No" name="incidentedit" onSubmit="javascript:listing()"> --->
<cfform action="IncidentPersonEditSubmit.cfm" method="POST" name="IncidentPersonEdit" enablecab="no">

<!-- Start of main table -->
<table width="100%" border="1" cellspacing="0" cellpadding="0" bordercolor="#002350" frame="all">
<tr>
	<td align="left" height="30" valign="middle" bgcolor="002350">
	&nbsp;<font face="Tahoma" size="2" color="#FFFFFF"><strong>Incident Person Edit</strong></font>
	</td>
	<td align="right" height="30" valign="middle" bgcolor="002350">
	<cfoutput>
	<input type="hidden" name="Incident" value="#qIncidentPerson.Incident#", size="5" maxlength="5" class="disabled" readonly>
	<input type="hidden" name="PersonNo" value="#qIncidentPerson.PersonNo#", size="20" maxlength="20" class="disabled" readonly>	
  	<input type="submit" class="input.button1" name="Submit" value=" Save ">	
	<input type="button" class="input.button1" name="Close" value=" Close " onClick="javascript:locClosePage()">	
	</cfoutput>		
	&nbsp;
	</td>
</tr> 	
  
<!-- Start data entry block -->   
<tr>
<td width="100%" colspan="2">
<table width="98%" border="0" cellspacing="0" cellpadding="0" align="center" bordercolor="#111111" style="border-collapse: collapse">
	<!-- space row -->
	<tr><td class="header" height="10" colspan="2"></td></tr>
	<!-- Person Name -->
	<tr>
	  <td class="header">&nbsp;Person Name:</td>
	  <td><cfinput type="text"  name="PersonName" class="regular" value="#qPerson.PersonName#" size="50" passThrough="disabled"></td>
	</tr>
   <!--- Birth date --->
    <tr> 
	<td class="header">&nbsp;Birth Date (dd/mm/yy):</td>
	<td class="regular">
		<cfif #qPerson.BirthDate# NEQ "">
			<cfset disp_date = DateFormat(#qPerson.BirthDate#,"dd/mm/yy")>
		<cfelse>
			<cfset disp_date = "">		
		</cfif>
		<cfinput name="BirthDate" type="text" value="#disp_date#" class="regular" size="12" passThrough="disabled">	
	</td>
	</tr>
	<!--- Decision --->
	<tr>
	  <td class="header">&nbsp;Decision*:</td>
	  <td class="regular">	
	  <cfselect name="Decision" required="Yes">
	  <cfoutput query="qDecision">
	    <option value="#Decision#" <cfif #Decision# eq #qIncidentPerson.Decision#>selected</cfif>>#sDecisionDesc#</option> 
	  </cfoutput>
	  </cfselect>	
	  </td>
	</tr>
	<!--- Approval date --->
	<tr>
    <td class="header">&nbsp;Approval date (dd/mm/yy):</td>
	<td class="regular">
		<cf_intelliCalendarDate
		FormName="IncidentPersonEdit"
		FieldName="ApprovalDate" 
		DateFormat="#CLIENT.DateFormatShow#"
		Default="#Dateformat(qIncidentPerson.ApprovalDate, CLIENT.DateFormatShow)#"
		AllowBlank="True">	
	</td>
	</tr>
	<!-- Remarks -->
	<tr>
	  <td class="header">&nbsp;Remarks (200 chars max):</td>
	  <td>
	  <cfoutput><textarea cols="50" rows="4" name="Remarks" wrap="virtual">#qIncidentPerson.Remarks#</textarea></cfoutput>
	  </td>
	</tr>	
	<!-- Save button -->
	<tr>
  	  <td class="header">&nbsp;	
	  	<input type="submit" class="input.button1" name="Submit" value=" Save ">
	  </td>	  
	  <td>&nbsp;
		<font face="tahoma" color="#000000" size="1.5">Note: An asterisk (*) after the field label indicates a mandatory field.</font>
	  </td>
	</tr>
	<!-- spacer row -->
	<tr class="header" bgcolor="#FFFFFF"><td height="5" colspan="2"></td></tr>	
</table>
<!-- End of data entry block -->
</table>
<!-- End of main table -->

</CFFORM>
</BODY>
</HTML>