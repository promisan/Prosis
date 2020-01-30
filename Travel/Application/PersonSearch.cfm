<!--- 
	PERSONSEARCH.CFM
	Page for searching for a deployed person to be associated to a Personnel Request document

	Modification History:
	15Oct03 - code adapted by MM from Vacancy/Application/CandidateEntry.cfm
--->

<HTML><HEAD><TITLE>Person Search</TITLE></HEAD>

<body bgcolor="#FFFFFF">
<link rel="stylesheet" type="text/css" href="../../<cfoutput>#client.style#</cfoutput>"> 

<body class="dialog" onLoad="javascript:document.forms.documentedit.lastname.focus();">

<cfparam name="URL.ID" default="0">
<cfset PersonSearchInd = "True">

<cf_preventCache>

<cf_dialogStaffing>
<cfinclude template="Dialog.cfm">

<SCRIPT LANGUAGE = "JavaScript">

function closing()
{
   window.close()
   opener.location.reload()
}

function check()
{
	if  (document.documentedit.indexno.value == "") 
	{
	   if (document.documentedit.lastname.value == "") 
	    {
		    alert("Enter an Index No or Last Name to use for searching for deployed persons.")
			return false;
		}
	 }	
  	window.open("", "list", "width=600, height=200, menubar=no, toolbar=no, scrollbars=yes, resizable=yes");
}

function inheritpersons(docno, olddocno)
{
if  (document.documentedit.old_docno.value == "") 
	{
	    alert("Enter the request number to inherit deployed persons from.")
		return false;
	}
	
 	window.location = "Rules/InheritNominees.cfm?ID=" + docno + "&ID_OLD=" + olddocno
}

</script>

<cfquery name="Parameter" datasource="#CLIENT.Datasource#" username="#SESSION.login#" password="#SESSION.dbpw#">
    SELECT * FROM Parameter
	WHERE Identifier = 'A'
</cfquery>

<cfquery name="qDocument" datasource="#CLIENT.Datasource#" username="#SESSION.login#" password="#SESSION.dbpw#">
    SELECT * FROM Document
	WHERE DocumentNo = '#URL.ID#'
</cfquery>

<cfquery name="qRef_PermanentMission" datasource="#CLIENT.Datasource#" username="#SESSION.login#" password="#SESSION.dbpw#">
    SELECT PermanentMissionId, Description FROM Ref_PermanentMission
	WHERE PermanentMissionId = #qDocument.PermanentMissionId#
</cfquery>

<cfquery name="qFlowClass" datasource="#CLIENT.Datasource#" username="#SESSION.login#" password="#SESSION.dbpw#">
    SELECT * FROM FlowClass
</cfquery>

<cfquery name="qRef_Nationality" datasource="#CLIENT.Datasource#" username="#SESSION.login#" password="#SESSION.dbpw#">
    SELECT code, name FROM Ref_Nationality
	WHERE Operational = '1'
	ORDER BY NAME
</cfquery>

<cfform action="PersonSearchList.cfm" name="documentedit" id="documentedit" target="list" enablecab="Yes">

