<!--- 
	PersonInquiry2.cfm
	
	Stand alone page for searching for persons to display in a Person List.

	Search by: Name, mission ID number, Nationality

	Called by: Application menu

	Calls: PersonInquiry2Result.cfm
			
	Modification History:
	10Jan04 - added new query var BirthDate
			- changed Criteria3 from MissionID to PassportNo
--->

<HTML><HEAD><TITLE>Person Inquiry</TITLE></HEAD>

<cfset CLIENT.DataSource = "AppsTravel">

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

<!---- 3a. If user has access to all mission, read all current missions from Position table (only those Pos that have an associated PersonAssign --->
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

<!---- 4. Build temp table to nationality codes for which assignments current exist --->
<CF_DropTable dbName="AppsQuery" tblName="tmp#SESSION.acc#pm_ActiveNat">

<cfquery name="ActiveNat" datasource="AppsEmployee" username="#SESSION.login#" password="#SESSION.dbpw#">
    SELECT DISTINCT N.Code, N.Name 
	INTO  userQuery.dbo.tmp#SESSION.acc#pm_ActiveNat
    FROM TRAVEL.DBO.Ref_Nationality N, Person P, PersonAssignment PA, Position PO
	WHERE N.Code = P.Nationality
	AND   P.PersonNo = PA.PersonNo
	AND   PA.PositionNo = PO.PositionNo
	AND   PO.PostType IN (SELECT PostType FROM userQuery.dbo.tmp#SESSION.acc#pm_AuthorizedPostType)
	AND   N.Name > 'A'
	ORDER BY N.Name
</cfquery>

<!--- 5a. Read list of field missions for drop list --->
<cfquery name="Mission" datasource="#CLIENT.Datasource#" username="#SESSION.login#" password="#SESSION.dbpw#">
    SELECT Mission
	FROM userQuery.dbo.tmp#SESSION.acc#pm_AuthorizedMiss
	ORDER BY Mission
</cfquery>

<!--- 5b. Read list of nationalities for drop list --->
<cfquery name="Nation" datasource="AppsQuery" username="#SESSION.login#" password="#SESSION.dbpw#">
    SELECT Code, Name 
	FROM userQuery.dbo.tmp#SESSION.acc#pm_ActiveNat
	ORDER BY Name
</cfquery>
<!---
<link rel="stylesheet" type="text/css" href="<cfoutput>#client.root#/#client.style#</cfoutput>"> 
--->
<link href="../../../../../<cfoutput>#client.style#</cfoutput>" rel="stylesheet" type="text/css">

<div class="screen">
<body class="main" onload="window.focus()" top="0", bottom="0">

<CFFORM action="PersonInquiry2Result.cfm" method="post">

<cfparam name="URL.FormName" default="Myform">
<cfparam name="URL.FieldName" default="MyField">

<cfoutput>
<input type="hidden" name="FormName"  value="#URL.FormName#">
<input type="hidden" name="FieldName" value="#URL.FieldName#">
</cfoutput>

<table width="100%" border="1" cellspacing="0" cellpadding="0" bordercolor="#002350" frame="all">
  <tr bgcolor="#002350">
  <td height="20" class="label">&nbsp;<b>Person Inquiry</b></td>
  </tr>
  
  <tr>
  <td>  
  
  <table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" bordercolor="#8EA4BB" rules="cols" style="border-collapse: collapse">
  
  <tr bgcolor="6688aa"><td height="10"></td></tr>
  <tr><td class="header">&nbsp;&nbsp;Instructions:</td></tr>
  <tr><td class="header">&nbsp;&nbsp;1. Use this page to control records to display in the resulting list.</td></tr>
  <tr><td class="header">&nbsp;&nbsp;2. Click the <b>Incl.</b> radio button to include values a selection box.</td></tr>
  <tr><td class="header">&nbsp;&nbsp;3. For multiple selection, click a list item while holding down the CTRL key.</td></tr>
  <tr><td class="header">&nbsp;&nbsp;4. Records retrieved will be limited to those persons with categories, and who are assigned to field missions, for which the user has been granted access.</td></tr>  

  <tr bgcolor="white" valign="top">
	<td>&nbsp;
	
	<table>
	
    <td></td>
	<!--- Field: LastName=CHAR;40;FALSE --->
	<input type="hidden" name="Crit2_FieldName" value="P.LastName">	
	<input type="hidden" name="Crit2_FieldType" value="CHAR">
	<tr><td width="50"></td>
	<td align="left">    
      <font size="1" face="Tahoma" color="#6688AA"><b>Last Name:</b></font>
    </td>
	<td colspan="3"><font color="#000000">
		<select name="Crit2_Operator">
			<option value="BEGINS_WITH">begins with
			<option value="ENDS_WITH">ends with
			<option value="CONTAINS">contains
			<option value="EQUAL">is
			<option value="NOT_EQUAL">is not
			<option value="SMALLER_THAN">before
			<option value="GREATER_THAN">after
		</select></font>
		<font color="#6688AA">&nbsp;</font>
		<font color="#000000"><input type="text" name="Crit2_Value" size="20"></font>	
	</td>
	</tr>

	<!--- Field: FirstName=CHAR;40;FALSE --->
	<input type="hidden" name="Crit3_FieldName" value="P.FirstName">	
	<input type="hidden" name="Crit3_FieldType" value="CHAR">
	<tr><td></td>
	<td align="left">
       <font color="#6688AA" size="1" face="Tahoma"><b>First Name:</b></font>
    </td>
	<td colspan="3"><font color="#000000">
		<select name="Crit3_Operator">		
			<option value="BEGINS_WITH">begins with
			<option value="ENDS_WITH">ends with
			<option value="CONTAINS">contains
			<option value="EQUAL">is
			<option value="NOT_EQUAL">is not
			<option value="SMALLER_THAN">before
			<option value="GREATER_THAN">after		
		</select>
		</font>
		<font color="#6688AA">&nbsp; </font>
		<font color="#000000">		
		<input type="text" name="Crit3_Value" size="20">
		</font>	
	</td>
	</tr>
	
	<!--- Field: Mission ID=CHAR;20;TRUE --->
	<input type="hidden" name="Crit1_FieldName" value="PD.DocumentReference">	
	<input type="hidden" name="Crit1_FieldType" value="CHAR">
	<tr>
	<td></td>
	<td align="left">
        <font size="1" face="Tahoma" color="#6688AA"><b>Passport No:</b></font>
    </td>
	<td colspan="3"><font color="#000000">
		<select name="Crit1_Operator">
			<option value="BEGINS_WITH">begins with
			<option value="ENDS_WITH">ends with
			<option value="CONTAINS">contains
			<option value="EQUAL">is
			<option value="NOT_EQUAL">is not
			<option value="SMALLER_THAN">before
			<option value="GREATER_THAN">after
		</select></font>
		<font color="#6688AA">&nbsp; </font>
		<font color="#000000"><input type="text" name="Crit1_Value" size="20"></font>	
	</td>
	</tr>	
	
	<tr>
	<td></td>
	<td><font color="#6688AA" size="1" face="Tahoma"><b>Birth Date:</b></font></td>
	<td valign="top" class="regular" colspan="3">
   		<cf_intelliCalendarDate
		FieldName="BirthDate" 
		Default=""
		AllowBlank="True">
	</td>
	</tr>
	
	 <!--- Field: Nationality=CHAR;40;FALSE --->
	<td width="30"> </td>
	<td align="left" valign="top">
      <font size="1" face="Tahoma" color="#6688AA"><b>Nationality:</b></font><P>
      <font color="#000000" face="Tahoma" size="1">	
		<input type="radio" name="Nation" value="0" checked></font><font face="Tahoma" size="1" color="#6688AA">Incl.
      </font>
      <font color="#000000" face="Tahoma" size="1">
    	<input type="radio" name="Nation" value="1"></font><font face="Tahoma" size="1" color="#6688AA">Excl.
      </font>  	
	</td>
	
	<td>
    	<font color="#000000">
    	<select name="Nationality" size="15" multiple>
	    <cfoutput query="Nation">		
			<option value="'#Code#'"selected>#Name#</option>
		</cfoutput>
	    </select></font>
	</td>
	</tr>
	<tr><td>&nbsp;</td></tr>
	</table>	 
</table>	

</td></tr>	

<tr bgcolor="6688aa"><td height="10"></td></tr>

</table>
	
<hr>

<input class="input.button1" type="submit" name"Search" value="  Submit  ">

</CFFORM>
</body>
</div>
</html>