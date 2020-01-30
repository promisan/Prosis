<!--- 
	IncidentListing.CFM

	View disciplinary incidents.
	
	Modification History:
	21Oct03 - created by MM
	13FEb03 - now using Employee.DBO.Person
--->
<HTML><HEAD><TITLE>Disciplinary Incidents</TITLE></HEAD>

<cfset CLIENT.DataSource = "AppsTravel">


<cf_PreventCache>

<SCRIPT LANGUAGE = "JavaScript">
function reloadForm(group,miss,nat,invoff,decis,hide,page)
{
    window.location="IncidentListing.cfm?IDSorting=" + group + "&ID_Miss=" + miss + "&ID_Nat=" + nat + "&ID_InvOff=" + invoff +  "&ID_Decis=" + decis + "&ID_Hide=" + hide + "&Page=" + page;
}
</SCRIPT>	

<!--- tools : make available javascript for quick reference to dialog screens --->
<cfinclude template="Dialog.cfm">

<!--- Create a flag to signal that page has been opened the first time (as opposed to page reloads --->
<cfif ParameterExists(URL.IDSorting)>
	<cfset PageJustOpenedFlag = 0 >	
<cfelse>
	<cfset PageJustOpenedFlag = 1 >
</cfif>

<cfparam name="URL.IDSorting" 	default="PersonName">
<cfparam name="URL.ID_Miss" 	default="ALL">
<cfparam name="URL.ID_Nat" 		default="ALL">
<cfparam name="URL.ID_InvOff" 	default="ALL">
<cfparam name="URL.ID_Decis" 	default="ALL">
<cfparam name="URL.ID_Hide" 	default="1">

<!--- If page was opened the first time, create all temp tables --->
<cfif #PageJustOpenedFlag#>

	<!---- 1. Check if use is allowed to access "All Missions" or particular missions --->
	<cfquery name="Mission1" datasource="#CLIENT.Datasource#" username="#SESSION.login#" password="#SESSION.dbpw#">
	SELECT AA.Mission
	FROM ActionAuthorization AA, FlowAction FA, Ref_TravellerType RT
	WHERE AA.ActionId = FA.ActionID
	AND   FA.ActionClass = RT.TravellerTypeCode
	AND   AA.AccessLevel <> '9'
	AND   AA.UserAccount = '#SESSION.acc#'
	GROUP BY AA.Mission
	</cfquery>

	<!---- 2. Build temp table of post types user is authorized to access --->
	<CF_DropTable dbName="AppsQuery" tblName="tmp#SESSION.acc#pm_AuthorizedPostType">

	<cfquery name="AuthorizedPostType" datasource="#CLIENT.Datasource#" username="#SESSION.login#" password="#SESSION.dbpw#">
	SELECT RT.TravellerType AS PostType
	INTO  userQuery.dbo.tmp#SESSION.acc#pm_AuthorizedPostType
	FROM ActionAuthorization AA, FlowAction FA, Ref_TravellerType RT
	WHERE AA.ActionId = FA.ActionID
	AND   FA.ActionClass = RT.TravellerTypeCode
	AND   AA.AccessLevel <> '9'
	AND   AA.UserAccount = '#SESSION.acc#'
	GROUP BY RT.TravellerType
	</cfquery>
	
	<!---- 3. Delete temp table to hold field missions user is authorized to access --->
	<CF_DropTable dbName="AppsQuery" tblName="tmp#SESSION.acc#pm_AuthorizedMiss">

	<!---- 3a. If user has access to all mission, read all current missions from Incident table --->
	<cfif #Mission1.Mission# EQ "All Missions">
		<cfquery name="AuthorizedMission" datasource="#CLIENT.Datasource#" username="#SESSION.login#" password="#SESSION.dbpw#">
		SELECT DISTINCT I.Mission
		INTO  userQuery.dbo.tmp#SESSION.acc#pm_AuthorizedMiss
		FROM Incident I WHERE I.Mission IS NOT NULL
		ORDER BY I.Mission
		</cfquery>
	<cfelse>
		<!--- 3b. Else, read authorized mission from ActionAuthorization table (same rules as above) --->
		<cfquery name="AuthorizedMission" datasource="#CLIENT.Datasource#" username="#SESSION.login#" password="#SESSION.dbpw#">
		SELECT DISTINCT AA.Mission
		INTO  userQuery.dbo.tmp#SESSION.acc#pm_AuthorizedMiss		
		FROM ActionAuthorization AA, FlowAction FA, Ref_TravellerType RT, Ref_Category RC,
			 EMPLOYEE.DBO.Person P, IncidentPerson IP, Incident I
		WHERE AA.ActionId = FA.ActionID
		AND   FA.ActionClass = RT.TravellerTypeCode
		AND   RT.TravellerType = RC.TravellerType
		AND   RC.Category = P.Category
		AND   P.PersonNo = IP.PersonNo
		AND   IP.Incident = I.Incident
		AND   AA.AccessLevel <> '9'
		AND   AA.UserAccount = '#SESSION.acc#'
		AND   RT.TravellerType IN (SELECT PostType FROM userQuery.dbo.tmp#SESSION.acc#pm_AuthorizedPostType)
		ORDER BY AA.Mission
		</cfquery>
	</cfif>

	<!---- 4. Build temp table to nationality codes for which an incident record currently exist,
          AND where the persons involved in the incident have a Category that the user is authorized to access  --->
	<CF_DropTable dbName="AppsQuery" tblName="tmp#SESSION.acc#pm_ActiveNat">

	<cfquery name="ActiveNat" datasource="AppsTravel" username="#SESSION.login#" password="#SESSION.dbpw#">
    SELECT DISTINCT N.Code, N.Name 
	INTO  userQuery.dbo.tmp#SESSION.acc#pm_ActiveNat
	FROM ActionAuthorization AA, FlowAction FA, Ref_TravellerType RT, Ref_Category RC,
		 EMPLOYEE.DBO.Person P, IncidentPerson IP, Incident I, APPLICANT.DBO.Ref_Nationality N
	WHERE AA.ActionId = FA.ActionID
	AND   FA.ActionClass = RT.TravellerTypeCode
	AND   RT.TravellerType = RC.TravellerType
	AND   RC.Category = P.Category
	AND   P.PersonNo = IP.PersonNo
	AND   IP.Incident = I.Incident
	AND   P.Nationality = N.Code
	AND   AA.AccessLevel <> '9'
	AND   AA.UserAccount = '#SESSION.acc#'
	AND   RT.TravellerType IN (SELECT PostType FROM userQuery.dbo.tmp#SESSION.acc#pm_AuthorizedPostType)
	ORDER BY N.Name
	</cfquery>

</cfif>

<!--- Signal that page will now henceforth be opened a second, third... time --->
<cfset PageJustOpenedFlag = 0>

<!--- 5a. Read list of field missions for drop list --->
<cfquery name="qMission" datasource="AppsTravel" username="#SESSION.login#" password="#SESSION.dbpw#">
    SELECT DISTINCT M.Mission
	FROM userQuery.dbo.tmp#SESSION.acc#pm_AuthorizedMiss M, Incident I
	WHERE M.Mission = I.Mission
	ORDER BY M.Mission
</cfquery>

<!--- 5b. Read list of nationalities for drop list --->
<cfquery name="qNation" datasource="AppsTravel" username="#SESSION.login#" password="#SESSION.dbpw#">
    SELECT DISTINCT N.Code, N.Name 
	FROM userQuery.dbo.tmp#SESSION.acc#pm_ActiveNat N, EMPLOYEE.DBO.Person P, IncidentPerson IP
	WHERE N.Code = P.Nationality
	AND   P.PersonNo = IP.PersonNo
	AND   N.Name > 'A'
	ORDER BY N.Name
</cfquery>

<cfquery name="qDecision" datasource="#CLIENT.Datasource#" username="#SESSION.login#" password="#SESSION.dbpw#">
	SELECT DISTINCT D.Decision, D.Description AS sDecisionDesc
	FROM Decision D INNER JOIN IncidentPerson IP ON D.Decision = IP.Decision
	   				INNER JOIN Incident I ON IP.Incident = I.Incident 
					INNER JOIN userQuery.dbo.tmp#SESSION.acc#pm_AuthorizedMiss AM ON I.Mission = AM.Mission
					INNER JOIN EMPLOYEE.DBO.Person P ON IP.PersonNo = P.PersonNo
					INNER JOIN Ref_Category RC ON P.Category = RC.Category
					INNER JOIN userQuery.dbo.tmp#SESSION.acc#pm_AuthorizedPostType AP ON RC.TravellerType = AP.PostType
	ORDER BY D.Description
</cfquery>

<cfquery name="qInvestigatingOffice" datasource="#CLIENT.Datasource#" username="#SESSION.login#" password="#SESSION.dbpw#">
	SELECT DISTINCT IO.InvestigatingOffice, IO.Description AS sInvestigatingOffice
	FROM InvestigatingOffice IO INNER JOIN Incident I ON IO.InvestigatingOffice = I.InvestigatingOffice
	         				    INNER JOIN userQuery.dbo.tmp#SESSION.acc#pm_AuthorizedMiss AM ON I.Mission = AM.Mission
								INNER JOIN IncidentPerson IP ON I.Incident =  IP.Incident
								INNER JOIN EMPLOYEE.DBO.Person P ON IP.PersonNo = P.PersonNo
								INNER JOIN Ref_Category RC ON P.Category = RC.Category
								INNER JOIN userQuery.dbo.tmp#SESSION.acc#pm_AuthorizedPostType AP ON RC.TravellerType = AP.PostType
	ORDER BY IO.Description
</cfquery>

<cfquery name="searchresult" datasource="#CLIENT.Datasource#" username="#SESSION.login#" password="#SESSION.dbpw#">
SELECT I.*, IP.Decision, IP.ApprovalDate, IO.Description AS sInvestigatingOffice, N.Name AS CountryName,
	  (CASE WHEN (I.Status = 0) THEN 'Pending' ELSE 'Closed' END) AS sStat, 
       D.Description AS sDecision, Upper(P.LastName) + ', ' + P.FirstName AS PersonName, P.Nationality, P.LastName, P.FirstName
FROM Incident I INNER JOIN userQuery.dbo.tmp#SESSION.acc#pm_AuthorizedMiss AM ON I.Mission = AM.Mission
        		LEFT JOIN InvestigatingOffice IO ON I.InvestigatingOffice = IO.InvestigatingOffice 
				LEFT JOIN (IncidentPerson IP LEFT JOIN Decision D ON IP.Decision = D.Decision) ON I.Incident = IP.Incident 
                LEFT JOIN (EMPLOYEE.DBO.Person P LEFT JOIN APPLICANT.DBO.Ref_Nationality N ON P.Nationality = N.Code)
					   ON  IP.PersonNo = P.PersonNo 
WHERE I.Incident > 0
AND P.Category IN (SELECT DISTINCT RC.Category 
                   FROM Ref_Category RC INNER JOIN userQuery.dbo.tmp#SESSION.acc#pm_AuthorizedPostType AP ON RC.TravellerType = AP.PostType)
AND P.Nationality IN (SELECT DISTINCT Code FROM userQuery.dbo.tmp#SESSION.acc#pm_ActiveNat)
<cfif '#URL.ID_Miss#' neq 'ALL'>
 	<cfoutput>AND I.Mission = '#URL.ID_Miss#' </cfoutput>
</cfif> 
<cfif '#URL.ID_Nat#' neq 'ALL'>
 	<cfoutput>AND P.Nationality = '#URL.ID_Nat#' </cfoutput>
</cfif>   
<cfif '#URL.ID_InvOff#' neq 'ALL'>
 	<cfoutput>AND I.InvestigatingOffice = '#URL.ID_InvOff#' </cfoutput>
</cfif>  
<cfif '#URL.ID_Decis#' neq 'ALL'>
 	<cfoutput>AND IP.Decision = '#URL.ID_Decis#' </cfoutput>
</cfif>  

UNION

SELECT I.*, IP.Decision, '' AS ApprovalDate, IO.Description AS sInvestigatingOffice, N.Name AS CountryName,
	  (CASE WHEN (I.Status = 0) THEN 'Pending' ELSE 'Closed' END) AS sStat, 
       '' AS sDecision, Upper(P.LastName) + ', ' + P.FirstName AS PersonName, P.Nationality, P.LastName, P.FirstName
FROM Incident I LEFT JOIN IncidentPerson IP ON I.Incident = IP.Incident 
                LEFT JOIN (EMPLOYEE.DBO.Person P LEFT JOIN APPLICANT.DBO.Ref_Nationality N ON P.Nationality = N.Code)
					   ON  IP.PersonNo = P.PersonNo				      
        		LEFT JOIN InvestigatingOffice IO ON I.InvestigatingOffice = IO.InvestigatingOffice 
WHERE I.Incident > 0
AND   IP.Incident IS NULL
<cfif '#URL.ID_Miss#' neq 'ALL'>
 	<cfoutput>AND I.Mission = '#URL.ID_Miss#' </cfoutput>
</cfif> 
<cfif '#URL.ID_Nat#' neq 'ALL'>
 	<cfoutput>AND P.Nationality = '#URL.ID_Nat#' </cfoutput>
</cfif>   
<cfif '#URL.ID_InvOff#' neq 'ALL'>
 	<cfoutput>AND I.InvestigatingOffice = '#URL.ID_InvOff#' </cfoutput>
</cfif>  
<cfif '#URL.ID_Decis#' neq 'ALL'>
 	<cfoutput>AND IP.Decision = '#URL.ID_Decis#' </cfoutput>
</cfif>  

<cfif '#URL.IDSorting#' EQ 'PersonName'>
	<cfoutput>ORDER BY P.LastName, P.FirstName</cfoutput>	
<cfelseif '#URL.IDSorting#' EQ 'Decision'>
  	<cfoutput>ORDER BY sDecision, P.LastName, P.FirstName</cfoutput>	
<cfelseif '#URL.IDSorting#' EQ 'InvestigatingOffice'>
  	<cfoutput>ORDER BY sInvestigatingOffice, P.LastName, P.FirstName</cfoutput>	
<cfelseif '#URL.IDSorting#' EQ 'Nationality'>
	<cfoutput>ORDER BY P.Nationality, P.LastName, P.FirstName</cfoutput>	
<cfelse>
	<cfoutput>ORDER BY I.#URL.IDSorting#, P.LastName, P.FirstName</cfoutput>	
</cfif>

</cfquery>

<link rel="stylesheet" type="text/css" href="<cfoutput>#client.root#/#client.style#</cfoutput>"> 
<div class="screen">
<body class="main" onload="window.focus()" top="0", bottom="0">

<form name="incidentlisting" id="incidentlisting">

<table width="100%" border="1" cellspacing="0" cellpadding="0" bordercolor="#002350" frame="all">
  <tr height="20" bgcolor="002350">	
    <td><font face="Tahoma" size="2" color="#FFFFFF"><b>&nbsp;SHOW:</b></font></td>
    <td><font face="Tahoma" size="2" color="#FFFFFF"><b>&nbsp;Field Mission:</b></font></td>
	<td>
	<!--- dropdown to select a different mission --->
    <select name="miss" style="background: #C9D3DE;" accesskey="P" title="Select Field Mission" 
	onChange="javascript:reloadForm(group.value,this.value,nat.value,invoff.value,decis.value,hide.checked,page.value)">
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

	<!-- Investigating Office filter droplist -->	
    <td><font face="Tahoma" size="2" color="#FFFFFF"><b>&nbsp;&nbsp;&nbsp;&nbsp;Investigating Office:</b></font></td>
	<td colspan="2">	
    <select name="invoff" style="background: #C9D3DE;" accesskey="P" title="Select Field Mission" 
	onChange="javascript:reloadForm(group.value,miss.value,nat.value,this.value,decis.value,hide.checked,page.value)">
 	<option value="ALL">
	<font face="Tahoma" size="3">
	All
	</font>
    <cfoutput query="qInvestigatingOffice">
	<option value="#InvestigatingOffice#" <cfif #InvestigatingOffice# is '#URL.ID_InvOff#'>selected</cfif>>
	<font face="Tahoma" size="3">
	#sInvestigatingOffice#
	</font>
	</option>
	</cfoutput>
    </select>
    </td>
  </tr> 	

  <tr bgcolor="#002350" height="20">
    <td>&nbsp; </td>
    <td><font face="Tahoma" size="2" color="#FFFFFF"><b>&nbsp;Nationality:</b></font></td>		
	<!--- dropdown to select a different nationalities --->
	<td width="80">
    <select name="nat" style="background: #C9D3DE;" accesskey="P" title="Select Field Mission" 
	onChange="javascript:reloadForm(group.value,miss.value,this.value,invoff.value,decis.value,hide.checked,page.value)">
 	<option value="ALL">
	<font face="Tahoma" size="3">
	All
	</font>
    <cfoutput query="qNation">
	<option value="#Code#" <cfif #Code# is '#URL.ID_Nat#'>selected</cfif>>
	<font face="Tahoma" size="3">
	#Name#
	</font>
	</option>
	</cfoutput>
    </select>
    </td>
	
    <td><font face="Tahoma" size="2" color="#FFFFFF"><b>&nbsp;&nbsp;&nbsp;&nbsp;Decision:</b></font></td>
 	<td width="150">	
	<!--- dropdown to select a different mission --->
    <select name="decis" style="background: #C9D3DE;" accesskey="P" title="Select Field Mission" 
	onChange="javascript:reloadForm(group.value,miss.value,nat.value,invoff.value,this.value,hide.checked,page.value)">
 	<option value="ALL">
	<font face="Tahoma" size="2">
	All
	</font>
    <cfoutput query="qDecision">
	<option value="#Decision#" <cfif #Decision# is '#URL.ID_Decis#'>selected</cfif>>
	<font face="Tahoma" size="2">
	#sDecisionDesc#
	</font>
	</option>
	</cfoutput>
    </select>
    </td>	
	<!--- Print button --->
	<td align="right" height="20" valign="middle" bgcolor="002350">
	<input type="button" class="input.button1" name="Add" value="Add Incident" onClick="javascript:addnewincident()">
 	<input type="button" class="input.button1" name="Print" value="Print" onClick="javascript:window.print()"> 
	&nbsp;
	</td> 	
  </tr>

<table width="100%" border="1" cellspacing="0" cellpadding="0" align="center" bordercolor="#6688aa" rules="cols" style="border-collapse: collapse">
  <tr bgcolor="#6688AA" height="30">
    <td width="130"><font face="Tahoma" size="2" color="#FFFFFF"><b>&nbsp;GROUP/SORT BY:</b></font></td>	
	<!-- Group By droplist -->
	<td colspan="1" align="left">
	<!--- drop down for record grouping and sorting  --->	
	<select name="group" size="1" style="background: #C9D3DE;" 
	onChange="javascript:reloadForm(this.value,miss.value,nat.value,invoff.value,decis.value,hide.checked,page.value)">
		 <OPTION value="PersonName" <cfif #URL.IDSorting# eq "PersonName">selected</cfif>>Sort by Person Lastname
		 <OPTION value="Nationality" <cfif #URL.IDSorting# eq "Nationality">selected</cfif>>Group by Nationality
		 <OPTION value="Mission" <cfif #URL.IDSorting# eq "Mission">selected</cfif>>Group by Field Mission
		 <OPTION value="RequestedBy" <cfif #URL.IDSorting# eq "Nationality">selected</cfif>>Group by Requesting Body
		 <OPTION value="InvestigatingOffice" <cfif #URL.IDSorting# eq "InvestigatingOffice">selected</cfif>>Group by Investigating Office
	     <OPTION value="OpenDate" <cfif #URL.IDSorting# eq "OpenDate">selected</cfif>>Group by Case Open Date
    	 <OPTION value="CloseDate" <cfif #URL.IDSorting# eq "CloseDate">selected</cfif>>Group by Case Close Date
		 <OPTION value="Decision" <cfif #URL.IDSorting# eq "Decision">selected</cfif>>Group by Decision
<!---  removed on 01Jun04 MM since this option when selected in GROUP/SORT BY list is causing error.
    	 <OPTION value="ApprovalDate" <cfif #URL.IDSorting# eq "ApprovalDate">selected</cfif>>Group by Decision Approval Date
--->		 
	</select> 
	</td>
    <!--- option to hide/unhide description --->
    <td align="right" colspan="1">
    <input type="checkbox" name="hide" value="1" <cfif "1" is '#URL.ID_Hide#'>checked</cfif> 
	onClick="javascript:reloadForm(group.value,miss.value,nat.value,invoff.value,decis.value,this.checked,page.value)"
	style="background: #6688AA; font: larger; color: White;">	
	<font face="Tahoma" size="1" color="#FFFFFF"><b>Check to hide description</b></font>&nbsp;
	</td>
	
	<td align="right">
	<!--- drop down to select only a number of record per page using a tag in tools --->	
	<cfinclude template="../../Tools/PageCount.cfm">
	<select name="page" size="1" style="background: #C9D3DE;" 
	onChange="javascript:reloadForm(group.value,miss.value,nat.value,invoff.value,decis.value,hide.checked,this.value)">
		 <cfloop index="Item" from="1" to="#pages#" step="1">
    		  <cfoutput><option value="#Item#"<cfif #URL.page# eq "#Item#">selected</cfif>>#Item# of #pages#</option></cfoutput>
	     </cfloop>	 
	</select>
	</td>
</tr>

<!--- Detail column headers --->
<table width="100%" border="0" cellspacing="0" cellpadding="1" align="center" rules="rows">

<tr bgcolor="#8EA4BB">
    <td width="3%"></td>
	<td width="2%"></td>
    <td width="15%" align="left"><font face="Tahoma" size="1" color="#FFFFFF">Persons Involved</font></td>
    <td width="4%" align="left"><font face="Tahoma" size="1" color="#FFFFFF">Nat</font></td>
	<td width="8%" align="left"><font face="Tahoma" size="1" color="#FFFFFF">Mission</font></td>
	<td width="8%" align="left"><font face="Tahoma" size="1" color="#FFFFFF">Case No</font></td>
	<td width="7%" align="left"><font face="Tahoma" size="1" color="#FFFFFF">Opened</font></td>	
	<td width="7%" align="left"><font face="Tahoma" size="1" color="#FFFFFF">Closed</font></td>
	<td width="4%" align="left"><font face="Tahoma" size="1" color="#FFFFFF">Req By</font></td>
	<td width="12%" align="left"><font face="Tahoma" size="1" color="#FFFFFF">Investigating Office</font></td>
    <td width="10%" align="left"><font face="Tahoma" size="1" color="#FFFFFF">Decision</font></td>
	<td width="8%" align="left"><font face="Tahoma" size="1" color="#FFFFFF">Approved</font></td>
    <td width="7%" align="left"><font face="Tahoma" size="1" color="#FFFFFF">Entered</font></td>
    <td width="6%" align="left"><font face="Tahoma" size="1" color="#FFFFFF">Status</font></td>
</tr>

<cfset vac     = "0">
<cfset action  = "9999">
<cfset amtT    = 0>

<cfoutput query="SearchResult" group=#URL.IDSorting# startrow=#first# maxrows=#No#>

<cfset amt  = 0>
    
<!--- Display ROW containing record group headers --->
<tr bgcolor="f6f6f6">
<cfswitch expression = #URL.IDSorting#>
     <cfcase value = "OpenDate">
     <td colspan="14"><font face="Tahoma" size="2"><b>&nbsp;#Dateformat(OpenDate, "#CLIENT.dateformatshow#")#</b></font></td>
     </cfcase>
     <cfcase value = "CloseDate">
     <td colspan="14"><font face="Tahoma" size="2"><b>&nbsp;#Dateformat(CloseDate, "#CLIENT.dateformatshow#")#</b></font></td>
     </cfcase>
<!---  removed on 01Jun04 MM since this option when selected in GROUP/SORT BY list is causing error.
     <cfcase value = "ApprovalDate">
     <td colspan="14"><font face="Tahoma" size="2"><b>&nbsp;#Dateformat(ApprovalDate, "#CLIENT.dateformatshow#")#</b></font></td>
     </cfcase>
--->	 
     <cfcase value = "Decision">
	 <td colspan="14"><font face="Tahoma" size="2"><b>&nbsp;#sDecision#</b></font></td>
     </cfcase>
     <cfcase value = "InvestigatingOffice">
	 <td colspan="14"><font face="Tahoma" size="2"><b>&nbsp;#sInvestigatingOffice#</b></font></td>
     </cfcase>
     <cfcase value = "RequestedBy">
	 <td colspan="14"><font face="Tahoma" size="2"><b>&nbsp;<cfif '#RequestedBy#' EQ 'M'>Mission<cfelse>Other</cfif></b></font></td>
     </cfcase>
     <cfcase value = "Mission">
     <td colspan="14"><font face="Tahoma" size="2"><b>&nbsp;#Mission#</b></font></td> 
     </cfcase>	
     <cfcase value = "Nationality">
     <td colspan="14"><font face="Tahoma" size="2"><b>&nbsp;#CountryName#</b></font></td> 
     </cfcase>	
</cfswitch>   
</tr>

<!--- DETAIL RECORD SECTION --->     
<!--- Print a line before the record --->
<tr bgcolor="C0C0C0"><td height="1" colspan="14" class="top2"></td></tr>
	
<!--- Record detail row --->
<cfoutput>
<tr bgcolor="#IIf(CurrentRow Mod 2, DE('ffffff'), DE('EBEBEB'))#">
		
<td rowspan="1" align="center">
  <button class="button3" onClick="javascript:showincidentedit('#SearchResult.Incident#')">
  <img src="#CLIENT.Root#/Images/button.jpg" alt="" name="img0_#PersonNo#"  width="14" height="14" border="0" align="middle">
</td>

<td class="regular">#CurrentRow#.</td>	
<td class="regular">#SearchResult.PersonName#</td>
<td class="regular">#SearchResult.Nationality#</td>
<td class="regular">#SearchResult.Mission#</td>
<td class="regular">#SearchResult.MissionCaseNumber#</td>
<td class="regular">#DateFormat(OpenDate, "#CLIENT.dateformatshow#")#</td>		
<td class="regular">#DateFormat(CloseDate, "#CLIENT.dateformatshow#")#</td>		
<td class="regular">#SearchResult.RequestedBy#</td>
<td class="regular">#SearchResult.sInvestigatingOffice#</td>
<td class="regular">#SearchResult.sDecision#</td>
<td class="regular">#DateFormat(ApprovalDate, "#CLIENT.dateformatshow#")#</td>
<td class="regular">#Dateformat(Created, "#CLIENT.dateformatshow#")#</td>
<td class="regular">#sStat#</td>
</tr>

<!-- print incident description -->
<cfif #SearchResult.Description# NEQ '' AND #URL.ID_Hide# NEQ '1'>
	<tr bgcolor="#IIf(CurrentRow Mod 2, DE('ffffff'), DE('EBEBEB'))#">
	<td colspan="2">&nbsp;</td>
	<td colspan="11" class="regular">#SearchResult.Description#</td>
	<td>&nbsp;</td>
	</tr>
</cfif>

<tr bgcolor="#IIf(CurrentRow Mod 2, DE('ffffff'), DE('EBEBEB'))#">
<td></td>
<cfset Amt = Amt + 1>
<cfset AmtT = AmtT + 1>
</cfoutput>

<!---If record groups are being used, display the group counter section --->
<cfif #URL.IDSorting# neq "PersonName">
  <tr>								<!--- Print a line before the sub-total --->
  	<td colspan="13" align="center">
	<td align="right"><hr></td>	
  </tr>
   
  <tr>								<!--- Print the sub-total --->
  	<td colspan="13" align="center">		
	<td align="right"><font size="1" face="Tahoma"><b>#NumberFormat(Amt,'_____,__')#&nbsp;</b></font></td>	
  </tr>

  <tr><td height="10" colspan="13"></td></tr>
</cfif>
</cfoutput>
	
<!---	
<tr bgcolor="f7f7f7">			<!--- Print a line before the total --->
<td colspan="13" align="center">
<td align="right"><hr></td>	
</tr>
<tr bgcolor="f7f7f7">				<!--- Print the total --->		
<td colspan="13" align="center">
<td align="right"><font size="1" face="Tahoma"><b><cfoutput>#NumberFormat(AmtT,'_____,__')#&nbsp;</cfoutput></b></font></td>	
</tr>
--->

</table>

<!--- Print a dark blue border --->
<tr><td height="10" colspan="14" bgcolor="#002350"></td></tr>

</table> 

</table>

<hr><p align="center"><font face="Tahoma" size="1"><cfoutput>#SESSION.Welcome#</cfoutput></font></p>

</form>
</body>
</div>
</html>