<!--- 
	PersonMedicalClearanceInquiry.cfm
	Page for searching for persons to display in the Record Medical Clearance page.

	Search by: LastName, FirstName, Field Mission, and Nationality
	
	Modification History:

--->

<HTML><HEAD><TITLE>Record Person Medical Clearance</TITLE></HEAD>

<!---- Check if user is allowed to access "All Missions" or particular missions --->
<cfquery name="Mission1" datasource="AppsTravel" username="#SESSION.login#" password="#SESSION.dbpw#">
	SELECT AA.Mission
	FROM ActionAuthorization AA, FlowAction FA, Ref_TravellerType RT
	WHERE AA.ActionId = FA.ActionID
	AND   FA.ActionClass = RT.TravellerTypeCode
	AND   AA.AccessLevel <> '9'
	AND   AA.UserAccount = '#SESSION.acc#'
	GROUP BY AA.Mission
</cfquery>

<!---- 1a. Delete temp table of post types user is authorized to access --->
<CF_DropTable dbName="AppsQuery" tblName="tmp#SESSION.acc#pm_AuthorizedPostType">

<!---- 1b. Build temp table of post types user is authorized to access --->
<cfquery name="AuthorizedPostType" datasource="AppsTravel" username="#SESSION.login#" password="#SESSION.dbpw#">
	SELECT RT.TravellerType AS PostType
	INTO  userQuery.dbo.tmp#SESSION.acc#pm_AuthorizedPostType
	FROM ActionAuthorization AA, FlowAction FA, Ref_TravellerType RT
	WHERE AA.ActionId = FA.ActionID
	AND   FA.ActionClass = RT.TravellerTypeCode
	AND   AA.AccessLevel <> '9'
	AND   AA.UserAccount = '#SESSION.acc#'
	GROUP BY RT.TravellerType
</cfquery>

<!---- 2. Delete temp table to hold field missions user is authorized to access --->
<CF_DropTable dbName="AppsQuery" tblName="tmp#SESSION.acc#pm_AuthorizedMiss">

