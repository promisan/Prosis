<!--- Prosis template framework --->
<cfsilent>
 <proUsr>administrator</proUsr>
 <proOwn>Hanno van Pelt</proOwn>
 <proDes>Generic Logon</proDes>
21sep07 - changed input button to use class="input.button1".
 <proCom>Changed release no</proCom>
</cfsilent>
<!--- End Prosis template framework --->

<!--
 	CandidateEntry.cfm
	
	Display person (nominee) entry form.
	
	Opened by clicking "Click here to identify candidate(s)" in the
	"Enter nominee data" step of in the Request Details form 
	
	Calls: CandidateEntrySubmit.cfm
	
	Modifcation History
	23Oct03 - added code to, for UNMO requests, display droplist of persons rotating 
			  out of the field mission
	07Nov03 - deleted code to handle passportissueplace after securing ok from Masaki
	06May04 - added code to handle new field ServiceJoinDate
	10May04 - added code to handle new field SatDate
	10Aug04 - changed Planned Deployment Date field label to Expected Deployment Date	
	21sep07 - changed input button to use class="input.button1".
	05oct07 - removed call to CF_DialogHeaderSub.  Created single button with call to window.print().	
-->

<!--- Create Criteria string for query from data entered thru search form --->

<HTML><HEAD><TITLE>Nominee - Entry</TITLE></HEAD>

<body background="../Images/background.gif" bgcolor="#FFFFFF">
<link rel="stylesheet" type="text/css" href="../../<cfoutput>#client.style#</cfoutput>"> 

<body class="dialog" onLoad="javascript:document.forms.CandidateEntry.lastname.focus();">

<cfparam name="URL.ID" default="0">
<cfparam name="CLIENT.nat" default = "">
<cfparam name="CLIENT.birthnat" default = "">
<cfparam name="CLIENT.rank" default = "">

<cf_preventCache>
<cf_calendarscript>

<cfinclude template="Dialog.cfm">

<script language = "JavaScript">
function reissue(vacno) {
 	window.open("DocumentEntryReissue.cfm?ID=" + vacno, "IndexWindow", "width=600, height=400, toolbar=no, scrollbars=yes, resizable=no");
}

function listing() {
 	window.open("", "Listing", "width=700, height=500, toolbar=no, scrollbars=yes, resizable=no");
}

function closing() {
 	opener.location.reload()
	window.close()
}
</script>

<cfquery name="Parameter" datasource="#CLIENT.Datasource#" username="#SESSION.login#" password="#SESSION.dbpw#">
    SELECT * FROM Parameter
	WHERE Identifier = 'A'
</cfquery>

<cfquery name="Get" datasource="#CLIENT.Datasource#" username="#SESSION.login#" password="#SESSION.dbpw#">
    SELECT D.*, C.TravellerType FROM Document D, Ref_Category C
	WHERE D.DocumentNo = '#URL.ID#'
	AND   D.PersonCategory = C.Category
</cfquery>

<cfquery name="P_Mission" datasource="#CLIENT.Datasource#" username="#SESSION.login#" password="#SESSION.dbpw#">
    SELECT PermanentMissionId, Description FROM Ref_PermanentMission
	WHERE PermanentMissionId = #get.PermanentMissionId#
</cfquery>

<cfquery name="Class" datasource="#CLIENT.Datasource#" username="#SESSION.login#" password="#SESSION.dbpw#">
    SELECT * FROM FlowClass
</cfquery>

<cfquery name="Rank" datasource="#CLIENT.Datasource#" username="#SESSION.login#" password="#SESSION.dbpw#">
    SELECT * FROM  Ref_Rank
	ORDER BY Description
</cfquery>

<cfquery name="Category" datasource="#CLIENT.Datasource#" username="#SESSION.login#" password="#SESSION.dbpw#">
    SELECT Category FROM Ref_Category
	WHERE Hybrid_ind = 0
	ORDER BY Category
</cfquery>

