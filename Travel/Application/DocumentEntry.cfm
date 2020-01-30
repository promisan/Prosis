<!--
	DocumentEntry.cfm
	
	Input screen for Personnel Request record
	
	Calls: DocumentEntrySubmit.cfm
	
	Modification History:
	21Apr04 - added Remarks and UsualOrigin fields
	10Aug04 - JS requested that no default planned deployment date be shown
			- CP agreed this was a good idea
	22dec04 - updated Missing query code from RM.MissionStatus =  1 to RM.Operational = 1
			- added today Operational column in Organization.Ref_Mission table			  
	03Oct05 - change filter for query "Mission" from Mission <> 'ADMINISTRATIVE' 
												to   Mission = 'Peacekeeping' 
	20Oct07 - added new query AuthorizedMission to check mission user is allowed to access. see further comments in the code.
-->	
<html><head><title>Document - Entry</title></head>

<!---
<body background="../Images/background.gif" bgcolor="#FFFFFF" onLoad="window.focus()" top="0", bottom="0">
--->
<cfparam name="URL.ID" default="">
<cfparam name="DocumentNoTrigger" default="#URL.ID#">

<cfset CLIENT.DataSource = "AppsTravel">

<script language="JavaScript">
	// display generic person search form
	function SearchPerson(FormName, FieldName)
		{
		  	window.open("../../DWarehouse/Search/IndexSearch.cfm?FormName=" + FormName + "&FieldName=" + FieldName, "IndexWindow", "width=600, height=550, toolbar=yes, scrollbars=yes, resizable=no");
		}

	// check if passed field is empty or is null. display warning msg.
	function IsFieldEmpty(fld) {
		if ((fld.value) == "" || (fld.value == null)) {
			alert("Field (" + fld.name + ") cannot be empty!");
			return true;
		} else {
			return false;
		}
	}

	// for each field specified, call rtn that checks if required fields are entry.
	function chkFields() {
		if (IsFieldEmpty(document.documententry.indexno)) {
			return false;
		}
		if (IsFieldEmpty(document.documententry.p_mission)) {
			return false;
		}
		return true;
	}
</script>


<!---- 1. Build temp table of post types user is authorized to access --->
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

<!---- 2. Check if use is allowed to access "All Missions" or particular missions 
<cfquery name="Mission1" datasource="#CLIENT.Datasource#" username="#SESSION.login#" password="#SESSION.dbpw#">
	SELECT AA.Mission
	FROM ActionAuthorization AA, FlowAction FA, Ref_TravellerType RT
	WHERE AA.ActionId = FA.ActionID
	AND   FA.ActionClass = RT.TravellerTypeCode
	AND   AA.AccessLevel <> '9'
	AND   AA.UserAccount = '#SESSION.acc#'
	GROUP BY AA.Mission
</cfquery>
--->

<!---- 3. Delete temp table to hold field missions user is authorized to access 
<CF_DropTable dbName="AppsQuery" tblName="tmp#SESSION.acc#pm_AuthorizedMiss">  --->