<!---- 2a. If user has access to all mission, read all current missions from Position table (only those Pos that have an associated PersonAssign --->
<cfif #Mission1.Mission# EQ "All Missions">
	<cfquery name="AuthorizedMission" datasource="AppsTravel" username="#SESSION.login#" password="#SESSION.dbpw#">
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
	<cfquery name="AuthorizedMission" datasource="AppsTravel" username="#SESSION.login#" password="#SESSION.dbpw#">
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

<!--- 3b. Read list of field missions for drop list --->
<cfquery name="Mission" datasource="AppsTravel" username="#SESSION.login#" password="#SESSION.dbpw#">
    SELECT Mission
	FROM userQuery.dbo.tmp#SESSION.acc#pm_AuthorizedMiss
	ORDER BY Mission
</cfquery>

<!--- 4. Read list of countries where candidates have reached 'Request Medical Clearance' step --->
<cfquery name="Nation" datasource="AppsTravel" username="#SESSION.login#" 
password="#SESSION.dbpw#" cachedwithin="#CreateTimeSpan(0,2,0,0)#">
SELECT DISTINCT N.code, N.name 	
FROM  Ref_Nationality N INNER JOIN 
      EMPLOYEE.DBO.Person P ON N.Code = P.Nationality INNER JOIN
	  DocumentCandidateAction DC ON P.PersonNo = DC.PersonNo INNER JOIN 
	  Document D ON DC.DocumentNo = D.DocumentNo INNER JOIN 
	  FlowActionView FA ON DC.ActionId = FA.ActionId
WHERE DC.ActionStatus = '7'
AND   D.Status IN ('0','1')
AND   FA.ConditionForView LIKE 'MedicallyClear'
AND   P.Category IN (SELECT DISTINCT RC.Category			
					FROM ActionAuthorization AA, FlowAction FA, Ref_TravellerType RT, Ref_Category RC
					WHERE AA.ActionId = FA.ActionID
					AND   FA.ActionClass = RT.TravellerTypeCode
					AND   RT.TravellerType = RC.TravellerType
					AND   AA.AccessLevel <> '9'
					AND   AA.UserAccount = '#SESSION.acc#')
AND   N.Name > 'A'
ORDER BY N.name
</cfquery>

<link rel="stylesheet" type="text/css" href="<cfoutput>#client.root#/#client.style#</cfoutput>"> 
<div class="screen">
<body class="main" onload="window.focus()" top="0", bottom="0">

<form action="PersonMedicalClearanceInquiryResult.cfm" method="post">

<cfparam name="URL.FormName" default="Myform">
<cfparam name="URL.FieldName" default="MyField">

<cfoutput>
<input type="hidden" name="FormName"  value="#URL.FormName#">
<input type="hidden" name="FieldName" value="#URL.FieldName#">
</cfoutput>

<table width="100%" border="1" cellspacing="0" cellpadding="0" bordercolor="#002350" frame="all">
  <tr bgcolor="#002350">
  <td height="20" class="label">&nbsp;<b>Locate Person to be medically cleared</b></td>
  </tr>
  
  <tr>
  <td>  
  
  <table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" bordercolor="#8EA4BB" rules="cols" style="border-collapse: collapse">
  
  <tr bgcolor="6688aa"><td height="10"></td></tr>
  <tr><td class="header">&nbsp;&nbsp;Instructions:</td></tr>
  <tr><td class="header">&nbsp;&nbsp;1. Use this page to control records to display in the resulting list.</td></tr>
  <tr><td class="header">&nbsp;&nbsp;2. Click the <b>Incl.</b> radio button to include values in the selection box.</td></tr>
  <tr><td class="header">&nbsp;&nbsp;3. For multiple selection, click a list item while holding down the CTRL key.</td></tr>
  <tr><td class="header">&nbsp;</td></tr>
  <tr><td class="header">&nbsp;&nbsp;Note: Only candidates for whom medical clearance has been requested shall be listed.</td></tr>  
  <tr><td class="header">&nbsp;</td></tr>
    
  <tr bgcolor="white" valign="top">
	<td>&nbsp;
	
	<table>
	
    <td></td>

	<!--- Field: LastName=CHAR;40;FALSE --->
	<input type="hidden" name="Crit2_FieldName" value="P.LastName">	
	<input type="hidden" name="Crit2_FieldType" value="CHAR">
	<tr>
	<td width="50"></td>
	<td align="left">    
      <font size="1" face="Tahoma" color="#6688AA"><b>Last name:</b></font>
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
	<tr>
	<td></td>
	<td align="left">
       <font color="#6688AA" size="1" face="Tahoma"><b>First name:</b></font>
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

	<tr><td>&nbsp;</td></tr>	

	<tr>
	<td></td>
	<td align="left">
       <font color="#6688AA" size="1" face="Tahoma"><b>Clearance Status:</b></font>
    </td>
    <td colspan="3" class="regular">    		
		<input type="radio" name="candactionstat" value="7" checked>Not yet processed
		<input type="radio" name="candactionstat" value="6">Pending
	</td>	
	</tr>		
	
	<tr><td>&nbsp;</td></tr>	
	
	<!--- Field: Field Mission=CHAR;40;FALSE --->
	<tr><td height="5"> </td></tr>
	<tr><td></td>
	<td align="left" valign="top">
      <font size="1" face="Tahoma" color="#6688AA"><b>Field Mission:</b></font><P>
      <font color="#000000" face="Tahoma" size="1">	
		<input type="radio" name="exclMission" value="0" checked></font><font face="Tahoma" size="1" color="#6688AA">Incl.
      </font>
      <font color="#000000" face="Tahoma" size="1">
    	<input type="radio" name="exclMission" value="1"></font><font face="Tahoma" size="1" color="#6688AA">Excl.
      </font>  	
	</td>
   	
	<td>
	  <font color="#000000">
    	<select name="Mission" size="15" multiple>
	    <cfoutput query="Mission">		
			<option value="'#Mission#'"selected>#Mission#</option>
		</cfoutput>
	    </select></font>
	</td>
	
     <!--- Field: Nationality=CHAR;40;FALSE --->
	<td width="30"> </td>
	<td align="left" valign="top">
      <font size="1" face="Tahoma" color="#6688AA"><b>Nationality:</b></font><P>
      <font color="#000000" face="Tahoma" size="1">	
		<input type="radio" name="exclNation" value="0" checked></font><font face="Tahoma" size="1" color="#6688AA">Incl.
      </font>
      <font color="#000000" face="Tahoma" size="1">
    	<input type="radio" name="exclNation" value="1"></font><font face="Tahoma" size="1" color="#6688AA">Excl.
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
<!--- show Close and Submit buttons --->
<input class="input.button1" type="button" name="OK"    value="    Close    " onClick="window.close()">
<input class="input.button1" type="submit" name"Search" value="     Submit   ">

</FORM>
</body>
</div>
</html>