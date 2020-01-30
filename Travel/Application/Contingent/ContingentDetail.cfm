<!--
	ContingentDetails.cfm
	
	Contingent detail form.
	
	Called by: ContingentListing.cfm
	
	Calls:     ContingentActivityEntry.cfm
			   ContingentActivityEdit.cfm
	
	Modification History:
	03Oct05 - change query "qMission" record filter 
			  from: WHERE MissionCategory IN ('SPECIAL','ESTABLISHED','DPA-LED')
			  to:   WHERE MissionType = 'Peacekeeping'

-->
<HTML><HEAD><TITLE>Contingent - Detail</TITLE></HEAD>

<link rel="stylesheet" type="text/css" href="../../../<cfoutput>#client.style#</cfoutput>"> 

<body class="dialog" onLoad="javascript:document.ContingentDetail.focus();">

<cf_preventCache>


<!--- tools : make available javascript for quick reference to dialog screens --->
<cfinclude template="../Dialog.cfm">

<cfset CLIENT.Datasource="AppsTravel">
<cfparam name="URL.CONT_ID" default="0">

<SCRIPT LANGUAGE = "JavaScript">
function OpenPage_AddNewContActivity(cont_id) {
    window.location="ContingentActivityEntry.cfm?CONT_ID=" + cont_id;
}
</SCRIPT>

<cfquery name="qMission" datasource="AppsOrganization" username="#SESSION.login#" password="#SESSION.dbpw#">
	SELECT DISTINCT Mission	FROM Ref_Mission
	WHERE MissionType = 'Peacekeeping'
	AND	  Operational = 1
	ORDER BY Mission
</cfquery>

<cfquery name="qContributor" datasource="#CLIENT.Datasource#" username="#SESSION.login#" password="#SESSION.dbpw#">
	SELECT PermanentMissionId, Description AS PermanentMissionName FROM Ref_PermanentMission
	WHERE Description IS NOT NULL	
	AND	  Operational = 1
	AND	  Contributor = 1
	ORDER BY Description
</cfquery>

<cfquery name="qUnitSubUnit" datasource="#CLIENT.Datasource#" username="#SESSION.login#" password="#SESSION.dbpw#">
	SELECT  TOP 1 cu.Id AS ContingentUnitId, cu.Name AS ContingentUnitName, 
			cs.Id AS ContingentSubUnitId, cs.Name AS ContingentSubUnitName 
	FROM 	ContingentUnit cu, ContingentSubUnit cs, Contingent co
	WHERE	co.ContingentUnit_Id = cu.Id
	AND		co.ContingentSubUnit_Id = cs.Id
	AND		co.Id = #URL.CONT_ID#
</cfquery>

<cfquery name="qGet" datasource="#CLIENT.Datasource#" username="#SESSION.login#" password="#SESSION.dbpw#">
	SELECT  co.*, co.Id AS ContingentId, co.Name AS ContingentName, 
			cu.Name AS ContingentUnitName, cs.Name AS ContingentSubUnitName, 
			pm.Description AS Contributor
	FROM    Contingent co INNER JOIN
			ContingentUnit cu ON co.ContingentUnit_Id = cu.Id INNER JOIN
			ContingentSubUnit cs ON co.ContingentSubUnit_Id = cs.Id INNER JOIN
			Ref_PermanentMission pm ON co.PermanentMissionId = pm.PermanentMissionId
    WHERE   co.Id = #URL.CONT_ID#		
</cfquery>


<CFFORM name="ContingentDetail" id="ContingentDetail">

<!-- Start of main table -->
<table width="100%" border="1" cellspacing="0" cellpadding="0" bordercolor="#002350" frame="all">
<tr>
	<td align="left" height="40" valign="middle" bgcolor="002350">
	&nbsp;<font face="Tahoma" size="2" color="#FFFFFF"><strong>Contingent Details</strong></font>
	</td>
	<td align="right" valign="middle" bgcolor="002350">
  	  <cfoutput>
 	  <input type="button" class="button8" name="Add" value=" Add Activity " 
		onClick="javascript:OpenPage_AddNewContActivity(#URL.CONT_ID#)">
	  </cfoutput>
	  <input type="button" class="button8" name="Close" value="Close" onClick="window.close()">
	  &nbsp;
	</td>