<!---- 3a. If user has access to all mission, read all current missions from Position table (only those Pos that have an associated PersonAssign 
<cfif #Mission1.Mission# EQ "All Missions">
	<cfquery name="AuthorizedMission" datasource="#CLIENT.Datasource#" username="#SESSION.login#" password="#SESSION.dbpw#">
		SELECT DISTINCT PO.Mission
		INTO  userQuery.dbo.tmp#SESSION.acc#pm_AuthorizedMiss
		FROM ActionAuthorization AA, FlowAction FA, Ref_TravellerType RT, 
			 EMPLOYEE.DBO.Position PO, EMPLOYEE.DBO.PersonAssignment PA
		WHERE AA.ActionId = FA.ActionID
		AND   FA.ActionClass = RT.TravellerTypeCode
		AND   RT.TravellerType = PO.PostType
		AND   PO.PositionNo = PA.PositionNo
		AND   AA.AccessLevel <> '9'
		AND   AA.UserAccount = '#SESSION.acc#'
		AND   PO.PostType IN (SELECT PostType FROM userQuery.dbo.tmp#SESSION.acc#pm_AuthorizedPostType)
		ORDER BY PO.Mission
	</cfquery>
<cfelse>
<!--- 3b. Else, read authorized mission from ActionAuthorization table (same rules as above) --->
	<cfquery name="AuthorizedMission" datasource="#CLIENT.Datasource#" username="#SESSION.login#" password="#SESSION.dbpw#">
		SELECT DISTINCT AA.Mission
		INTO  userQuery.dbo.tmp#SESSION.acc#pm_AuthorizedMiss		
		FROM ActionAuthorization AA, FlowAction FA, Ref_TravellerType RT, 
			 EMPLOYEE.DBO.Position PO, EMPLOYEE.DBO.PersonAssignment PA
		WHERE AA.ActionId = FA.ActionID
		AND   FA.ActionClass = RT.TravellerTypeCode
		AND   RT.TravellerType = PO.PostType
		AND   PO.PositionNo = PA.PositionNo
		AND   AA.AccessLevel <> '9'
		AND   AA.UserAccount = '#SESSION.acc#'
		AND   PO.PostType IN (SELECT PostType FROM userQuery.dbo.tmp#SESSION.acc#pm_AuthorizedPostType)
		ORDER BY AA.Mission
	</cfquery>
</cfif>
--->

<cfquery name="P_Mission" datasource="#CLIENT.Datasource#" username="#SESSION.login#" password="#SESSION.dbpw#">
    SELECT PermanentMissionId, Description FROM Ref_PermanentMission
	WHERE Operational = '1'
	AND   Contributor = '1'
	AND   PermanentMissionId > 0
	ORDER BY Description
</cfquery>

<!--- 20-Oct-07 Check if current user is limited in access to particular mission(s).
			    This is now needed as Field Mission Military Personnel staff require access
				to Enter New Requests and access should be restricted to the FM they belong to.
--->
<cfquery name="AuthorizedMission" datasource="#CLIENT.Datasource#" username="#SESSION.login#" password="#SESSION.dbpw#">
    SELECT DISTINCT Mission FROM ActionAuthorization
	WHERE UserAccount = '#SESSION.acc#'
	AND	  AccessLevel IN ('0','1')
</cfquery>
<!--- 20-Oct-07 - Note that in the future, mission access should be governed by OrganizationAuthorization table entries.
When that happens, switch to code below.
<cfquery name="AuthorizedMission" datasource="AppsOrganization" username="#SESSION.login#" password="#SESSION.dbpw#">
    SELECT DISTINCT Mission FROM OrganizationAuthorization
	WHERE AccessLevel = '1'
	AND	  Mission IS NOT NULL
	AND   UserAccount = '#SESSION.acc#'
</cfquery>
--->

<cfquery name="Mission" datasource="AppsOrganization" username="#SESSION.login#" password="#SESSION.dbpw#">
    SELECT DISTINCT Mission FROM Ref_Mission
	WHERE Operational = '1'
	AND   MissionType = 'Peacekeeping'
	<!--- 20-Oct-07  Added check below to limit access to particular mission user is allowed to access --->
	<cfif #AuthorizedMission.Mission# NEQ 'All Missions'>		
		AND Mission = '#AuthorizedMission.Mission#'
	</cfif>
	ORDER BY Mission
</cfquery>

<!--- 5a. Read list of field missions for drop list 
<cfquery name="Mission" datasource="#CLIENT.Datasource#" username="#SESSION.login#" password="#SESSION.dbpw#">
    SELECT Mission
	FROM USERQUERY.DBO.tmp#SESSION.acc#pm_AuthorizedMiss
	ORDER BY Mission	
</cfquery>
--->

<cfquery name="Category" datasource="#CLIENT.Datasource#" username="#SESSION.login#" password="#SESSION.dbpw#">
    SELECT C.Category  
	FROM  Ref_Category C INNER JOIN USERQUERY.DBO.tmp#SESSION.acc#pm_AuthorizedPostType PT
		  ON C.TravellerType = PT.PostType
	ORDER BY C.CatSort
</cfquery>

<cfquery name="Military" datasource="#CLIENT.Datasource#" username="#SESSION.login#" password="#SESSION.dbpw#">
    SELECT DISTINCT C.Category  
	FROM  Ref_Category C INNER JOIN USERQUERY.DBO.tmp#SESSION.acc#pm_AuthorizedPostType PT
		  ON C.TravellerType = PT.PostType
    WHERE C.TravellerType = 'MILITARY'
	ORDER BY Category
</cfquery>

<cfquery name="Class" datasource="#CLIENT.Datasource#" username="#SESSION.login#" password="#SESSION.dbpw#">
    SELECT * FROM  FlowClass
</cfquery>

<cfquery name="RequestType" datasource="#CLIENT.Datasource#" username="#SESSION.login#" password="#SESSION.dbpw#">
    SELECT * FROM  Ref_RequestType
</cfquery>

<link rel="stylesheet" type="text/css" href="<cfoutput>#client.root#/#client.style#</cfoutput>"> 
<div class="screen">
<body class="main" onload="window.focus()" top="0", bottom="0">

<!--- <cfif usergroup  eq “fgsTempAccess”>
<CFFORM action="DocumentEntrysubmit.cfm" method="POST" name="documententry">
<cfelse>
</cfif> --->



<CFFORM action="DocumentEntrysubmit.cfm" method="POST" name="documententry">

<table width="100%" border="1" cellspacing="0" cellpadding="0" bordercolor="#002350" frame="all">

	<tr>
		<td width="100%">
			<table width="100%" border="1" cellspacing="0" cellpadding="0" bordercolor="#002350" frame="all">
			<tr height="30" valign="middle" bgcolor="#002350">
				<td width="80%">
					<font face="Times New Roman" size="3" color="FFFFFF"><b>&nbsp;Personnel Request Entry</b></font>
				</td>
				<td align="right">
					<input class="input.button1" type="submit" name="Submit" value="   Save   " onClick="javascript: return chkFields()">
					&nbsp;&nbsp;&nbsp;&nbsp;
				</td>
			</tr>
			</table>
		</td>
	</tr> 	
  
	<tr>
    <td width="100%" height="16" align="left" bgcolor="#6688aa">
	<cfoutput>
	<font face="tahoma" size="1" color="FFFFFF">&nbsp;Note: An asterisk (*) after the field label indicates a mandatory field.</font>
	</cfoutput>
    </td>
 	</tr> 	

    <tr>
    <td width="100%">
    <table border="0" cellpadding="0" cellspacing="0" style="border-collapse: collapse" bordercolor="#111111" width="100%">
	
	<!--- Insert blank line --->
	<tr><td height="10"></td>
	</tr>
	
	<!--- Field: Permanent Mission --->
    <tr>
    <td class="header">&nbsp;Permanent Mission*:</td>
	<td>
	<font color="#0000FF" face="Lucida Console" size="1">
 	    <select name="p_mission" required="Yes">
	    <cfoutput query="P_Mission">
		<option value="#PermanentMissionId#">#Description#</option>
		</cfoutput>		
	    </select>	
	</td>
	</tr>	
    <!--- Field: Field Mission --->
    <tr>
    <td class="header">&nbsp;DPKO Field Mission*:</td>
	<td>
	<font color="#0000FF" face="Lucida Console" size="1">
 	    <select name="mission" required="Yes">
	    <cfoutput query="Mission">
		<option value="#Mission#">#Mission#
		</option>
		</cfoutput>
	    </select>			
	</td>
	</tr>	
    <!--- Field: Personnel Type or Category --->
    <tr>
    <td class="header">&nbsp;Personnel Type*:</td>
	<td>
	<font color="#0000FF" face="Lucida Console" size="1">
 	    <select name="category" required="Yes">
	    <cfoutput query="Category">
		<option value="#Category#">#Category#
		</option>
		</cfoutput>
	    </select>			
	</td>
	</tr>
	<!--- Field: Travel arranged by:  MM 10May04 --->
	<tr>
	<td class="header">&nbsp;Travel arranged by*:</td>
	<td class="regular">		
	<input type="radio" name="TvlArrBy" value="U" checked> UN
	<input type="radio" name="TvlArrBy" value="C"> Country
	</td>
	</tr>	
	<!--- Field: Travel processed by:  MM 16/9/03 --->
	<tr>
	<td class="header">&nbsp;Travel processed by*:</td>
	<td class="regular">		
	<input type="radio" name="TravelBy" value="T" checked> Travel Unit
	<input type="radio" name="TravelBy" value="M"> MovCon		
	</td>
	</tr>	
    <!--- Field: Request Type --->
	<tr>
    <td class="header">&nbsp;Request type*:</td>
	<td>
	<font color="#0000FF" face="Lucida Console" size="1">
 	    <select name="requesttype" required="Yes">
	    <cfoutput query="RequestType">
		<option value="#RequestType#" <cfif #RequestType# eq "2"> selected</cfif>>#Description#
		</option>
		</cfoutput>
	    </select>			
	</td>
	</tr>
    <!--- Field: Request date --->
    <tr> 
	<td class="header">&nbsp;Request date (dd/mm/yy)*:</td>
	<td><cfset end = DateAdd("m",  0,  now())> 
   	   	<cf_intelliCalendarDate
		FormName="documententry"
		FieldName="RequestDate" 
		DateFormat="#CLIENT.DateFormatShow#"
		Default="#Dateformat(end, CLIENT.DateFormatShow)#"
		AllowBlank="False">	
	</td>
	</tr>
	<!--- Field: Planned deployment --->
	<tr>
    <td class="header">&nbsp;Planned deployment date (dd/mm/yy)*:</td>
	<td><cfset end = DateAdd("m",  3,  now())> 
   	   	<cf_intelliCalendarDate
		FormName="documententry"
		FieldName="PlannedDeployment" 
		DateFormat="#CLIENT.DateFormatShow#"
		Default=""
		AllowBlank="False">	
		<!--- 10Aug04 - def value requested to be removed by JS; CP agreed it was a good idea
		Default="#Dateformat(end, CLIENT.DateFormatShow)#"
		--->
	</td>
	</tr>
    <!--- Field: Default SAT date --->
    <tr> 
	<td class="header">&nbsp;Default SAT date (dd/mm/yy):</td>
	<td>
	   	<cf_intelliCalendarDate
		FormName="documententry"
		FieldName="SatDate" 
		DateFormat="#CLIENT.DateFormatShow#"
		Default=""
		AllowBlank="True">	
	</td>	
    <!--- Field: Number requested --->	
	<tr>
    <td class="header">&nbsp;Number requested*:</td>
    <td>
	  	<input type="text" name="personcount" message="Please enter the number of personnel requested." required="Yes" size="5" maxlength="5" class="regular"> <font size="1" face="tahoma">personnel</font>
	</td>
	</tr>	
    <!--- Field: Tour of Duty Length --->	
	<tr>
    <td class="header">&nbsp;Tour of duty length*:</td>
    <td>
	  	<input type="text" name="dutylength" message="Please enter the TOD length in whole months." required="Yes" size="5" maxlength="5" class="regular"> <font size="1" face="tahoma">months</font>
	</td>
	</tr>	
	<!--- Field: Request reference 
	<cfif #Military.RecordCount# GT 0>
		<cfset sDefRef = "FGS fax to PM of AAA dated DD/MM/YY">
	<cfelse>
		<cfset sDefRef = "">
	</cfif>
	--->	
	<tr>
    <td class="header">&nbsp;Request Reference (40 chars max):</td>
    <td>
	  	<input type="text" name="referenceno" message="Please enter the request reference (if any)." size="40" maxlength="40" class="regular">
	</td>
	</tr>
    <!--- Field: Rank Level required --->				
    <tr>
    <td class="header">&nbsp;Ranks required (200 chars max):</td>
    <td>
		<textarea cols="50" rows="3" name="levelrequired" message="Please enter rank(s) required if applicable." class="regular"></textarea>
	</td>
	</tr>	
    <!--- Field: Qualifications required --->				
    <tr>
    <td class="header">&nbsp;Qualifications required (200 chars max):</td>
    <td>
		 <textarea cols="50" rows="3" name="qualification" class="regular"></textarea>
	</td>
	</tr>
    <!--- Field: Remarks  MM 21/4/04 --->				
    <tr>
    <td class="header">&nbsp;Remarks (200 chars max):</td>
    <td>
		 <textarea cols="50" rows="4" name="remarks" class="regular"></textarea>
	</td>
	</tr>
	<!--- Field: Traveller departing from usual point of origin?:  MM 21/4/04 --->
	<tr>
	<td class="header">&nbsp;From usual point of origin?*:</td>
	<td class="regular">		
	<input type="radio" name="usualorigin" value="1" checked> Yes
	<input type="radio" name="usualorigin" value="0"> No		
	</td>
	</tr>
	<!--- Insert extra blank row --->
	<tr><td height="10" class="header"></td></tr>

</table>

</table>
<!---
<HR>	

<input class="input.button1" type="submit" name="Submit" value="   Save   " onClick="javascript: return chkFields()">
--->
</CFFORM>
</body>
</div>
</html>