<cfquery name="Nationality" datasource="AppsSelection" username="#SESSION.login#" password="#SESSION.dbpw#">
    SELECT CODE, NAME  FROM Ref_Nationality
	WHERE Operational = '1'
	AND Code <> '-'
	ORDER BY NAME
</cfquery>

<cfquery name="DefaultNationality" datasource="#CLIENT.Datasource#" username="#SESSION.login#" password="#SESSION.dbpw#">
    SELECT NationalityCode FROM Ref_PermanentMission
	WHERE PermanentMissionId = #get.PermanentMissionId#
</cfquery>

<cfquery name="RotatingPerson" datasource="#CLIENT.Datasource#" username="#SESSION.login#" password="#SESSION.dbpw#">
    SELECT DRP.*, P.LastName + ', ' + P.FirstName AS PersonName 
	FROM DocumentRotatingPerson DRP INNER JOIN EMPLOYEE.DBO.Person P ON DRP.PersonNo = P.PersonNo
	WHERE DocumentNo = '#URL.ID#'
	ORDER BY P.LastName, P.FirstName
</cfquery>

<cfform action="CandidateEntryList.cfm?ID=#URL.ID#" method="POST" target="Listing" enablecab="No" name="CandidateEntry" onSubmit="javascript:listing()">

<table width="100%" cellspacing="0" cellpadding="0" bordercolor="#002350" frame="all">

<tr>

    <td height="30" align="left" valign="middle" bgcolor="#002350">
	<font face="Tahoma" size="2" color="#FFFFFF">
	<b>&nbsp;Req#: <font color="#33CCFF"><cfoutput>#Get.DocumentNo#</cfoutput></font>
	&nbsp;&nbsp;Permanent Mission: <font color="#33CCFF"><cfoutput>#p_mission.Description#</cfoutput></font>
	&nbsp;&nbsp;Field mission: <font color="#33CCFF"><cfoutput>#Get.Mission#</cfoutput></font></b>
	</font>
	</td>

	<td height="30" align="right" valign="middle" bgcolor="002350">

<!---   MM, 21/9/07
		This function no longer supported.
	<CF_DialogHeaderSub MailSubject="Document" MailTo="" MailAttachment="" MailFilter="#URL.ID#" 
	    ExcelFile="" CloseButton="False"> 
		replaced by next line
--->
	<input type="button" class="input.button1" name="Print" value="  Print  " title="Print the contents of the window" onClick="javascript:window.print()">
	<input type="button" class="input.button1" name="Close" value=" Close " onClick="window.close()">	
	</td>
</tr> 	
  
<tr>
	<td height="16" align="left" bgcolor="6688aa" class="topN">
	&nbsp;&nbsp;&nbsp;Number and Type of personnel requested:&nbsp;<font color="#FFCC33"><cfoutput>#get.PersonCount#</cfoutput></font> - <font color="#FFCC33"><cfoutput>#get.PersonCategory#</cfoutput></font>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Travel arranged by:&nbsp;<font color="#FFCC33"><cfoutput>#Class.Description#</cfoutput></font>
	</td>
	<td align="right" class="topN" bgcolor="6688aa">

	<cfif #Get.Status# is "0" or #Get.Status# is "9">	
	&nbsp;	
	<!--- Field: Document Status --->
    	<INPUT type="radio" name="Status" value="0" <cfif #Get.Status# is "0"> checked</cfif>> Document Pending
		<INPUT type="radio" name="Status" value="9" <cfif #Get.Status# is "9"> checked</cfif>> Document Cancelled&nbsp;	 	   
	<cfelse>
		<input type="hidden" name="Status" value="1" hidden="text">
		<input type="text" name="StatusShow" value="Completed" size="8" maxlength="8" readonly style="color: Black; text-align: center; border-bottom-style: solid; border-bottom-width: 1px;">   
	</cfif>
	&nbsp;	
	</td>
</tr> 	
     
<tr>
<td width="100%" colspan="2">
<table>
<tr>
<td width="10%"></td>
<table border="0" cellspacing="10" cellpadding="0" align="center" bordercolor="#111111" style="border-collapse: collapse">

<tr><td class="header" height="10"></td></tr>
		