</tr> 	
  
<cfoutput>
   <input type="hidden" name="ContingentId" value="#qGet.ContingentId#" size="5" maxlength="5">
</cfoutput>

<!-- Start data entry block -->   
<tr>
<td width="100%" colspan="2">
<table width="98%" border="0" cellspacing="0" cellpadding="0" align="center" bordercolor="#111111" style="border-collapse: collapse">

	<tr>
	  <td class="header">&nbsp;Contingent Name (100 chars max)*:</td>
	  <td>
	  <input type="Text" name="ContingentName" value="<cfoutput>#qGet.ContingentName#</cfoutput>" size="100" readonly="yes">
	  </td>
	</tr>

    <tr>
	  <td class="header">&nbsp;Contributor*:</td>
	  <td>
	  <input type="Text" name="PermanentMissionId" value="<cfoutput>#qGet.Contributor#</cfoutput>" size="100" readonly="yes">	  
	  </td>
	</tr>

    <tr>
      <td valign="top" class="header">&nbsp;Unit:</td>
	  <td>
  	  <input type="Text" name="ContingentUnit" value="<cfoutput>#qGet.ContingentUnitName#</cfoutput>" size="100" readonly="yes">
      </td>
	</tr>

    <tr>
      <td valign="top" class="header">&nbsp;Sub Unit:</td>
	  <td>
  	  <input type="Text" name="ContingentSubUnit" value="<cfoutput>#qGet.ContingentSubUnitName#</cfoutput>" size="100" readonly="yes">
      </td>
	</tr>
	
	<tr>
	  <td class="header">&nbsp;Authorized Strength:</td>
	  <td>
	  <cfoutput>
	  <input type="Text" name="AuthorizedStrength" value="<cfoutput>#qGet.AuthorizedStrength#</cfoutput>" size="10"readonly="yes">
	  </cfoutput>
	  </td>
	</tr>

    <tr>
	  <td class="header">&nbsp;DPKO Field Mission*:</td>
	  <td>
	  <input type="Text" name="DeploymentPeriod" value="<cfoutput>#qGet.Mission#</cfoutput>" size="20" readonly="yes">
	  </td>
	</tr>

	<tr>
	  <td class="header">&nbsp;Deployment Period (# of mos):</td>
	  <td>
	  <input type="Text" name="DeploymentPeriod" value="<cfoutput>#qGet.DeploymentPeriod#</cfoutput>" size="10" readonly="yes">
	  </td>
	</tr>
	
	<tr>
	  <td class="header">&nbsp;Status*:</td>
	  <td class="regular">		
	  <input type="radio" name="Status" value="0" disabled="yes" <cfif #qGet.Status# EQ "0"> checked</cfif>> Active
	  <input type="radio" name="Status" value="1" disabled="yes" <cfif #qGet.Status# EQ "1"> checked</cfif>> Inactive		
	  </td>
	</tr>
	
	<tr>
	  <td valign="top" class="header">&nbsp;Remarks (200 chars max)*:</td>
	  <td>
	  <textArea name="Remarks" value="#qGet.Remarks#" cols="50" rows="4" wrap="virtual" readonly="yes"></textarea>
	  </td>
	</tr>

	<tr>
  	  <td class="header">	
	  &nbsp; 	  
  	  <cfoutput>
 	  <input type="button" class="button8" name="Add" value=" Add Activity " 
		onClick="javascript:OpenPage_AddNewContActivity(#URL.CONT_ID#)">
	  </cfoutput>
	  <input type="button" class="button8" name="Close" value="Close" onClick="window.close()">
	  </td>
	  <td colspan="2">&nbsp;</td>
	</tr>
	<!-- spacer row -->
	<tr class="header" bgcolor="#FFFFFF"><td height="5" colspan="2"></td></tr>	
</table>
</td>
</tr>

<cfinclude template="ContingentActivityListing.cfm">

</table>

</CFFORM>
</BODY>
</HTML>