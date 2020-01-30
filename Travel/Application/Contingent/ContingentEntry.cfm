<!--
	ContingentEntry.cfm
	
	Contingent entry form.
	
	Calls: ContingentEntrySubmit.cfm
	
	Modification History:
	03Oct05 - change query "qMission" record filter 
			  from: WHERE MissionCategory IN ('SPECIAL','ESTABLISHED','DPA-LED')
			  to:   WHERE MissionType = 'Peacekeeping'

-->
<HTML><HEAD><TITLE>Contingent - Entry</TITLE></HEAD>

<link rel="stylesheet" type="text/css" href="../../../<cfoutput>#client.style#</cfoutput>"> 

<body class="dialog" onLoad="javascript:document.ContingentEntry.focus();">

<cf_preventCache>


<SCRIPT LANGUAGE = "JavaScript">
function ClosePage() {
	window.close();
    opener.history.go();
}
</SCRIPT>

<cfquery name="qMission" datasource="AppsOrganization" username="#SESSION.login#" password="#SESSION.dbpw#">
	SELECT DISTINCT Mission	FROM Ref_Mission
	WHERE MissionType = 'Peacekeeping'
	AND	  Operational = 1
	ORDER BY Mission
</cfquery>

<cfquery name="qContributor" datasource="AppsTravel" username="#SESSION.login#" password="#SESSION.dbpw#">
	SELECT PermanentMissionId, Description AS PermanentMissionName FROM Ref_PermanentMission
	WHERE Description IS NOT NULL	
	AND	  Operational = 1
	AND	  Contributor = 1
	AND   PermanentMissionId > 0
	ORDER BY Description
</cfquery>

<cfquery name="qUnitSubUnit" datasource="AppsTravel" username="#SESSION.login#" password="#SESSION.dbpw#">
	SELECT  cu.Id AS ContingentUnitId, cu.Name AS ContingentUnitName, 
			cs.Id AS ContingentSubUnitId, cs.Name AS ContingentSubUnitName 
	FROM 	ContingentUnitSubUnit cus, ContingentUnit cu, ContingentSubUnit cs
	WHERE	cus.ContingentUnit_Id = cu.Id
	AND		cus.ContingentSubUnit_Id = cs.Id
	ORDER BY cu.Name, cs.Name
</cfquery>

<CFFORM action="ContingentEntrySubmit.cfm" method="POST" name="ContingentEntry">

<!-- Start of main table -->
<table width="100%" border="1" cellspacing="0" cellpadding="0" bordercolor="#002350" frame="all">
<tr>
	<td align="left" height="40" valign="middle" bgcolor="002350">
	&nbsp;<font face="Tahoma" size="2" color="#FFFFFF"><strong>Contingent Entry</strong></font>
	</td>
	<td align="right" valign="middle" bgcolor="002350">
   	  <input type="submit" class="button8" name="Submit" value=" Save Entry ">
  	  <input type="button" class="button8" name="Close" value="Close" onClick="window.close()">
	  &nbsp;
	</td>
</tr> 	
  
<!-- Start data entry block -->   
<tr>
<td width="100%" colspan="2">
<table width="98%" border="0" cellspacing="0" cellpadding="0" align="center" bordercolor="#111111" style="border-collapse: collapse">
	<!-- space row -->
	<tr><td class="header" height="10"></td></tr>

	<tr>
	  <td class="header">&nbsp;Contingent Name (100 chars max)*:</td>
	  <td>
	  <cfinput type="Text" name="contingentname" required="Yes" size="100" maxlength="100">
	  </td>
	</tr>

	<tr><td height="10"></td></tr>
	
    <tr>
	  <td class="header">&nbsp;Contributor*:</td>
	  <td>
		<font color="#0000FF" face="Lucida Console" size="1">
 		    <cfselect name="permanentmissionid" required="Yes">
	    	<cfoutput query="qContributor">
			<option value="#PermanentMissionId#">#PermanentMissionName#</option>
			</cfoutput>
		    </cfselect>			
	  </td>
	</tr>
	
	<tr><td height="10"></td></tr>
		
    <tr>
    <td valign="top" class="header">&nbsp;Unit/Sub Unit Type*:</td>
	<td>
    <CF_TwoSelectsRelated
	QUERY="qUnitSubUnit"
	NAME1="ContingentUnitId"
	NAME2="ContingentSubUnitId"
	DISPLAY1="ContingentUnitName"
	DISPLAY2="ContingentSubUnitName"
	VALUE1="ContingentUnitId"
	VALUE2="ContingentSubUnitId"
	SIZE1="1"
	SIZE2="1"
	AUTOSELECTFIRST="Yes"
	FORMNAME="ContingentEntry">		  	  
    </td>
	</tr>
	
	<tr><td height="10"></td></tr>
		
	<tr>
	  <td class="header">&nbsp;Authorized Strength:</td>
	  <td>
	  <cfinput type="Text" name="authorizedstrength" required="No" size="10" maxlength="10">
	  </td>
	</tr>

	<tr><td height="10"></td></tr>
	
    <tr>
	  <td class="header">&nbsp;DPKO Field Mission*:</td>
	  <td>
		<font color="#0000FF" face="Lucida Console" size="1">
 		    <cfselect name="mission" required="Yes">
	    	<cfoutput query="qMission">
			<option value="#Mission#">#Mission#</option>
			</cfoutput>
		    </cfselect>			
	  </td>
	</tr>

	<tr><td height="10"></td></tr>
	
	<tr>
	  <td class="header">&nbsp;Deployment Period (# of months):</td>
	  <td>
	  <cfinput type="Text" name="deploymentperiod" required="No" size="10" maxlength="10">
	  </td>
	</tr>

	<tr><td height="10"></td></tr>
		
	<tr>
	  <td class="header">&nbsp;Status*:</td>
	  <td class="regular">		
	  <INPUT type="radio" name="status" value="0" checked> Active
	  <INPUT type="radio" name="status" value="1"> Inactive		
	  </td>
	</tr>

	<tr><td height="10"></td></tr>
	
	<tr>
	  <td valign="top" class="header">&nbsp;Remarks (200 chars max)*:</td>
	  <td>
		 <textArea name="remarks" cols="50" rows="4" wrap="virtual"></textarea>
	  </td>
	</tr>

	<tr>
  	  <td class="header">	
	  &nbsp;
   	  <input type="submit" class="button8" name="Submit" value="Save Entry">
  	  <input type="button" class="button8" name="Close" value="Close" onClick="javascript:ClosePage()">
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
</BODY>
</HTML>