<cfoutput>
<input type="hidden" name="mission" value="#get.Mission#" size="30" maxlength="30" class="disabled" readonly>
<input type="hidden" name="documentno" value="#Get.DocumentNo#">
</cfoutput>

<!-- If UNMO request, identify person being replaced -->
<cfif #get.TravellerType# EQ 'MILITARY'>
  <tr>
	<td class="header">&nbsp;Person being replaced*:</td>
	<td width="25%" class="regular">	
	<cfselect name="RotatingPersonNo" required="Yes">
		<option value=0><font face="Tahoma" size="3">Unknown</font>
    	<cfoutput query="RotatingPerson">
		<option value="#RotatingPerson.PersonNo#"><font face="Tahoma" size="3">#RotatingPerson.PersonName#</font>
		</option>
		</cfoutput>
	</cfselect>		
	</td>
  </tr>
</cfif>	 

<tr>
  <td class="header">&nbsp;Last name*:</td>
  <td>
  <cfinput type="Text" name="lastname" value="" message="Please enter candidate lastname" required="Yes" size="40" maxlength="40" class="regular">
  </td>
</tr>	
	
<tr>
<td class="header">&nbsp;First name*:</td>
<td>
<cfinput type="Text" name="firstname" value="" message="Please enter candidate first name" required="Yes" size="30" maxlength="30" class="regular">
</td>
</tr>
	
<tr>
<td class="header">&nbsp;Middle name:</td>
<td>
<cfinput type="Text" name="middlename" value="" message="Please enter candidate middle name" required="No" size="25" maxlength="25" class="regular">
</td>
</tr>	

<tr>
<td class="header">&nbsp;IndexNo:</td>
<td>
<cfinput type="Text" name="IndexNo" value="" message="Please enter IMIS number if known" required="No" size="10" maxlength="10" class="regular">
</td>
</tr> 

<tr>
<td class = "Header">&nbsp;Date of Birth (dd/mm/yy)*:</td>
<td class = "regular">	
					  <cf_intelliCalendarDate9
						FieldName="BirthDate"
						Default=""
						AllowBlank="False">									
</td>
</tr>
	
<tr>
<td class="header">&nbsp;Gender*:</td>
<td class="regular">		
<INPUT type="radio" name="Gender" value="M" checked> Male
<INPUT type="radio" name="Gender" value="F"> Female		
</td>
</tr>

<tr>
<td class="header">&nbsp;Present nationality*:</td>
<td width="25%" class="regular">	
<cfselect name="Nationality" required="Yes">
<cfoutput query="Nationality">
<option value="#Code#" <cfif #Code# eq #DefaultNationality.NationalityCode#> selected </cfif>>#Name#</option> 
</cfoutput>
</cfselect>	
</td>
</tr>

<tr>
<td class="header">&nbsp;Nationality at birth*:</td>
<td width="25%" class="regular">	
<cfselect name="BirthNationality" required="Yes">
<cfoutput query="Nationality">
<option value="#Code#" <cfif #Code# eq #DefaultNationality.NationalityCode#> selected </cfif>>#Name#</option> 
</cfoutput>
</cfselect>		
</td>
</tr>

<tr>
<td class="header">&nbsp;Rank*:</td>
<td>
	<cfselect name="Rank" required="Yes">
	<cfoutput query="Rank">

	<cfif #get.PersonCategory# EQ "CIVPOL">
		<option value="#Rank#" <cfif #Rank# EQ "1"> selected</cfif>>#Description#</option>
	<cfelse>
		<option value="#Rank#">#Description#</option>
	</cfif>	

	</cfoutput>
	</cfselect>	
</td>
</tr>
	
<tr>
<td class="header">&nbsp;Category*:</td>
<td>	
	<cfselect name="Category" required="Yes">
	<cfoutput query="Category">
	<option value="#Category#" <cfif #Category# eq #get.PersonCategory#> selected </cfif>>#Category#</option>
	</cfoutput>
	</cfselect>	
</td>
</tr>
	
