<!--
 	IncidentEntry.cfm
	
	Disciplinary Incident entry form.
	
	Calls: IncidentEntrySubmit.cfm
	
	Modification History:
	15Oct03 - created by MM
	09Mar04 - added code to handle CloseDate and ApprovalDate which are now optional fields
			- also to handle new radio button - Status
	03Oct05 - change query "qMission" record filter 
			  from: WHERE MissionCategory IN ('SPECIAL','ESTABLISHED','DPA-LED')
			  to:   WHERE MissionType = 'Peacekeeping'			
-->
<HTML><HEAD><TITLE>Incident - Entry</TITLE></HEAD>

<cf_preventCache>


<cfset CLIENT.Datasource="AppsTravel">

<cfquery name="Parameter" datasource="#CLIENT.Datasource#" username="#SESSION.login#" password="#SESSION.dbpw#">
    SELECT * FROM Parameter	WHERE Identifier = 'A'
</cfquery>

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

<link rel="stylesheet" type="text/css" href="<cfoutput>#client.root#/#client.style#</cfoutput>"> 
<div class="screen">
<body class="dialog" onLoad="javascript:document.forms.IncidentEntry.focus();" top="0", bottom="0">

<CFFORM action="IncidentEntrySubmit.cfm" method="POST" name="IncidentEntry">

<!-- Start of main table -->
<table width="100%" border="1" cellspacing="0" cellpadding="0" bordercolor="#002350" frame="all">
<tr>
	<td align="left" height="30" valign="middle" bgcolor="002350">
	&nbsp;<font face="Tahoma" size="2" color="#FFFFFF"><strong>Incident Entry</strong></font>
	</td>
	<td align="right" height="30" valign="middle" bgcolor="002350">
	<input type="submit" class="input.button1" name="Save" value=" Save ">	
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
	  <td valign="top" class="header">&nbsp;Description (300 chars max)*:</td>
	  <td>
		 <textArea name="description" cols="60" rows="5" wrap="virtual"></textarea>
	  </td>
	</tr>
	<!-- Field Mission -->
    <tr>
	  <td class="header">&nbsp;DPKO Field Mission*:</td>
	  <td>
		<font color="#0000FF" face="Lucida Console" size="1">
 		    <cfselect name="mission" required="Yes">
	    	<cfoutput query="qMission">
			<option value="#Mission#">#Mission#
			</option>
			</cfoutput>
		    </cfselect>			
	  </td>
	</tr>
	<!-- Case number -->
	<tr>
	  <td class="header">&nbsp;Mission Case Number:</td>
	  <td>
	  <cfinput type="Text" name="missioncasenumber" required="No" size="50" maxlength="50" class="regular">
	  </td>
	</tr>	
   <!--- Open date --->
    <tr> 
	<td class="header">&nbsp;Open date (dd/mm/yy):</td>
	<td><cfset end = DateAdd("m",  0,  now())> 
   	   	<cf_intelliCalendarDate
		FormName="incidententry"
		FieldName="OpenDate" 
		DateFormat="#CLIENT.DateFormatShow#"
		Default="#Dateformat(end, CLIENT.DateFormatShow)#"
		AllowBlank="False">	
	</td>
	</tr>
	<!--- Close date --->
	<tr>
    <td class="header">&nbsp;Close date (dd/mm/yy):</td>
	<td><cfset end = DateAdd("m",  0,  now())> 
   	   	<cf_intelliCalendarDate
		FormName="incidententry"
		FieldName="CloseDate" 
		DateFormat="#CLIENT.DateFormatShow#"
		Default="#Dateformat(end, CLIENT.DateFormatShow)#"
		AllowBlank="True">	
	</td>
	</tr>
	<!--- Requested By --->
	<tr>
	  <td class="header">&nbsp;Requested By*:</td>
	  <td class="regular">		
	  <INPUT type="radio" name="requestedby" value="M" checked> Mission
	  <INPUT type="radio" name="requestedby" value="O"> Other		
	  </td>
	</tr>
	<!--- Investigating Office --->
	<tr>
	  <td class="header">&nbsp;Investigating Office*:</td>
	  <td class="regular">	
	  <cfselect name="investigatingoffice" required="Yes">
	  <cfoutput query="qInvestigatingOffice">
	    <option value="#InvestigatingOffice#">#sInvestigatingOffice#</option> 
	  </cfoutput>
	  </cfselect>	
	  </td>
	</tr>
	<!---  Status --->
	<tr>
	  <td class="header">&nbsp;Status*:</td>
	  <td class="regular">		
	  <INPUT type="radio" name="status" value="0" checked> Pending
	  <INPUT type="radio" name="status" value="1"> Closed		
	  </td>
	</tr>
	<!-- Save incident button -->
	<tr>
  	  <td class="header">	
	  &nbsp;
   	  <input type="submit" class="input.button1" name="Submit" value=" Save ">	  
	  </td>
	  <td colspan="2">
	  &nbsp;
	  <font face="tahoma" color="#000000" size="1.5">Note: An asterisk (*) after the field label indicates a mandatory field.</font>
	  </td>
	</tr>
	<!-- spacer row -->
	<tr class="header" bgcolor="#FFFFFF"><td height="5" colspan="2"></td></tr>	
</table>
</td>
</tr>
<!-- End of data entry block -->
</table>
<!-- End of main table -->

</CFFORM>
</body>
</div>
</html>