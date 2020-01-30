<!--
	ContingentEdit.cfm
	
	Contingent edit form.
	
	Calls: ContingentEditSubmit.cfm
	
	Modification History:
	03Oct05 - change query "qMission" record filter 
			  from: WHERE MissionCategory IN ('SPECIAL','ESTABLISHED','DPA-LED')
			  to:   WHERE MissionType = 'Peacekeeping'

-->
<HTML><HEAD><TITLE>Contingent - Edit</TITLE></HEAD>

<link rel="stylesheet" type="text/css" href="../../../<cfoutput>#client.style#</cfoutput>"> 

<body class="dialog" onLoad="javascript:document.ContingentEdit.focus();">

<cf_preventCache>


<cfparam name="URL.ID" default="0">

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
<!---
<cfquery name="qUnitUnion" datasource="#CLIENT.Datasource#" username="#SESSION.login#" password="#SESSION.dbpw#">
	SELECT  TOP 1 cu.Id AS ContingentUnitId, ' ' + cu.Name AS ContingentUnitName 
	FROM 	ContingentUnit cu INNER JOIN Contingent co ON cu.Id = co.ContingentUnit_Id
	WHERE   co.Id = #URL.ID#
	UNION
	SELECT  cu1.Id AS ContingentUnitId, cu1.Name AS ContingentUnitName 
	FROM 	ContingentUnit cu1 
	WHERE   cu1.Id <> (SELECT ContingentUnit_Id FROM Contingent WHERE Contingent.Id = #URL.ID#)
</cfquery>

<cfquery name="qSubUnitUnion" datasource="#CLIENT.Datasource#" username="#SESSION.login#" password="#SESSION.dbpw#">
	SELECT  TOP 1 cs.Id AS ContingentSubUnitId, ' ' + cs.Name AS ContingentSubUnitName 
	FROM 	ContingentSubUnit cs INNER JOIN Contingent co ON cs.Id = co.ContingentSubUnit_Id
	WHERE	co.Id = #URL.ID#
	UNION
	SELECT  cs1.Id AS ContingentSubUnitId, cs1.Name AS ContingentSubUnitName 
	FROM 	ContingentSubUnit cs1 INNER JOIN ContingentUnitSubUnit cus1 ON cs1.Id = cus1.ContingentSubUnit_Id
	WHERE   cs1.Id <> (SELECT ContingentSubUnit_Id FROM Contingent WHERE Contingent.Id = #URL.ID#)
	AND		cus1.ContingentUnit_Id = (SELECT ContingentUnit_Id FROM Contingent WHERE Contingent.Id = #URL.ID#)
</cfquery>

<cfquery dbtype="query" name="qUnit">
	SELECT * FROM qUnitUnion
	ORDER BY ContingentUnitName
</cfquery>

<cfquery dbtype="query" name="qSubUnit">
	SELECT * FROM qSubUnitUnion
	ORDER BY ContingentSubUnitName
</cfquery>
--->

<cfquery name="qUnit" datasource="AppsTravel" username="#SESSION.login#" password="#SESSION.dbpw#">
	SELECT  cu.Id AS ContingentUnitId, cu.Name AS ContingentUnitName 
	FROM 	ContingentUnit cu 
	ORDER BY cu.Name
</cfquery>

<cfquery name="qSubUnit" datasource="AppsTravel" username="#SESSION.login#" password="#SESSION.dbpw#">
	SELECT  cs.Id AS ContingentSubUnitId, cs.Name AS ContingentSubUnitName 
	FROM 	ContingentSubUnit cs 
	ORDER BY cs.Name
</cfquery>

<cfquery name="qGet" datasource="AppsTravel" username="#SESSION.login#" password="#SESSION.dbpw#">
	SELECT   *, Id AS ContingentId, Name AS ContingentName
    FROM     Contingent
    WHERE    Id = #URL.ID#		
</cfquery>

<CFFORM action="ContingentEditSubmit.cfm" method="POST" name="ContingentEdit">

<!-- Start of main table -->
<table width="100%" border="1" cellspacing="0" cellpadding="0" bordercolor="#002350" frame="all">
<tr>
	<td align="left" height="40" valign="middle" bgcolor="002350">
	&nbsp;<font face="Tahoma" size="2" color="#FFFFFF"><strong>Contingent Edit</strong></font>
	</td>
	<td align="right" valign="middle" bgcolor="002350">
   	  <input type="submit" class="button8" name="Submit" value=" Save Changes ">
	  <input type="button" class="button8" name="Close" value="Close" onClick="window.close()">
	  &nbsp;
	</td>
</tr> 	
  
<cfoutput>
   <input type="hidden" name="ContingentId" value="#qGet.ContingentId#", size="5" maxlength="5">
</cfoutput>		

<!-- Start data entry block -->   
<tr>
<td width="100%" colspan="2">
<table width="98%" border="0" cellspacing="0" cellpadding="0" align="center" bordercolor="#111111" style="border-collapse: collapse">

	<tr><td class="header" height="10"></td></tr>

	<tr>
	  <td class="header">&nbsp;Contingent Name (100 chars max)*:</td>
	  <td>
	  <cfinput type="Text" name="ContingentName" value="#qGet.ContingentName#" required="No" size="100" maxlength="100">
	  </td>
	</tr>

	<tr><td height="10"></td></tr>
	
    <tr>
	  <td class="header">&nbsp;Contributor*:</td>
	  <td>
		<font color="#0000FF" face="Lucida Console" size="1">
 		    <cfselect name="PermanentMissionId" required="Yes">
	    	<cfoutput query="qContributor">
			<option value="#PermanentMissionId#" <cfif #PermanentMissionId# eq #qGet.PermanentMissionId#> selected</cfif>>#PermanentMissionName#</option>
			</cfoutput>
		    </cfselect>			
		</font>
	  </td>
	</tr>

	<tr><td height="10"></td></tr>

    <tr>
    <td valign="top" class="header">&nbsp;Unit*:</td>
	<td>
		<font color="#0000FF" face="Lucida Console" size="1">
 		    <cfselect name="ContingentUnitId" required="Yes">
	    	<cfoutput query="qUnit">
			<option value="#ContingentUnitId#" <cfif #ContingentUnitId# eq #qGet.ContingentUnit_Id#> selected</cfif>>#ContingentUnitName#</option>
			</cfoutput>
		    </cfselect>
		</font>
    </td>
	</tr>
	
	<tr><td height="10"></td></tr>
			
    <tr>
    <td valign="top" class="header">&nbsp;Sub-Unit*:</td>
	<td>
		<font color="#0000FF" face="Lucida Console" size="1">
 		    <cfselect name="ContingentSubUnitId" required="Yes">
	    	<cfoutput query="qSubUnit">
			<option value="#ContingentSubUnitId#" <cfif #ContingentSubUnitId# eq #qGet.ContingentSubUnit_Id#> selected</cfif>>#ContingentSubUnitName#</option>
			</cfoutput>
		    </cfselect>
		</font>
    </td>
	</tr>
	
	<tr><td height="10"></td></tr>
		
	<tr>
	  <td class="header">&nbsp;Authorized Strength:</td>
	  <td>
	  <cfinput type="Text" name="AuthorizedStrength" value="#qGet.AuthorizedStrength#" required="No" size="10" maxlength="10">
	  </td>
	</tr>

	<tr><td height="10"></td></tr>
	
    <tr>
	  <td class="header">&nbsp;DPKO Field Mission*:</td>
	  <td>
		<font color="#0000FF" face="Lucida Console" size="1">
 		    <cfselect name="Mission" required="Yes">
	    	<cfoutput query="qMission">
			<option value="#Mission#" <cfif #Mission# eq #qGet.Mission#> selected</cfif>>#Mission#</option>
			</cfoutput>
		    </cfselect>			
	  </td>
	</tr>

	<tr><td height="10"></td></tr>
	
	<tr>
	  <td class="header">&nbsp;Deployment Period (# of months):</td>
	  <td>
	  <cfinput type="Text" name="DeploymentPeriod" value="#qGet.DeploymentPeriod#" required="No" size="10" maxlength="10">
	  </td>
	</tr>
	
	<tr><td height="10"></td></tr>
		
	<tr>
	  <td class="header">&nbsp;Status*:</td>
	  <td class="regular">		
	  <INPUT type="radio" name="Status" value="0" <cfif #qGet.Status# EQ "0"> checked</cfif>> Active
	  <INPUT type="radio" name="Status" value="1" <cfif #qGet.Status# EQ "1"> checked</cfif>> Inactive		
	  </td>
	</tr>
	
	<tr><td height="10"></td></tr>

	<tr>
	  <td valign="top" class="header">&nbsp;Remarks (200 chars max)*:</td>
	  <td>
		 <textArea name="Remarks" value="#qGet.Remarks#" cols="50" rows="4" wrap="virtual"></textarea>
	  </td>
	</tr>

	<tr>
  	  <td class="header">	
	  &nbsp;
   	  <input type="submit" class="button8" name="Submit" value="Save Changes">
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