<!--- 
	ContingentListing.CFM

	View military contingent records.  Used by FGS users only.
	
	Modification History:
	
--->
<HTML><HEAD><TITLE>Contingents</TITLE></HEAD>

<cfset CLIENT.DataSource = "AppsTravel">

<link href="../../../<cfoutput>#client.style#</cfoutput>" rel="stylesheet" type="text/css">
<link href="../../../../print.css" rel="stylesheet" type="text/css" media="print">


<cf_PreventCache>

<SCRIPT LANGUAGE = "JavaScript">
function reloadForm(group,miss,contrib,unitid,hide,page)
{
    window.location="ContingentListing.cfm?IDSorting=" + group + "&ID_Miss=" + miss + "&ID_Contrib=" + contrib + "&ID_UnitId=" + unitid + "&ID_Hide=" + hide + "&Page=" + page;
}
</SCRIPT>	

<!--- tools : make available javascript for quick reference to dialog screens --->
<cfinclude template="../Dialog.cfm">

<!--- Create a flag to signal that page has been opened the first time (as opposed to page reloads --->
<cfif ParameterExists(URL.IDSorting)>
	<cfset PageJustOpenedFlag = 0 >	
<cfelse>
	<cfset PageJustOpenedFlag = 1 >
</cfif>

<cfparam name="URL.IDSorting" 	default="ContingentName">
<cfparam name="URL.ID_Miss" 	default="ALL">
<cfparam name="URL.ID_Contrib" 	default="ALL">
<cfparam name="URL.ID_UnitId" 	default="ALL">
<cfparam name="URL.ID_Hide" 	default="1">

<!--- If page was opened the first time, create all temp tables --->
<cfif #PageJustOpenedFlag#>

	<!---- 1. Check if user is allowed to access "All Missions" or particular missions --->
	<cfquery name="Mission1" datasource="#CLIENT.Datasource#" username="#SESSION.login#" password="#SESSION.dbpw#">
	SELECT AA.Mission
	FROM ActionAuthorization AA, FlowAction FA, Ref_TravellerType RT
	WHERE AA.ActionId = FA.ActionID
	AND   FA.ActionClass = RT.TravellerTypeCode
	AND   AA.AccessLevel <> '9'
	AND   AA.UserAccount = '#SESSION.acc#'
	GROUP BY AA.Mission
	</cfquery>

	<!---- 2. Delete temp table to hold field missions user is authorized to access --->
	<CF_DropTable dbName="AppsQuery" tblName="tmp#SESSION.acc#pm_AuthorizedMiss">

	<!---- 2a. If user has access to all mission, read all current missions from Contingent table --->
	<cfif #Mission1.Mission# EQ "All Missions">
		<cfquery name="AuthorizedMission" datasource="#CLIENT.Datasource#" username="#SESSION.login#" password="#SESSION.dbpw#">
		SELECT DISTINCT Mission
		INTO  userQuery.dbo.tmp#SESSION.acc#pm_AuthorizedMiss
		FROM  Contingent 
		WHERE Mission IS NOT NULL
		AND   Status <> '9'		
		ORDER BY Mission
		</cfquery>
	<cfelse>
		<!--- 2b. Else, read authorized mission from ActionAuthorization table (same rules as above) --->
		<cfquery name="AuthorizedMission" datasource="#CLIENT.Datasource#" username="#SESSION.login#" password="#SESSION.dbpw#">
		SELECT DISTINCT aa.Mission
		INTO  userQuery.dbo.tmp#SESSION.acc#pm_AuthorizedMiss		
		FROM ActionAuthorization aa, FlowAction fa, Ref_TravellerType rt
		WHERE aa.ActionId = fa.ActionID
		AND   fa.ActionClass = rt.TravellerTypeCode
		AND   rt.TravellerType = 'MILITARY'
		AND   aa.AccessLevel <> '9'
		AND   aa.UserAccount = '#SESSION.acc#'		
		ORDER BY aa.Mission
		</cfquery>
	</cfif>

	<!---- 3. Build temp table to TCC codes for which a contingent record currently exist --->
	<CF_DropTable dbName="AppsQuery" tblName="tmp#SESSION.acc#pm_TCC">

	<cfquery name="Contribs" datasource="#CLIENT.Datasource#" username="#SESSION.login#" password="#SESSION.dbpw#">
    SELECT DISTINCT pm.PermanentMissionId, pm.Description
	INTO  	userQuery.dbo.tmp#SESSION.acc#pm_TCC
	FROM 	Ref_PermanentMission pm INNER JOIN 
			Contingent co ON pm.PermanentMissionId = co.PermanentMissionId
	ORDER BY pm.Description
	</cfquery>

</cfif>

<!--- Signal that page will now henceforth be opened a second, third... time --->
<cfset PageJustOpenedFlag = 0>

<!--- 4a. Read list of field missions for drop list --->
<cfquery name="qMission" datasource="#CLIENT.Datasource#" username="#SESSION.login#" password="#SESSION.dbpw#">
    SELECT 	DISTINCT m.Mission
	FROM 	userQuery.dbo.tmp#SESSION.acc#pm_AuthorizedMiss m INNER JOIN 
			Contingent co ON m.Mission = co.Mission
	WHERE	co.Status <> '9'	
	ORDER BY m.Mission
</cfquery>

<!--- 4b. Read list of TCCs for drop list --->
<cfquery name="qTCC" datasource="#CLIENT.Datasource#" username="#SESSION.login#" password="#SESSION.dbpw#">
    SELECT DISTINCT PermanentMissionId, Description AS TCC
	FROM 	userQuery.dbo.tmp#SESSION.acc#pm_TCC 
	ORDER BY Description
</cfquery>

<cfquery name="qUnit" datasource="#CLIENT.Datasource#" username="#SESSION.login#" password="#SESSION.dbpw#">
	SELECT DISTINCT cu.Id AS ContingentUnitId, cu.Name AS ContingentUnitName
	FROM 	Contingent co INNER JOIN 
			ContingentUnit cu ON co.ContingentUnit_Id = cu.Id
	WHERE	co.Status <> '9'	
	ORDER BY cu.Name
</cfquery>

<cfquery name="searchresult" datasource="#CLIENT.Datasource#" 
 username="#SESSION.login#" password="#SESSION.dbpw#">
SELECT     
  co.Id AS ContingentId, co.Name AS ContingentName, co.PermanentMissionId, pm.Description AS Contributor, cu.Id AS ContingentUnitId, 
  cu.Name AS ContingentUnitName, cs.Id AS ContingentSubUnitId, cs.Name AS ContingentSubUnitName, co.AuthorizedStrength, co.Mission, 
  co.DeploymentPeriod, co.Remarks, co.OfficerFirstName + ' ' + co.OfficerLastName AS EnteredBy, co.Created
FROM         
  Contingent co INNER JOIN
  Ref_PermanentMission pm ON co.PermanentMissionId = pm.PermanentMissionId INNER JOIN
  ContingentUnit cu ON co.ContingentUnit_Id = cu.Id INNER JOIN
  ContingentSubUnit cs ON co.ContingentSubUnit_Id = cs.Id
WHERE co.Status <> '9'
<cfif '#URL.ID_Miss#' neq 'ALL'>
 	<cfoutput>AND co.Mission = '#URL.ID_Miss#' </cfoutput>
</cfif> 
<cfif '#URL.ID_Contrib#' neq 'ALL'>
 	<cfoutput>AND co.PermanentMissionId = '#URL.ID_Contrib#' </cfoutput>
</cfif>   
<cfif '#URL.ID_UnitId#' neq 'ALL'>
 	<cfoutput>AND co.ContingentUnit_Id = '#URL.ID_UnitId#' </cfoutput>
</cfif> 

<cfif '#URL.IDSorting#' EQ 'Contributor'>
  	<cfoutput>ORDER BY pm.Contributor, co.ContingentName</cfoutput>	
<cfelseif '#URL.IDSorting#' EQ 'Mission'>
  	<cfoutput>ORDER BY co.Mission, co.ContingentName</cfoutput>	
<cfelseif '#URL.IDSorting#' EQ 'Unit Type'>
  	<cfoutput>ORDER BY ContingentUnitName, co.ContingentName</cfoutput>	
<cfelse>
	<cfoutput>ORDER BY co.ContingentName</cfoutput>	
</cfif>

</cfquery>

<!--- Query returning search results --->
<body class="main" onload="window.focus()" leftmargin="0" rightmargin="0" 
topmargin="0" bottommargin="0" marginheight="0" marginwidth="0">

<form name="contingentlisting" id="contingentlisting">

<table width="100%" border="1" cellspacing="0" cellpadding="0" bordercolor="#002350" frame="all">
  <tr height="20" bgcolor="002350">	
    <td><font face="Tahoma" size="2" color="#FFFFFF"><b>&nbsp;SHOW:</b></font></td>
    <td><font face="Tahoma" size="2" color="#FFFFFF"><b>&nbsp;Field Mission:</b></font></td>
	<td>
	<!--- dropdown to select a different mission --->
    <select name="miss" style="background: #C9D3DE;" accesskey="P" title="Select Field Mission" 
	onChange="javascript:reloadForm(group.value,this.value,contrib.value,unitid.value,hide.checked,page.value)">
 	<option value="ALL">
	<font face="Tahoma" size="3">
	All
	</font>
    <cfoutput query="qMission">
	<option value="#Mission#" <cfif #Mission# is '#URL.ID_Miss#'>selected</cfif>>
	<font face="Tahoma" size="3">
	#Mission#
	</font>
	</option>
	</cfoutput>
    </select>
    </td>

	<!-- TCC filter droplist -->	
    <td><font face="Tahoma" size="2" color="#FFFFFF"><b>&nbsp;&nbsp;&nbsp;&nbsp;Contributor:</b></font></td>
	<td colspan="2">	
    <select name="contrib" style="background: #C9D3DE;" accesskey="P" title="Select Contributor" 
	onChange="javascript:reloadForm(group.value,miss.value,this.value,unitid.value,hide.checked,page.value)">
 	<option value="ALL">
	<font face="Tahoma" size="3">
	All
	</font>
    <cfoutput query="qTCC">
	<option value="#PermanentMissionId#" <cfif #PermanentMissionId# is '#URL.ID_Contrib#'>selected</cfif>>
	<font face="Tahoma" size="3">
	#TCC#
	</font>
	</option>
	</cfoutput>
    </select>
    </td>

    <td>&nbsp; </td>
    <td><font face="Tahoma" size="2" color="#FFFFFF"><b>&nbsp;Unit Type:</b></font></td>		
	<!--- dropdown to select a different unit types --->
	<td colspan="3">
    <select name="unitid" style="background: #C9D3DE;" accesskey="P" title="Select Unit Type" 
	onChange="javascript:reloadForm(group.value,miss.value,contrib.value,this.value,hide.checked,page.value)">
 	<option value="ALL">
	<font face="Tahoma" size="3">
	All
	</font>
    <cfoutput query="qUnit">
	<option value="#ContingentUnitId#" <cfif #ContingentUnitId# is '#URL.ID_UnitId#'>selected</cfif>>
	<font face="Tahoma" size="3">
	#ContingentUnitName#
	</font>
	</option>
	</cfoutput>
    </select>
    </td>

  </tr> 	

  <!---tr bgcolor="#002350" height="20">
	<!--- Print button --->
	<td colspan="11" align="right" height="20" valign="middle" bgcolor="002350">&nbsp;
	
	</td> 	
  </tr---->

<table width="100%" border="1" cellspacing="0" cellpadding="0" align="center" bordercolor="#6688aa" rules="cols" style="border-collapse: collapse">
  <tr bgcolor="#6688AA" height="25">
    <td colspan="2"><font face="Tahoma" size="2" color="#FFFFFF"><b>&nbsp;GROUP/SORT BY:</b></font>
	<select name="group" size="1" style="background: #C9D3DE;" 
	onChange="javascript:reloadForm(this.value,miss.value,contrib.value,unitid.value,hide.checked,page.value)">
		 <OPTION value="ContingentName" <cfif #URL.IDSorting# eq "ContingentName">selected</cfif>>Sort by Contingent Name
		 <OPTION value="Contributor" <cfif #URL.IDSorting# eq "Contributor">selected</cfif>>Group by Contributor
		 <OPTION value="Mission" <cfif #URL.IDSorting# eq "Mission">selected</cfif>>Group by Field Mission
		 <OPTION value="ContingentUnitName" <cfif #URL.IDSorting# eq "ContingentUnitName">selected</cfif>>Group by Unit Type
	</select> 
	</td>
    <!--- option to hide/unhide description --->
    <td align="right" colspan="1">
    <input type="checkbox" name="hide" value="1" <cfif "1" is '#URL.ID_Hide#'>checked</cfif> 
	onClick="javascript:reloadForm(group.value,miss.value,contrib.value,unitid.value,this.checked,page.value)"
	style="background: #6688AA; font: larger; color: White;">	
	<font face="Tahoma" size="1" color="#FFFFFF"><b>Check to hide remarks</b></font>&nbsp;
	</td>
	
	<td align="right">
	<!--- drop down to select only a number of record per page using a tag in tools --->	
	<cfinclude template="../../../Tools/PageCount.cfm">
	<select name="page" size="1" style="background: #C9D3DE;" 
	onChange="javascript:reloadForm(group.value,miss.value,contrib.value,unitid.value,hide.checked,this.value)">
		 <cfloop index="Item" from="1" to="#pages#" step="1">
    		  <cfoutput><option value="#Item#"<cfif #URL.page# eq "#Item#">selected</cfif>>#Item# of #pages#</option></cfoutput>
	     </cfloop>	 
	</select>
	</td>
</tr>
<tr>
<td bgcolor="#6688AA" height="15" colspan="2"><font color="white">&nbsp;&nbsp;Instructions: Click box to input contingent activity.  Click description to edit contingent record.</font></td> 
<td bgcolor="#6688AA" colspan="2" align="right">
	<input type="button" class="button8" name="Add" value="Add Contingent" onClick="javascript:addnewcontingent()">
	<input type="button" class="button8" name="Print" value="Print" onClick="javascript:window.print()"> 
</td>
</tr>
<!--- Detail column headers --->
<table width="100%" border="0" cellspacing="0" cellpadding="1" align="center" rules="rows">

<tr bgcolor="#8EA4BB">
    <td class="top4n" width="2%"></td>
    <td class="top4n" width="2%"></td>	
    <td class="top4n" width="8%" align="left">Contributor</td>
	<td class="top4n" width="16%" align="left">Description</td>
    <td class="top4n" width="15%" align="left">Unit</td>
	<td class="top4n" width="10%" align="left">Sub-Unit</td>
	<td class="top4n" width="5%" align="left">Strength</td>
    <td class="top4n" width="8%" align="left">Mission</td>
	<td class="top4n" width="4%" align="left">Depl Pd</td>
	<td class="top4n" width="10%" align="left">Entered by</td>
	<td class="top4n" width="8%" align="left">Entered on</td>
</tr>

<cfset vac     = "0">
<cfset action  = "9999">
<cfset amtT    = 0>
 
<cfoutput query="SearchResult" group=#URL.IDSorting# startrow=#first# maxrows=#No#>

<cfset amt  = 0>
    
<!--- Display ROW containing record group headers --->
<tr bgcolor="f6f6f6">
<cfswitch expression = #URL.IDSorting#>
     <cfcase value = "Contributor">
	 <td colspan="11"><font face="Tahoma" size="2"><b>&nbsp;#Contributor#</b></font></td>
     </cfcase>
     <cfcase value = "Mission">
     <td colspan="11"><font face="Tahoma" size="2"><b>&nbsp;#Mission#</b></font></td> 
     </cfcase>
     <cfcase value = "ContingentUnitName">
     <td colspan="11"><font face="Tahoma" size="2"><b>&nbsp;#ContingentUnitName#</b></font></td> 
     </cfcase>	 	
</cfswitch>   
</tr>

<!--- DETAIL RECORD SECTION --->     
<!--- Print a line before the record --->
<tr bgcolor="C0C0C0"><td height="1" colspan="11" class="top2"></td></tr>
	
<!--- Record detail row --->
<cfoutput>
<tr bgcolor="#IIf(CurrentRow Mod 2, DE('ffffff'), DE('EBEBEB'))#">
		
<td rowspan="1" align="center">
  <button class="button3" onClick="javascript:showcontingentdetail('#SearchResult.ContingentId#')">
	  <img src="../../../Images/function.jpg" alt="" width="18" height="15" border="0">
  </button>
</td>
<td class="regular">#CurrentRow#.</td>	
<td class="regular">#Contributor#</td>
<td class="regular"><a href="javascript:showcontingentedit('#SearchResult.ContingentId#')" title="Click to edit contingent record.">#ContingentName#</a></td>
<td class="regular">#ContingentUnitName#</td>
<td class="regular">#ContingentSubUnitName#</td>
<td class="regular">#AuthorizedStrength#</td>
<td class="regular">#Mission#</td>
<td class="regular">#DeploymentPeriod#</td>
<td class="regular">#EnteredBy#</td>
<td class="regular">#Dateformat(Created, "#CLIENT.dateformatshow#")#</td>
</tr>

<!-- print incident description -->
<cfif #SearchResult.Remarks# NEQ '' AND #URL.ID_Hide# NEQ '1'>
	<tr bgcolor="#IIf(CurrentRow Mod 2, DE('ffffff'), DE('EBEBEB'))#">
	<td>&nbsp;</td>
	<td colspan="9" class="regular">#Remarks#</td>
	<td>&nbsp;</td>
	</tr>
</cfif>

<tr bgcolor="#IIf(CurrentRow Mod 2, DE('ffffff'), DE('EBEBEB'))#">
<td></td>
<cfset Amt = Amt + 1>
<cfset AmtT = AmtT + 1>
</cfoutput>

<!---If record groups are being used, display the group counter section --->
<cfif #URL.IDSorting# neq "ContingentName">
  <tr>								<!--- Print a line before the sub-total --->
  	<td colspan="10" align="center">
	<td align="right"><hr></td>	
  </tr>
   
  <tr>								<!--- Print the sub-total --->
  	<td colspan="10" align="center">		
	<td align="right"><font size="1" face="Tahoma"><b>#NumberFormat(Amt,'_____,__')#&nbsp;</b></font></td>	
  </tr>

  <tr><td height="10" colspan="11"></td></tr>
</cfif>
</cfoutput>
	
</table>

<!--- Print a dark blue border --->
<tr><td height="10" colspan="11" bgcolor="#002350"></td></tr>

</table> 

</table>

<hr><p align="center"><font face="Tahoma" size="1"><cfoutput>#SESSION.Welcome#</cfoutput></font></p>

</form>

</BODY></HTML>