<table width="100%" border="1" cellspacing="0" cellpadding="0" bordercolor="#002350" frame="all">
  <tr>
    <td height="30" align="left" valign="middle" bgcolor="#002350">
	<font face="Tahoma" size="2" color="#FFFFFF">
	<b>&nbsp;Req#: <font color="#33CCFF"><cfoutput>#qDocument.DocumentNo#</cfoutput></font>
	&nbsp;&nbsp;Permanent Mission: <font color="#33CCFF"><cfoutput>#qRef_PermanentMission.Description#</cfoutput></font>
	&nbsp;&nbsp;Field mission: <font color="#33CCFF"><cfoutput>#qDocument.Mission#</cfoutput></font></b>
	</font>
	</td>
	<td height="30" align="right" valign="middle" bgcolor="002350">	
	<font color="FFFFFF">	
	
	<!---CF_DialogHeaderSub 
	MailSubject="Document" 
	MailTo="" 
	MailAttachment="../../travel/application/documenteditexport.cfm" 
	MailFilter="#URL.ID#"
	ExcelFile=""
	CloseButton="False"---> 

    <input type="button" class="input.button1" name="Close" value=" Close " onClick="javascript:closing()">
	</font>
    </td>			
  </tr> 	
  
  <tr>
    <td colspan="2" height="16" align="left" bgcolor="6688aa" class="top">
	&nbsp;&nbsp;&nbsp;Number and Type of personnel requested:&nbsp;<font color="#FFCC33"><cfoutput>#qDocument.PersonCount#</cfoutput></font>
	 - <font color="#FFCC33"><cfoutput>#qDocument.PersonCategory#</cfoutput></font>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Travel arranged by:&nbsp;<font color="#FFCC33"><cfoutput>#qFlowClass.Description#</cfoutput></font>
	</td>	
  </tr>
  
  <tr>
  	<td colspan="2" height="25" align="left" class="top">
    	&nbsp;&nbsp;&nbsp;Inherit personnel from request no:&nbsp;
	    <cfoutput>
	    <input type="text" name="old_docno" value="" size="5" maxlength="5" style="background: 002350; color: White; border: 1px solid Gray; text-align: center; border-color: 002350;">
     	<input type="button" class="input.button1" name="Inherit" value="Inherit deployed personnel" onClick="javascript:inheritpersons('#URL.ID#',old_docno.value)">
    	</cfoutput>
	</td>
  </tr> 	
     
  <tr>
    <td width="100%" colspan="2">
    <table width="98%" border="0" cellspacing="0" cellpadding="0" align="center" bordercolor="#111111" style="border-collapse: collapse">
	
  <tr><td height="10" class="header"></td></tr>
	
	<cfoutput>
	<input type="hidden" name="mission" value="#qDocument.Mission#" size="30" maxlength="30" class="disabled" readonly>
	<input type="hidden" name="documentno" value="#qDocument.DocumentNo#">
    </cfoutput>

  <tr>
  	<td class="header">&nbsp;IndexNo*:</td>
    <td>
    <input type="Text" name="indexno" value="" size="15" maxlength="20" class="regular">
	</td>
  </tr>			
	 
  <tr>
    <td class="header">&nbsp;Last name*:</td>
    <td>
	<input type="Text" name="lastname" value="" size="40" maxlength="40" class="regular">
	</td>
  </tr>	
	
  <tr>
	<td class="header">&nbsp;First name:</td>
    <td>
	<input type="Text" name="firstname" value="" size="30" maxlength="30" class="regular">
	</td>
  </tr>	
	
  <tr>
    <td class = "Header">&nbsp;Date of birth (dd/mm/yy):</td>
    <td class = "regular">	
	<input class="regular" type="Text" name="BirthDate" size="12" maxlength="16">				
	</td>
  </tr>
	
  <tr>
    <td class="header">&nbsp;Gender:</td>
    <td class="regular">
	<INPUT type="radio" name="Gender" value="M"> Male
	<INPUT type="radio" name="Gender" value="F"> Female 
	<INPUT type="radio" name="Gender" value="" checked> Unknown 
	</td>
  </tr>

  <tr>
  	<td class="header">&nbsp;Nationality:</td>
    <td><select name="Nationality">
	    <cfoutput query="qRef_Nationality">
		<option value="#Code#">
		#Name#
		</option>
		</font>
		</cfoutput>
	    </select>	
	</td>
  </tr>
		
  <tr bgcolor="#FFFFFF"><td height="7" class="header"></td></tr>
	
  <tr>
  	<td class="header">
    &nbsp;
    <cfif #qDocument.Status# is "0" or #qDocument.Status# is "9">
       <input type="submit" class="input.button1" name="Submit" value="Find deployed person" onClick="return check()">
    </cfif>
	</td>
	<td>
	&nbsp;&nbsp;
	<font face="tahoma" color="#000000" size="1.5" >Note: An asterisk (*) after the field label indicates a mandatory field.</font>
	</td>
  </tr>
	
  <tr bgcolor="#FFFFFF"><td height="5" class="header"></td></tr>	
</table>
	
</table>

<!--- Start of Deployed Persons table at the lower half of page --->
<table width="100%" border="1" cellspacing="0" cellpadding="0" bordercolor="#002350" frame="all">

  <tr>
	<td height="18" align="left" valign="middle" bgcolor="002350">
	<font face="Times New Roman" size="2" color="FFFFFF">
	&nbsp;<b>Deployed Persons</b>
	</font>	 
    <tr>
	<td width="100%" colspan="2">
    <table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" bordercolor="#111111" style="border-collapse: collapse">
	  <tr>
		<td>
		<cfinclude template="DocumentRotatingPersonList.cfm">
		</td>
	  </tr>	     
	</table>
    </td>
    </tr>
  </tr>	
  <tr><td height="5" colspan="2"></td></tr>	
</table>
<!--- End of Deployed Persons table --->

</cfform>
</BODY></HTML>