<tr>
<td class = "header">&nbsp;Expected deployment date(dd/mm/yy)*:</td>
<td class = "regular">
		<cfset disp_date = DateFormat(#Get.PlannedDeployment#,"dd/mm/yy")>
		<cf_intelliCalendarDate9
			FieldName="PlannedDeployment"
			Default="#disp_date#"
			AllowBlank="False">									
</td>
</tr>	

<!--- added 6 May 04 --->
<cfif #get.TravellerType# EQ "CIVPOL">
<tr>
<td class = "Header">&nbsp;Date Joined Service(dd/mm/yy):</td>
<td class = "regular">	

		<cf_intelliCalendarDate9
			FieldName="ServiceJoinDate"
			Default=""
			AllowBlank="true">									
			
</td>
</tr>
</cfif>

<!--- added 10May04 --->
<cfif #get.TravellerType# EQ "CIVPOL">
<tr>
<td class = "header">&nbsp;SAT date(dd/mm/yy):</td>
<td class = "regular">
<cfset disp_date = DateFormat(#Get.SatDate#,"dd/mm/yy")>
		<cf_intelliCalendarDate9
			FieldName="SatDate"
			Default="#disp_date#"
			AllowBlank="true">	
</td>
</tr>
</cfif>		
	
<!--- Field: BirthCity   REMOVED AS PER MARITA'S INSTRUCTIONS - 3OCT2003
<tr>
<td class="header">&nbsp;Place of birth:</td>
<td>
<cfinput type="Text" name="BirthCity" value="" message="Please enter the place of birth" size="40" maxlength="40" class="regular">
</td>
</tr>
--->
	
<tr>
<td class="header">&nbsp;Passport Number:</td>
<td>
<cfinput type="Text" name="PassportNo" value="" message="Please enter a valid passport number" size="20" maxlength="20" class="regular">
</td>
</tr>	

<tr>
<td class = "Header">&nbsp;Passport Issue Date (dd/mm/yy):</td>
<td width="25%" class = "regular">
		<cf_intelliCalendarDate9
			FieldName="PassportIssue"
			Default=""
			AllowBlank="true">	
			
</td>
</tr>
<tr>
<td class = "Header">&nbsp;Passport Expiry Date (dd/mm/yy):</td>
<td width="25%" class = "regular">
		<cf_intelliCalendarDate9
			FieldName="PassportExpiry"
			Default=""
			AllowBlank="true">	

</td>
</tr>
	
<td class="header">&nbsp;Remarks: (200 chars max)<p></td>
<td colspan="3"><textarea cols="50" rows="4" class="regular" name="Remarks"></textarea></td>
</tr>
	
<tr>
<td class="header">&nbsp;
<cfif #Get.Status# is "0" or #Get.Status# is "9">
      <input type="submit" class="input.button1" name="Submit" value="  Add nominees  ">
</cfif>	
</td>
<td colspan="2">&nbsp;
<font face="tahoma" color="#000000" size="1.5">Note: An asterisk (*) after the field label indicates a mandatory field.</font>
</td>
</tr>
	
<tr class="header" bgcolor="#FFFFFF"><td height="5" colspan="2"></td></tr>
	
</table>
</td>
<td width="10%"></td>
</tr>
</table>

</td>
</tr>

</table>

<table width="100%" cellspacing="0" cellpadding="0" bordercolor="#002350" frame="all">
  <tr>
  	<td width="10%"></td>
	<td align="left" valign="middle" bgcolor="002350">
	<table width="100%">
	   <font face="Tahoma" size="2" color="FFFFFF"><b>&nbsp;Nominees</b></font>
	   <tr>
	 		<td width="100%" colspan="2">	
			<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" bordercolor="#111111" style="border-collapse: collapse">
				<tr>
					<td>
						<cfinclude template="DocumentEditCandidate.cfm">
					</td>
				</tr>   
			</table>
  			</td>
 		</tr>	
		<tr><td height="5" colspan="2"></td></tr>
	</table>	
	</td>
  	<td width="10%"></td>
  </tr>	
</table>
</CFFORM>
</BODY>
</HTML>